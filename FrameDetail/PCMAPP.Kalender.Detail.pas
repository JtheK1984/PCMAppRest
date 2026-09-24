unit PCMAPP.Kalender.Detail;

interface

uses
  {$Region uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.Threading, FMX.Effects,
  FMX.Objects,DateUtils,FMX.DialogService.Async,
  System.Math,FMX.VirtualKeyboard, FMX.Platform, FMX.DateTimeCtrls, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.Memo.Types;
  {$endRegion uses}
type
  {$Region Type}
  Tfrm_PCMAPP_KalenderDetail = class(TForm)
    btn_Back: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    cbx_Ort: TComboBox;
    cbx_Reminderbefore: TComboBox;
    cbx_Terminart: TComboBox;
    chkbx_CompleteDay: TCheckBox;
    chkbx_Reminder: TCheckBox;
    dtp_Bis: TDateEdit;
    dtp_Von: TDateEdit;
    edt_Betreff: TEdit;
    edt_Kalender: TEdit;
    lbl_Begin: TLabel;
    lbl_Betreff: TLabel;
    lbl_Cal: TLabel;
    lbl_CompleteDay: TLabel;
    lbl_End: TLabel;
    lbl_Message: TLabel;
    lbl_ModulName: TLabel;
    lbl_Ort: TLabel;
    lbl_Reminder: TLabel;
    lbl_RemminderMinutes: TLabel;
    lbl_Terminart: TLabel;
    lo_1: TLayout;
    lo_2: TLayout;
    lo_3: TLayout;
    lo_4: TLayout;
    lo_Begin: TLayout;
    lo_BeginDetail: TLayout;
    lo_Cal: TLayout;
    lo_CompleteDay: TLayout;
    lo_End: TLayout;
    lo_EndDetail: TLayout;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Ort: TLayout;
    lo_Reminder: TLayout;
    lo_RemminderMinutes: TLayout;
    lo_Right: TLayout;
    lo_Terminart: TLayout;
    mem_Message: TMemo;
    tb_Main: TRectangle;
    te_Bis: TTimeEdit;
    te_Von: TTimeEdit;
    vsbx_KalenderDetailView: TVertScrollBox;
    vsbx_Main: TVertScrollBox;
    procedure btn_SaveApplyStyleLookup(Sender: TObject);
    procedure btn_BackClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure chkbx_CompleteDayClick(Sender: TObject);
    procedure chkbx_ReminderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure lo_1Resized(Sender: TObject);
  private
    { Private-Deklarationen }
    qry_Kalender: TFDQuery;
    dBounds: TRectF;
    bNeedOffset: Boolean;
    function GetReminder(AMinutes: Integer) : Integer;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public-Deklarationen }
  end;
  {$EndRegion Type}
var
  frm_PCMAPP_KalenderDetail: Tfrm_PCMAPP_KalenderDetail;

implementation

{$R *.fmx}

uses  PCMAPP.Datamodul,
      PCMApp.Funktionen,
      PCMApp.Main,
      PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
function Tfrm_PCMAPP_KalenderDetail.GetReminder(AMinutes: Integer) : Integer;
begin
  Result:= 0;
  case AMinutes of
    5: Result:= 1;
    10: Result:= 2;
    15: Result:= 3 ;
    20: Result:= 4 ;
    30: Result:= 5 ;
    60: Result:= 6 ;
    120: Result:= 7 ;
    180: Result:= 8 ;
    240: Result:= 9 ;
    300: Result:= 10 ;
    360: Result:= 11 ;
    420: Result:= 12 ;
    480: Result:= 13 ;
    540: Result:= 14 ;
    600: Result:= 15 ;
    660: Result:= 16 ;
    720: Result:= 17 ;
    1080: Result:= 18 ;
    1440: Result:= 19 ;
    2880: Result:= 20 ;
    4320: Result:= 21 ;
    5760: Result:= 22 ;
    10080: Result:= 23 ;
    20160: Result:= 24 ;
  end;
end;
procedure Tfrm_PCMAPP_KalenderDetail.btn_SaveApplyStyleLookup(Sender: TObject);
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
procedure Tfrm_PCMAPP_KalenderDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_KalenderDetail.RestorePosition;
begin
  vsbx_Main.ViewportPosition := PointF(vsbx_Main.ViewportPosition.X, 0);
  lo_Main.Align := TAlignLayout.Client;
  vsbx_Main.RealignContent;
end;
procedure Tfrm_PCMAPP_KalenderDetail.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  bNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbx_Main.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(dBounds))) and (LFocusRect.Bottom > dBounds.Top) then
    begin
      bNeedOffset := True;
      lo_Main.Align := TAlignLayout.Horizontal;
      vsbx_Main.RealignContent;
      Application.ProcessMessages;
      vsbx_Main.ViewportPosition := PointF(vsbx_Main.ViewportPosition.X,LFocusRect.Bottom - (dBounds.Top - 48));
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
procedure Tfrm_PCMAPP_KalenderDetail.btn_CancelClick(Sender: TObject);
var
  dtDateTimeVon,dtDateTimeBis: TDateTime;
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCMAPP_KalenderDetail.close;
    frm_PCM_Main.bNeu:= false;
  end
  else begin
  cbx_Terminart.Itemindex:= -1;
  qry_Kalender.SQL.Text:= sSQL_SEL_ALL_Kalender_WHERE_ID;
  qry_Kalender.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
  qry_Kalender.open;
  cbx_Reminderbefore.itemindex:= GetReminder(qry_Kalender.FieldByName('ReminderMinutesBeforeStart').AsInteger);
  dtDateTimeVon:= qry_Kalender.FieldByName('Start').AsDateTime;
  dtDateTimeBis:= qry_Kalender.FieldByName('Finish').AsDateTime;
  chkbx_CompleteDay.IsChecked := qry_Kalender.FieldByName('CompleteDay').AsBoolean;
  dtp_von.Format := 'dd.mm.yyyy';
  dtp_Bis.Format := 'dd.mm.yyyy';
  dtp_von.DateTime := dtDateTimeVon;
  dtp_Bis.DateTime := dtDateTimeBis;
  if chkbx_CompleteDay.IsChecked and
    (DateOf(dtDateTimeBis) > DateOf(dtDateTimeVon)) then
    // Saving all-day events stores the day AFTER the last included day.
    dtp_Bis.DateTime := IncDay(DateOf(dtDateTimeBis), -1);
  te_von.Time := TimeOf(dtDateTimeVon);
  te_Bis.Time := TimeOf(dtDateTimeBis);
  te_von.Visible := not chkbx_CompleteDay.IsChecked;
  te_Bis.Visible := not chkbx_CompleteDay.IsChecked;
  cbx_Terminart.Itemindex:= qry_Kalender.FieldByName('EventType').asInteger;
  if qry_Kalender.FieldByName('Reminder').AsBoolean = True then
  begin
    chkbx_Reminder.IsChecked:= true;
  end
  else begin
    chkbx_Reminder.IsChecked:= false;
    cbx_Reminderbefore.ItemIndex:= 0;
  end;
  cbx_Ort.ItemIndex:= cbx_Ort.Items.IndexOf(qry_Kalender.FieldByName('Location').asString);
  edt_Kalender.Text:= qry_Kalender.FieldByName('Kalendername').asString;
  edt_Betreff.Text:= qry_Kalender.FieldByName('Caption').asString;
  mem_message.Text:= qry_Kalender.FieldByName('Message').AsString;
  qry_Kalender.Close;
  te_von.enabled:= false;
  te_Bis.enabled:= false;
  dtp_von.enabled:= false;
  dtp_Bis.enabled:= false;
  chkbx_CompleteDay.enabled:= false;
  cbx_Terminart.enabled:= false;
  chkbx_Reminder.enabled:= false;
  cbx_Reminderbefore.enabled:= false;
  cbx_Ort.enabled:= false;
  edt_Kalender.enabled:= false;
  edt_Betreff.enabled:= false;
  mem_message.Readonly:= true;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_KalenderDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_KalenderDetail.close;
end;
procedure Tfrm_PCMAPP_KalenderDetail.btn_EditClick(Sender: TObject);
begin
  te_von.enabled:= true;
  te_Bis.enabled:= true;
  te_von.Visible:= true;
  te_Bis.Visible:= true;
  dtp_von.enabled:= true;
  dtp_Bis.enabled:= true;
  chkbx_CompleteDay.enabled:= true;
  cbx_Terminart.enabled:= true;
  chkbx_Reminder.enabled:= true;
  cbx_Reminderbefore.enabled:= true;
  cbx_Ort.enabled:= true;
  edt_Kalender.enabled:= true;
  edt_Betreff.enabled:= true;
  mem_message.Readonly:= false;
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;

end;
procedure Tfrm_PCMAPP_KalenderDetail.btn_SaveClick(Sender: TObject);
var
  dtDateTime: TDateTime;
  dtStart,dtFinish: TDateTime;
  sWochentagBeginn, sWochentagEnde: string;
  iMinutes: integer;
begin
  iMinutes:= 0;
  if (edt_Betreff.text = '') then
  begin
    ShowMessage('Betreff darf nicht leer sein!');
    exit;
  end;
  sWochentagBeginn:= GetWeekDay(dtp_von.Date);
  sWochentagEnde:= GetWeekDay(dtp_bis.Date);
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

  dtDateTime:= IncMinute(dtp_von.DateTime,iMinutes);
  if chkbx_CompleteDay.IsChecked then
  begin
    dtStart:= StrToDateTimeDef(DateTostr(dtp_von.date) + ' 00:00',-1);
    dtFinish:= StrToDateTimeDef(DateTostr(IncDay(dtp_Bis.date,1)) + ' 00:00',-1);
  end
  else begin
    dtStart:= StrToDateTimeDef(DateTostr(dtp_von.date) + ' ' + TimeTostr(te_von.Time),-1);
    dtFinish:= StrToDateTimeDef(DateTostr(dtp_Bis.date) + ' ' + TimeTostr(te_Bis.Time),-1);
  end;
  if dtStart > dtFinish then
  begin
    ShowMessage('Das Beginndatum darf nicht größer als das Endedatum sein.');
    exit;
  end;
  if not frm_PCM_Main.bNeu then
  begin
    qry_Kalender.SQL.Text:= sSQL_UPD_ALL_Kalender_WHERE_ID;
    qry_Kalender.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Kalender.ParamByName('EventType').AsInteger:= cbx_Terminart.Itemindex;
    qry_Kalender.ParamByName('Caption').AsString:= edt_Betreff.Text;
    if cbx_Ort.ItemIndex > -1 then
      qry_Kalender.ParamByName('Location').AsString:= cbx_Ort.Items[cbx_Ort.ItemIndex]
    else
      qry_Kalender.ParamByName('Location').AsString:= '';
    qry_Kalender.ParamByName('Message').AsString:= mem_message.Text;
    qry_Kalender.ParamByName('Start').AsDateTime:= dtStart;
    qry_Kalender.ParamByName('Finish').AsDateTime:= dtFinish;
    if chkbx_CompleteDay.IsChecked then
      qry_Kalender.ParamByName('CompleteDay').AsBoolean:= true
    else
      qry_Kalender.ParamByName('CompleteDay').AsBoolean:= false;

    if chkbx_Reminder.IsChecked then
      qry_Kalender.ParamByName('Reminder').AsBoolean:= true
    else
      qry_Kalender.ParamByName('Reminder').AsBoolean:= false;
    qry_Kalender.ParamByName('ReminderDate').AsDateTime:= dtDateTime;
    qry_Kalender.ParamByName('ReminderMinutesBeforeStart').AsInteger:= iMinutes;
    qry_Kalender.ParamByName('Kalendername').asString:= edt_Kalender.Text;
    qry_Kalender.ExecSQl;

    with frm_PCM_Main.lv_Kalender.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= edt_Betreff.text;
      if chkbx_CompleteDay.IsChecked then
      begin
        if dtFinish - dtStart  = 1 then
        begin
          Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',dtStart);
        end
        else begin
          Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',dtStart) + ' - ' + sWochentagEnde + ' ' + FormatDateTime('dd.mm.yyyy',dtFinish);
        end;
      end
      else begin
        if dtFinish - dtStart  = 1 then
        begin
          Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',dtStart);
        end
        else begin
          Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy hh:mm',dtStart) + ' - ' + FormatDateTime('hh:mm',dtFinish);
        end;
      end;
    end;
  end
  else begin
    frm_PCM_Main.bNeu:= FALSE;
    qry_Kalender.SQL.Text:= sSQL_INS_ALL_Kalender;
    qry_Kalender.ParamByName('EventType').AsInteger:= cbx_Terminart.Itemindex;
    qry_Kalender.ParamByName('Caption').AsString:= edt_Betreff.Text;
    qry_Kalender.ParamByName('Location').AsString:= cbx_Ort.Items[cbx_Ort.ItemIndex];
    qry_Kalender.ParamByName('Message').AsString:= mem_message.Text;
    qry_Kalender.ParamByName('Start').AsDateTime:= dtStart;
    qry_Kalender.ParamByName('Finish').AsDateTime:= dtFinish;
    if chkbx_CompleteDay.IsChecked then
      qry_Kalender.ParamByName('CompleteDay').AsBoolean:= true
    else
      qry_Kalender.ParamByName('CompleteDay').AsBoolean:= false;

    if chkbx_Reminder.IsChecked then
      qry_Kalender.ParamByName('Reminder').AsBoolean:= true
    else
      qry_Kalender.ParamByName('Reminder').AsBoolean:= false;
    qry_Kalender.ParamByName('ReminderDate').AsDateTime:= dtDateTime;
    qry_Kalender.ParamByName('ReminderMinutesBeforeStart').AsInteger:= iMinutes;
    qry_Kalender.ParamByName('Kalendername').asString:= edt_Kalender.Text;
    try
      qry_Kalender.ExecSQl;
    Except
    end;
    frm_PCM_Main.lv_Kalender.Items.Clear;
    frm_PCM_Main.lv_Kalender.BeginUpdate;
    if frm_PCM_Main.btn_KalenderFilter.Tag = 0 then
      frm_PCM_Main.CreateKalGridConfig(true)
    else
      frm_PCM_Main.CreateKalGridConfig(false);
    frm_PCM_Main.lv_Kalender.EndUpdate;
  end;

  if chkbx_CompleteDay.IsChecked then
  begin
    te_von.Visible:= false;
    te_Bis.Visible:= false;
  end
  else begin
    te_von.Visible:= true;
    te_Bis.Visible:= true;
  end;
  te_von.enabled:= false;
  te_Bis.enabled:= false;
  dtp_von.enabled:= false;
  dtp_Bis.enabled:= false;
  chkbx_CompleteDay.enabled:= false;
  cbx_Terminart.enabled:= false;
  chkbx_Reminder.enabled:= false;
  cbx_Reminderbefore.enabled:= false;
  cbx_Ort.enabled:= false;
  edt_Kalender.enabled:= false;
  edt_Betreff.enabled:= false;
  mem_message.Readonly:= true;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_KalenderDetail.chkbx_CompleteDayClick(Sender: TObject);
begin
  if chkbx_CompleteDay.ischecked = false then
  begin
    te_von.visible:= false;
    te_Bis.visible:= false;
  end
  else begin
    te_von.visible:= true;
    te_Bis.visible:= true;
  end;
end;
procedure Tfrm_PCMAPP_KalenderDetail.chkbx_ReminderClick(Sender: TObject);
begin
  if chkbx_Reminder.isChecked = false then
    lo_RemminderMinutes.Visible:= true
  else
    lo_RemminderMinutes.Visible:= false;
end;
procedure Tfrm_PCMAPP_KalenderDetail.lo_1Resized(Sender: TObject);
begin
  lo_Begin.width:= Round(lo_1.Width / 2);
  lo_End.Width:=lo_Begin.width;
  lo_Completeday.Width:=lo_Begin.width;
  lo_Terminart.width:=lo_Begin.width;
  lo_Reminder.width:=lo_Begin.width;
  lo_RemminderMinutes.width:=lo_Begin.width;
  lo_Ort.width:=lo_Begin.width;
  lo_Cal.width:=lo_Begin.width;
end;
{$EndRegion ButtonFunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_KalenderDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  freeandnil(qry_kalender);
end;
procedure Tfrm_PCMAPP_KalenderDetail.FormCreate(Sender: TObject);
begin
  vsbx_Main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_KalenderDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_KalenderDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_KalenderDetail.FormShow(Sender: TObject);
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
        frm_PCMAPP_KalenderDetail.StyleBook:= dmMain.stB_0;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_KalenderDetail.StyleBook:= dmMain.stB_1;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_KalenderDetail.StyleBook:= dmMain.stB_2;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_KalenderDetail.StyleBook:= dmMain.stB_3;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
     {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_KalenderDetail.StyleBook:= dmMain.stB_4;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
  end;
var
  dtDateTimeVon,dtDateTimeBis: TDateTime;
begin
  SetDesign;
  qry_kalender:= TFDQuery.Create(nil);
  qry_kalender.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Kalender laden...', 'Kalender', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  te_Von.Width:= 100;
  te_Bis.Width:= 100;
  {$ENDIF MSWINDOWS}
  try
    cbx_Terminart.Itemindex:= -1;
    qry_Kalender.SQL.Text:= sSQL_SEL_ALL_Kalender_WHERE_ID;
    qry_Kalender.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Kalender.open;
    cbx_Reminderbefore.itemindex:= 0;
    cbx_Reminderbefore.itemindex:= GetReminder(qry_Kalender.FieldByName('ReminderMinutesBeforeStart').AsInteger);
    dtDateTimeVon:= qry_Kalender.FieldByName('Start').asDateTime;
    dtDateTimeBis:= qry_Kalender.FieldByName('Finish').AsDateTime;
  chkbx_CompleteDay.IsChecked := qry_Kalender.FieldByName('CompleteDay').AsBoolean;
  dtp_von.Format := 'dd.mm.yyyy';
  dtp_Bis.Format := 'dd.mm.yyyy';
  dtp_von.DateTime := dtDateTimeVon;
  dtp_Bis.DateTime := dtDateTimeBis;
  if chkbx_CompleteDay.IsChecked and
    (DateOf(dtDateTimeBis) > DateOf(dtDateTimeVon)) then
    // Saving all-day events stores the day AFTER the last included day.
    dtp_Bis.DateTime := IncDay(DateOf(dtDateTimeBis), -1);
  te_von.Time := TimeOf(dtDateTimeVon);
  te_Bis.Time := TimeOf(dtDateTimeBis);
  te_von.Visible := not chkbx_CompleteDay.IsChecked;
  te_Bis.Visible := not chkbx_CompleteDay.IsChecked;
    cbx_Terminart.Itemindex:= qry_Kalender.FieldByName('EventType').asInteger;
    if qry_Kalender.FieldByName('Reminder').AsBoolean = True then
    begin
      chkbx_Reminder.IsChecked:= true;
    end
    else begin
      chkbx_Reminder.IsChecked:= false;
      cbx_Reminderbefore.ItemIndex:= 0;
    end;
    cbx_Ort.Itemindex :=cbx_Ort.Items.IndexOf(qry_Kalender.FieldByName('Location').asString);
    edt_Kalender.Text:= qry_Kalender.FieldByName('Kalendername').asString;
    edt_Betreff.Text:= qry_Kalender.FieldByName('Caption').asString;
    if qry_Kalender.FieldByName('Message').AsString <> '' then
      mem_message.Text:= qry_Kalender.FieldByName('Message').AsString
    else
      mem_message.Text:= '';
    qry_Kalender.Close;
    if frm_PCM_Main.bNeu  then
    begin
      te_von.enabled:= true;
      te_Bis.enabled:= true;
      te_von.visible:= true;
      te_Bis.visible:= true;
      dtp_von.enabled:= true;
      dtp_Bis.enabled:= true;
      te_von.Time := Now;
      te_Bis.Time := Now;
      dtp_von.date:= Now;
      dtp_Bis.date:= Now;
      chkbx_CompleteDay.enabled:= true;
      chkbx_CompleteDay.IsChecked:= false;
      cbx_Terminart.enabled:= true;
      chkbx_Reminder.enabled:= true;
      chkbx_Reminder.IsChecked:= true;
      cbx_Reminderbefore.enabled:= true;
      cbx_Ort.enabled:= true;
      edt_Kalender.enabled:= true;
      edt_Betreff.enabled:= true;
      mem_Message.Readonly:= false;
      btn_Back.Visible:= false;
      btn_Cancel.Visible:= true;
      btn_Edit.Visible:= false;
      btn_save.Visible:= true;
    end;
    dmmain.wfWaitFrame.HideFW;
    qry_Kalender.Close;
  except
    qry_Kalender.Close;
    dmmain.wfWaitFrame.HideFW;
    frm_PCM_Main.bNeu:= false;
  end;
end;
procedure Tfrm_PCMAPP_KalenderDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_KalenderDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.

