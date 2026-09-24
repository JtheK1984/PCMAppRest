unit PCMAPP.Kontakte.Detail;

interface

uses
  {$Region uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FMX.Objects, FMX.DateTimeCtrls,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D,
  System.IOUtils, System.Sensors,System.Threading, FMX.ListView,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  System.Math, Soap.EncdDecd,System.netencoding,
  {$IFDEF ANDROID}
  FMX.PushNotification.Android,
  FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  FMX.Platform,
  Androidapi.JNIBridge,
  System.Android.Notification,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Media,
  Androidapi.JNI.Provider,
  FMX.DialogService.Async,
  Androidapi.JNI.App,
  FMX.VirtualKeyboard,
  Androidapi.JNI.Net,
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI,
  {$ENDIF MSWINDOWS}
  IdURI, FMX.Effects,  FMX.ListBox, FMX.ComboEdit,
  System.ImageList, FMX.ImgList, FMX.EditBox, FMX.NumberBox;
  {$EndRegion uses}
type
  {$Region Type}
  Tfrm_PCMAPP_KontakteDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_Anrede: TComboBox;
    cbx_Familienstand: TComboBox;
    cbx_Geschlecht: TComboBox;
    cbx_Konfession: TComboBox;
    cbx_Staatsangehoerigkeit: TComboBox;
    dtp_Geburtsdatum: TDateEdit;
    edt_Email: TEdit;
    edt_EMailfirma: TEdit;
    edt_Firma: TEdit;
    edt_Handy: TEdit;
    edt_HandyFirma: TEdit;
    edt_Nachname: TEdit;
    edt_Postleitzahl: TEdit;
    edt_PostleitzahlFirma: TEdit;
    edt_Strasse: TEdit;
    edt_StrasseFirma: TEdit;
    edt_Telefon: TEdit;
    edt_TelefonFirma: TEdit;
    edt_Vorname: TEdit;
    img_EMail: TImage;
    img_EMailfirma: TImage;
    img_Handy: TImage;
    img_HandyFirma: TImage;
    img_MapFirma: TImage;
    img_MapPrivat: TImage;
    img_Picture: TImage;
    img_PictureDefault: TImage;
    img_TelefonFirma: TImage;
    img_TelefonPrivat: TImage;
    imglst_Contacts: TImageList;
    lbl_Adresse: TLabel;
    lbl_AdresseFirma: TLabel;
    lbl_Anrede: TLabel;
    lbl_Familienstand: TLabel;
    lbl_Firma: TLabel;
    lbl_Firmar: TLabel;
    lbl_Geburtsdatum: TLabel;
    lbl_Geschlecht: TLabel;
    lbl_Handy: TLabel;
    lbl_HandyFirma: TLabel;
    lbl_Konfession: TLabel;
    lbl_Mail: TLabel;
    lbl_MailFirma: TLabel;
    lbl_ModulName: TLabel;
    lbl_Nachname: TLabel;
    lbl_PRIVAT: TLabel;
    lbl_Staatsangehoerigkeit: TLabel;
    lbl_Telefon: TLabel;
    lbl_TelefonFirma: TLabel;
    lbl_Vorname: TLabel;
    lo_Adresse: TLayout;
    lo_AdresseFirma: TLayout;
    lo_AdresseFirmaDetail: TLayout;
    lo_AdressPrivatDetail: TLayout;
    lo_EMail: TLayout;
    lo_EMailFirma: TLayout;
    lo_Form: TLayout;
    lo_Handy: TLayout;
    lo_HandyFirma: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Right: TLayout;
    lo_Telefon: TLayout;
    lo_TelefonFirma: TLayout;
    rec_FIRMA: TRectangle;
    rec_MapFirma: TRectangle;
    rec_MapPrivat: TRectangle;
    rec_Photo: TRectangle;
    rec_PRIVAT: TRectangle;
    tb_Main: TRectangle;
    vsbx_KontakteDetailView: TVertScrollBox;
    vsbx_main: TVertScrollBox;
    procedure btn_BackClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure img_EMailClick(Sender: TObject);
    procedure img_EMailfirmaClick(Sender: TObject);
    procedure img_HandyClick(Sender: TObject);
    procedure img_HandyFirmaClick(Sender: TObject);
    procedure img_MapFirmaClick(Sender: TObject);
    procedure img_MapPrivatClick(Sender: TObject);
    procedure img_TelefonFirmaClick(Sender: TObject);
    procedure img_TelefonPrivatClick(Sender: TObject);
  private
    { Private-Deklarationen }
    dBounds: TRectF;
    bNeedOffset: Boolean;
    qry_Kontakte: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure SendMail(ATarget: string);
    procedure SendToMapApp(AStreet,AZip: string);public
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion Type}
var
  frm_PCMAPP_KontakteDetail: Tfrm_PCMAPP_KontakteDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_KontakteDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_KontakteDetail.SendMail(ATarget: string);
{$IFDEF ANDROID}
var
  JRecipient: TJavaObjectArray<JString>;
  Intent: JIntent;
{$ENDIF ANDROID}
{$IFDEF MSWINDOWS}
var
  ExecStr : String;
{$ENDIF MSWINDOWS}
begin
{$IFDEF ANDROID}
  JRecipient := TJavaObjectArray<JString>.Create(1);
  JRecipient.Items[0] := StringToJString(ATarget);
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_SEND);
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, JRecipient);
  Intent.setType(StringToJString('vnd.android.cursor.dir/email'));
  TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  ExecStr := Format('mailto:%s?subject=', [ATarget]);
  ShellExecute(0,'open', PChar(ExecStr), NIL, NIL, 1);
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_KontakteDetail.SendToMapApp(AStreet,AZip: string);
{$IFDEF ANDROID}
var
  Intent: JIntent;
{$ENDIF ANDROID}
begin
  {$IFDEF ANDROID}
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
  TJnet_Uri.JavaClass.parse(StringToJString('http://maps.google.com/?q=' + AStreet + ', ' + AZip)));
  TAndroidHelper.Activity.startActivity(Intent);
  exit;
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', PChar('http://maps.google.de/maps?q=' + AStreet + ',' + AZiP + '&z=12'), nil, nil, 1);
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_KontakteDetail.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  bNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbx_main.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(dBounds))) and  (LFocusRect.Bottom > dBounds.Top) then
    begin
      bNeedOffset := True;
      lo_main.Align := TAlignLayout.Horizontal;
      vsbx_main.RealignContent;
      Application.ProcessMessages;
      vsbx_main.ViewportPosition :=  PointF(vsbx_main.ViewportPosition.X, LFocusRect.Bottom - (dBounds.Top - 48));
    end;
  end;
  if not bNeedOffset then
    RestorePosition;
end;
{$ENDRegion Helperfunctions}
////////////////////////////////////////////////////////////////////////////////
// Button FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region ButtonFunctions}
procedure Tfrm_PCMAPP_KontakteDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_KontakteDetail.close;
end;
procedure Tfrm_PCMAPP_KontakteDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_KontakteDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_Kontakte.SQL.Text:= sSQL_SEL_ALL_Kontakte_WHERE_ID;
    qry_Kontakte.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Kontakte.open;
    cbx_Anrede.ItemIndex:= -1;
  //  cbx_Anrede.Text:= '';
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Herr' then
      cbx_Anrede.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Frau' then
      cbx_Anrede.ItemIndex:= 1;
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Familie' then
      cbx_Anrede.ItemIndex:= 2;
    edt_Vorname.Text:= qry_Kontakte.FieldByName('Vorname').AsString;
    edt_Nachname.Text:= qry_Kontakte.FieldByName('Nachname').AsString;
    cbx_Geschlecht.ItemIndex:=  -1;
  //  cbx_Geschlecht.Text:= '';
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'männlich' then
      cbx_Geschlecht.ItemIndex:=  0;
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'weiblich' then
      cbx_Geschlecht.ItemIndex:=  1;
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'Familie' then
      cbx_Geschlecht.ItemIndex:=  2;
    dtp_Geburtsdatum.Text:= qry_Kontakte.FieldByName('Geburtsdatum').AsString;
    if qry_Kontakte.FieldByName('Geburtsdatum').AsDateTime <>  StrToDate('01.01.1900') then
      dtp_Geburtsdatum.Text:= FormatDateTime('dd.mm.yyyy', qry_Kontakte.FieldByName('Geburtsdatum').AsDateTime)
    else
      dtp_Geburtsdatum.Text:= '';

    cbx_Familienstand.itemindex:= -1;
  //  cbx_Familienstand.text:= '';
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'ledig' then
      cbx_Familienstand.itemindex:= 0;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'geschieden' then
      cbx_Familienstand.itemindex:= 1;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'verheiratet' then
      cbx_Familienstand.itemindex:= 2;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'verwitwet' then
      cbx_Familienstand.itemindex:= 3;

    cbx_Staatsangehoerigkeit.ItemIndex:= -1;
  //  cbx_Staatsangehoerigkeit.text:= '';
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='deutsch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='englisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:=1;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='französisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 2;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='bosnisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 3;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='russisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 4;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='türkisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 5;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='amerikanisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 6;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='arabisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 7;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='indisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 8;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='polnisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 9;

    cbx_Konfession.ItemIndex:= -1;
  //  cbx_Konfession.Text:= '';
    if qry_Kontakte.FieldByName('Konfession').AsString = 'Römisch-Katholisch' then
      cbx_Konfession.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Konfession').AsString = 'Evangelisch' then
      cbx_Konfession.ItemIndex:= 1;
    if qry_Kontakte.FieldByName('Konfession').AsString = 'Sonstige' then
      cbx_Konfession.ItemIndex:= 2;
    edt_Strasse.Text:= qry_Kontakte.FieldByName('Strasse').AsString;
    edt_Postleitzahl.Text:= qry_Kontakte.FieldByName('PLZ').AsString + ' ' + qry_Kontakte.FieldByName('Ort').AsString;;
    edt_Telefon.Text:= qry_Kontakte.FieldByName('Telefon').AsString;
    edt_Handy.Text:= qry_Kontakte.FieldByName('Handy').AsString;
    edt_Email.Text:= qry_Kontakte.FieldByName('Email').AsString;
    edt_Firma.Text:= qry_Kontakte.FieldByName('Firma').AsString;
    edt_StrasseFirma.Text:= qry_Kontakte.FieldByName('StrasseFirma').AsString;
    edt_PostleitzahlFirma.Text:= qry_Kontakte.FieldByName('PLZFirma').AsString + ' ' + qry_Kontakte.FieldByName('OrtFirma').AsString;
    edt_TelefonFirma.Text:= qry_Kontakte.FieldByName('TelefonFirma').AsString;
    edt_HandyFirma.Text:= qry_Kontakte.FieldByName('HandyFirma').AsString;
    edt_EmailFirma.Text:= qry_Kontakte.FieldByName('EmailFirma').AsString;
    qry_Kontakte.Close;

    cbx_Anrede.enabled:= false;
    edt_Vorname.enabled:= false;
    edt_Nachname.enabled:= false;
    cbx_Geschlecht.enabled:= false;
    dtp_Geburtsdatum.enabled:= false;
    cbx_Familienstand.enabled:= false;
    cbx_Staatsangehoerigkeit.enabled:= false;
    cbx_Konfession.enabled:= false;
    edt_Strasse.enabled:= false;
    edt_Postleitzahl.enabled:= false;
    edt_Telefon.enabled:= false;
    edt_Handy.enabled:= false;
    edt_Email.enabled:= false;
    edt_Firma.enabled:= false;
    edt_StrasseFirma.enabled:= false;
    edt_PostleitzahlFirma.enabled:= false;
    edt_TelefonFirma.enabled:= false;
    edt_HandyFirma.enabled:= false;
    edt_EmailFirma.enabled:= false;

    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.btn_EditClick(Sender: TObject);
begin
  cbx_Anrede.enabled:= true;
  edt_Vorname.enabled:= true;
  edt_Nachname.enabled:= true;
  cbx_Geschlecht.enabled:= true;
  dtp_Geburtsdatum.enabled:= true;
  cbx_Familienstand.enabled:= true;
  cbx_Staatsangehoerigkeit.enabled:= true;
  cbx_Konfession.enabled:= true;
  edt_Strasse.enabled:= true;
  edt_Postleitzahl.enabled:= true;
  edt_Telefon.enabled:= true;
  edt_Handy.enabled:= true;
  edt_Email.enabled:= true;
  edt_Firma.enabled:= true;
  edt_StrasseFirma.enabled:= true;
  edt_PostleitzahlFirma.enabled:= true;
  edt_TelefonFirma.enabled:= true;
  edt_HandyFirma.enabled:= true;
  edt_EmailFirma.enabled:= true;
  cbx_Anrede.SetFocus;

  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_KontakteDetail.btn_SaveApplyStyleLookup(Sender: TObject);
var
  LGlyph: TGlyph;
begin
  // Reapply after each StyleBook change; keep the existing light/dark image index.
  if btn_Save.FindStyleResource<TGlyph>('glyphstyle', LGlyph) then
  begin
    LGlyph.Margins.Rect := TRectF.Create(0, 0, 0, 0);
    LGlyph.Align := TAlignLayout.Center;
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Vorname.Text = '') or (edt_Nachname.Text = '') then
  begin
    ShowMessage('Vor- und Nachname darf nicht leer sein!');
    exit;
  end;

  if not frm_PCM_Main.bNeu then
  begin
    qry_Kontakte.SQL.Text:= sSQL_UPD_ALL_Kontakte_WHERE_ID;
    qry_Kontakte.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    if cbx_Anrede.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Anrede').AsString:= cbx_Anrede.Selected.Text
    else
      qry_Kontakte.ParamByName('Anrede').AsString:= '';

    qry_Kontakte.ParamByName('Vorname').AsString:= edt_Vorname.Text;
    qry_Kontakte.ParamByName('Nachname').AsString:= edt_Nachname.Text;
    qry_Kontakte.ParamByName('Strasse').AsString:= edt_Strasse.Text;
    qry_Kontakte.ParamByName('PLZ').AsString:= Copy(edt_Postleitzahl.Text,1,5);
    qry_Kontakte.ParamByName('Ort').AsString:= Copy(edt_Postleitzahl.Text,7,Length(edt_Postleitzahl.Text)-6 );
    qry_Kontakte.ParamByName('Telefon').AsString:= edt_Telefon.Text;
    qry_Kontakte.ParamByName('Handy').AsString:= edt_Handy.Text;
    qry_Kontakte.ParamByName('Email').AsString:= edt_Email.Text;
    qry_Kontakte.ParamByName('Geburtsdatum').AsDate:= dtp_Geburtsdatum.Date;
    if cbx_Geschlecht.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Geschlecht').AsString:= cbx_Geschlecht.Selected.Text
    else
      qry_Kontakte.ParamByName('Geschlecht').AsString:= '';

    if cbx_Familienstand.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Familienstand').AsString:= cbx_Familienstand.Selected.Text
    else
      qry_Kontakte.ParamByName('Familienstand').AsString:= '';

    if cbx_Staatsangehoerigkeit.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Staatsangehoerigkeit').AsString:= cbx_Staatsangehoerigkeit.Selected.Text
    else
      qry_Kontakte.ParamByName('Staatsangehoerigkeit').AsString:= '';

    if cbx_Konfession.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Konfession').AsString:= cbx_Konfession.Selected.Text
    else
      qry_Kontakte.ParamByName('Konfession').AsString:= '';

    qry_Kontakte.ParamByName('Firma').AsString:= edt_Firma.Text;
    qry_Kontakte.ParamByName('StrasseFirma').AsString:= edt_StrasseFirma.Text;
    qry_Kontakte.ParamByName('PLZFirma').AsString:= Copy(edt_PostleitzahlFirma.Text,1,5);
    qry_Kontakte.ParamByName('OrtFirma').AsString:= Copy(edt_PostleitzahlFirma.Text,7,Length(edt_PostleitzahlFirma.Text)-6 );
    qry_Kontakte.ParamByName('TelefonFirma').AsString:= edt_TelefonFirma.Text;
    qry_Kontakte.ParamByName('HandyFirma').AsString:= edt_HandyFirma.Text;
    qry_Kontakte.ParamByName('EmailFirma').AsString:= edt_EmailFirma.Text;
    qry_Kontakte.ExecSQl;
    with frm_PCM_Main.lv_Kontakte.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Vorname.Text + ' ' + edt_Nachname.Text;
      Detail:= edt_Firma.Text;
    end;
  end
  else begin
    frm_PCM_Main.bNeu:= false;
    qry_Kontakte.SQL.Text:= sSQL_INS_ALL_Kontakte;
    if cbx_Anrede.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Anrede').AsString:= cbx_Anrede.Selected.Text
    else
      qry_Kontakte.ParamByName('Anrede').AsString:= '';
    qry_Kontakte.ParamByName('Vorname').AsString:= edt_Vorname.Text;
    qry_Kontakte.ParamByName('Nachname').AsString:= edt_Nachname.Text;
    qry_Kontakte.ParamByName('Strasse').AsString:= edt_Strasse.Text;
    qry_Kontakte.ParamByName('PLZ').AsString:= Copy(edt_Postleitzahl.Text,1,5);
    qry_Kontakte.ParamByName('Ort').AsString:= Copy(edt_Postleitzahl.Text,7,Length(edt_Postleitzahl.Text)-6 );
    qry_Kontakte.ParamByName('Telefon').AsString:= edt_Telefon.Text;
    qry_Kontakte.ParamByName('Handy').AsString:= edt_Handy.Text;
    qry_Kontakte.ParamByName('Email').AsString:= edt_Email.Text;
    qry_Kontakte.ParamByName('Geburtsdatum').AsDate:= dtp_Geburtsdatum.Date;
    if cbx_Geschlecht.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Geschlecht').AsString:= cbx_Geschlecht.Selected.Text
    else
      qry_Kontakte.ParamByName('Geschlecht').AsString:= '';

    if cbx_Familienstand.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Familienstand').AsString:= cbx_Familienstand.Selected.Text
    else
      qry_Kontakte.ParamByName('Familienstand').AsString:= '';

    if cbx_Staatsangehoerigkeit.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Staatsangehoerigkeit').AsString:= cbx_Staatsangehoerigkeit.Selected.Text
    else
      qry_Kontakte.ParamByName('Staatsangehoerigkeit').AsString:= '';

    if cbx_Konfession.ItemIndex >= 0 then
      qry_Kontakte.ParamByName('Konfession').AsString:= cbx_Konfession.Selected.Text
    else
      qry_Kontakte.ParamByName('Konfession').AsString:= '';

    qry_Kontakte.ParamByName('Firma').AsString:= edt_Firma.Text;
    qry_Kontakte.ParamByName('StrasseFirma').AsString:= edt_StrasseFirma.Text;
    qry_Kontakte.ParamByName('PLZFirma').AsString:= Copy(edt_PostleitzahlFirma.Text,1,5);
    qry_Kontakte.ParamByName('OrtFirma').AsString:= Copy(edt_PostleitzahlFirma.Text,7,Length(edt_PostleitzahlFirma.Text)-6 );
    qry_Kontakte.ParamByName('TelefonFirma').AsString:= edt_TelefonFirma.Text;
    qry_Kontakte.ParamByName('HandyFirma').AsString:= edt_HandyFirma.Text;
    qry_Kontakte.ParamByName('EmailFirma').AsString:= edt_EmailFirma.Text;
    try
      qry_Kontakte.ExecSQl;
      frm_PCM_Main.lv_Kontakte.Items.Clear;
      frm_PCM_Main.lv_Kontakte.BeginUpdate;
      frm_PCM_Main.CreateKontaktuebersichtGridConfig;
      frm_PCM_Main.lv_Kontakte.EndUpdate;
    except
      on e:Exception do
        ShowMessage(e.Message)
    end;
  end;
  cbx_Anrede.enabled:= false;
  edt_Vorname.enabled:= false;
  edt_Nachname.enabled:= false;
  cbx_Geschlecht.enabled:= false;
  dtp_Geburtsdatum.enabled:= false;
  cbx_Familienstand.enabled:= false;
  cbx_Staatsangehoerigkeit.enabled:= false;
  cbx_Konfession.enabled:= false;
  edt_Strasse.enabled:= false;
  edt_Postleitzahl.enabled:= false;
  edt_Telefon.enabled:= false;
  edt_Handy.enabled:= false;
  edt_Email.enabled:= false;
  edt_Firma.enabled:= false;
  edt_StrasseFirma.enabled:= false;
  edt_PostleitzahlFirma.enabled:= false;
  edt_TelefonFirma.enabled:= false;
  edt_HandyFirma.enabled:= false;
  edt_EmailFirma.enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_EMailClick(Sender: TObject);
begin
  if (edt_Email.text <> '') then
  begin
    SendMail(edt_Email.text);
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_EMailfirmaClick(Sender: TObject);
begin
  if (edt_EmailFirma.text <> '') then
  begin
    SendMail(edt_EmailFirma.text);
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_HandyClick(Sender: TObject);
begin
  frm_PCM_Main.sDisplayname:= edt_Vorname.Text + ' ' + edt_Nachname.Text;
  frm_PCM_Main.sPhoneNumber:=  edt_Handy.Text;
  frm_PCM_Main.MakeCall(Self);
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_HandyFirmaClick(Sender: TObject);
begin
  frm_PCM_Main.sDisplayname:= edt_Vorname.Text + ' ' + edt_Nachname.Text;
  frm_PCM_Main.sPhoneNumber:= edt_HandyFirma.Text;
  frm_PCM_Main.MakeCall(Self);
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_MapPrivatClick(Sender: TObject);
begin
  if (edt_Strasse.text <> '') and (edt_Postleitzahl.text <> '') then
  begin
    SendToMapApp(edt_Strasse.text,edt_Postleitzahl.text);
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_MapFirmaClick(Sender: TObject);
begin
  if (edt_StrasseFirma.text <> '') and (edt_PostleitzahlFirma.text <> '') then
  begin
    SendToMapApp(edt_StrasseFirma.text,edt_PostleitzahlFirma.text);
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_TelefonPrivatClick(Sender: TObject);
begin
  frm_PCM_Main.sDisplayname:= edt_Vorname.Text + ' ' + edt_Nachname.Text;
  frm_PCM_Main.sPhoneNumber:= edt_Telefon.Text;
  frm_PCM_Main.MakeCall(Self);
end;
procedure Tfrm_PCMAPP_KontakteDetail.img_TelefonFirmaClick(Sender: TObject);
begin
  frm_PCM_Main.sDisplayname:= edt_Vorname.Text + ' ' + edt_Nachname.Text;
  frm_PCM_Main.sPhoneNumber:= edt_TelefonFirma.Text;
  frm_PCM_Main.MakeCall(Self);
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_KontakteDetail.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  FreeandNil(qry_kontakte);
end;
procedure Tfrm_PCMAPP_KontakteDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_KontakteDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_KontakteDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_KontakteDetail.FormShow(Sender: TObject);
  function CreateRoundPhoto(const ASource: TBitmap): TBitmap;
  var
    Size: Integer;
  begin
    Result := TBitmap.Create;
    Size := Min(ASource.Height, ASource.Width);
    Result.SetSize(Size, Size);
    Result.Clear(TAlphaColorRec.Null);
    if Result.Canvas.BeginScene then
      try
        Result.Canvas.Fill.Bitmap.Bitmap.Assign(ASource);
        Result.Canvas.Fill.Kind := TBrushKind.Bitmap;
        Result.Canvas.FillEllipse(TRectF.Create(0, 0, Size, Size), 1);
      finally
        Result.Canvas.EndScene;
      end;
  end;
  function BitmapFromBase64(const base64: string): TBitmap;
  var
    Input: TStringStream;
    Output: TBytesStream;
  begin
    Input := TStringStream.Create(base64, TEncoding.ASCII);
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
  procedure SetDesign;
  var
    iDesignStyle,icbxCount: integer;
    TextColor: Cardinal;
  begin
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    {$ENDIF MSWINDOWS}
    TextColor:= TAlphaColorRec.White;
    case iDesignStyle of
      0: // Calypso
      begin
        frm_PCMAPP_KontakteDetail.StyleBook:= dmMain.stB_0;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_KontakteDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_KontakteDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_KontakteDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_KontakteDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.white;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_Anrede.count - 1 do
    begin
      cbx_Anrede.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Anrede.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Anrede.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Anrede.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Geschlecht.count - 1 do
    begin
      cbx_Geschlecht.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Geschlecht.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Geschlecht.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Geschlecht.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Familienstand.count - 1 do
    begin
      cbx_Familienstand.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Familienstand.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Familienstand.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Familienstand.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Staatsangehoerigkeit.count - 1 do
    begin
      cbx_Staatsangehoerigkeit.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Staatsangehoerigkeit.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Staatsangehoerigkeit.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Staatsangehoerigkeit.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Konfession.count - 1 do
    begin
      cbx_Konfession.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Konfession.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Konfession.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Konfession.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
var
  Pic : TBitmap;
begin
  SetDesign;
  qry_Kontakte:= TFDQuery.Create(nil);
  qry_Kontakte.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Kontaktedetails laden...', 'Kontakte', True);

  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  try
    cbx_Anrede.ItemIndex:= -1;
    cbx_Geschlecht.ItemIndex:=  -1;
    cbx_Familienstand.itemindex:= -1;
    cbx_Staatsangehoerigkeit.ItemIndex:= -1;
    cbx_Konfession.ItemIndex:= -1;
    qry_Kontakte.SQL.Text:= sSQL_SEL_ALL_Kontakte_WHERE_ID;
    qry_Kontakte.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Kontakte.open;
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Herr' then
      cbx_Anrede.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Frau' then
      cbx_Anrede.ItemIndex:= 1;
    if qry_Kontakte.FieldByName('Anrede').AsString = 'Familie' then
      cbx_Anrede.ItemIndex:= 2;
    edt_Vorname.Text:= qry_Kontakte.FieldByName('Vorname').AsString;
    edt_Nachname.Text:= qry_Kontakte.FieldByName('Nachname').AsString;
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'männlich' then
      cbx_Geschlecht.ItemIndex:=  0;
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'weiblich' then
      cbx_Geschlecht.ItemIndex:=  1;
    if qry_Kontakte.FieldByName('Geschlecht').AsString = 'Familie' then
      cbx_Geschlecht.ItemIndex:=  2;
    dtp_Geburtsdatum.Text:= qry_Kontakte.FieldByName('Geburtsdatum').AsString;
    if qry_Kontakte.FieldByName('Geburtsdatum').AsDateTime <>  StrToDate('30.12.1899') then
      dtp_Geburtsdatum.Text:= FormatDateTime('dd.mm.yyyy', qry_Kontakte.FieldByName('Geburtsdatum').AsDateTime)
    else
      dtp_Geburtsdatum.Text:= '';


    if qry_Kontakte.FieldByName('Familienstand').AsString = 'ledig' then
      cbx_Familienstand.itemindex:= 0;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'geschieden' then
      cbx_Familienstand.itemindex:= 1;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'verheiratet' then
      cbx_Familienstand.itemindex:= 2;
    if qry_Kontakte.FieldByName('Familienstand').AsString = 'verwitwet' then
      cbx_Familienstand.itemindex:= 3;

    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='deutsch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='englisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:=1;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='französisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 2;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='bosnisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 3;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='russisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 4;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='türkisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 5;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='amerikanisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 6;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='arabisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 7;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='indisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 8;
    if qry_Kontakte.FieldByName('Staatsangehoerigkeit').AsString='polnisch' then
      cbx_Staatsangehoerigkeit.ItemIndex:= 9;


    if qry_Kontakte.FieldByName('Konfession').AsString = 'Römisch-Katholisch' then
      cbx_Konfession.ItemIndex:= 0;
    if qry_Kontakte.FieldByName('Konfession').AsString = 'Evangelisch' then
      cbx_Konfession.ItemIndex:= 1;
    if qry_Kontakte.FieldByName('Konfession').AsString = 'Sonstige' then
      cbx_Konfession.ItemIndex:= 2;
    edt_Strasse.Text:= qry_Kontakte.FieldByName('Strasse').AsString;
    edt_Postleitzahl.Text:= qry_Kontakte.FieldByName('PLZ').AsString + ' ' + qry_Kontakte.FieldByName('Ort').AsString;;
    edt_Telefon.Text:= qry_Kontakte.FieldByName('Telefon').AsString;
    edt_Handy.Text:= qry_Kontakte.FieldByName('Handy').AsString;
    edt_Email.Text:= qry_Kontakte.FieldByName('Email').AsString;
    edt_Firma.Text:= qry_Kontakte.FieldByName('Firma').AsString;
    edt_StrasseFirma.Text:= qry_Kontakte.FieldByName('StrasseFirma').AsString;
    edt_PostleitzahlFirma.Text:= qry_Kontakte.FieldByName('PLZFirma').AsString + ' ' + qry_Kontakte.FieldByName('OrtFirma').AsString;
    edt_TelefonFirma.Text:= qry_Kontakte.FieldByName('TelefonFirma').AsString;
    edt_HandyFirma.Text:= qry_Kontakte.FieldByName('HandyFirma').AsString;
    edt_EmailFirma.Text:= qry_Kontakte.FieldByName('EmailFirma').AsString;
    if qry_Kontakte.FieldByName('Bild').AsString <> '' then
    begin;
      Pic:= BitmapFromBase64(qry_Kontakte.FieldByName('Bild').AsString);
      img_Picture.Bitmap := CreateRoundPhoto(Pic);
      img_Picture.Visible:= true;
      img_PictureDefault.Visible:= false;
    end
    else begin
      img_Picture.Visible:= false;
      img_PictureDefault.Visible:= true;
    end;
    qry_Kontakte.Close;
    cbx_Anrede.enabled:= false;
    edt_Vorname.enabled:= false;
    edt_Nachname.enabled:= false;
    cbx_Geschlecht.enabled:= false;
    dtp_Geburtsdatum.enabled:= false;
    cbx_Familienstand.enabled:= false;
    cbx_Staatsangehoerigkeit.enabled:= false;
    cbx_Konfession.enabled:= false;
    edt_Strasse.enabled:= false;
    edt_Postleitzahl.enabled:= false;
    edt_Telefon.enabled:= false;
    edt_Handy.enabled:= false;
    edt_Email.enabled:= false;
    edt_Firma.enabled:= false;
    edt_StrasseFirma.enabled:= false;
    edt_PostleitzahlFirma.enabled:= false;
    edt_TelefonFirma.enabled:= false;
    edt_HandyFirma.enabled:= false;
    edt_EmailFirma.enabled:= false;
    if frm_PCM_Main.bNeu  then
    begin
      cbx_Anrede.enabled:= true;
      edt_Vorname.enabled:= true;
      edt_Nachname.enabled:= true;
      cbx_Geschlecht.enabled:= true;
      dtp_Geburtsdatum.enabled:= true;
      cbx_Familienstand.enabled:= true;
      cbx_Staatsangehoerigkeit.enabled:= true;
      cbx_Konfession.enabled:= true;
      edt_Strasse.enabled:= true;
      edt_Postleitzahl.enabled:= true;
      edt_Telefon.enabled:= true;
      edt_Handy.enabled:= true;
      edt_Email.enabled:= true;
      edt_Firma.enabled:= true;
      edt_StrasseFirma.enabled:= true;
      edt_PostleitzahlFirma.enabled:= true;
      edt_TelefonFirma.enabled:= true;
      edt_HandyFirma.enabled:= true;
      edt_EmailFirma.enabled:= true;
      cbx_Anrede.SetFocus;
      btn_Back.Visible:= false;
      btn_Cancel.Visible:= true;
      btn_Edit.Visible:= false;
      btn_save.Visible:= true;
    end;
    dmmain.wfWaitFrame.HideFW;
    qry_Kontakte.Close;
  except
    qry_Kontakte.Close;
    dmmain.wfWaitFrame.HideFW;
    frm_PCM_Main.bNeu:= false;
  end;
end;
procedure Tfrm_PCMAPP_KontakteDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_KontakteDetail.FormVirtualKeyboardShown(Sender: TObject;  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.

