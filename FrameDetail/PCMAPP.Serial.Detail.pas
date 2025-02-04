unit PCMAPP.Serial.Detail;

interface

uses
  {$Region uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.Effects, FMX.Objects,System.Threading, System.ImageList,
  FMX.ImgList, system.math,
  FMX.Platform,FMX.VirtualKeyboard, FMX.EditBox, FMX.NumberBox, FMX.ListBox;
  {$EndRegion uses}
type
  {$Region Types}
  Tfrm_PCMAPP_SerialDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_SerialTyp: TComboBox;
    edt_BenutzerDetail: TEdit;
    edt_Programm_SpielDetail: TEdit;
    edt_SerialDetail: TEdit;
    lbl_BenutzerDetail: TLabel;
    lbl_ModulName: TLabel;
    lbl_Programm_SpielDetail: TLabel;
    lbl_SerialDetail: TLabel;
    lbl_SerialTyp: TLabel;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Right: TLayout;
    tb_Main: TRectangle;
    vsbx_main: TVertScrollBox;
    vsbx_SerialDetailView: TVertScrollBox;
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
    qry_Serial: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion Types}
var
  frm_PCMAPP_SerialDetail: Tfrm_PCMAPP_SerialDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_SerialDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_SerialDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_SerialDetail.UpdateKBBounds;
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
{$EndRegion Helperfunctions}
////////////////////////////////////////////////////////////////////////////////
// Button FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region ButtonFunctions}
procedure Tfrm_PCMAPP_SerialDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_SerialDetail.close;
end;
procedure Tfrm_PCMAPP_SerialDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_SerialDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_Serial.SQL.Text:= sSQL_SEL_ALL_Serials_Where_ID;
    qry_Serial.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Serial.open;
    edt_Programm_SpielDetail.Text:= qry_Serial.FieldByName('App').AsString;
    edt_BenutzerDetail.Text:= qry_Serial.FieldByName('user').AsString;
    edt_SerialDetail.Text:= qry_Serial.FieldByName('Serial').AsString;
    cbx_SerialTyp.ItemIndex:= cbx_SerialTyp.Items.IndexOf(qry_Serial.FieldByName('Bezeichnung').AsString);
    qry_Serial.Close;

    edt_Programm_SpielDetail.enabled:= false;
    edt_BenutzerDetail.enabled:= false;
    edt_SerialDetail.enabled:= false;
    cbx_SerialTyp.Enabled:= false;

    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_SerialDetail.btn_EditClick(Sender: TObject);
begin
  edt_Programm_SpielDetail.enabled:= true;
  edt_BenutzerDetail.enabled:= true;
  edt_SerialDetail.enabled:= true;
  cbx_SerialTyp.Enabled:= true;

  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_SerialDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Programm_SpielDetail.Text = '') then
  begin
    ShowMessage('Beschreibung darf nicht leer sein!');
    exit;
  end;

  if (cbx_SerialTyp.ItemIndex < 0 ) then
  begin
    ShowMessage('Typ darf nicht leer sein!');
    exit;
  end;

  if not frm_PCM_Main.bNeu then
  begin
    qry_Serial.SQL.Text:= sSQL_UPD_ALL_Serial_WHERE_ID;
    qry_Serial.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Serial.ParamByName('App').AsString:= edt_Programm_SpielDetail.text;
    qry_Serial.ParamByName('USER').AsString:= edt_BenutzerDetail.Text;
    qry_Serial.ParamByName('Serial').AsString:= edt_SerialDetail.Text;
    qry_Serial.ParamByName('Bezeichnung').Asstring:= cbx_SerialTyp.Items[cbx_SerialTyp.ItemIndex];
    qry_Serial.ExecSQl;
    with frm_PCM_Main.lv_Serials.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Programm_SpielDetail.Text;
      Detail:= cbx_SerialTyp.Items[cbx_SerialTyp.ItemIndex];
    end;
  end
  else begin
    qry_Serial.SQL.Text:= sSQL_INS_ALL_Serial;
    qry_Serial.ParamByName('App').AsString:= edt_Programm_SpielDetail.text;
    qry_Serial.ParamByName('USER').AsString:= edt_BenutzerDetail.Text;
    qry_Serial.ParamByName('Serial').asString:= edt_SerialDetail.Text;
    qry_Serial.ParamByName('Bezeichnung').AsString:= cbx_SerialTyp.Items[cbx_SerialTyp.ItemIndex];
    qry_Serial.ExecSQl;
    frm_PCM_Main.lv_Serials.Items.Clear;
    frm_PCM_Main.lv_Serials.BeginUpdate;
    frm_PCM_Main.CreateSerialGridConfig;
    frm_PCM_Main.lv_Serials.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  edt_Programm_SpielDetail.enabled:= FALSE;
  edt_BenutzerDetail.enabled:= FALSE;
  edt_SerialDetail.enabled:= FALSE;
  cbx_SerialTyp.Enabled:= FALSE;

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
procedure Tfrm_PCMAPP_SerialDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(qry_Serial);
end;
procedure Tfrm_PCMAPP_SerialDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_SerialDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_SerialDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_SerialDetail.FormShow(Sender: TObject);
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
        frm_PCMAPP_SerialDetail.StyleBook:= dmMain.stB_0;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_SerialDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_SerialDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_SerialDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_SerialDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_SerialTyp.count - 1 do
    begin
      cbx_SerialTyp.ListBox.ListItems[icbxCount].StyledSettings:= cbx_SerialTyp.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_SerialTyp.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_SerialTyp.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
begin
  SetDesign;
  qry_Serial:= TFDQuery.Create(nil);
  qry_Serial.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Serials laden...', 'Serials', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  qry_Serial.SQL.Text:= sSQL_SEL_ALL_Serials_Where_ID;
  qry_Serial.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
  qry_Serial.open;
  edt_Programm_SpielDetail.Text:= qry_Serial.FieldByName('App').AsString;
  edt_BenutzerDetail.Text:= qry_Serial.FieldByName('user').AsString;
  edt_SerialDetail.Text:= qry_Serial.FieldByName('Serial').AsString;
  cbx_SerialTyp.ItemIndex:= cbx_SerialTyp.Items.IndexOf(qry_Serial.FieldByName('Bezeichnung').AsString);
  qry_Serial.Close;

  if frm_PCM_Main.bNeu  then
  begin
    edt_Programm_SpielDetail.enabled:= true;
    edt_BenutzerDetail.enabled:= true;
    edt_SerialDetail.enabled:= true;
    cbx_SerialTyp.Enabled:= true;

    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end;

  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCMAPP_SerialDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_SerialDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.



