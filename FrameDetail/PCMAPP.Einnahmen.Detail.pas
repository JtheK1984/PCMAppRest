unit PCMAPP.Einnahmen.Detail;

interface

uses
  {$Region Uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.Effects, FMX.Objects,System.Threading, System.ImageList,
  FMX.ImgList, system.math,
  FMX.Platform,FMX.VirtualKeyboard, FMX.EditBox, FMX.NumberBox;
  {$EndRegion Uses}
type
  {$Region types}
  Tfrm_PCMAPP_EinnahmenDetail = class(TForm)
    btn_Back: TButton;
    btn_BetragNull: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_FixBetrag: TButton;
    btn_Save: TButton;
    edt_Beschreibung: TEdit;
    edt_Betrag: TNumberBox;
    edt_FixBetrag: TNumberBox;
    edt_Target: TEdit;
    lbl_Beschreibung: TLabel;
    lbl_Betrag: TLabel;
    lbl_FixBetrag: TLabel;
    lbl_ModulName: TLabel;
    lbl_Target: TLabel;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Right: TLayout;
    tb_Main: TRectangle;
    vsbx_EinnahmenDetailView: TVertScrollBox;
    vsbx_main: TVertScrollBox;
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_BetragNullClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_FixBetragClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure edt_BetragEnter(Sender: TObject);
    procedure edt_FixBetragEnter(Sender: TObject);
    procedure edt_FixBetragKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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
    qry_Einnahmen: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion types}
var
  frm_PCMAPP_EinnahmenDetail: Tfrm_PCMAPP_EinnahmenDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_SaveApplyStyleLookup(Sender: TObject);
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
procedure Tfrm_PCMAPP_EinnahmenDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.UpdateKBBounds;
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
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_EinnahmenDetail.Close;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_BetragNullClick(Sender: TObject);
begin
  edt_Betrag.Value:= 0;
  btn_SaveClick(Sender);
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_EinnahmenDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_Einnahmen.SQL.Text:= sSQL_SEL_ALL_Einnahmen_WHERE_ID;
    qry_Einnahmen.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Einnahmen.open;
    edt_Target.Text:= qry_Einnahmen.FieldByName('Quelle').AsString;
    edt_Beschreibung.Text:= qry_Einnahmen.FieldByName('Bezeichnung').AsString;
    edt_Betrag.Value:= qry_Einnahmen.FieldByName('Betrag').asFloat;
    edt_FixBetrag.Value:= qry_Einnahmen.FieldByName('FixBetrag').asFloat;
    qry_Einnahmen.Close;
    edt_Target.enabled:= false;
    edt_Beschreibung.enabled:= false;
    edt_Betrag.enabled:= false;
    edt_FixBetrag.enabled:= false;
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_EditClick(Sender: TObject);
begin
  edt_Target.enabled:= true;
  edt_Beschreibung.enabled:= true;
  edt_Betrag.enabled:= true;
  edt_FixBetrag.enabled:= true;
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_FixBetragClick(Sender: TObject);
begin
  edt_Betrag.Value:= edt_FixBetrag.Value;
  btn_SaveClick(Sender);
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Target.Text = '') then
  begin
    ShowMessage('Absender darf nicht leer sein!');
    exit;
  end;
  if not frm_PCM_Main.bNeu then
  begin
    qry_Einnahmen.SQL.Text:= sSQL_UPD_ALL_Einnahmen_WHERE_ID;
    qry_Einnahmen.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Einnahmen.ParamByName('Quelle').AsString:= edt_Target.text;
    qry_Einnahmen.ParamByName('Bezeichnung').AsString:= edt_Beschreibung.Text;
    qry_Einnahmen.ParamByName('Betrag').asFloat:= StrToFloatDef(edt_Betrag.Text,-1);
    qry_Einnahmen.ParamByName('FixBetrag').asFloat:= StrToFloatDef(edt_FixBetrag.Text,-1);
    qry_Einnahmen.ExecSQl;
    with frm_PCM_Main.lv_Einnahmen.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Target.Text;
      Detail:= FormatCurr(',0.00 €;-,0.00 €', StrToFloatDef(edt_Betrag.Text,-1));
    end;
  end
  else begin
    qry_Einnahmen.SQL.Text:= sSQL_INS_ALL_Einnahme;
    qry_Einnahmen.ParamByName('Quelle').asString:= edt_Target.text;
    qry_Einnahmen.ParamByName('Bezeichnung').AsString:= edt_Beschreibung.Text;
    qry_Einnahmen.ParamByName('Betrag').asFloat:= StrToFloatDef(edt_Betrag.Text,-1);
    qry_Einnahmen.ParamByName('FixBetrag').asFloat:= StrToFloatDef(edt_FixBetrag.Text,-1);
    qry_Einnahmen.ExecSQl;
    frm_PCM_Main.lv_Einnahmen.Items.Clear;
    frm_PCM_Main.lv_Einnahmen.BeginUpdate;
    frm_PCM_Main.CreateFinEinGridConfig;
    frm_PCM_Main.lv_Einnahmen.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  edt_Target.enabled:= false;
  edt_Beschreibung.enabled:= false;
  edt_Betrag.enabled:= false;
  edt_FixBetrag.enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.edt_BetragEnter(Sender: TObject);
begin
  edt_Betrag.SelectAll;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.edt_FixBetragEnter(Sender: TObject);
begin
  edt_FixBetrag.SelectAll;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.edt_FixBetragKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if not CharInSet(KeyChar,[',', '0'..'9']) then
  begin
    KeyChar := #0;
  end;
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_EinnahmenDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(qry_Einnahmen);
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_EinnahmenDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.FormShow(Sender: TObject);
  procedure SetDesign;
  var
    iDesignStyle: integer;
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
        frm_PCMAPP_EinnahmenDetail.StyleBook:= dmMain.stB_0;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_EinnahmenDetail.StyleBook:= dmMain.stB_1;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
     2:
      begin
        frm_PCMAPP_EinnahmenDetail.StyleBook:= dmMain.stB_2;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
     3:
      begin
        frm_PCMAPP_EinnahmenDetail.StyleBook:= dmMain.stB_3;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_EinnahmenDetail.StyleBook:= dmMain.stB_4;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
  end;
begin
  SetDesign;
  qry_Einnahmen:= TFDQuery.Create(nil);
  qry_Einnahmen.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Einnahmen laden...', 'Finanzen Ausgaben', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  qry_Einnahmen.SQL.Text:= sSQL_SEL_ALL_Einnahmen_WHERE_ID;
  qry_Einnahmen.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
  qry_Einnahmen.open;
  edt_Target.Text:= qry_Einnahmen.FieldByName('Quelle').AsString;
  edt_Beschreibung.Text:= qry_Einnahmen.FieldByName('Bezeichnung').AsString;
  edt_Betrag.value := qry_Einnahmen.FieldByName('Betrag').asFloat;
  edt_FixBetrag.value := qry_Einnahmen.FieldByName('FixBetrag').asFloat;
  qry_Einnahmen.Close;
  if frm_PCM_Main.bNeu  then
  begin
    edt_Beschreibung.enabled:= true;
    edt_Betrag.enabled:= true;
    edt_FixBetrag.enabled:= true;
    edt_Target.enabled:= true;
    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_EinnahmenDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.
