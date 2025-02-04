unit PCMAPP.CalendarHolidayDays.Style;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.UI.Intf,
  FMX.Calendar,
  FMX.Calendar.Style,
  FMX.Controls.Model,
  FMX.Controls.Presentation,
  FMX.Presentation.Messages,
  FMX.ListBox,
  PCMAPP.Datamodul,
  PCMAPP.Funktionen,
  PCMAPP.SQL,
  System.UITypes;
type

  TStyledCalendarWithHolidayDays = class(TStyledCalendar)
  protected
    { Messages from Model }
    /// <summary>Notification about changing value of DataSource of a model of <c>PresentedControl</c> </summary>
    procedure MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>); message MM_DATA_CHANGED;
  protected
    procedure FillDays; override;
    procedure CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor); virtual;
    procedure RemoveDaysBackgrounds;
    procedure PaintWeekends; virtual;
    procedure PaintEventswithReccurrence; virtual;
    procedure PaintEvents; virtual;
  end;

implementation

uses
  System.SysUtils, System.DateUtils, System.Math, System.Types, FMX.Presentation.Factory, FMX.Controls, FMX.Presentation.Style, FMX.Types, FMX.Objects, FMX.Graphics, PCMAPP.Calendar.Helpers;

{ TStyledCalendarWithHolidayDays }


procedure TStyledCalendarWithHolidayDays.CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor);
var
  Hightlight: TCircle;
begin
  Hightlight := TCircle.Create(nil);
  Hightlight.Name := 'HightlightBackground';
  Hightlight.HitTest := False;
  Hightlight.Align := TAlignLayout.Contents;
  Hightlight.Margins.Rect := TRectF.Create(3, 3, 3, 3);
  Hightlight.Stroke.Kind := TBrushKind.None;
  Hightlight.Fill.Color := AColor;
  ADayItem.InsertObject(0, Hightlight);
end;
procedure TStyledCalendarWithHolidayDays.FillDays;
begin
  inherited;
  // Paint holidays
  RemoveDaysBackgrounds;
  if Model.ShowWeekends then
  begin
    PaintWeekends;
    PaintEventswithReccurrence;
  end;
  Repaint;
end;
procedure TStyledCalendarWithHolidayDays.MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>);
begin
  if SameText(AMessage.Value.Key, 'ShowWeekends') or
     SameText(AMessage.Value.Key, 'ShowEvents') or
     SameText(AMessage.Value.Key, 'EventsColor') or
     SameText(AMessage.Value.Key, 'WeekendsColor') or
     SameText(AMessage.Value.Key, 'Events') then
    FillCalendar
  else
    inherited;
end;
procedure TStyledCalendarWithHolidayDays.PaintEvents;
var
  Events: TArray<TDateTime>;
  Event: TDateTime;
  DayItem: TListBoxItem;
begin
  if Model.Data['Events'].IsType<TArray<TDateTime>> then
  begin
    Events := Model.Data['Events'].AsType<TArray<TDateTime>>;
    for Event in Events do
    begin
      DayItem := TryFindDayItem(Event);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.EventsColor);
    end;
  end;
end;
procedure TStyledCalendarWithHolidayDays.PaintEventswithReccurrence;
  function CheckReccurence(AStart, ADate: TDateTime; AWiederholung: string) :TDate;
  var
    fWeekWiederholung: double;
    fDays: double;
    iDow: Integer;
    iInterval: Integer;
    iMonat: Integer;
    iTag: Integer;
    sDay: String;
    sInterval: String;
    sWiederholungDays: String;
    wJahrAkt: Word;
    wMonatAkt: Word;
    wTagakt: Word;
  begin
    if AWiederholung = '' then
    begin
      result := AStart;
      exit;
    end;
    itag:= 1;
    iMonat:= 1;
    Result:= AStart;
  ////////////////////////////////////////////////////////////////////////////////
  // Täglich                                                                    //
  ////////////////////////////////////////////////////////////////////////////////
    if Pos('FREQ=DAILY',Awiederholung) > 0 then
    begin
      if Pos('INTERVAL',Awiederholung) > 0 then
      begin
        fDays:= (ADate - StrToDate(Copy(DateTimeToStr(AStart),1,10))) /2;
        if frac(fdays * 10) = 0  then
        begin
          Result:= StrToDate(DateToStr(ADate));
        end;
      end
      else begin
        Result:= StrToDate(DateToStr(ADate));
      end;
    end;
  ////////////////////////////////////////////////////////////////////////////////
  // Wöchentlich                                                                //
  ////////////////////////////////////////////////////////////////////////////////
    if Pos('FREQ=WEEKLY',Awiederholung) > 0 then
    begin
      if Pos('BYDAY',Awiederholung) > 0 then
      begin
        sWiederholungDays:= Copy(Awiederholung,Pos('BYDAY',Awiederholung) + 6,Length(Awiederholung));
        iDow := DayOfWeek(ADate);
        case iDow of
        1: sDay:= 'SU';
        2: sDay:= 'MO';
        3: sDay:= 'TU';
        4: sDay:= 'WE';
        5: sDay:= 'TH';
        6: sDay:= 'FR';
        7: sDay:= 'SA';
        end;
        if Pos(sday,sWiederholungDays) > 0 then
        begin
          if Pos('INTERVAL',Awiederholung) > 0 then
          begin
            sInterval:= Copy(Awiederholung,Pos('INTERVAL',Awiederholung)+9,Length(AWiederholung));
            sInterval:= Copy(sInterval,1,Pos(';',sInterval) -1);
            iInterval:=  StrToInt(sInterval);
            fWeekWiederholung := WeekOf(ADate - AStart);
            fWeekWiederholung:= fWeekWiederholung / iInterval;
            fWeekWiederholung:= frac(fWeekWiederholung);
            if fWeekWiederholung = 0 then
              Result:= StrToDate(DateToStr(ADate));
          end
          else
          begin
            Result:= StrToDate(DateToStr(ADate));
          end;
        end;
      end
      else begin
        Result:= StrToDate(DateToStr(ADate));
      end;
    end;
  ////////////////////////////////////////////////////////////////////////////////
  // Monatlich                                                                  //
  ////////////////////////////////////////////////////////////////////////////////
    if Pos('FREQ=MONTHLY',Awiederholung) > 0 then
    begin

    end;
  ////////////////////////////////////////////////////////////////////////////////
  // Jährlich                                                                  //
  ////////////////////////////////////////////////////////////////////////////////
    if Pos('FREQ=YEARLY',Awiederholung) > 0 then
    begin
      sWiederholungDays:= StringReplace(AWiederholung,'FREQ=YEARLY;','',[rfReplaceAll,rfIgnoreCase]);
      sWiederholungDays:= Copy(sWiederholungDays,Pos('BYMONTHDAY=',sWiederholungDays) + 11,Length(sWiederholungDays));
      iTag := StrToint(Copy(sWiederholungDays,1,Pos(';',sWiederholungDays)-1));
      sWiederholungDays:= Copy(sWiederholungDays,Pos('BYMONTH=',sWiederholungDays) + 8,Length(sWiederholungDays));
      iMonat := StrToint(Copy(sWiederholungDays,1,2));
    end;
    DecodeDate(ADate,wJahrAkt,wMonatAkt,wTagakt);
    if (wTagakt = iTag) and (wMonatAkt = iMonat)then
      Result:= StrToDate(DateToStr(ADate));
  end;
var
  DayItem: TListBoxItem;
  FirstDate: TDateTime;
  i: Integer;
  dtDateTimeEvent: TDateTime;
  dtLoopDate: TDateTime;
  wMonthDaysCount: Word;

  qry_Kalender: TFDQuery;
begin
  FirstDate := StartOfTheMonth(Self.Date);
  wMonthDaysCount := DaysInMonth(FirstDate);
  qry_Kalender:= TFDQuery.Create(Self);
  qry_Kalender.Connection:= dmmain.con_PCM;
  qry_Kalender.SQL.Text:= sSQL_SEL_ALL_Kalender_Where_Deleted;
  qry_Kalender.open;
  while not qry_Kalender.Eof do
  begin
    for I := 0 to wMonthDaysCount - 1 do
    begin
      dtLoopDate:= FirstDate + i;
      dtDateTimeEvent:= CheckReccurence(qry_Kalender.FieldByName('Start').asDatetime,dtLoopDate,qry_Kalender.FieldByName('wiederholungtext').asString);
      if Dateof(dtDateTimeEvent) = dtLoopDate then
      begin
        DayItem := TryFindDayItem(dtLoopDate);
        CreateBackground(DayItem, Model.EventsColor);
      end;
    end;
    qry_Kalender.Next;
  end;
  qry_Kalender.Close;
  FreeandNil(qry_Kalender);
end;
procedure TStyledCalendarWithHolidayDays.PaintWeekends;
var
  DayItem: TListBoxItem;
  FirstDate: TDateTime;
  FirstDay: Word;
  LWeek: Integer;
  WeekendDate: TDateTime;
  FirstWeekendDay: Integer;
  MonthDaysCount: Word;
  SaturdayDay: Word;
  SundayDay: Word;
begin
  FirstDate := StartOfTheMonth(Self.Date);
  FirstDay := DayOfTheWeek(FirstDate);
  MonthDaysCount := DaysInMonth(FirstDate);
  FirstWeekendDay := DaysPerWeek - FirstDay + 1;

  for LWeek := 0 to 4 do
  begin
    // Saturday
    SaturdayDay := FirstWeekendDay - 1 + LWeek * DaysPerWeek;
    if InRange(SaturdayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SaturdayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
    // Sunday
    SundayDay := FirstWeekendDay + LWeek * DaysPerWeek;
    if InRange(SundayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SundayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
  end;
end;
procedure TStyledCalendarWithHolidayDays.RemoveDaysBackgrounds;
  procedure RemoveBackground(ADayItem: TListBoxItem);
  var
    I: Integer;
    Background: TControl;
  begin
    for I := ADayItem.ControlsCount - 1 downto 0 do
      if ADayItem.Controls[I].Name = 'HightlightBackground' then
      begin
        Background := ADayItem.Controls[I];
        Background.Parent := nil;
        Background.Free;
      end;
  end;

var
  I: Integer;
  DayItem: TListBoxItem;
begin
  if Days <> nil then
    for I := 0 to Days.Count - 1 do
    begin
      DayItem := Days.ListItems[I];
      RemoveBackground(DayItem);
    end;
end;
initialization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendarWithHolidayDays>);
finalization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendar>);

end.
