unit PCMApp.Ausgaben.Detail;

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
  FMX.Platform,FMX.VirtualKeyboard, FMX.EditBox, FMX.NumberBox, FMX.ListBox;
  {$EndRegion Uses}
type
  {$Region Types}
  Tfrm_PCMAPP_AusgabenDetail = class(TForm)
    btn_Back: TButton;
    btn_BetragNull: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_FixBetrag: TButton;
    btn_Save: TButton;
    cbx_Jahr: TComboBox;
    cbx_Monat: TComboBox;
    chkbx_Fixkosten: TCheckBox;
    edt_Bankleitzahl: TEdit;
    edt_Beschreibung: TEdit;
    edt_Betrag: TNumberBox;
    edt_FixBetrag: TNumberBox;
    edt_Kontonummer: TEdit;
    edt_Target: TEdit;
    edt_Verwendungszweck: TEdit;
    lbl_Beschreibung: TLabel;
    lbl_Betrag: TLabel;
    lbl_Bic: TLabel;
    lbl_FixBetrag: TLabel;
    lbl_Fixkosten: TLabel;
    lbl_IBAN: TLabel;
    lbl_Jahr: TLabel;
    lbl_ModulName: TLabel;
    lbl_Monat: TLabel;
    lbl_Target: TLabel;
    lbl_Verwendungszweck: TLabel;
    lo_Form: TLayout;
    lo_Jahr: TLayout;
    lo_KostenDatum: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Monat: TLayout;
    lo_Right: TLayout;
    tb_Main: TRectangle;
    vsbx_Bemerkung: TVertScrollBox;
    vsbx_main: TVertScrollBox;
    procedure btn_BackClick(Sender: TObject);
    procedure btn_BetragNullClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_FixBetragClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure chkbx_FixkostenChange(Sender: TObject);
    procedure edt_BetragEnter(Sender: TObject);
    procedure edt_FixBetragEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure lo_KostenDatumResized(Sender: TObject);
  private
    { Private-Deklarationen }
    bNeedOffset: Boolean;
    dBounds: TRectF;
    qry_Ausgaben: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion Types}
var
  frm_PCMAPP_AusgabenDetail: Tfrm_PCMAPP_AusgabenDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_AusgabenDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.UpdateKBBounds;
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
procedure Tfrm_PCMAPP_AusgabenDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_AusgabenDetail.close;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.btn_BetragNullClick(Sender: TObject);
begin
  edt_Betrag.Value:= 0;
  btn_SaveClick(Sender)
end;
procedure Tfrm_PCMAPP_AusgabenDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_AusgabenDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_Ausgaben.SQL.Text:= sSQL_SEL_ALL_Ausgaben_WHERE_ID;
    qry_Ausgaben.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Ausgaben.open;
    edt_Target.Text:= qry_Ausgaben.FieldByName('Name').AsString;
    edt_Beschreibung.Text:= qry_Ausgaben.FieldByName('Beschreibung').AsString;
    edt_Kontonummer.Text:= qry_Ausgaben.FieldByName('Kontonummer').AsString;
    edt_Bankleitzahl.Text:= qry_Ausgaben.FieldByName('Bankleitzahl').AsString;
    edt_Betrag.value:= qry_Ausgaben.FieldByName('Betrag').asFloat;
    edt_FixBetrag.value:= qry_Ausgaben.FieldByName('FixBetrag').asFloat;
    edt_Verwendungszweck.Text:= qry_Ausgaben.FieldByName('Verwendungszweck').AsString;
    cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(qry_Ausgaben.FieldByName('Gueltig_Jahr').AsString);
    cbx_Monat.ItemIndex:= cbx_Monat.Items.IndexOf(qry_Ausgaben.FieldByName('Gueltig_Monat').AsString);


    if qry_Ausgaben.FieldByName('Fixkosten').AsBoolean then
    begin
      chkbx_Fixkosten.IsChecked:= True;
      lo_KostenDatum.Visible:= false;
    end
    else begin
      chkbx_Fixkosten.IsChecked := false;
      lo_KostenDatum.Visible:= true;
    end;
    qry_Ausgaben.Close;

    edt_Target.enabled:= false;
    edt_Beschreibung.enabled:= false;
    edt_Kontonummer.enabled:= false;
    edt_Bankleitzahl.enabled:= false;
    edt_Verwendungszweck.Enabled:= false;
    edt_Betrag.Enabled:= false;
    edt_FixBetrag.Enabled:= false;
    chkbx_Fixkosten.Enabled:= false;
    cbx_Jahr.Enabled:= false;
    cbx_Monat.Enabled:= false;

    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.btn_EditClick(Sender: TObject);
begin
  edt_Target.enabled:= true;
  edt_Beschreibung.enabled:= true;
  edt_Kontonummer.enabled:= true;
  edt_Bankleitzahl.enabled:= true;
  edt_Verwendungszweck.Enabled:= true;
  edt_Betrag.Enabled:= true;
  edt_FixBetrag.Enabled:= true;
  chkbx_Fixkosten.Enabled:= true;
  cbx_Jahr.Enabled:= true;
  cbx_Monat.Enabled:= true;
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.btn_FixBetragClick(Sender: TObject);
begin
  edt_Betrag.Value:= edt_FixBetrag.Value;
  btn_SaveClick(Sender);
end;
procedure Tfrm_PCMAPP_AusgabenDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Target.Text = '') then
  begin
    ShowMessage('Empfänger darf nicht leer sein!');
    exit;
  end;

  if not frm_PCM_Main.bNeu then
  begin
    qry_Ausgaben.SQL.Text:= sSQL_UPD_ALL_Ausgaben_WHERE_ID;
    qry_Ausgaben.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Ausgaben.ParamByName('Quelle').AsString:= edt_Target.text;
    qry_Ausgaben.ParamByName('Bezeichnung').AsString:= edt_Beschreibung.Text;
    qry_Ausgaben.ParamByName('Betrag').asFloat:= edt_Betrag.Value;
    qry_Ausgaben.ParamByName('FixBetrag').asFloat:= edt_FixBetrag.Value;
    qry_Ausgaben.ParamByName('Kontonummer').AsString:= edt_Kontonummer.Text;
    qry_Ausgaben.ParamByName('Bankleitzahl').AsString:= edt_Bankleitzahl.Text;
    qry_Ausgaben.ParamByName('Fixkosten').AsBoolean:= chkbx_Fixkosten.IsChecked;
    if cbx_Monat.ItemIndex = -1 then
      qry_Ausgaben.ParamByName('Monat').AsInteger:= 1
    else
      qry_Ausgaben.ParamByName('Monat').AsInteger:= StrToint(cbx_Monat.Items[cbx_Monat.ItemIndex]);
    if cbx_Jahr.ItemIndex = -1 then
      qry_Ausgaben.ParamByName('Jahr').AsInteger:= 2020
    else
      qry_Ausgaben.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
    qry_Ausgaben.ParamByName('Verwendungszweck').AsString:= edt_Verwendungszweck.Text;

    qry_Ausgaben.ExecSQl;
    with frm_PCM_Main.lv_Ausgaben.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Target.Text;
      Detail:= FormatCurr(',0.00 €;-,0.00 €', StrToFloatDef(edt_Betrag.Text,-1));
    end;
  end
  else begin
    qry_Ausgaben.SQL.Text:= sSQL_INS_ALL_Ausgaben;
    qry_Ausgaben.ParamByName('Quelle').AsString:= edt_Target.text;
    qry_Ausgaben.ParamByName('Bezeichnung').AsString:= edt_Beschreibung.Text;
    qry_Ausgaben.ParamByName('Betrag').asFloat:= edt_Betrag.value;
    qry_Ausgaben.ParamByName('FixBetrag').asFloat:= edt_Betrag.Value;
    qry_Ausgaben.ParamByName('Kontonummer').AsString:= edt_Kontonummer.Text;
    qry_Ausgaben.ParamByName('Bankleitzahl').AsString:= edt_Bankleitzahl.Text;
    qry_Ausgaben.ParamByName('Fixkosten').AsBoolean:= chkbx_Fixkosten.IsChecked;
    if cbx_Monat.ItemIndex = -1 then
      qry_Ausgaben.ParamByName('Monat').AsInteger:= 1
    else
      qry_Ausgaben.ParamByName('Monat').AsInteger:= StrToint(cbx_Monat.Items[cbx_Monat.ItemIndex]);
    if cbx_Jahr.ItemIndex = -1 then
      qry_Ausgaben.ParamByName('Jahr').AsInteger:= 2020
    else
      qry_Ausgaben.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
    qry_Ausgaben.ParamByName('Verwendungszweck').AsString:= edt_Verwendungszweck.Text;
    qry_Ausgaben.ExecSQl;
    frm_PCM_Main.lv_Ausgaben.Items.Clear;
    frm_PCM_Main.lv_Ausgaben.BeginUpdate;
    frm_PCM_Main.CreateFinAusGridConfig;
    frm_PCM_Main.lv_Ausgaben.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  edt_Target.enabled:= false;
  edt_Beschreibung.enabled:= false;
  edt_Kontonummer.enabled:= false;
  edt_Bankleitzahl.enabled:= false;
  edt_Verwendungszweck.Enabled:= false;
  edt_Betrag.Enabled:= false;
  edt_FixBetrag.Enabled:= false;
  chkbx_Fixkosten.Enabled:= false;
  cbx_Jahr.Enabled:= false;
  cbx_Monat.Enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.chkbx_FixkostenChange(Sender: TObject);
begin
  if chkbx_Fixkosten.IsChecked then
  begin
    lo_KostenDatum.Visible:= false;
  end
  else begin
    lo_KostenDatum.Visible:= true;
  end;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.edt_BetragEnter(Sender: TObject);
begin
  edt_Betrag.SelectAll;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.edt_FixBetragEnter(Sender: TObject);
begin
  edt_FixBetrag.SelectAll;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.lo_KostenDatumResized(Sender: TObject);
begin
  lo_Monat.Width:= Round((lo_KostenDatum.Width - 8) /2);
  lo_Jahr.Width:= lo_Monat.Width
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_AusgabenDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(qry_Ausgaben);
end;
procedure Tfrm_PCMAPP_AusgabenDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_AusgabenDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_AusgabenDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.FormShow(Sender: TObject);
  procedure SetDesign;
  var
    TextColor: Cardinal;
    iDesignStyle,icbxCount: integer;
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
        frm_PCMAPP_AusgabenDetail.StyleBook:= dmMain.stB_0;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_AusgabenDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_AusgabenDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_AusgabenDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      4:
      {$IFDEF MSWINDOWS}
      begin
        frm_PCMAPP_AusgabenDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_Monat.count - 1 do
    begin
      cbx_Monat.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Monat.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Monat.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Monat.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Jahr.count - 1 do
    begin
      cbx_Jahr.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Jahr.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Jahr.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 14;
      cbx_Jahr.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
var
  iJahr,iMonat,iTag: Word;
begin
  SetDesign;
  qry_Ausgaben:= TFDQuery.Create(nil);
  qry_Ausgaben.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Ausgaben laden...', 'Finanzen Ausgaben', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  qry_Ausgaben.SQL.Text:= sSQL_SEL_ALL_Ausgaben_WHERE_ID;
  qry_Ausgaben.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
  qry_Ausgaben.open;
  edt_Target.Text:= qry_Ausgaben.FieldByName('Name').AsString;
  edt_Beschreibung.Text:= qry_Ausgaben.FieldByName('Beschreibung').AsString;
  edt_Kontonummer.Text:= qry_Ausgaben.FieldByName('Kontonummer').AsString;
  edt_Bankleitzahl.Text:= qry_Ausgaben.FieldByName('Bankleitzahl').AsString;
  edt_Betrag.Value:= qry_Ausgaben.FieldByName('Betrag').asFloat;
  edt_FixBetrag.Value:= qry_Ausgaben.FieldByName('FixBetrag').asFloat;
  edt_Verwendungszweck.Text:= qry_Ausgaben.FieldByName('Verwendungszweck').AsString;

  cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(qry_Ausgaben.FieldByName('Gueltig_Jahr').AsString);
  cbx_Monat.ItemIndex:= cbx_Monat.Items.IndexOf(qry_Ausgaben.FieldByName('Gueltig_Monat').AsString);
  if cbx_Jahr.ItemIndex = -1 then
  begin
    DecodeDate(Now,iJahr,iMonat,iTag);
    cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(IntToStr(iJahr));
    cbx_Monat.ItemIndex:= iMonat - 1;
  end;

  if qry_Ausgaben.FieldByName('Fixkosten').AsBoolean then
  begin
    chkbx_Fixkosten.IsChecked:= true;
    lo_KostenDatum.Visible:= false;
  end
  else begin
    chkbx_Fixkosten.IsChecked := false;
    lo_KostenDatum.Visible:= true;
  end;
  qry_Ausgaben.Close;

  if frm_PCM_Main.bNeu  then
  begin
    edt_Target.enabled:= true;
    edt_Beschreibung.enabled:= true;
    edt_Kontonummer.enabled:= true;
    edt_Bankleitzahl.enabled:= true;
    edt_Verwendungszweck.Enabled:= true;
    edt_Betrag.Enabled:= true;
    edt_FixBetrag.Enabled:= true;
    chkbx_Fixkosten.Enabled:= true;
    cbx_Jahr.Enabled:= true;
    cbx_Monat.Enabled:= true;
    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.FormVirtualKeyboardHidden(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_AusgabenDetail.FormVirtualKeyboardShown(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$ENDRegion Formfunctions}
end.

