unit PCMAPP.Restore.Detail;

interface

uses
  PCMAPP.BackgroundTasks,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FMX.DialogService.Async,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, System.ImageList, FMX.ImgList, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListBox, FMX.Edit, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  {$IFDEF ANDROID}
  DW.NativeSlider,
  {$ENDIF ANDROID}

  FMX.VirtualKeyboard,System.IOUtils,FMX.Platform,system.Math,System.Threading,
  FMX.Effects;

type
  TfrmRestoreDetail = class(TForm)
    tbMain: TRectangle;
    lblModulName: TLabel;
    Layout1: TLayout;
    btnBack: TButton;
    Layout2: TLayout;
    Layout3: TLayout;
    vsbxmain: TVertScrollBox;
    loMain: TLayout;
    vsbxBemerkung: TVertScrollBox;
    qryRestore: TFDQuery;
    ImageList1: TImageList;
    btnBetragNull: TButton;
    lblTarget: TLabel;
    loLocalAccountSwitch: TLayout;
    swBelege: TSwitch;
    loLocalAccountDetail: TLayout;
    loLocalAccountDetailDescription: TLabel;
    lo8Belege: TLayout;
    lo9Gutscheine: TLayout;
    Layout6: TLayout;
    swGutschein: TSwitch;
    Layout7: TLayout;
    Label1: TLabel;
    lo7Ausgaben: TLayout;
    Layout9: TLayout;
    swAusgaben: TSwitch;
    Layout10: TLayout;
    Label2: TLabel;
    lo6Einnahmen: TLayout;
    Layout12: TLayout;
    swEinnahmen: TSwitch;
    Layout13: TLayout;
    Label3: TLabel;
    lo5Serials: TLayout;
    Layout15: TLayout;
    swSerial: TSwitch;
    Layout16: TLayout;
    Label4: TLabel;
    lo4Passwort: TLayout;
    Layout18: TLayout;
    swPasswort: TSwitch;
    Layout19: TLayout;
    Label5: TLabel;
    lo3Kalender: TLayout;
    Layout21: TLayout;
    swKalender: TSwitch;
    Layout22: TLayout;
    Label6: TLabel;
    lo2Kontakte: TLayout;
    Layout24: TLayout;
    swKontakt: TSwitch;
    Layout25: TLayout;
    Label7: TLabel;
    lo1All: TLayout;
    Layout27: TLayout;
    swAll: TSwitch;
    Layout28: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    cbxFiles: TComboBox;
    Label10: TLabel;
    qryMain: TFDQuery;
    ProgressBar1: TProgressBar;
    Layout4: TLayout;
    Layout5: TLayout;
    Switch1: TSwitch;
    Layout8: TLayout;
    Label11: TLabel;
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure swAllClick(Sender: TObject);
    procedure cbxFilesChange(Sender: TObject);
    procedure btnBetragNullClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FService1 : IFMXVirtualKeyboardToolbarService;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;

var
  frmRestoreDetail: TfrmRestoreDetail;

implementation

{$R *.fmx}

uses pcmapp.Main,pcmapp.Datamodul;

procedure TfrmRestoreDetail.btnBetragNullClick(Sender: TObject);
var
  iAnzahl: integer;
begin
  TDialogServiceAsync.MessageDialog('Möchten Sie die ausgewählten Tabellen wiederherstellen?',
  TMsgDlgType.mtInformation, mbYesNo, TMsgDlgBtn.mbNo, 0,
  procedure(const AResult: TModalResult)
  begin
    if AResult = mrYes then
    begin
      RunAppTask(
      procedure
      begin
        ProgressBar1.Min:= 0;
        dmMain.conRestore.Params.Values['Database'] := TPath.Combine(TPath.GetsharedDocumentsPath, cbxFiles.Items[cbxFiles.Itemindex]);
        dmMain.conRestore.Connected:= true;
        dmmain.WriteLog('Restore Connected',0,false);
        if swBelege.IsChecked then
        begin
          ProgressBar1.value:= 0;
          qryRestore.SQL.Text:= 'SELECT * FROM Belege';
          ProgressBar1.Max:= qryRestore.RecordCount;
          qryRestore.open;
          while not qryRestore.Eof do
          begin
            ProgressBar1.Value:= ProgressBar1.Value + 1;
            qryMain.SQL.Text:= 'Select Count(*) as Anzahl From Belege where ID = :ID';
            qryMain.ParamByName('ID').AsInteger:= qryRestore.FieldByName('ID').AsInteger;
            qryMain.open;
            iAnzahl:= qryMain.FieldByName('Anzahl').AsInteger;
            qryMain.Close;
            if iAnzahl = 0 then
            begin
              qryMain.SQl.Text:= 'Insert into Belege (Nummer,Datum,Aussteller,Betrag,Kategorie,Belege_ID,GeaendertAm,Deleted) Values ' +
                                  ' (:Nummer,:Datum,:Aussteller,:Betrag,:Kategorie,:Belege_ID,:GeaendertAm,:Deleted)';
              try
                qryMain.ParamByName('Nummer').AsString:= qryRestore.FieldByName('Nummer').AsString;
                qryMain.ParamByName('Datum').AsDate:= qryRestore.FieldByName('Datum').AsDateTime;
                qryMain.ParamByName('Aussteller').AsString:= qryRestore.FieldByName('Aussteller').AsString;
                qryMain.ParamByName('Betrag').AsFloat:= qryRestore.FieldByName('Betrag').asFloat;
                qryMain.ParamByName('Kategorie').AsInteger:= qryRestore.FieldByName('Kategorie').AsInteger;
                qryMain.ParamByName('Belege_ID').AsInteger:= qryRestore.FieldByName('Belege_ID').AsInteger;
                qryMain.ParamByName('GeaendertAm').AsDateTime:= qryRestore.FieldByName('GeaendertAm').AsDateTime;
                qryMain.ParamByName('Deleted').AsBoolean:= qryRestore.FieldByName('Deleted').AsBoolean;
                qryMain.ExecSQL;
              except
                on e:Exception do
                  dmmain.WriteLog(e.Message,2,false);
              end;
            end;
            qryRestore.Next
          end;
        end;
        if swGutschein.IsChecked then
        begin
          ProgressBar1.value:= 0;
          qryRestore.SQL.Text:= 'SELECT * FROM Gutschein';
          ProgressBar1.Max:= qryRestore.RecordCount;
          qryRestore.open;
          while not qryRestore.Eof do
          begin
            ProgressBar1.Value:= ProgressBar1.Value + 1;
            qryMain.SQL.Text:= 'Select Count(*) as Anzahl From Gutschein where ID = :ID';
            qryMain.ParamByName('ID').AsInteger:= qryRestore.FieldByName('ID').AsInteger;
            qryMain.open;
            iAnzahl:= qryMain.FieldByName('Anzahl').AsInteger;
            qryMain.Close;
            if iAnzahl = 0 then
            begin
              qryMain.SQl.Text:= 'Insert into Gutschein (Nummer,Bezeichnung,Wert,RestWert,Datum,AbfragePin,Gutschein_ID,GeaendertAm,Deleted) Values ' +
                                  ' (:Nummer,:Bezeichnung,:Wert,:RestWert,:Datum,:AbfragePin,:Gutschein_ID,:GeaendertAm,:Deleted)';
              try
                qryMain.ParamByName('Nummer').AsString:= qryRestore.FieldByName('Nummer').AsString;
                qryMain.ParamByName('Bezeichnung').AsString:= qryRestore.FieldByName('Bezeichnung').AsString;
                qryMain.ParamByName('Wert').AsFloat:= qryRestore.FieldByName('Wert').AsFloat;
                qryMain.ParamByName('RestWert').AsFloat:= qryRestore.FieldByName('RestWert').AsFloat;
                qryMain.ParamByName('Datum').asDate:= qryRestore.FieldByName('Datum').AsDateTime;
                qryMain.ParamByName('AbfragePin').AsInteger:= qryRestore.FieldByName('AbfragePin').AsInteger;
                qryMain.ParamByName('Gutschein_ID').AsInteger:= qryRestore.FieldByName('Gutschein_ID').AsInteger;
                qryMain.ParamByName('GeaendertAm').AsDateTime:= qryRestore.FieldByName('GeaendertAm').AsDateTime;
                qryMain.ParamByName('Deleted').AsBoolean:= qryRestore.FieldByName('Deleted').AsBoolean;
                qryMain.ExecSQL;
              except
                on e:Exception do
                  dmmain.WriteLog(e.Message,2,false);
              end;
            end;
            qryRestore.Next
          end;
        end;
      end);
    end;
  end);
end;
procedure TfrmRestoreDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - FKBBounds.Top);
  end;
end;
procedure TfrmRestoreDetail.cbxFilesChange(Sender: TObject);
begin
  if cbxFiles.ItemIndex > -1  then
  begin
    swKontakt.enabled:= true;
    swKalender.enabled:= true;
    swPasswort.enabled:= true;
    swSerial.enabled:= true;
    swEinnahmen.enabled:= true;
    swAusgaben.enabled:= true;
    swBelege.enabled:= true;
    swGutschein.enabled:= true;
  end;
end;
procedure TfrmRestoreDetail.RestorePosition;
begin
  vsbxmain.ViewportPosition := PointF(vsbxmain.ViewportPosition.X, 0);
  lomain.Align := TAlignLayout.Client;
  vsbxmain.RealignContent;
end;
procedure TfrmRestoreDetail.swAllClick(Sender: TObject);
begin
  if swAll.IsChecked then
  begin
    label10.Text:= 'Sie haben alle Tabellen ausgewählt. Hierbei werden auch alle Systemrelevanten Tabellen wiederhergestellt.';

    swKontakt.IsChecked:= true;
    swKontakt.enabled:= false;

    swKalender.IsChecked:= true;
    swKalender.enabled:= false;

    swPasswort.IsChecked:= true;
    swPasswort.enabled:= false;

    swSerial.IsChecked:= true;
    swSerial.enabled:= false;

    swEinnahmen.IsChecked:= true;
    swEinnahmen.enabled:= false;

    swAusgaben.IsChecked:= true;
    swAusgaben.enabled:= false;

    swBelege.IsChecked:= true;
    swBelege.enabled:= false;

    swGutschein.IsChecked:= true;
    swGutschein.enabled:= false;

  end
  else begin
    label10.Text:= 'Sie haben nur einzelne Tabellen ausgewählt. Hierbei werden nur die Tabellen wiederhergestellt, die Sie ausgewählt haben.';
    swKontakt.enabled:= true;
    swKalender.enabled:= true;
    swPasswort.enabled:= true;
    swSerial.enabled:= true;
    swEinnahmen.enabled:= true;
    swAusgaben.enabled:= true;
    swBelege.enabled:= true;
    swGutschein.enabled:= true;
  end;

end;
procedure TfrmRestoreDetail.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbxmain.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      lomain.Align := TAlignLayout.Horizontal;
      vsbxmain.RealignContent;
      Application.ProcessMessages;
      vsbxmain.ViewportPosition :=
        PointF(vsbxmain.ViewportPosition.X,
               LFocusRect.Bottom - (FKBBounds.Top - 48));
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;
procedure TfrmRestoreDetail.btnBackClick(Sender: TObject);
begin
  Close;
end;
procedure TfrmRestoreDetail.FormCreate(Sender: TObject);
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardToolbarService, IInterface(FService1)) then
  begin
    FService1.SetToolbarEnabled(True);
    FService1.SetHideKeyboardButtonVisibility(True);
  end;
  vsbxmain.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frmRestoreDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure TfrmRestoreDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure TfrmRestoreDetail.FormShow(Sender: TObject);
var
  i,i2: integer;
//  TextColor: Cardinal;
  LList: TStringDynArray;
begin
  swKontakt.enabled:= false;
  swKalender.enabled:= false;
  swPasswort.enabled:= false;
  swSerial.enabled:= false;
  swEinnahmen.enabled:= false;
  swAusgaben.enabled:= false;
  swBelege.enabled:= false;
  swGutschein.enabled:= false;
  {$IFDEF MSWINDOWS}
  frmRestoreDetail.StyleBook:= dmmain.stB_Win_1;
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tbmain.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  {$IFDEF ANDROID}
//  TextColor:= $FF393939;
  case iDesign of
    // System
    0:
    begin
//      TextColor:= $FF393939;
      frmRestoreDetail.StyleBook:= frmmain.StyleCalypso;
    end;
    // Hell
    1:
    begin
//      TextColor:= $FF393939;
      frmRestoreDetail.StyleBook:= frmmain.StyleCalypso;
    end;

    // dunkel
    2:
    begin
//      TextColor:= $FFFCFCFC;
      frmRestoreDetail.StyleBook:= frmmain.StyleCalypso;
    end;
    // Calypso
    3:
    begin
//      TextColor:= $FFFCFCFC;
      frmRestoreDetail.StyleBook:= frmMain.StyleCalypso;
    end;
  end;
  {$ENDIF ANDROID}
end;
procedure TfrmRestoreDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition
end;
procedure TfrmRestoreDetail.FormVirtualKeyboardShown(Sender: TObject;  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

end.
