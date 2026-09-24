unit PCMApp.Belege.Detail;

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
  FMX.Platform,FMX.VirtualKeyboard, FMX.EditBox, FMX.NumberBox, FMX.ListBox,
  FMX.DateTimeCtrls;
  {$EndRegion Uses}
type
  {$Region Types}
  Tfrm_PCMAPP_BelegeDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_Jahr: TComboBox;
    cbx_Kat: TComboBox;
    cbx_Monat: TComboBox;
    dtp_Beleg: TDateEdit;
    edt_BelAus: TEdit;
    edt_BelNr: TEdit;
    edt_BetragBel: TNumberBox;
    lbl_Aussteller: TLabel;
    lbl_Belegdatum: TLabel;
    lbl_Betrag: TLabel;
    lbl_Jahr: TLabel;
    lbl_Kategorie: TLabel;
    lbl_ModulName: TLabel;
    lbl_Monat: TLabel;
    lbl_Target: TLabel;
    lo_Form: TLayout;
    lo_Jahr: TLayout;
    lo_KostenDatum: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Monat: TLayout;
    lo_Right: TLayout;
    tb_Main: TRectangle;
    vsbx_BelegeDetailView: TVertScrollBox;
    vsbx_main: TVertScrollBox;
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure edt_BetragBelEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private-Deklarationen }
    bNeedOffset: Boolean;
    dBounds: TRectF;
    qry_Belege: TFDQuery;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
var
  frm_PCMAPP_BelegeDetail: Tfrm_PCMAPP_BelegeDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure Tfrm_PCMAPP_BelegeDetail.btn_SaveApplyStyleLookup(Sender: TObject);
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
procedure Tfrm_PCMAPP_BelegeDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_BelegeDetail.RestorePosition;
begin
  vsbx_main.ViewportPosition := PointF(vsbx_main.ViewportPosition.X, 0);
  lo_main.Align := TAlignLayout.Client;
  vsbx_main.RealignContent;
end;
procedure Tfrm_PCMAPP_BelegeDetail.UpdateKBBounds;
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
procedure Tfrm_PCMAPP_BelegeDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_BelegeDetail.Close;
end;
procedure Tfrm_PCMAPP_BelegeDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_BelegeDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
    qry_belege.SQL.Text:= sSQL_SEL_ALL_Belege_WHERE_ID;
    qry_belege.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_belege.open;

    edt_BelNr.Text:= qry_belege.FieldByName('Nummer').AsString;
    dtp_Beleg.Date:= qry_belege.FieldByName('Datum').AsDateTime;
    edt_BelAus.Text:= qry_belege.FieldByName('Aussteller').AsString;
    edt_BetragBel.value:= qry_belege.FieldByName('Betrag').asFloat;
    cbx_Kat.ItemIndex:= qry_belege.FieldByName('Kategorie').asInteger;
    cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(qry_belege.FieldByName('Jahr').AsString);
    cbx_Monat.ItemIndex:= cbx_Monat.Items.IndexOf(qry_belege.FieldByName('Monat').AsString);

    qry_belege.Close;

    edt_BelNr.enabled:= false;
    dtp_Beleg.enabled:= false;
    edt_BelAus.enabled:= false;
    edt_BetragBel.enabled:= false;
    cbx_Kat.Enabled:= false;
    cbx_Jahr.Enabled:= false;
    cbx_Monat.Enabled:= false;
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_BelegeDetail.btn_EditClick(Sender: TObject);
begin
  edt_BelNr.enabled:= true;
  dtp_Beleg.enabled:= true;
  edt_BelAus.enabled:= true;
  edt_BetragBel.enabled:= true;
  cbx_Kat.Enabled:= true;
  cbx_Jahr.Enabled:= true;
  cbx_Monat.Enabled:= true;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
end;
procedure Tfrm_PCMAPP_BelegeDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_BelNr.Text = '') or  (edt_BelAus.Text = '')then
  begin
    ShowMessage('Nummer oder Austeller darf nicht leer sein!');
    exit;
  end;

  if not frm_PCM_Main.bNeu then
  begin
    qry_belege.SQL.Text:= sSQL_UPD_ALL_WHERE_ID;
    qry_belege.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_belege.ParamByName('Nummer').AsString:= edt_BelNr.Text;
    qry_belege.ParamByName('Aussteller').AsString:= edt_BelAus.Text;
    qry_belege.ParamByName('Datum').AsDate:= dtp_Beleg.Date;
    qry_belege.ParamByName('Betrag').asFloat:= edt_BetragBel.value;
    qry_belege.ParamByName('Kategorie').AsInteger:= cbx_Kat.ItemIndex;
    if cbx_Monat.ItemIndex = -1 then
      qry_belege.ParamByName('Monat').AsInteger:= 1
    else
      qry_belege.ParamByName('Monat').AsInteger:= StrToint(cbx_Monat.Items[cbx_Monat.ItemIndex]);
    if cbx_Jahr.ItemIndex = -1 then
      qry_belege.ParamByName('Jahr').AsInteger:= 2020
    else
      qry_belege.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);

    qry_belege.ExecSQl;
    with frm_PCM_Main.lv_Belege.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_BelAus.Text + ': ' + edt_BelNr.Text;
      Detail:= FormatDateTime('dd.mm.yyyy',dtp_Beleg.date)  + ', ' + FormatCurr(',0.00 €;-,0.00 €', edt_BetragBel.value);
    end;
  end
  else begin
    qry_belege.SQL.Text:= sSQL_INS_ALL_Belege;
    qry_belege.ParamByName('Nummer').AsString:= edt_BelNr.Text;
    qry_belege.ParamByName('Aussteller').AsString:= edt_BelAus.Text;
    qry_belege.ParamByName('Datum').AsDate:= dtp_Beleg.Date;
    qry_belege.ParamByName('Betrag').asFloat:= edt_BetragBel.Value;
    qry_belege.ParamByName('Kategorie').AsInteger:= cbx_Kat.ItemIndex;
    if cbx_Monat.ItemIndex = -1 then
      qry_belege.ParamByName('Monat').AsInteger:= 1
    else
      qry_belege.ParamByName('Monat').AsInteger:= StrToint(cbx_Monat.Items[cbx_Monat.ItemIndex]);
    if cbx_Jahr.ItemIndex = -1 then
      qry_belege.ParamByName('Jahr').AsInteger:= 2020
    else
      qry_belege.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);

    qry_belege.ExecSQl;
    frm_PCM_Main.lv_Belege.Items.Clear;
    frm_PCM_Main.lv_Belege.BeginUpdate;
    frm_PCM_Main.CreateBelegeGridConfig;
    frm_PCM_Main.lv_Belege.EndUpdate;
    frm_PCM_Main.bNeu:= FALSE;
  end;
  edt_BelNr.enabled:= false;
  dtp_Beleg.enabled:= false;
  edt_BelAus.enabled:= false;
  edt_BetragBel.enabled:= false;
  cbx_Kat.Enabled:= false;
  cbx_Jahr.Enabled:= false;
  cbx_Monat.Enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_BelegeDetail.edt_BetragBelEnter(Sender: TObject);
begin
  edt_BetragBel.SelectAll;
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_BelegeDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(qry_Belege);
//  frm_PCMAPP_BelegeDetail.Release
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormCreate(Sender: TObject);
begin
  vsbx_main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_BelegeDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormResize(Sender: TObject);
begin
  lo_jahr.Width:= Round((frm_PCMAPP_BelegeDetail.ClientWidth - 48) / 2);
  lo_monat.Width:=  Round((frm_PCMAPP_BelegeDetail.ClientWidth - 48) / 2);
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormShow(Sender: TObject);
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
        frm_PCMAPP_BelegeDetail.StyleBook:= dmMain.stB_0;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_BelegeDetail.StyleBook:= dmMain.stB_1;
        TextColor:= TAlphaColorRec.Black;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_BelegeDetail.StyleBook:= dmMain.stB_2;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_BelegeDetail.StyleBook:= dmMain.stB_3;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_BelegeDetail.StyleBook:= dmMain.stB_4;
        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
    for icbxCount := 0 to cbx_Kat.count - 1 do
    begin
      cbx_Kat.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Kat.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Kat.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 12;
      cbx_Kat.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Monat.count - 1 do
    begin
      cbx_Monat.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Monat.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Monat.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 12;
      cbx_Monat.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;

    for icbxCount := 0 to cbx_Jahr.count - 1 do
    begin
      cbx_Jahr.ListBox.ListItems[icbxCount].StyledSettings:= cbx_Jahr.ListBox.ListItems[icbxCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Jahr.ListBox.ListItems[icbxCount].TextSettings.Font.Size:= 12;
      cbx_Jahr.ListBox.ListItems[icbxCount].TextSettings.FontColor:= TextColor;
    end;
  end;
var
  iJahr,iMonat,iTag: Word;
begin
  SetDesign;
  qry_Belege:= TFDQuery.Create(nil);
  qry_Belege.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Belege laden...', 'Finanzen Belege', True);
  {$IFDEF MSWINDOWS}
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  if cbx_Monat.ItemIndex = -1 then
  begin
    DecodeDate(Now,iJahr,iMonat,iTag);
    cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(IntToStr(iJahr));
    cbx_Monat.ItemIndex:= iMonat - 1;
  end;

  if frm_PCM_Main.bNeu  then
  begin
    dtp_Beleg.Date:= now();
    edt_BelNr.enabled:= true;
    dtp_Beleg.enabled:= true;
    dtp_Beleg.Date:= Now;
    edt_BelAus.enabled:= true;

    edt_BetragBel.enabled:= true;
    edt_BetragBel.Value:= 0;
    cbx_Kat.Enabled:= true;
    cbx_Jahr.Enabled:= true;
    cbx_Monat.Enabled:= true;
    btn_Back.Visible:= false;
    btn_Cancel.Visible:= true;
    btn_Edit.Visible:= false;
    btn_save.Visible:= true;
  end
  else begin
    qry_belege.SQL.Text:= sSQL_SEL_ALL_Belege_WHERE_ID;
    qry_belege.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_belege.open;


    edt_BelNr.Text:= qry_belege.FieldByName('Nummer').AsString;
    dtp_Beleg.Date:= qry_belege.FieldByName('Datum').AsDateTime;
    edt_BelAus.Text:= qry_belege.FieldByName('Aussteller').AsString;
    edt_BetragBel.value:= qry_belege.FieldByName('Betrag').asFloat;
    cbx_Kat.ItemIndex:= qry_belege.FieldByName('Kategorie').asInteger;
    cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(qry_belege.FieldByName('Jahr').AsString);
    cbx_Monat.ItemIndex:= cbx_Monat.Items.IndexOf(qry_belege.FieldByName('Monat').AsString);
    qry_belege.Close;
  end;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormVirtualKeyboardHidden(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_BelegeDetail.FormVirtualKeyboardShown(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.

