unit PCMAPP.Import.Kontakte;

interface

uses
  {$Region uses}
  {$IFDEF ANDROID}
  Androidapi.JNI.Os,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  {$ENDIF ANDROID}
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FMX.AddressBook,
  FMX.AddressBook.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Dialogservice,
  FMX.Forms,
  FMX.Graphics,
  FMX.ImgList,
  FMX.ListView,
  FMX.ListView.Adapters.Base,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Surfaces,
  FMX.Types,
  Soap.EncdDecd,
  System.Classes,
  System.ImageList,
  System.Math,
  system.netencoding,
  System.SysUtils,
  system.threading,FMX.Ani,
  System.Types,
  System.UITypes,
  System.Variants;
  {$EndRegion uses}
type
  {$Region types}
  Tfrm_PCMAPP_ImportKontakte = class(TFrame)
    adrbk_Contacts: TAddressBook;
    imglst_Contact: TImageList;
    lbl_Progress: TLabel;
    lv_Contacts: TListView;
    pgbr_Progress: TProgressBar;
    pgbr_ProgressAnimation: TFloatAnimation;
    rec_ContactsProgressbar: TRectangle;
    procedure adrbk_ContactsExternalChange(ASender: TObject);
    procedure adrbk_ContactsPermissionRequest(ASender: TObject;const AMessage: string; const AAccessGranted: Boolean);
    procedure lv_ContactsPullRefresh(Sender: TObject);
  private
    { Private-Deklarationen }
    FAllContacts: TAddressBookContacts;
    FContacts: TAddressBookContacts;
    sPermissionReadContacts: string;
    qry_Synch: TFDQuery;
    procedure FillContactsList;
    procedure LocationPermissionRequestResult(Sender: TObject; const APermissions:TClassicStringDynArray; const APostRationaleProc: TProc);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
  end;
  {$EndRegion types}
var
  {$Region Var}
  frm_PCMAPP_ImportKontakte: Tfrm_PCMAPP_ImportKontakte;
  {$EndRegion Var}
implementation
{$R *.fmx}
uses
  {$Region uses}
  PCMAPP.Datamodul,
  PCMApp.Main,
  PCMAPP.SQL;
  {$EndRegion uses}
////////////////////////////////////////////////////////////////////////////////
// Functions                                                                  //
////////////////////////////////////////////////////////////////////////////////
{$Region FUNCTIONS}
procedure Tfrm_PCMAPP_ImportKontakte.adrbk_ContactsExternalChange(ASender: TObject);
begin
  adrbk_Contacts.RevertCurrentChangesAndUpdate;
end;
procedure Tfrm_PCMAPP_ImportKontakte.adrbk_ContactsPermissionRequest(ASender: TObject; const AMessage: string; const AAccessGranted: Boolean);
begin
  if AAccessGranted then
    FillContactsList;
end;
procedure Tfrm_PCMAPP_ImportKontakte.FillContactsList;
begin
  dmmain.wfWaitFrame.Execute('Kontakte laden...', 'Kontakte aus Telefon', True);
  TTask.Run(
  procedure()
  var
    Contact: TAddressBookContact;
    sSQLInsert,sSQLValues: string;
    sPrevContact,sCurrContact: string;
    ANumber: Integer;
  begin
    TThread.Synchronize(nil, procedure begin
      rec_ContactsProgressbar.Visible:= true;
      frm_PCM_Main.btn_BackSystem.Enabled := false;
      frm_PCM_Main.btn_Synchronisation.Enabled:= false;
    end);
    try
      try
      FreeAndNil(FContacts);
      FContacts := TAddressBookContacts.Create(True);
      TThread.Synchronize(nil, procedure begin adrbk_Contacts.AllContacts(FContacts); end);
      FAllContacts := FContacts;
      TThread.Synchronize(nil, procedure begin
        lv_Contacts.Items.Clear;
        lv_Contacts.PullRefreshWait := True;
        pgbr_ProgressAnimation.Inverse := False;
        pgbr_ProgressAnimation.Enabled := True;
        pgbr_ProgressAnimation.Start;
        pgbr_Progress.Value := 0;
        pgbr_Progress.Max := FContacts.Count;
      end);
      Index := 0;
      sPrevContact:='';
      ANumber:= 0;
      sSQLInsert:= sSQL_INS_ALL_Kontakte_Statement;
      sSQLValues:= sSQL_INS_ALL_Kontakte_Values;

      for Contact in FAllContacts do
      begin
        TThread.Synchronize(nil,
        procedure()
          function Base64FromBitmap(Bitmap: TBitmap): Ansistring;
          var
            Input: TBytesStream;
            Output: TStringStream;
          begin
            Input := TBytesStream.Create;
            try
              Bitmap.SaveToStream(Input);
              Input.Position := 0;
              Output := TStringStream.Create('', TEncoding.ASCII);
              try
                Soap.EncdDecd.EncodeStream(Input, Output);
                Result := AnsiString(Output.DataString);
              finally
                Output.Free;
              end;
            finally
              Input.Free;
            end;
          end;
          function BitmapFromBase64(const base64: Ansistring): TBitmap;
          var
            Input: TStringStream;
            Output: TBytesStream;
          begin
            Input := TStringStream.Create(String(base64), TEncoding.ASCII);
            try
              Output := TBytesStream.Create;
              try
                Soap.EncdDecd.DecodeStream(Input, Output);
                Output.Position := 0;
                Result := TBitmap.Create;
                try
                  Result.LoadFromStream(Output);
                except
                  Result.Free;
                  raise;
                end;
              finally
                Output.Free;
              end;
            finally
              Input.Free;
            end;
          end;
          function CreateRoundPhoto(const ASource: TBitmapSurface): TBitmap;
          var
            Size: Integer;
          begin
            Result := TBitmap.Create;
            Size := Min(ASource.Height, ASource.Width);
            Result.SetSize(Size, Size);
            Result.Clear(TAlphaColorRec.Null);
            if Result.Canvas.BeginScene then
            begin
              try
                Result.Canvas.Fill.Bitmap.Bitmap.Assign(ASource);
                Result.Canvas.Fill.Kind := TBrushKind.Bitmap;
                Result.Canvas.FillEllipse(TRectF.Create(0, 0, Size, Size), 1);
              finally
                Result.Canvas.EndScene;
              end;
            end;
          end;
        var
          iPos,ipos2, i: Integer;
          bmPicture: TBitmap;
          sFirstname,sLastName,sGeburtsdatum: String;
          sTelefonFirma,sHandyFirma, sMobil,sPrivat,sMailFirma,sMailPrivat: string;
          sAdress,sAdressF,sStrasse,sStrasseFirma,sPLZ,sPLZFirma,sOrt,sOrtFirma: string;
          Item1: TListViewItem;
//          sSQLUpdate,sSQLSetWHERE: string;
        begin
          sStrasse:= '';
          sStrasseFirma:= '';
          sPLZ:= '';
          sPLZFirma:= '';
          sOrt:= '';
          sOrtFirma:= '';
          sFirstname:= '';
          sLastName:= '';
          sMailFirma:= '';
          sMailPrivat:= '';
          bmPicture:= nil;
          sGeburtsdatum:= '';
          sMobil:= '';
          sPrivat:= '';
          sTelefonFirma:= '';
          sHandyFirma:= '';
          ANumber:= ANumber + 1;
          pgbr_Progress.Value := pgbr_Progress.Value + 1;
          lbl_Progress.Text  := Format('%d Kontakte von %d Kontakten geladen', [ANumber, FAllContacts.Count]);
          sCurrContact:= Contact.DisplayName;
          if sCurrContact <> sPrevContact then
          begin
            Item1 := lv_Contacts.Items.Add;
            Item1.Detail := Contact.Organization;
            Item1.Text := Contact.DisplayName;
            sFirstname:= Contact.FirstName;
            sLastName:= Contact.LastName;
            if Contact.PhotoThumbnail = nil then
            begin
              Item1.ImageIndex := 0;
            end
            else
            begin
              Item1.Bitmap := CreateRoundPhoto(Contact.PhotoThumbnail);
              bmPicture:= Item1.Bitmap;
            end;

            try
              sGeburtsdatum:= DateToStr(Contact.Birthday);
            except
            end;
            for i := 0 to Contact.Phones.Count - 1 do
            begin
              try
                if (Contact.Phones[i].LabelText = 'Mobil') or (Contact.Phones[i].LabelText = 'Sonstige') or
                   (Contact.Phones[i].LabelText = 'MOBILE') or (Contact.Phones[i].LabelText = 'OTHER')
                then
                begin
                  sMobil:= Contact.Phones[i].Number
                end;
                if (Contact.Phones[i].LabelText = 'Zuhause') or (Contact.Phones[i].LabelText = 'HOME') then
                begin
                  sPrivat:= Contact.Phones[i].Number
                end;
                if (Contact.Phones[i].LabelText = 'Hauptnummer') or (Contact.Phones[i].LabelText = 'Arbeit') or
                   (Contact.Phones[i].LabelText = 'MAIN') or (Contact.Phones[i].LabelText = 'WORK') then
                begin
                  sTelefonFirma:= Contact.Phones[i].Number
                end;
              except
              end;
            end;

            for i := 0 to Contact.EMails.Count - 1 do
            begin
              try
                if (Contact.EMails[i].LabelText = 'Start') or (Contact.EMails[i].LabelText = 'Weitere') or
                   (Contact.EMails[i].LabelText = 'HOME') or (Contact.EMails[i].LabelText = 'OTHER') then
                begin


                  sMailPrivat:= Contact.EMails[i].Email;
                end;
                if (Contact.EMails[i].LabelText = 'Ausführen') or (Contact.EMails[i].LabelText = 'WORK') then
                begin
                  sMailFirma:= Contact.EMails[i].Email;
                end;
              except
              end;
            end;

            for i := 0 to Contact.Addresses.Count - 1 do
            begin
              try
                if (Contact.Addresses[i].LabelText = 'Start') or (Contact.Addresses[i].LabelText = 'Weitere') or
                   (Contact.Addresses[i].LabelText = 'HOME') or (Contact.Addresses[i].LabelText = 'OTHER') then
                begin
                  sStrasse:= Contact.Addresses[i].Street;
                  sPLZ:= Contact.Addresses[i].ZIP;
                  sOrt:= Contact.Addresses[i].City;
                end;
                if (Contact.Addresses[i].LabelText = 'Ausführen') or (Contact.Addresses[i].LabelText = 'WORK') then
                begin
                  sStrasseFirma:= Contact.Addresses[i].Street;
                  sPLZFirma:= Contact.Addresses[i].ZIP;
                  sOrtFirma:= Contact.Addresses[i].City;
                end;
              except
              end;
              try
                if sPLZ <> '' then
                  sStrasse:= sStrasse + ', ' + sPlz;
                if sOrt <> '' then
                  sStrasse:= sStrasse+ ' ' + sOrt;
                sAdress:= StringReplace(sStrasse,#10,'',[rfReplaceAll,rfIgnoreCase]);
                iPos:=Pos(',',sStrasse);
                sStrasse:= Copy(sAdress,1,iPos - 1);
                sAdress:= Copy(sAdress,iPos+2,Length(sAdress));
                iPos2:=Pos(' ',sAdress);
                sPLZ:= Copy(sAdress,1,ipos2-1);
                sAdress:= Copy(sAdress,iPos2+1,Length(sAdress));
                sOrt:= sAdress
              except
              end;

              try
                if sPLZFirma <> '' then
                  sStrasseFirma:= sStrasseFirma + ', ' + sPLZFirma;
                if sOrtFirma <> ''  then
                  sStrasseFirma:= sStrasseFirma + ' ' + sOrtFirma;

                sAdressF:= StringReplace(sStrasseFirma,#10,'',[rfReplaceAll,rfIgnoreCase]);
                iPos:=Pos(',',sAdressF);
                sStrasseFirma:= Copy(sAdressF,1,iPos - 1);
                sAdressF:= Copy(sAdressF,iPos+2,Length(sAdressF));
                iPos2:=Pos(' ',sAdressF);
                sPLZFirma:= Copy(sAdressF,1,ipos2-1);
                sAdressF:= Copy(sAdressF,iPos2+1,Length(sAdressF));
                sOrtFirma:= sAdressF;
              except
              end;
            end;
            if sFirstName = '' then
            begin
              sFirstName:= sLastName;
              sLastName:= '';
            end;
            qry_Synch:= TFDQuery.Create(nil);
            qry_Synch.Connection:= dmmain.con_PCM;
            qry_Synch.SQL.Text:= sSQL_SEL_ID_Kontakte_WHERE_NACHNAMEVORNAME;
            qry_Synch.ParamByName('Vorname').AsString := sFirstName;
            qry_Synch.ParamByName('Nachname').AsString := sLastName;
            qry_Synch.open;
            if qry_Synch.RecordCount > 0 then
            begin
              if sGeburtsdatum <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Geburtsdatum = :Geburtsdatum ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Geburtsdatum').asDAte := StrToDate(sGeburtsdatum);
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if Contact.Organization <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Firma = :Firma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Firma').AsString := Contact.Organization;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sPrivat <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Telefon = :Telefon ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Telefon').AsString := sPrivat;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sMobil <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Handy = :Handy ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Handy').AsString := sMobil;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sTelefonFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),TelefonFirma = :TelefonFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('TelefonFirma').AsString := sTelefonFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sHandyFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),HandyFirma = :HandyFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('HandyFirma').AsString := sHandyFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sMailPrivat <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Email = :Email ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Email').AsString := sMailPrivat;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sMailFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),EmailFirma = :EmailFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('EmailFirma').AsString := sMailFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sStrasse <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Strasse = :Strasse ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Strasse').AsString := sStrasse;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sPLZ <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),PLZ = :PLZ ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('PLZ').AsString := sPLZ;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sOrt <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Ort = :Ort ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Ort').AsString := sOrt;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sStrasseFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),StrasseFirma = :StrasseFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('StrasseFirma').AsString := sStrasseFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sPLZFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),PLZFirma = :PLZFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('PLZFirma').AsString := sPLZFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if sOrtFirma <> '' then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),OrtFirma = :OrtFirma ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('OrtFirma').AsString := sOrtFirma;
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
              if bmPicture <> nil then
              begin
                qry_Synch.SQL.Text:= 'Update Kontakte SET GeaendertAm = DateTime(),Bild = :Bild ' +
                                           'WHERE Nachname = :Nachname AND Vorname = :Vorname';
                qry_Synch.ParamByName('Bild').AsAnsiString := Base64FromBitmap(bmPicture);
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                qry_Synch.ExecSQL;
              end;
            end
            else
            begin
            if (sLastName <> '') or (sFirstname <> '') or  (Contact.Organization <> '' )then
            begin
                qry_Synch.SQL.Text := sSQLInsert + ')' + sSQLValues +  ')';
                qry_Synch.ParamByName('Vorname').AsString := sFirstName;
                qry_Synch.ParamByName('Nachname').AsString := sLastName;
                if sGeburtsdatum <> '' then
                  qry_Synch.ParamByName('Geburtsdatum').asDAte := StrToDate(sGeburtsdatum)
                else
                  qry_Synch.ParamByName('Geburtsdatum').asDAte := StrToDate('01.01.1900');
                qry_Synch.ParamByName('Firma').asString := Contact.Organization;
                qry_Synch.ParamByName('Telefon').asString := sPrivat;
                qry_Synch.ParamByName('Handy').asString := sMobil;
                qry_Synch.ParamByName('TelefonFirma').asString := sTelefonFirma;
                qry_Synch.ParamByName('HandyFirma').asString := sHandyFirma;
                qry_Synch.ParamByName('Email').asString := sMailPrivat;
                qry_Synch.ParamByName('EmailFirma').asString := sMailFirma;
                qry_Synch.ParamByName('Strasse').AsString := sStrasse;
                qry_Synch.ParamByName('PLZ').AsString := sPLZ;
                qry_Synch.ParamByName('Ort').AsString := sOrt;
                qry_Synch.ParamByName('StrasseFirma').AsString := sStrasseFirma;
                qry_Synch.ParamByName('PLZFirma').AsString := sPLZFirma;
                qry_Synch.ParamByName('OrtFirma').AsString := sOrtFirma;
                if bmPicture <> nil then
                  qry_Synch.ParamByName('Bild').AsMemo := Base64FromBitmap(bmPicture)
                else
                  qry_Synch.ParamByName('Bild').AsMemo := '';
                qry_Synch.ExecSQL;
              end;
            end;
            FreeandNil(qry_Synch);
          end;
          sPrevContact:= sCurrContact;
//          Inc(Index);
        end);
      end;
    except
      on E: Exception do
        TThread.Synchronize(nil,
          procedure begin ShowMessage('Kontaktimport: ' + E.Message); end);
    end;
  finally
    TThread.Synchronize(nil,
      procedure
      begin
        lv_Contacts.PullRefreshWait := False;
        pgbr_ProgressAnimation.Enabled := False;
        frm_PCM_Main.btn_BackSystem.Enabled := True;
        frm_PCM_Main.btn_Synchronisation.Enabled := True;
        frm_PCM_Main.bKontakte := False;
        rec_ContactsProgressbar.Visible := False;
        frm_PCM_Main.btn_BackSystemClick(Self);
      end);
    dmmain.wfWaitFrame.HideFW;
  end;
  end);
end;
procedure Tfrm_PCMAPP_ImportKontakte.LocationPermissionRequestResult(Sender: TObject; const APermissions:TClassicStringDynArray; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to Pred(Length(APermissions)) do
  begin
    if APermissions[I] = sPermissionReadContacts then
      RationaleMsg := RationaleMsg + 'The app needs to look in the address book';
    if I <> Pred(Length(APermissions)) then
      RationaleMsg := RationaleMsg + SLineBreak + SLineBreak;
  end;
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc
    end)
end;
procedure Tfrm_PCMAPP_ImportKontakte.lv_ContactsPullRefresh(Sender: TObject);
begin
  lv_Contacts.PullRefreshWait := True;
  FillContactsList;
end;
constructor Tfrm_PCMAPP_ImportKontakte.Create(AOwner: TComponent);
  procedure SetDesign;
  var
    DetailColor: Cardinal;
    TextColor: Cardinal;
    iDesignStyle: integer;
  begin
    DetailColor:=TAlphaColorRec.White;
    TextColor:=TAlphaColorRec.White;
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    {$ENDIF MSWINDOWS}
    case iDesignStyle of
      0: // Calypso
      begin
        DetailColor:=TAlphaColorRec.White;
        TextColor:= TAlphaColorRec.White;
      end;
      1: // Diamond
      begin
        DetailColor:= TAlphaColorRec.Black;
        TextColor:= TAlphaColorRec.Black;
      end;
      2:
      begin
        DetailColor:=TAlphaColorRec.White;
        TextColor:= TAlphaColorRec.White;
      end;
      3:
      begin
        DetailColor:=TAlphaColorRec.White;
        TextColor:= TAlphaColorRec.White;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        DetailColor:= TAlphaColorRec.White;
        TextColor:= TAlphaColorRec.White;
      end;
      {$ENDIF MSWINDOWS}
    end;
    lv_Contacts.ItemAppearanceObjects.ItemObjects.Detail.TextColor := DetailColor;
    lv_Contacts.ItemAppearanceObjects.ItemObjects.Text.TextColor:= TextColor;
  end;
begin
  inherited;
  SetDesign;
  frm_PCM_Main.iTags:= 7;
  frm_PCM_Main.SetDisableToolButtons;
  frm_PCM_Main.tc_More.ActiveTab := frm_PCM_Main.ti_2ConfigImportContacts;
  frm_PCM_Main.btn_BackSystem.Visible := True;
  frm_PCM_Main.lbl_ModulName.Text := 'Kontakte aus Telefon';
  frm_PCM_Main.btn_Synchronisation.visible:= True;
  {$IFDEF ANDROID}
  sPermissionReadContacts := JStringToString(TJManifest_permission.JavaClass.READ_CONTACTS);
  {$ENDIF}
  adrbk_Contacts.RequestPermission(LocationPermissionRequestResult);
end;
{$EndRegion FUNCTIONS}
end.
