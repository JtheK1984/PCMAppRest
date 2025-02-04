unit PCMAPP.Server;

interface

uses
  {$Region Uses}
  Data.DB,
  Data.SqlExpr,
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
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.DialogService.Async,
  FMX.Edit,
  FMX.Effects,
  FMX.Forms,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Memo,
  FMX.Objects,
  FMX.Platform,
  FMX.ScrollBox,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Types,
  IdHash,
  IdHashMessageDigest,
  System.Classes,
  System.IOUtils,
  System.Math,
  System.SysUtils,
  System.Threading,
  System.Types,
  System.UITypes,
  System.Variants;
  {$EndRegion Uses}
type
  {$Region Type}
  Tfrm_PCMAPP_Server = class(TForm)
    btn_AddServer: TButton;
    btn_BackSystem: TButton;
    btn_Delete: TRectangle;
    btn_DeleteUser: TRectangle;
    btn_DescImg: TButton;
    btn_lock: TButton;
    btn_lockRep: TButton;
    btn_portImg: TButton;
    btn_Save: TRectangle;
    btn_SaveUser: TRectangle;
    btn_ServerImg: TButton;
    btn_Unlock: TButton;
    btn_UnlockRep: TButton;
    btn_UserImg: TButton;
    edt_Bezeichnung: TEdit;
    edt_LocalPassword: TEdit;
    edt_LocalPasswordRepeat: TEdit;
    edt_LocalUser: TEdit;
    edt_Port: TEdit;
    edt_Server: TEdit;
    img_Localaccount: TImage;
    img_Serveraccount: TImage;
    lbl_Delete: TLabel;
    lbl_DeleteUser: TLabel;
    lbl_LocalaccountBody: TLabel;
    lbl_LocalaccountHeader: TLabel;
    lbl_ModulName: TLabel;
    lbl_Save: TLabel;
    lbl_SaveUser: TLabel;
    lbl_ServeraccountBody: TLabel;
    lbl_ServeraccountHeader: TLabel;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_LocalAccount: TLayout;
    lo_LocalaccountImg: TLayout;
    lo_LocalaccountLabel: TLayout;
    lo_main: TLayout;
    lo_Right: TLayout;
    lo_ServeraccountImg: TLayout;
    lo_ServeraccountLabel: TLayout;
    lo_ServerKonfiguration: TLayout;
    lstbx_Server: TListBox;
    lstbx_SystemInformation: TListBox;
    lstbxitm_1Localaccount: TListBoxItem;
    lstbxitm_2Serveraccount: TListBoxItem;
    tb_Main: TRectangle;
    tc_Server: TTabControl;
    ti_1Account: TTabItem;
    ti_2Auswahl: TTabItem;
    ti_3Einstellungen: TTabItem;
    ti_4ServerKonfiguration: TTabItem;
    vsbx_main: TVertScrollBox;
    procedure btn_AddServerClick(Sender: TObject);
    procedure btn_BackSystemClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_lockClick(Sender: TObject);
    procedure btn_lockRepClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_SaveUserClick(Sender: TObject);
    procedure btn_UnlockClick(Sender: TObject);
    procedure btn_UnlockRepClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure lstbx_ServerItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure lstbxitm_1LocalaccountClick(Sender: TObject);
    procedure lstbxitm_2ServeraccountClick(Sender: TObject);
    procedure tc_ServerChange(Sender: TObject);
  private
    { Private declarations }
    bNeedOffset: Boolean;
    dBounds: TRectF;
    iItemID: Integer;
    qry_Work: TFDQuery;
    procedure Back;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure ClearEdits;
    procedure FillEdits(bEdit: Boolean);
    procedure FillServerListBox;
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public declarations }
  end;
  {$EndRegion Type}
var
  {$Region Var}
  frm_PCMAPP_Server: Tfrm_PCMAPP_Server;
  {$EndRegion Var}
implementation

uses
  {$Region Var}
  PCMAPP.Datamodul,
  PCMAPP.Funktionen,
  PCMApp.Main,
  PCMApp.SQL;
  {$EndRegion Var}
{$R *.fmx}
////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region HELPER FUNCTIONS}
procedure Tfrm_PCMAPP_Server.Back;
begin
  if tc_Server.ActiveTab = ti_2Auswahl then
  begin
    Close;
  end else
  begin
    iItemID := -1;
    tc_Server.ActiveTab := ti_2Auswahl;
    ClearEdits;
    btn_AddServer.Visible := True;
  end;
end;
procedure Tfrm_PCMAPP_Server.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_Server.ClearEdits;
begin
  edt_Bezeichnung.Text := '';
  edt_Server.Text := '';
  edt_Port.Text := '';
  edt_Server.Enabled := True;
  edt_Port.Enabled := True;
end;
procedure Tfrm_PCMAPP_Server.FillEdits(bEdit: Boolean);
begin
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text := sSQL_SEL_All_Server_Where_ID;
  qry_Work.ParamByName('ID').AsInteger := iItemID;
  qry_Work.Open;
  edt_Bezeichnung.Text := qry_Work.FieldByName('Bezeichnung').AsString;
  edt_Server.Text := qry_Work.FieldByName('Hostname').AsString;
  edt_Port.Text := qry_Work.FieldByName('Port').AsString;
  qry_Work.Close;
  Freeandnil(qry_Work);
  if bEdit then
  begin
    edt_Port.Enabled := true;
    edt_Server.Enabled := true;
  end;
end;
procedure Tfrm_PCMAPP_Server.FillServerListBox;
var
  iIndex: Integer;
begin
  lstbx_Server.Clear;
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text := sSQL_SEL_All_Server;
  qry_Work.Open;
  while not qry_Work.Eof do
  begin
    iIndex := lstbx_Server.Items.Add(qry_Work.FieldByName('Bezeichnung').AsString);
    lstbx_Server.ItemByIndex(iIndex).Tag := qry_Work.FieldByName('ID').ASInteger;
    qry_Work.Next;
  end;
  qry_Work.Close;
  btn_AddServer.Visible := True;
  Freeandnil(qry_Work);
end;
procedure Tfrm_PCMAPP_Server.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_Server.UpdateKBBounds;
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
      vsbx_main.ViewportPosition :=
        PointF(vsbx_main.ViewportPosition.X,
               LFocusRect.Bottom - dBounds.Top);
    end;
  end;
  if not bNeedOffset then
    RestorePosition;
end;
{$EndRegion HELPER FUNCTIONS}
////////////////////////////////////////////////////////////////////////////////
// COMPONENTS FUNCTIONS                                                       //
////////////////////////////////////////////////////////////////////////////////
{$Region COMPONENTS FUNCTIONS}
procedure Tfrm_PCMAPP_Server.btn_AddServerClick(Sender: TObject);
begin
  tc_Server.ActiveTab := ti_4ServerKonfiguration;
  btn_AddServer.Visible := False;
  btn_Delete.Visible := False;
end;
procedure Tfrm_PCMAPP_Server.btn_BackSystemClick(Sender: TObject);
begin
  if tc_Server.ActiveTab = ti_2Auswahl then Back;
  if tc_Server.ActiveTab = ti_1Account then tc_Server.ActiveTab:= ti_2Auswahl;
  if tc_Server.ActiveTab = ti_3Einstellungen then tc_Server.ActiveTab:= ti_2Auswahl;
  if tc_Server.ActiveTab = ti_4ServerKonfiguration then tc_Server.ActiveTab:= ti_3Einstellungen;
end;
procedure Tfrm_PCMAPP_Server.btn_DeleteClick(Sender: TObject);
begin
  TDialogServiceAsync.MessageDialog('ACHTUNG: Wenn der Server entfernt wird, '
   + #13 + 'werden alle zum Server gespeicherten Userdaten ebenfalls entfernt! Möchten Sie fortfahren?',
  TMsgDlgType.mtWarning,
  mbYesNo,
  TMsgDlgBtn.mbNo,
  0,
  procedure(const AResult: TModalResult)
  begin
    if AResult = mrYes then
    begin
      ClearAllTablesByID(iItemID, 'ID_Server');
      qry_Work:= TFDQuery.Create(nil);
      qry_Work.Connection:= dmmain.con_PCM;
      qry_Work.SQL.Text := sSQL_DEL_All_Server;
      qry_Work.ExecSQL;
      Freeandnil(qry_Work);
      FillServerListBox;
      tc_Server.ActiveTab := ti_3Einstellungen;
      ClearEdits;
      btn_AddServer.Visible := True;
    end;
  end);
  iItemID:= -1;
end;
procedure Tfrm_PCMAPP_Server.btn_lockClick(Sender: TObject);
begin
  btn_Lock.Visible:= false;
  btn_UnLock.Visible:= true;
  edt_LocalPassword.Password:= false;
end;
procedure Tfrm_PCMAPP_Server.btn_lockRepClick(Sender: TObject);
begin
  btn_LockRep.Visible:= false;
  btn_UnLockRep.Visible:= true;
  edt_LocalPasswordRepeat.Password:= true;
end;
procedure Tfrm_PCMAPP_Server.btn_SaveClick(Sender: TObject);
var
  iAnzahlAcc: integer;
begin
  if edt_Bezeichnung.Text = '' then
  begin
    ShowMessage('Bitte tragen Sie eine Bezeichnung ein');
    exit;
  end;
  if edt_Server.Text = '' then
  begin
    ShowMessage('Bitte tragen Sie einen Server ein');
    exit;
  end;
  if edt_Port.Text = '' then
  begin
    ShowMessage('Bitte tragen Sie einen Port ein');
    exit;
  end;
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  if iItemID <= 0 then
  begin
    qry_Work.SQL.Text:= sSQL_INS_All_Server;
    qry_Work.ParamByName('Bez').AsString := edt_Bezeichnung.Text;
    qry_Work.ParamByName('Host').AsString := edt_Server.Text;
    qry_Work.ParamByName('Port').AsString := edt_Port.Text;
    qry_Work.ExecSQL;
  end else
  begin
    qry_Work.SQL.Text := sSQL_UPD_All_Server_Where_ID;
    qry_Work.ParamByName('Bez').AsString := edt_Bezeichnung.Text;
    qry_Work.ParamByName('Host').AsString := edt_Server.Text;
    qry_Work.ParamByName('Port').AsString := edt_Port.Text;
    qry_Work.ParamByName('ID').AsInteger := iItemID;
    qry_Work.ExecSQL;
  end;
  qry_Work.SQL.Text:= sSQL_SEL_COUNT_Autologin;
  qry_Work.open;
  iAnzahlAcc:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  if iAnzahlAcc > 0 then
  begin
    qry_Work.SQL.Text := sSQL_UPD_LOCALACCOUNT_Autologin;
    qry_Work.ParamByName('Localaccount').AsBoolean := false;
    qry_Work.ExecSQL;
  end;
  FreeAndNil(qry_Work);
  FillServerListBox;
  tc_Server.ActiveTab := ti_3Einstellungen;
  ClearEdits;
  btn_AddServer.Visible := True;
  Close;
end;
procedure Tfrm_PCMAPP_Server.btn_SaveUserClick(Sender: TObject);
var
  iAnzahlAcc: Integer;
  iAnzahlServer: Integer;
  iIDServer: Integer;
  sPasswort: String;
begin
  if edt_LocalUser.Text = '' then
  begin
    ShowMessage('Bitte vergeben Sie einen Benutzernamen');
    exit;
  end;
  if edt_LocalPassword.Text = '' then
  begin
    ShowMessage('Bitte vergeben sie ein Passwort');
    exit;
  end;
  if edt_LocalPassword.Text <> edt_LocalPasswordRepeat.Text then
  begin
    ShowMessage('Die Passwörter stimmen nicht überein');
    exit;
  end;
  sPasswort := edt_LocalPassword.Text;
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SEL_COUNT_Server;
  qry_Work.open;
  iAnzahlServer:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  if iAnzahlServer = 0 then
  begin
    qry_work.SQL.Text := sSQL_INS_All_Server;
    qry_work.ParamByName('Bez').AsString := 'PCM';
    qry_work.ParamByName('Host').AsString := '127.0.0.1';
    qry_work.ParamByName('Port').AsString := '55700';
    qry_work.ExecSQL;
  end;
  qry_Work.SQL.Text:= sSQL_SEL_ID_Server;
  qry_Work.open;
  iIDServer:= qry_Work.FieldByName('ID').AsInteger;
  qry_Work.Close;
  qry_Work.SQL.Text:= sSQL_SEL_COUNT_Autologin;
  qry_Work.open;
  iAnzahlAcc:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  if iAnzahlAcc = 0 then
  begin
    qry_work.SQL.Text := sSQL_INS_All_Autologin;
    qry_work.ParamByName('ID_Server').AsInteger := iIDServer;
    qry_work.ParamByName('Benutzername').AsString := edt_LocalUser.Text;
    qry_work.ParamByName('Passwort').AsString := edt_LocalPassword.text;
    qry_work.ParamByName('Autologin').AsBoolean := True;
    qry_work.ParamByName('Design').AsInteger := 0;
    qry_work.ParamByName('DesignWin').AsInteger := 0;
    qry_work.ParamByName('DesignApp').AsInteger := 0;
    qry_work.ParamByName('Localaccount').AsBoolean := True;
    qry_work.ExecSQL;
  end else
  begin
    qry_work.SQL.Text := sSQL_UPD_ALL_Autologin;
    qry_work.ParamByName('ID_Server').AsInteger := iIDServer;
    qry_work.ParamByName('Benutzername').AsString := edt_LocalUser.Text;
    qry_work.ParamByName('Passwort').AsString := edt_LocalPassword.Text;
    qry_work.ParamByName('Autologin').AsBoolean := True;
    qry_work.ParamByName('Design').AsInteger := 0;
    qry_work.ParamByName('Localaccount').AsBoolean := True;
    qry_work.ExecSQL;
  end;
  qry_Work.SQL.Text:= sSQL_SEL_COUNT_login;
  qry_Work.open;
  iAnzahlAcc:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  if iAnzahlAcc = 0 then
  begin
    qry_work.SQL.Text := sSQL_INS_All_login;
    qry_work.ParamByName('ID_Server').AsInteger := iIDServer;
    qry_work.ParamByName('Benutzername').AsString := edt_LocalUser.Text;
    qry_work.ParamByName('Passwort').AsString := edt_LocalPassword.Text;
    qry_work.ParamByName('Firststart').AsBoolean := True;
    qry_work.ParamByName('ID_Benutzer').AsInteger := 0;
    qry_work.ExecSQL;
  end else
  begin
    qry_work.SQL.Text := sSQL_UPD_ALL_login;
    qry_work.ParamByName('ID_Server').AsInteger := iIDServer;
    qry_work.ParamByName('Benutzername').AsString := edt_LocalUser.Text;
    qry_work.ParamByName('Passwort').AsString := edt_LocalPassword.Text;
    qry_work.ParamByName('Firststart').AsBoolean := False;
    qry_work.ParamByName('ID_Benutzer').AsInteger := 0;
    qry_work.ExecSQL;
  end;
  frm_PCM_Main.edt_Benutzername.Text:= edt_LocalUser.Text;
  frm_PCM_Main.edt_Passwort.Text:= edt_LocalPassword.Text;
  Freeandnil(qry_Work);
  Close;
end;
procedure Tfrm_PCMAPP_Server.btn_UnlockClick(Sender: TObject);
begin
  btn_Lock.Visible:= true;
  btn_UnLock.Visible:= false;
  edt_LocalPassword.Password:= true;
end;
procedure Tfrm_PCMAPP_Server.btn_UnlockRepClick(Sender: TObject);
begin
  btn_LockRep.Visible:= true;
  btn_UnLockRep.Visible:= false;
  edt_LocalPasswordRepeat.Password:= false;
end;
procedure Tfrm_PCMAPP_Server.lstbx_ServerItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  tc_Server.ActiveTab := ti_4ServerKonfiguration;
  iItemID := Item.Tag;
  FillEdits(True);
  btn_AddServer.Visible := False;
  btn_Delete.Visible := True;
end;
procedure Tfrm_PCMAPP_Server.lstbxitm_1LocalaccountClick(Sender: TObject);
begin
  btn_AddServer.Visible:= false;
  tc_Server.ActiveTab := ti_1Account;
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SEL_All_AUtologin;
  qry_Work.open;
  edt_LocalUser.Text:= qry_work.FieldByName('Benutzername').AsString;
  edt_LocalPassword.Text:= qry_work.FieldByName('Passwort').AsString;
  edt_LocalPasswordRepeat.Text:= qry_work.FieldByName('Passwort').AsString;
  qry_work.close;
  Freeandnil(qry_work);
end;
procedure Tfrm_PCMAPP_Server.lstbxitm_2ServeraccountClick(Sender: TObject);
var
  iCount: integer;
begin
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SEL_COUNT_Server;
  qry_Work.open;
  iCount:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.close;
  Freeandnil(qry_Work);
  if iCount > 0 then
  begin
    btn_AddServer.Visible:= false;
    tc_Server.ActiveTab := ti_3Einstellungen;
  end
  else
  begin
    tc_Server.ActiveTab := ti_4ServerKonfiguration;
    btn_AddServer.Visible := False;
    btn_Delete.Visible := False;
  end;
end;
procedure Tfrm_PCMAPP_Server.tc_ServerChange(Sender: TObject);
var
  iCount: integer;
begin

  if tc_Server.ActiveTab = ti_3Einstellungen then
  begin
    qry_Work:= TFDQuery.Create(nil);
    qry_Work.Connection:= dmmain.con_PCM;
    qry_Work.SQL.Text:= sSQL_SEL_COUNT_Server;
    qry_Work.open;
    iCount:= qry_Work.FieldByName('Anzahl').AsInteger;
    qry_Work.close;
    FreeAndNil(qry_Work);
    if iCount > 0 then
      btn_AddServer.Visible:= false
    else
      btn_AddServer.Visible:= true;
  end
  else begin
    btn_AddServer.Visible:= false;
  end;
end;
{$EndRegion COMPONENTS FUNCTIONS}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Form FUNCTIONS}
procedure Tfrm_PCMAPP_Server.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frm_PCM_Main.SetServerList;
  Action := TCloseAction.caFree;
end;
procedure Tfrm_PCMAPP_Server.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
end;
procedure Tfrm_PCMAPP_Server.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_Server.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (Sender.ClassName = 'TfrmServer') then
  begin
    Key := 0;
    Back;
  end;
end;
procedure Tfrm_PCMAPP_Server.FormShow(Sender: TObject);
  procedure SetDesign;
  var
    iDesignStyle: Integer;
  begin
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    {$ENDIF MSWINDOWS}
    case iDesignStyle of
      0: // Calypso
      begin
        frm_PCMAPP_Server.StyleBook:= dmMain.stB_0;
        btn_BackSystem.ImageIndex:= 3;
        btn_AddServer.ImageIndex:= 7;
        btn_lock.ImageIndex:= 15;
        btn_unlock.ImageIndex:= 17;
        btn_lockRep.ImageIndex:= 15;
        btn_unlockRep.ImageIndex:= 17;
        btn_UserImg.ImageIndex:= 13;
        btn_DescImg.ImageIndex:= 25;
        btn_portImg.ImageIndex:= 27;
        btn_ServerImg.ImageIndex:= 29;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_Server.StyleBook:= dmMain.stB_1;
        btn_BackSystem.ImageIndex:= 2;
        btn_AddServer.ImageIndex:= 6;
        btn_lock.ImageIndex:= 14;
        btn_unlock.ImageIndex:= 16;
        btn_lockRep.ImageIndex:= 14;
        btn_unlockRep.ImageIndex:= 16;
        btn_UserImg.ImageIndex:= 12;
        btn_DescImg.ImageIndex:= 24;
        btn_portImg.ImageIndex:= 26;
        btn_ServerImg.ImageIndex:= 28;
      end;
      2:
      begin
        frm_PCMAPP_Server.StyleBook:= dmMain.stB_2;
        btn_BackSystem.ImageIndex:= 3;
        btn_AddServer.ImageIndex:= 7;
        btn_lock.ImageIndex:= 15;
        btn_unlock.ImageIndex:= 17;
        btn_lockRep.ImageIndex:= 15;
        btn_unlockRep.ImageIndex:= 17;
        btn_UserImg.ImageIndex:= 13;
        btn_DescImg.ImageIndex:= 25;
        btn_portImg.ImageIndex:= 27;
        btn_ServerImg.ImageIndex:= 29;
      end;
      3:
      begin
        frm_PCMAPP_Server.StyleBook:= dmMain.stB_3;
        btn_BackSystem.ImageIndex:= 3;
        btn_AddServer.ImageIndex:= 7;
        btn_lock.ImageIndex:= 15;
        btn_unlock.ImageIndex:= 17;
        btn_lockRep.ImageIndex:= 15;
        btn_unlockRep.ImageIndex:= 17;
        btn_UserImg.ImageIndex:= 13;
        btn_DescImg.ImageIndex:= 25;
        btn_portImg.ImageIndex:= 27;
        btn_ServerImg.ImageIndex:= 29;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_Server.StyleBook:= dmMain.stB_4;
        btn_BackSystem.ImageIndex:= 3;
        btn_AddServer.ImageIndex:= 7;
        btn_lock.ImageIndex:= 15;
        btn_unlock.ImageIndex:= 17;
        btn_lockRep.ImageIndex:= 15;
        btn_unlockRep.ImageIndex:= 17;
        btn_UserImg.ImageIndex:= 13;
        btn_DescImg.ImageIndex:= 25;
        btn_portImg.ImageIndex:= 27;
        btn_ServerImg.ImageIndex:= 29;
      end;
      {$ENDIF MSWINDOWS}
    end;
  end;
begin
  SetDesign;
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  frm_PCMApp_Server.BorderStyle:= TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
  tc_Server.ActiveTab := ti_2Auswahl;
  FillServerListBox;
  btn_AddServer.Visible:= false;
end;
procedure Tfrm_PCMAPP_Server.FormVirtualKeyboardHidden(Sender: TObject;KeyboardVisible: Boolean;const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_Server.FormVirtualKeyboardShown(Sender: TObject;KeyboardVisible: Boolean;const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Form FUNCTIONS}
end.
