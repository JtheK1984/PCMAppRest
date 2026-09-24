unit PCMAPP.Passwort.Detail;

interface

uses
  {$Region uses}
  {$IFDEF MSWINDOWS}
  Shellapi, Winapi.Windows,
  {$ENDIF MSWINDOWS}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.Effects, FMX.Objects,System.Threading, System.ImageList,
  FMX.ImgList, system.math, FMX.DialogService.Async,
  FMX.Platform,FMX.VirtualKeyboard, FMX.EditBox, FMX.NumberBox, FMX.ListBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,  FMX.ListView,
  {$IFDEF ANDROID}
  Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  Androidapi.JNI.Os,
  FMX.PushNotification.Android,
  FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNIBridge,
  System.Android.Notification,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Media,
  Androidapi.JNI.Provider,
  Androidapi.JNI.App,
  Androidapi.JNI.Net,
  {$ENDIF ANDROID}
  FMX.TabControl;
  {$EndRegion uses}
type
  {$Region Types}
  Tfrm_PCMAPP_PasswortDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_Typ: TComboBox;
    edt_APP_IPConfig: TEdit;
    edt_APP_PortConfig: TNumberBox;
    edt_APP_VerschluesselungConfig: TEdit;
    edt_Beschreibung: TEdit;
    edt_linkURL: TEdit;
    edt_MAIL_PostausgangsPortConfig: TNumberBox;
    edt_MAIL_PostausgangsserverConfig: TEdit;
    edt_MAIL_PostausgangsVerschluesselungConfig: TEdit;
    edt_MAIL_PosteingangsPortConfig: TNumberBox;
    edt_MAIL_PosteingangsserverConfig: TEdit;
    edt_MAIL_PosteingangsVerschluesselungConfig: TEdit;
    edt_Pass: TEdit;
    edt_Target: TEdit;
    edt_VPN_SharedSecretConfig: TEdit;
    edt_WLANConfig: TEdit;
    img_Link: TImage;
    img_Passwordnotvis: TImage;
    img_Passwordvis: TImage;
    lbl_APP_IP: TLabel;
    lbl_APP_PortConfig: TLabel;
    lbl_APP_Verschluesselung: TLabel;
    lbl_Beschreibung: TLabel;
    lbl_linkURL: TLabel;
    lbl_MAIL_PostausgangsPort: TLabel;
    lbl_MAIL_Postausgangsserver: TLabel;
    lbl_MAIL_PostausgangsVerschluesselung: TLabel;
    lbl_MAIL_PosteingangsPortConfig: TLabel;
    lbl_MAIL_PosteingangsserverConfig: TLabel;
    lbl_MAIL_PosteingangsVerschluesselung: TLabel;
    lbl_ModulName: TLabel;
    lbl_pass: TLabel;
    lbl_Typ: TLabel;
    lbl_User: TLabel;
    lbl_VPN_SharedSecret: TLabel;
    lbl_WLANConfig: TLabel;
    lo_APP_Port: TLayout;
    lo_APP_Verschluesselung: TLayout;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Link: TLayout;
    lo_LinkDesc: TLayout;
    lo_LinkImg: TLayout;
    lo_MAIL_PostausgangsPort: TLayout;
    lo_MAIL_Postausgangsserver: TLayout;
    lo_MAIL_PostausgangsVerschluesselung: TLayout;
    lo_MAIL_PosteingangsPort: TLayout;
    lo_MAIL_Posteingangsserver: TLayout;
    lo_MAIL_PosteingangsVerschluesselung: TLayout;
    lo_Main: TLayout;
    lo_Password: TLayout;
    lo_PasswordDesc: TLayout;
    lo_PasswordImg: TLayout;
    lo_Right: TLayout;
    lo_VPNApp: TLayout;
    lo_VPNShared: TLayout;
    lo_WLAN: TLayout;
    tb_Main: TRectangle;
    vsbx_main: TVertScrollBox;
    vsbx_PasswortDetailView: TVertScrollBox;
    edt_PassClear: TEdit;
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure cbx_TypChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure img_LinkClick(Sender: TObject);
    procedure img_PasswordnotvisClick(Sender: TObject);
    procedure img_PasswordvisClick(Sender: TObject);
  private
    { Private-Deklarationen }
    bNeedOffset: Boolean;
    bWeiter: Boolean;
    dBounds: TRectF;
    qry_Passwort: TFDQuery;
    function EnDecrypt(AInput: string; AEncrypt: boolean): String;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure OpenURL(const URL: string; const DisplayError: Boolean = False);
    procedure RestorePosition;
    procedure SetCompVisible;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion Types}
var
  frm_PCMAPP_PasswortDetail: Tfrm_PCMAPP_PasswortDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL,
      LbCipher,
      LbClass;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_PasswortDetail.btn_SaveApplyStyleLookup(Sender: TObject);
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
function Tfrm_PCMAPP_PasswortDetail.EnDecrypt(AInput: String; AEncrypt: boolean) : String;
var
  Rijndael: TLbRijndael;
begin
  Rijndael := TLbRijndael.Create(nil);
  try
    Rijndael.GenerateKey('PCMDevelopmentJensHenske24021984'); // Replace with your actual key

    if AEncrypt then
      Result := Rijndael.DecryptString(AInput)//  EncryptString(PlainText);
    else
      Result := Rijndael.EncryptString(AInput);//  EncryptString(PlainText);
  finally
    Rijndael.Free;
  end;
end;
procedure Tfrm_PCMAPP_PasswortDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_PasswortDetail.OpenURL(const URL: string; const DisplayError: Boolean = False);
{$IFDEF ANDROID}
var
  Intent: JIntent;
{$ENDIF ANDROID}
begin
  {$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PWideChar(URL), nil, nil, SW_SHOWNORMAL);
  {$ENDIF MSWINDOWS}
  {$IFDEF ANDROID}
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
  TJnet_Uri.JavaClass.parse(StringToJString(URL)));
  TANdroidHelper.Activity.startActivity(Intent)
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCMAPP_PasswortDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_PasswortDetail.SetCompVisible;
var
  PasswordType: string;
  IsApp, IsMail, IsVPN, IsWLAN: Boolean;
begin
  PasswordType := '';
  if (cbx_Typ.ItemIndex >= 0) and (cbx_Typ.ItemIndex < cbx_Typ.Items.Count) then
    PasswordType := UpperCase(Trim(cbx_Typ.Items[cbx_Typ.ItemIndex]));

  // Match type names, not positions: the list also contains Arbeit/Privat variants.
  IsApp := (PasswordType = 'APP') or (Pos('APP ', PasswordType) = 1);
  IsMail := PasswordType = 'E-MAIL';
  IsVPN := (PasswordType = 'VPN') or (Pos('VPN ', PasswordType) = 1);
  IsWLAN := (PasswordType = 'W-LAN / ROUTER') or
    (PasswordType = 'W-LAN ROUTER') or (PasswordType = 'WLAN');

  // Assign every section, including when no type is selected.
  lo_WLAN.Visible := IsWLAN;
  lo_VPNShared.Visible := IsVPN;
  lo_VPNAPP.Visible := IsApp or IsVPN;
  lo_APP_Verschluesselung.Visible := IsApp;
  lo_APP_Port.Visible := IsApp;
  lo_MAIL_Posteingangsserver.Visible := IsMail;
  lo_MAIL_PosteingangsPort.Visible := IsMail;
  lo_MAIL_PosteingangsVerschluesselung.Visible := IsMail;
  lo_MAIL_Postausgangsserver.Visible := IsMail;
  lo_MAIL_PostausgangsPort.Visible := IsMail;
  lo_MAIL_PostausgangsVerschluesselung.Visible := IsMail;
end;
procedure Tfrm_PCMAPP_PasswortDetail.UpdateKBBounds;
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
    if (LFocusRect.IntersectsWith(TRectF.Create(dBounds))) and
       (LFocusRect.Bottom > dBounds.Top) then
    begin
      bNeedOffset := True;
      lo_main.Align := TAlignLayout.Horizontal;
      vsbx_main.RealignContent;
      Application.ProcessMessages;
      vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X,LFocusRect.Bottom - (dBounds.Top - 48));
    end;
  end;
  if not bNeedOffset then
    RestorePosition;
end;
{$EndRegion Helperfunctions}
////////////////////////////////////////////////////////////////////////////////
// Button FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region ButtonFunctions}
procedure Tfrm_PCMAPP_PasswortDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_PasswortDetail.Close;
end;
procedure Tfrm_PCMAPP_PasswortDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_PasswortDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_Passwort.SQL.Text:= sSQL_SEL_ALL_PASSWORD_WHERE_ID;
    qry_Passwort.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Passwort.open;
    edt_Target.Text:= qry_Passwort.FieldByName('Bezeichnung').AsString;
    edt_Beschreibung.Text:= qry_Passwort.FieldByName('user').AsString;
    edt_Pass.Text:= qry_Passwort.FieldByName('password').AsString;
    edt_linkurl.text:= qry_Passwort.FieldByName('link').asString;
    edt_wlanConfig.text:= qry_Passwort.FieldByName('WLAN').asString;
    edt_VPN_SharedSecretConfig.text:= qry_Passwort.FieldByName('VPN_SharedSecret').asString;
    edt_APP_IPConfig.text:= qry_Passwort.FieldByName('APP_IP').asString;
    edt_APP_PortConfig.Value:= qry_Passwort.FieldByName('APP_Port').asInteger;
    edt_APP_VerschluesselungConfig.text:= qry_Passwort.FieldByName('APP_Verschluesselung').asString;
    edt_MAIL_PosteingangsserverConfig.text:= qry_Passwort.FieldByName('MAIL_Posteingangsserver').asString;
    edt_MAIL_PosteingangsPortConfig.value:= qry_Passwort.FieldByName('MAIL_PosteingangsPort').asInteger;
    edt_MAIL_PosteingangsVerschluesselungConfig.text:= qry_Passwort.FieldByName('MAIL_PosteingangsVerschluesselung').asString;
    edt_MAIL_PostausgangsserverConfig.text:= qry_Passwort.FieldByName('MAIL_Postausgangsserver').asString;
    edt_MAIL_PostausgangsPortConfig.value:= qry_Passwort.FieldByName('MAIL_PostausgangsPort').asInteger;
    edt_MAIL_PostausgangsVerschluesselungConfig.text:= qry_Passwort.FieldByName('MAIL_PostausgangsVerschluesselung').asString;
    cbx_Typ.Itemindex := cbx_Typ.Items.IndexOf(Trim(qry_Passwort.FieldByName('PWTyp').asString));
    qry_Passwort.Close;
    SetCompVisible;
    edt_Target.Enabled:= false;
    edt_Beschreibung.Enabled:= false;
    edt_linkurl.Enabled:= false;
    edt_wlanConfig.Enabled:= false;
    edt_APP_PortConfig.Enabled:= false;
    edt_APP_VerschluesselungConfig.Enabled:= false;
    edt_MAIL_PosteingangsserverConfig.Enabled:= false;
    edt_MAIL_PosteingangsPortConfig.Enabled:= false;
    edt_MAIL_PosteingangsVerschluesselungConfig.Enabled:= false;
    edt_MAIL_PostausgangsserverConfig.Enabled:= false;
    edt_MAIL_PostausgangsPortConfig.Enabled:= false;
    edt_MAIL_PostausgangsVerschluesselungConfig.Enabled:= false;
    cbx_Typ.Enabled:= false;
    edt_Pass.Enabled:= false;
    edt_VPN_SharedSecretConfig.Enabled:= false;
    edt_APP_IPConfig.Enabled:= false;
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_PasswortDetail.btn_EditClick(Sender: TObject);
begin
  edt_Target.Enabled:= true;
  edt_Beschreibung.Enabled:= true;
  edt_linkurl.Enabled:= true;
  edt_wlanConfig.Enabled:= true;
  edt_APP_PortConfig.Enabled:= true;
  edt_APP_VerschluesselungConfig.Enabled:= true;
  edt_MAIL_PosteingangsserverConfig.Enabled:= true;
  edt_MAIL_PosteingangsPortConfig.Enabled:= true;
  edt_MAIL_PosteingangsVerschluesselungConfig.Enabled:= true;
  edt_MAIL_PostausgangsserverConfig.Enabled:= true;
  edt_MAIL_PostausgangsPortConfig.Enabled:= true;
  edt_MAIL_PostausgangsVerschluesselungConfig.Enabled:= true;
  cbx_Typ.Enabled:= true;
  edt_Pass.Enabled:= true;
  edt_VPN_SharedSecretConfig.Enabled:= true;
  edt_APP_IPConfig.Enabled:= true;
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_PasswortDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Target.Text = '') then
  begin
    ShowMessage('Beschreibung darf nicht leer sein!');
    exit;
  end;

  if (cbx_Typ.itemindex = -1) then
  begin
    ShowMessage('Typ für Passwort muss gewählt sein!');
    exit;
  end;
  if not frm_PCM_Main.bNeu then
  begin
    qry_Passwort.SQL.Text:= sSQL_UPD_ALL_PASSWORD_WHERE_ID;
    qry_Passwort.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Passwort.ParamByName('Bezeichnung').AsString := edt_Target.Text;
    qry_Passwort.ParamByName('user').AsString:= edt_Beschreibung.Text;
    qry_Passwort.ParamByName('password').AsString:= edt_Pass.Text;
    qry_Passwort.ParamByName('link').asString:= edt_linkurl.text;
    qry_Passwort.ParamByName('VPN_SharedSecret').asString:= edt_VPN_SharedSecretConfig.text;
    qry_Passwort.ParamByName('APP_IP').asString:= edt_APP_IPConfig.text;
    qry_Passwort.ParamByName('APP_Port').asString:= edt_APP_PortConfig.text;
    qry_Passwort.ParamByName('APP_Verschluesselung').asString:= edt_APP_VerschluesselungConfig.text;
    qry_Passwort.ParamByName('MAIL_Posteingangsserver').asString:= edt_MAIL_PosteingangsserverConfig.text;
    qry_Passwort.ParamByName('MAIL_PosteingangsPort').asString:= edt_MAIL_PosteingangsPortConfig.text;
    qry_Passwort.ParamByName('MAIL_PosteingangsVerschluesselung').asString:= edt_MAIL_PosteingangsVerschluesselungConfig.text;
    qry_Passwort.ParamByName('MAIL_Postausgangsserver').asString:= edt_MAIL_PostausgangsserverConfig.text;
    qry_Passwort.ParamByName('MAIL_PostausgangsPort').asString:= edt_MAIL_PostausgangsPortConfig.text;
    qry_Passwort.ParamByName('MAIL_PostausgangsVerschluesselung').asString:= edt_MAIL_PostausgangsVerschluesselungConfig.text;
    qry_Passwort.ParamByName('WLAN').asString:= edt_wlanConfig.text;
    qry_Passwort.ParamByName('PWTyp').asString:= cbx_Typ.Items[cbx_Typ.ItemIndex];
    try
      qry_Passwort.ExecSQl;
    except
    end;

    with frm_PCM_Main.lv_Passwort.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Target.Text;
      Detail:= cbx_Typ.Items[cbx_Typ.itemindex];
    end;
  end
  else begin
    qry_Passwort.SQL.Text:= sSQL_INS_ALL_PASSWORD;
    qry_Passwort.ParamByName('Bezeichnung').AsString := edt_Target.Text;
    qry_Passwort.ParamByName('user').AsString:= edt_Beschreibung.Text;
    qry_Passwort.ParamByName('password').AsString:= edt_Pass.Text;
    qry_Passwort.ParamByName('link').asString:= edt_linkurl.text;
    qry_Passwort.ParamByName('VPN_SharedSecret').asString:= edt_VPN_SharedSecretConfig.text;
    qry_Passwort.ParamByName('APP_IP').asString:= edt_APP_IPConfig.text;
    qry_Passwort.ParamByName('APP_Port').asString:= edt_APP_PortConfig.text;
    qry_Passwort.ParamByName('APP_Verschluesselung').asString:= edt_APP_VerschluesselungConfig.text;
    qry_Passwort.ParamByName('MAIL_Posteingangsserver').asString:= edt_MAIL_PosteingangsserverConfig.text;
    qry_Passwort.ParamByName('MAIL_PosteingangsPort').asString:= edt_MAIL_PosteingangsPortConfig.text;
    qry_Passwort.ParamByName('MAIL_PosteingangsVerschluesselung').asString:= edt_MAIL_PosteingangsVerschluesselungConfig.text;
    qry_Passwort.ParamByName('MAIL_Postausgangsserver').asString:= edt_MAIL_PostausgangsserverConfig.text;
    qry_Passwort.ParamByName('MAIL_PostausgangsPort').asString:= edt_MAIL_PostausgangsPortConfig.text;
    qry_Passwort.ParamByName('MAIL_PostausgangsVerschluesselung').asString:= edt_MAIL_PostausgangsVerschluesselungConfig.text;
    qry_Passwort.ParamByName('WLAN').asString:= edt_wlanConfig.text;
    qry_Passwort.ParamByName('PWTyp').asString:= cbx_Typ.Items[cbx_Typ.ItemIndex];
    try
      qry_Passwort.ExecSQl;
    except
    end;

    frm_PCM_Main.lv_Passwort.Items.Clear;
    frm_PCM_Main.lv_Passwort.BeginUpdate;
    frm_PCM_Main.CreatePWDGridConfig;
    frm_PCM_Main.lv_Passwort.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  edt_Target.Enabled:= false;
  edt_Beschreibung.Enabled:= false;
  edt_linkurl.Enabled:= false;
  edt_wlanConfig.Enabled:= false;
  edt_APP_PortConfig.Enabled:= false;
  edt_APP_VerschluesselungConfig.Enabled:= false;
  edt_MAIL_PosteingangsserverConfig.Enabled:= false;
  edt_MAIL_PosteingangsPortConfig.Enabled:= false;
  edt_MAIL_PosteingangsVerschluesselungConfig.Enabled:= false;
  edt_MAIL_PostausgangsserverConfig.Enabled:= false;
  edt_MAIL_PostausgangsPortConfig.Enabled:= false;
  edt_MAIL_PostausgangsVerschluesselungConfig.Enabled:= false;
  cbx_Typ.Enabled:= false;

  edt_Pass.Enabled:= false;
  edt_VPN_SharedSecretConfig.Enabled:= false;
  edt_APP_IPConfig.Enabled:= false;


  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_PasswortDetail.cbx_TypChange(Sender: TObject);
begin
  SetCompVisible;
end;
procedure Tfrm_PCMAPP_PasswortDetail.img_LinkClick(Sender: TObject);
begin
  if edt_linkurl.text <> '' then
    OpenUrl(edt_linkurl.text);
end;
procedure Tfrm_PCMAPP_PasswortDetail.img_PasswordnotvisClick(Sender: TObject);
begin
  img_Passwordvis.Visible:= true;
  img_Passwordnotvis.Visible:= false;
//  edt_Pass.Password:= true;
  edt_Pass.Visible:= true;
  edt_passClear.Visible:= false;
end;
procedure Tfrm_PCMAPP_PasswortDetail.img_PasswordvisClick(Sender: TObject);
begin
  img_Passwordvis.Visible:= false;
  img_Passwordnotvis.Visible:= true;
//  edt_Pass.Password:= false;
  edt_Pass.Visible:= false;
  edt_passClear.Visible:= true;
  edt_passClear.Text:= EnDecrypt(edt_Pass.Text,true);
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_PasswortDetail.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  FreeAndNil(qry_Passwort);
end;
procedure Tfrm_PCMAPP_PasswortDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_PasswortDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_PasswortDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_PasswortDetail.FormShow(Sender: TObject);
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
        frm_PCMAPP_PasswortDetail.StyleBook:= dmMain.stB_0;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_PasswortDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_PasswortDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_PasswortDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
     {$IFdef MSWINDOWS}
      4:
      begin
        frm_PCMAPP_PasswortDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_Typ.count - 1 do
    begin
      cbx_Typ.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Typ.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Typ.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Typ.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
begin
  SetDesign;
  qry_Passwort:= TFDQuery.Create(nil);
  qry_Passwort.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Passwörter laden...', 'Passwörter', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  qry_Passwort.SQL.Text:= sSQL_SEL_ALL_PASSWORD_WHERE_ID;
  qry_Passwort.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
  qry_Passwort.open;
  edt_Target.Text:= qry_Passwort.FieldByName('Bezeichnung').AsString;
  edt_Beschreibung.Text:= qry_Passwort.FieldByName('user').AsString;
  edt_Pass.Text:= qry_Passwort.FieldByName('password').AsString;
  edt_linkurl.text:= qry_Passwort.FieldByName('link').asString;
  edt_wlanConfig.text:= qry_Passwort.FieldByName('WLAN').asString;
  edt_VPN_SharedSecretConfig.text:= qry_Passwort.FieldByName('VPN_SharedSecret').asString;
  edt_APP_IPConfig.text:= qry_Passwort.FieldByName('APP_IP').asString;
  edt_APP_PortConfig.value:= qry_Passwort.FieldByName('APP_Port').asInteger;
  edt_APP_VerschluesselungConfig.text:= qry_Passwort.FieldByName('APP_Verschluesselung').asString;
  edt_MAIL_PosteingangsserverConfig.text:= qry_Passwort.FieldByName('MAIL_Posteingangsserver').asString;
  edt_MAIL_PosteingangsPortConfig.value:= qry_Passwort.FieldByName('MAIL_PosteingangsPort').asInteger;
  edt_MAIL_PosteingangsVerschluesselungConfig.text:= qry_Passwort.FieldByName('MAIL_PosteingangsVerschluesselung').asString;
  edt_MAIL_PostausgangsserverConfig.text:= qry_Passwort.FieldByName('MAIL_Postausgangsserver').asString;
  edt_MAIL_PostausgangsPortConfig.value:= qry_Passwort.FieldByName('MAIL_PostausgangsPort').asInteger;
  edt_MAIL_PostausgangsVerschluesselungConfig.text:= qry_Passwort.FieldByName('MAIL_PostausgangsVerschluesselung').asString;
  cbx_Typ.Itemindex := cbx_Typ.Items.IndexOf(Trim(qry_Passwort.FieldByName('PWTyp').asString));
  SetCompVisible;
  img_Passwordvis.Visible:= true;
  img_Passwordnotvis.Visible:= false;
  qry_Passwort.Close;
  if frm_PCM_Main.iID= 0 then
  begin
    edt_Target.Enabled:= true;
    edt_Beschreibung.Enabled:= true;
    edt_linkurl.Enabled:= true;
    edt_wlanConfig.Enabled:= true;
    edt_APP_PortConfig.Enabled:= true;
    edt_APP_VerschluesselungConfig.Enabled:= true;
    edt_MAIL_PosteingangsserverConfig.Enabled:= true;
    edt_MAIL_PosteingangsPortConfig.Enabled:= true;
    edt_MAIL_PosteingangsVerschluesselungConfig.Enabled:= true;
    edt_MAIL_PostausgangsserverConfig.Enabled:= true;
    edt_MAIL_PostausgangsPortConfig.Enabled:= true;
    edt_MAIL_PostausgangsVerschluesselungConfig.Enabled:= true;
    cbx_Typ.Enabled:= true;
    edt_Pass.Enabled:= true;
    edt_VPN_SharedSecretConfig.Enabled:= true;
    edt_APP_IPConfig.Enabled:= true;
    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCMAPP_PasswortDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
  if (edt_APP_PortConfig.IsFocused) and bWeiter then
  begin
    edt_APP_VerschluesselungConfig.SetFocus;
    bWeiter:= false;
  end;

  if (edt_MAIL_PosteingangsPortConfig.IsFocused) and bWeiter then
  begin
    edt_MAIL_PosteingangsVerschluesselungConfig.SetFocus;
    bWeiter:= false;
  end;

  if (edt_MAIL_PostausgangsPortConfig.IsFocused) and bWeiter then
  begin
    edt_MAIL_PostausgangsVerschluesselungConfig.SetFocus;
    bWeiter:= false;
  end;

end;
procedure Tfrm_PCMAPP_PasswortDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
  if edt_APP_PortConfig.IsFocused then
    bWeiter:= true;
  if edt_MAIL_PostausgangsPortConfig.IsFocused then
    bWeiter:= true;
  if edt_MAIL_PosteingangsPortConfig.IsFocused then
    bWeiter:= true;
end;
{$EndRegion Formfunctions}
end.
