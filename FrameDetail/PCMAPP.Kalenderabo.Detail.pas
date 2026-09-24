unit PCMAPP.Kalenderabo.Detail;

interface

uses
  {$Region uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.ListBox,FMX.Platform,
  FMX.VirtualKeyboard,system.math,system.Threading, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList,
  FMX.ImgList;
  {$EndRegion uses}
type
  {$Region types}
  Tfrm_PCMAPP_CalAboDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_Reminderbefore: TComboBox;
    edt_Benutzer: TEdit;
    edt_Kalender: TEdit;
    edt_Link: TEdit;
    edt_Passwort: TEdit;
    lbl_Benutzer: TLabel;
    lbl_Kalender: TLabel;
    lbl_link: TLabel;
    lbl_ModulName: TLabel;
    lbl_Passwort: TLabel;
    lbl_ReminderHeader: TLabel;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Reminder: TLayout;
    lo_Reminderbefore: TLayout;
    lo_ReminderCheck: TLabel;
    lo_ReminderDetail: TLayout;
    lo_ReminderLabel: TLayout;
    lo_ReminderMinutes: TLabel;
    lo_Right: TLayout;
    sw_Reminderbefore: TSwitch;
    tb_Main: TRectangle;
    vsbx_CalaboDetailView: TVertScrollBox;
    vsbx_main: TVertScrollBox;
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private-Deklarationen }
    bNeedOffset: Boolean;
    dBounds: TRectF;
    qry_KalAbo: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion types}
var
  frm_PCMAPP_CalAboDetail: Tfrm_PCMAPP_CalAboDetail;

implementation

uses  PCMAPP.Datamodul,
      PCMAPP.Main,
      PCMAPP.SQL;

{$R *.fmx}

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_CalAboDetail.btn_SaveApplyStyleLookup(Sender: TObject);
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
procedure Tfrm_PCMAPP_CalAboDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_CalAboDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_CalAboDetail.UpdateKBBounds;
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
               LFocusRect.Bottom - (dBounds.Top - 48));
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
procedure Tfrm_PCMAPP_CalAboDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_CalAboDetail.Close;
end;
procedure Tfrm_PCMAPP_CalAboDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_CalAboDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_KalAbo.SQL.Text:= sSQL_SEL_ALL_Calabo_WHERE_ID;
    qry_KalAbo.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_KalAbo.open;


    edt_Kalender.Text:= qry_KalAbo.FieldByName('Kalender').AsString;
    edt_Link.Text:= qry_KalAbo.FieldByName('Link').AsString;

    edt_Benutzer.Text:= qry_KalAbo.FieldByName('Benutzer').AsString;
    edt_Passwort.Text:= qry_KalAbo.FieldByName('Passwort').AsString;
    if qry_KalAbo.FieldByName('Erinnerung').AsBoolean then
      sw_Reminderbefore.IsChecked:= true
    else
      sw_Reminderbefore.IsChecked:= false;

    case qry_KalAbo.FieldByName('ErinnerungVor').ASInteger of

    5: cbx_Reminderbefore.itemindex:= 1;
    10: cbx_Reminderbefore.itemindex:= 2;
    15: cbx_Reminderbefore.itemindex:= 3 ;
    20: cbx_Reminderbefore.itemindex:= 4 ;
    30: cbx_Reminderbefore.itemindex:= 5 ;
    60: cbx_Reminderbefore.itemindex:= 6 ;
    120: cbx_Reminderbefore.itemindex:= 7 ;
    180: cbx_Reminderbefore.itemindex:= 8 ;
    240: cbx_Reminderbefore.itemindex:= 9 ;
    300: cbx_Reminderbefore.itemindex:= 10 ;
    360: cbx_Reminderbefore.itemindex:= 11 ;
    420: cbx_Reminderbefore.itemindex:= 12 ;
    480: cbx_Reminderbefore.itemindex:= 13 ;
    540: cbx_Reminderbefore.itemindex:= 14 ;
    600: cbx_Reminderbefore.itemindex:= 15 ;
    660: cbx_Reminderbefore.itemindex:= 16 ;
    720: cbx_Reminderbefore.itemindex:= 17 ;
    1080: cbx_Reminderbefore.itemindex:= 18 ;
    1440: cbx_Reminderbefore.itemindex:= 19 ;
    2880: cbx_Reminderbefore.itemindex:= 20 ;
    4320: cbx_Reminderbefore.itemindex:= 21 ;
    5760: cbx_Reminderbefore.itemindex:= 22 ;
    10080: cbx_Reminderbefore.itemindex:= 23 ;
    20160: cbx_Reminderbefore.itemindex:= 24 ;
    end;



    qry_KalAbo.Close;

    edt_Kalender.enabled:= false;
    edt_Link.enabled:= false;
    edt_Benutzer.enabled:= false;
    edt_Passwort.enabled:= false;
    sw_Reminderbefore.Enabled:= false;
    cbx_Reminderbefore.Enabled:= false;

    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_CalAboDetail.btn_EditClick(Sender: TObject);
begin
  edt_Kalender.enabled:= true;
  edt_Link.enabled:= true;
  edt_Benutzer.enabled:= true;
  edt_Passwort.enabled:= true;
  sw_Reminderbefore.Enabled:= true;
  cbx_Reminderbefore.Enabled:= true;
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_CalAboDetail.btn_SaveClick(Sender: TObject);
var
  iminutes: integer;
begin
  try
  if (edt_Link.Text = '')  then
  begin
    ShowMessage('Link darf nicht leer sein!');
    exit;
  end;
  if (edt_Kalender.Text = '')  then
  begin
    ShowMessage('Kalendername darf nicht leer sein!');
    exit;
  end;
  iMinutes:= 0;
  case cbx_Reminderbefore.itemindex of
    0: iMinutes:= 0;
    1: iMinutes:= 5;
    2: iMinutes:= 10;
    3: iMinutes:= 15;
    4: iMinutes:= 20;
    5: iMinutes:= 30;
    6: iMinutes:= 60;
    7: iMinutes:= 120;
    8: iMinutes:= 180;
    9: iMinutes:= 240;
    10: iMinutes:= 300;
    11: iMinutes:= 360;
    12: iMinutes:= 420;
    13: iMinutes:= 480;
    14: iMinutes:= 540;
    15: iMinutes:= 600;
    16: iMinutes:= 660;
    17: iMinutes:= 720;
    18: iMinutes:= 1080;
    19: iMinutes:= 1440;
    20: iMinutes:= 2880;
    21: iMinutes:= 4320;
    22: iMinutes:= 5760;
    23: iMinutes:= 10080;
    24: iMinutes:= 20160;
  end;


  if not frm_PCM_Main.bNeu then
  begin
    qry_KalAbo.SQL.Text:= sSQL_UPD_ALL_Calabo_WHERE_ID;
    qry_KalAbo.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_KalAbo.ParamByName('Kalender').AsString:= edt_Kalender.text;
    qry_KalAbo.ParamByName('Link').AsString:= edt_Link.Text;
    qry_KalAbo.ParamByName('Benutzer').AsString:= edt_Benutzer.Text;
    qry_KalAbo.ParamByName('Passwort').AsString:= edt_Passwort.Text;
    qry_KalAbo.ParamByName('Erinnerung').AsBoolean:= sw_Reminderbefore.IsChecked;
    qry_KalAbo.ParamByName('ErinnerungVor').asInteger:= iMinutes;
    qry_KalAbo.ExecSQl;
    with frm_PCM_Main.lv_Calabo.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Kalender.Text;
      Detail:= edt_Link.Text;
    end;
  end
  else begin
    qry_KalAbo.SQL.Text:= sSQL_INS_ALL_CalAbo;
    qry_KalAbo.ParamByName('Kalender').AsString:= edt_Kalender.text;
    qry_KalAbo.ParamByName('Link').AsString:= edt_Link.Text;
    qry_KalAbo.ParamByName('Benutzer').AsString:= edt_Benutzer.Text;
    qry_KalAbo.ParamByName('Passwort').AsString:= edt_Passwort.Text;
    qry_KalAbo.ParamByName('Erinnerung').AsBoolean:= sw_Reminderbefore.IsChecked;
    qry_KalAbo.ParamByName('ErinnerungVor').asInteger:= iMinutes;
    qry_KalAbo.ExecSQl;

    frm_PCM_Main.lv_Calabo.Items.Clear;
    frm_PCM_Main.lv_Calabo.BeginUpdate;
    frm_PCM_Main.CreateCalAboGrid;
    frm_PCM_Main.lv_Calabo.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  except
  end;
  edt_Kalender.enabled:= false;
  edt_Link.enabled:= false;
  edt_Benutzer.enabled:= false;
  edt_Passwort.enabled:= false;
  sw_Reminderbefore.Enabled:= false;
  cbx_Reminderbefore.Enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;

end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_CalAboDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeandNil(qry_KalAbo);
end;
procedure Tfrm_PCMAPP_CalAboDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_CalAboDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_CalAboDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_CalAboDetail.FormShow(Sender: TObject);
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
        frm_PCMAPP_CalAboDetail.StyleBook:= dmMain.stB_0;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_CalAboDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_CalAboDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_CalAboDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_CalAboDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_Reminderbefore.count - 1 do
    begin
      cbx_Reminderbefore.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Reminderbefore.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Reminderbefore.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 12;
      cbx_Reminderbefore.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
begin
  SetDesign;
  qry_KalAbo:= TFDQuery.Create(nil);
  qry_KalAbo.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Kalenderabos laden...', 'Kalenderabos', True);
  {$IFDEF MSWINDOWS}
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  if frm_PCM_Main.bNeu  then
  begin
    edt_Kalender.enabled:= true;
    edt_Link.enabled:= true;
    edt_Benutzer.enabled:= true;
    edt_Passwort.enabled:= true;
    sw_Reminderbefore.Enabled:= true;
    cbx_Reminderbefore.Enabled:= true;
    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end
  else begin
    qry_KalAbo.SQL.Text:= sSQL_SEL_ALL_Calabo_WHERE_ID;
    qry_KalAbo.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_KalAbo.open;
    edt_Kalender.Text:= qry_KalAbo.FieldByName('Kalender').AsString;
    edt_Link.Text:= qry_KalAbo.FieldByName('Link').AsString;
    edt_Benutzer.Text:= qry_KalAbo.FieldByName('Benutzer').AsString;
    edt_Passwort.Text:= qry_KalAbo.FieldByName('Passwort').AsString;
    if qry_KalAbo.FieldByName('Erinnerung').AsBoolean then
      sw_Reminderbefore.IsChecked:= true
    else
      sw_Reminderbefore.IsChecked:= false;
    case qry_KalAbo.FieldByName('ErinnerungVor').ASInteger of
    5: cbx_Reminderbefore.itemindex:= 1;
    10: cbx_Reminderbefore.itemindex:= 2;
    15: cbx_Reminderbefore.itemindex:= 3 ;
    20: cbx_Reminderbefore.itemindex:= 4 ;
    30: cbx_Reminderbefore.itemindex:= 5 ;
    60: cbx_Reminderbefore.itemindex:= 6 ;
    120: cbx_Reminderbefore.itemindex:= 7 ;
    180: cbx_Reminderbefore.itemindex:= 8 ;
    240: cbx_Reminderbefore.itemindex:= 9 ;
    300: cbx_Reminderbefore.itemindex:= 10 ;
    360: cbx_Reminderbefore.itemindex:= 11 ;
    420: cbx_Reminderbefore.itemindex:= 12 ;
    480: cbx_Reminderbefore.itemindex:= 13 ;
    540: cbx_Reminderbefore.itemindex:= 14 ;
    600: cbx_Reminderbefore.itemindex:= 15 ;
    660: cbx_Reminderbefore.itemindex:= 16 ;
    720: cbx_Reminderbefore.itemindex:= 17 ;
    1080: cbx_Reminderbefore.itemindex:= 18 ;
    1440: cbx_Reminderbefore.itemindex:= 19 ;
    2880: cbx_Reminderbefore.itemindex:= 20 ;
    4320: cbx_Reminderbefore.itemindex:= 21 ;
    5760: cbx_Reminderbefore.itemindex:= 22 ;
    10080: cbx_Reminderbefore.itemindex:= 23 ;
    20160: cbx_Reminderbefore.itemindex:= 24 ;
    end;
    qry_KalAbo.Close;
    dmmain.wfWaitFrame.HideFW;
  end;
end;
procedure Tfrm_PCMAPP_CalAboDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_CalAboDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.
