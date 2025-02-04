unit PCMAPP.Ical; //V1.11

/////This class imports a iCal calander file into a list of objects

interface

uses
  SysUtils, Variants, Classes;

Type
  riCalItem = Class
  Public
    UID : String;
    DTSTART, DTEND, LASTMODIFIED, DTSTAMP, CREATED :string;
    DTStartd, DtEndd, LASTMODIFIEDd, DTSTAMPd, CREATEDd : TDateTime;
    SUMMARY, aCLASS, DESCRIPTION : String;
    Rule, ORGANIZER, LOCATION, SEQUENCE, STATUS, TRANSP : String;
    TZOFFSETFROM, TZOFFSETTO, TZNAME : String;
    //Temp Vars
    aFontID : Integer;
    aColor :String;
//    constructor create;
//    destructor Destroy;
End;

  TiCalPackage = Class
  Private
    aChanged : Boolean;
    aList : TStringList;
    aMemo : TStringList;
    //aMemo : TMemo;
    iCalEventsFound : Integer;
    DateFrmat : TFormatSettings;
    function getModified: Boolean;
    procedure setModified(const Value: Boolean);
    Procedure MatStringDelete(Var StrLine:String;SubtractStr:String);
    function getiCalList: TStringList;
    Function convertDate(iCalDate:String):TDateTime;
    Procedure MatStringDelete2End(Var StrLine:String;SubtractStr:String);
    Procedure MatStringDeleteUp2(Var StrLine:String;SubtractStr:String);
    procedure readMemo;
//    Function CheckExistingCommand(s:String):Boolean;
  Public
    Property modified:Boolean read getModified write setModified;
    Property CountStarts:Integer read iCalEventsFound;
    Property iCalList:TStringList read getiCalList;
    procedure saveMemo(strList:TStringList;DstFile:String);
    constructor Create(Filename:string); Overload;
    constructor Create(stringlist:TStringList;i:integer=1); Overload;
    destructor Destroy; override;
end;

implementation

uses Math;

{ TiCalPackage }

constructor TiCalPackage.Create(Filename: string);
var
  Reader: TStreamReader;
begin
  Reader:= NIL;
  If FileExists(Filename) then Begin
 //Set Date Time Formatting
  Reader := TStreamReader.Create(Filename);
  iCalEventsFound := 0;
  DateFrmat.DateSeparator := '\';
  DateFrmat.ShortDateFormat := 'yyyy\MM\dd';
  DateFrmat.LongDateFormat := 'dd\MMMM\yyy';
  DateFrmat.TimeSeparator := '-';
  DateFrmat.ShortTimeFormat := 'hh-mm-ss';
  DateFrmat.LongTimeFormat := 'hh-mm-ss';
    //aMemo := TMemo.Create(nil);
    aMemo := TStringList.Create;
    //aMemo.Parent := Parent;
    //aMemo.Visible := False;
    //aMemo.Width := 1000;
    //aMemo.WordWrap := False; HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


//    aMemo.LoadFromFile(Filename);
    while not Reader.EndOfStream do
      aMemo.Add(Reader.ReadLine);
    aList := TStringList.Create;
    readMemo;
  end
  Else
  Reader.Free;
end;
function TiCalPackage.convertDate(iCalDate:String): TDateTime;
Var
  s,t : String;
  aDate : TDateTime;
begin
 //Convert the date
  s := iCalDate;
  MatStringDelete2End(s,'T');
  insert('\',s,5);
  insert('\',s,8);
 //Convert the Time
  t := iCalDate;
  if pos(t,'T') <> 0 then Begin
    MatStringDeleteUp2(t,'T');
    insert('-',t,3);
    insert('-',t,6);
  end
  Else
    t := '';
  if t <> '' then
    aDate := StrToDate(s,DateFrmat) + StrToTime(t,DateFrmat)
  else
    aDate := StrToDate(s,DateFrmat) + Time;
  Result := aDate;
end;
constructor TiCalPackage.Create(stringlist:TStringList; i:integer=1);
begin
  If stringlist  <> nil then Begin
 //Set Date Time Formatting
    iCalEventsFound := 0;
    DateFrmat.DateSeparator := '\';
    DateFrmat.ShortDateFormat := 'yyyy\MM\dd';
    DateFrmat.LongDateFormat := 'yyyy\MM\dd';
    DateFrmat.TimeSeparator := '-';
    DateFrmat.ShortTimeFormat := 'hh-mm-ss tt';
    DateFrmat.LongTimeFormat := 'hh-mm-ss tt';
    //aMemo := TMemo.Create(nil);
    aMemo := TStringList.Create;
    {aMemo.Parent := Parent;
    aMemo.Visible := False;
    aMemo.Width := 1000;
    aMemo.WordWrap := False;}
    aMemo := stringlist;;
    aList := TStringList.Create;
    readMemo;
  end
end;
destructor TiCalPackage.Destroy;
begin
  aList.Free;
  inherited;
end;
function TiCalPackage.getiCalList: TStringList;
begin
  result := aList;
end;
function TiCalPackage.getModified: Boolean;
begin
  Result := aChanged;
end;
procedure TiCalPackage.MatStringDelete(var StrLine: String; SubtractStr: String);
begin
  If Pos(SubtractStr,StrLine) <> 0 then
   Begin
    Delete(StrLine,1,length(SubtractStr));
   End;
end;
procedure TiCalPackage.MatStringDelete2End(var StrLine: String; SubtractStr: String);
begin
  If Pos(SubtractStr,StrLine) <> 0 then
   Begin
    Delete(StrLine,Pos(SubtractStr,StrLine),5000);
   End;
end;
procedure TiCalPackage.MatStringDeleteUp2(var StrLine: String; SubtractStr: String);
begin
  If Pos(SubtractStr,StrLine) <> 0 then
   Begin
    Delete(StrLine,1,Pos(SubtractStr,StrLine));
   End;
end;
procedure TiCalPackage.readMemo;
Var
  i,z, NextLine : Integer;
  s, s1, s2 : String;
  CanAdd : Boolean;
  aData : riCalItem;
//  dStartTime, dEndTime : TTime;
//  dEndDate, dStartDate : TDate;
//  sStartDate,sEndDate, sStartTime, sEndTime : String;
//  n : Pchar;
begin
  aData:= Nil;
  CanAdd := False;
  i := -1;
  While i < aMemo.Count  do Begin
    inc(i);
    NextLine := i +1;
    s := aMemo.Strings[i];
    for z := 1 to Length(s) do
    begin
      s2 := Copy(s,1,1);
      if s2 = ' ' then
        s := Copy(s, 2, Length(s))
    end;
    s1 := s;


    if pos('BEGIN:VEVENT',s)> 0 then begin
      inc(iCalEventsFound);
      CanAdd := true;
      aData := riCalItem.create;
      aList.AddObject(IntToStr(i),aData);
    end
      else
    if pos('END:VEVENT',s)> 0 then begin
      CanAdd := False;
      If aData.DtEndd < aData.DTStartd then
        aData.DtEndd := aData.DTStartd + 0.0002;
    end;
    if CanAdd = true then begin
      If pos('DTSTART',s) > 0 then begin
          MatStringDeleteUp2(s1,':');
          aData.DTStartd := convertDate(s1);
          aData.DTSTART := s1;
        end
        Else
        If pos('DTSTART;VALUE=DATE:',s) > 0 then begin
          MatStringDelete(s1,'DTSTART;VALUE=DATE:');
          aData.DTStartd := convertDate(s1);
          aData.DTSTART := s1;
          aData.DtEndd := convertDate(s1);
          aData.DTEND := s1;
        end
        else
        If pos('DTEND;VALUE=DATE:',s) > 0 then begin
          MatStringDelete(s1,'DTEND;VALUE=DATE:');
          aData.DtEndd := convertDate(s1);
          aData.DTEND := s1;
        end
        else
        If pos('DTEND',s) > 0 then begin
          MatStringDeleteUp2(s1,':');
          //MatStringDelete(s1,':');
          aData.DtEndd := convertDate(s1);
          aData.DTEND := s1;
        end
        Else
        If pos('SUMMARY:',s) > 0 then begin
          MatStringDelete(s1,'SUMMARY:');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.SUMMARY := s1;
          s1 := aMemo.Strings[NextLine];
//          while CheckExistingCommand(s1) = false do Begin
//            aData.SUMMARY := aData.SUMMARY + #10+#13 + s1;
//            Inc(NextLine);
//            s1 := aMemo.Strings[NextLine];
//          End;
//          NextLine := i +1;
        end
        Else
        If pos('SUMMARY',s) > 0 then begin
          MatStringDelete(s1,'SUMMARY');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.SUMMARY := s1;
          s1 := aMemo.Strings[NextLine];
//          while CheckExistingCommand(s1) = false do Begin
//            aData.SUMMARY := aData.SUMMARY + #10+#13 + s1;
//            Inc(NextLine);
//            s1 := aMemo.Strings[NextLine];
//          End;
//          NextLine := i +1;
        end
        else
        If pos('CLASS:',s) > 0 then begin
          MatStringDelete(s1,'CLASS:');
          aData.aCLASS := s1;
        end
        Else
        If pos('DESCRIPTION:',s) > 0 then begin
//          n:= '\n';
          MatStringDelete(s1,'DESCRIPTION:');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.DESCRIPTION :=  s1;
          s1 := aMemo.Strings[NextLine];
        end
        Else
         If pos('DESCRIPTION',s) > 0 then begin
//          n:= '\n';
          MatStringDelete(s1,'DESCRIPTION');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.DESCRIPTION :=  s1;
          s1 := aMemo.Strings[NextLine];
        end
        Else
        If pos('TRANSP:',s) > 0 then
        begin
        end
        ElsE
        If pos('LAST-MODIFIED:',s) > 0 then begin
          MatStringDelete(s1,'LAST-MODIFIED:');
          aData.LASTMODIFIEDd := convertDate(s1);
          aData.LASTMODIFIED := s1;
        end
        Else
        If pos('UID:',s) > 0 then begin
          MatStringDelete(s1,'UID:');
          aData.UID := s1;
        end
        Else
        If pos('RRULE:',s) > 0 then begin
          MatStringDelete(s1,'RRULE:');
          aData.Rule := s1;
        end
        Else
        If pos('DTSTAMP:',s) > 0 then begin
          MatStringDelete(s1,'DTSTAMP:');
          aData.DTSTAMPd := convertDate(s1);
          aData.DTSTAMP := s1;
        end
        Else
        If pos('ORGANIZER;',s) > 0 then begin
          MatStringDelete(s1,'ORGANIZER;');
          aData.ORGANIZER := s1;
        end
        Else
        If pos('CREATED:',s) > 0 then begin
          MatStringDelete(s1,'CREATED:');
          aData.CREATEDd := convertDate(s1);
          aData.CREATED := s1;
        end
        Else
        If pos('LOCATION:',s) > 0 then begin
          MatStringDelete(s1,'LOCATION:');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.LOCATION := s1;
          s1 := aMemo.Strings[NextLine];
//          while CheckExistingCommand(s1) = false do Begin
//            aData.LOCATION := aData.LOCATION + #10+#13 + s1;
//            Inc(NextLine);
//            s1 := aMemo.Strings[NextLine];
//          End;
//          NextLine := i +1;
        end
        Else
        If pos('LOCATION',s) > 0 then begin
          MatStringDelete(s1,'LOCATION');
          MatStringDelete(s1,';LANGUAGE=de-DE:');
          aData.LOCATION := s1;
          s1 := aMemo.Strings[NextLine];
//          while CheckExistingCommand(s1) = false do Begin
//            aData.LOCATION := aData.LOCATION + #10+#13 + s1;
//            Inc(NextLine);
//            s1 := aMemo.Strings[NextLine];
//          End;
//          NextLine := i +1;
        end
        Else
        If pos('SEQUENCE:',s) > 0 then begin
          MatStringDelete(s1,'SEQUENCE:');
          aData.SEQUENCE := s1;
        end
        Else
        If pos('STATUS:',s) > 0 then begin
          MatStringDelete(s1,'STATUS:');
          aData.STATUS := s1;
        end
        Else
        If pos('TRANSP:',s) > 0 then begin
          MatStringDelete(s1,'TRANSP:');
          aData.TRANSP := s1;
        end
        Else
        If pos('TZOFFSETFROM:',s) > 0 then begin
          MatStringDelete(s1,'TZOFFSETFROM:');
          aData.TZOFFSETFROM := s1;
        end
        Else
        If pos('TZOFFSETTO:',s) > 0 then begin
          MatStringDelete(s1,'TZOFFSETTO:');
          aData.TZOFFSETTO := s1;
        end
        Else
        If pos('TZNAME:',s) > 0 then begin
          MatStringDelete(s1,'TZNAME:');
          aData.TZNAME := s1;
        end
         ;
    end;

   If pos('END:VCALENDAR',s) > 0 then
     i := aMemo.Count +1;
  end;
end;
procedure TiCalPackage.saveMemo(strList:TStringList;DstFile:String);
Var
 i : Integer;
 aItem : riCalItem;
begin
  aItem:= NIL;
  Try
    aItem := riCalItem.create;
    aMemo.Clear;
    aMemo.Add('BEGIN:VCALENDAR');
    aMemo.Add('CALSCALE:GREGORIAN');
    aMemo.Add('VERSION:2.0');
    for i := 0 to strList.Count -1 do Begin
      aItem := strList.Objects[i] as riCalItem;
      aMemo.Add('BEGIN:VEVENT');
      //Today := FormatDateTime('hh:mm:ss AM/PM',RTime);
      aMemo.Add('DTSTART:'+ FormatDateTime('yyyyMMdd'+'T'+'HHmmss',aItem.DTStartd));
      aMemo.Add('DTEND:'+ FormatDateTime('yyyyMMdd'+'T'+'HHmmss',aItem.DtEndd));
      aMemo.Add('SUMMARY:'+aItem.SUMMARY);
      aMemo.Add('CLASS:'+aItem.aCLASS);
      aMemo.Add('DESCRIPTION:'+aItem.DESCRIPTION);
      aMemo.Add('LAST-MODIFIED:');
      aMemo.Add('UID:'+aItem.UID);
      aMemo.Add('END:VEVENT');
    end;
    aMemo.Add('END:VCALENDAR');
    aMemo.SaveToFile(DstFile);
    Finally
      aItem.Free;
    end;
end;
procedure TiCalPackage.setModified(const Value: Boolean);
begin
  aChanged := Value;
end;

end.
