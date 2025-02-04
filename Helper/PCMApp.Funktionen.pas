unit PCMAPP.Funktionen;

interface

uses
  {$Region Uses}
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.app,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  FMX.Helpers.Android,
  {$ENDIF ANDROID}
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  Data.DB,
  Data.DBXCommon,
  Data.DBXDataSnap,
  Data.DbxHTTPLayer,
  Data.FMTBcd,
  Data.SqlExpr,
  DBXCompressionFilter,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Pool,
  FireDAC.UI.Intf,
  FMX.Graphics,
  FMX.Platform,
  Rest.Types,
  Soap.EncdDecd,
  System.Classes,
  System.DateUtils,
  System.Devices,
  System.IOUtils,
  System.JSON,
  System.Math,
  System.Net.HttpClientComponent,
  System.NetEncoding,
  System.Net.HttpClient,
  System.SysUtils,
  System.Types,
  System.UITypes,
  PCMAPP.Datamodul,
  PCMAPP.SQL,
  PCMAPP.WaitForm;
  {$EndRegion Uses}
// Deklarationen Functions
{$Region Functions}
// Restfunctions
function CheckLogin: Boolean;
function CheckServerConnection: Boolean;
// Helperfunctions
function AddZeros(AValue: String; ACount: integer): string;
function BitmapFromBase64(const base64: string): TBitmap;
function CheckReccurence(AID: Integer; AStart, ADate: TDateTime; AWiederholung: string) :TDateTime;
function CreateRoundPhoto(const ASource: TBitmap): TBitmap;
function FormatDateTimeToStr(ADate: TDateTime): String ;
function GetBuchungsart(ATyp: integer; AVon,ABis: TDate) : integer;
function GetCountFromTableAuto_Login: integer;
function GetCountFromTableLogin: integer;
function GetCountFromTableServer: integer;
function GetDeviceType: string;
function GetFehltagSum(AFeiertag, ATyp, ABezahlt: integer;AVon,ABis:TDate) : double;
function GetFeiertage(AVon,ABis: TDate) : double;
function GetTimeValue(AValue: integer) : String;
function GetWeekDay(ADateTime: TDateTime) : String;
{$EndRegion Functions}
// Deklarationen Procedures
{$Region Procedures}
procedure BerechneMonat(AMonat,AJahr: integer);
procedure BerechneTage(ATag,AMonat,AJahr: integer);
procedure ClearAllTablesByID(AID: Integer; AColumnName: String);
procedure CreateDatabase;
procedure CreateDatabasePCMAPP;
procedure DeleteAllTables;
procedure WriteLog(AMessage: String; ATyp: Integer; ANewFile: boolean);
procedure UpdateFieldValues_String(AField, ATable, AValue: String; AID:Integer);Overload;
procedure UpdateFieldValues_Ansistring(AField, ATable: String; AValue: Ansistring; AID:Integer);Overload
procedure UpdateFieldValues_TDateTime(AField, ATable: String; AValue: TDateTime; AID:Integer);Overload
procedure UpdateFieldValues_TDate(AField, ATable: String; AValue: TDate; AID:Integer);Overload
procedure UpdateFieldValues_Boolean(AField, ATable: String; AValue: Boolean; AID:Integer);Overload
procedure UpdateFieldValues_Integer(AField, ATable: String; AValue: Integer; AID:Integer);Overload
procedure UpdateFieldValues_Float(AField, ATable: String; AValue: Double; AID:Integer);Overload
procedure SaveLogin(AUsername, APassword: String; AUserID, AServerID: Integer;AFirstStart: Boolean);
procedure SyncConfig_toServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncKontakte_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncPasswort_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncFinanzenEin_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncFinanzenAus_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncBelege_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncGutscheine_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
procedure SyncKontakte_FromServer(AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncKalender_FromServer(const AUserID:Integer; AWaitFrame: TWaitForm);
procedure SyncPasswort_FromServer(const AUserID:Integer; AWaitFrame: TWaitForm);
procedure SyncSerials_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncFinanzenEin_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncFinanzenAus_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncBelege_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure SyncGutscheine_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
procedure Synchronisation(const AUserID, AServerID: Integer; AWaitFrame: TWaitForm; bALL: Boolean);
{$EndRegion Procedures}
var
  {$Region uses}
  joResponseJSON: TJSONObject;
  joResponseJSONData: TJSONObject;
  JSONResult: TJSONObject;
  jaDetails: TJSonArray;
  icode: integer;
  sMessage: String;
  bHasError: boolean;
  {$EndRegion uses}
implementation
// Functions
{$Region Functions}
// Restfunction
function CheckLogin: Boolean;
begin
  Result:= False;
  JSONResult := dmmain.RestRequest(nil,'Checklogin',rmGET) as TJSONObject;
  bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
  if not bHasError then
  begin
    jaDetails :=  JSONResult.GetValue<TJSONArray>('Login');
    for var JSonValue in jaDetails do
    begin
      JSonValue.TryGetValue<boolean>('Allowed',Result);
      JSonValue.TryGetValue<Integer>('ID_User',dmmain.iUserID);
    end;
  end;
end;
function CheckServerConnection: Boolean;
begin
  Result:= False;
  JSONResult := dmmain.RestRequest(nil,'CheckServer',rmGET) as TJSONObject;
  bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
  if not bHasError then
  begin
    Result:= True;
  end;
end;
// Helperfunctions
function AddZeros(AValue: String; ACount: integer): string;
begin
  if Length(AValue) > Acount then
  begin
    // die letzten count Stellen kopieren
    AValue := Copy(AValue, Length(AValue) - Acount + 1, Acount);
  end
  else begin
    // '0'-en hinzufügen
    while Length(AValue) < Acount do
      AValue := '0' + AValue;
  end;
  result:= AValue;
end;
function BitmapFromBase64(const base64: string): TBitmap;
var
  strmInput: TStringStream;
  strmOutput: TBytesStream;
begin
  strmInput := TStringStream.Create(base64, TEncoding.ASCII);
  try
    strmOutput := TBytesStream.Create;
    try
      Soap.EncdDecd.DecodeStream(strmInput, strmOutput);
      strmOutput.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(strmOutput);
      except
        raise;
      end;
    finally
      FreeAndNil(strmOutput);
    end;
  finally
    FreeAndNil(strmInput);
  end;
end;
function CheckReccurence(AID: Integer; AStart, ADate: TDateTime; AWiederholung: string) :TDateTime;
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
//  wJahr,wMonat,wTag,wStunde,wMinute,wSekunde,wMSek: Word;
begin
  Result:= now();
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
        Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
      end;
    end
    else begin
      Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
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
            Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
        end
        else
        begin
          Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
        end;
      end;
    end
    else begin
      Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
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
    Result:= StrToDateTime(DateToStr(ADate) + ' ' + Copy(DateTimetoStr(AStart),11,Length(DateTimetoStr(AStart))));
end;
function CreateRoundPhoto(const ASource: TBitmap): TBitmap;
var
  iSize: Integer;
begin
  Result := TBitmap.Create;
  iSize := Min(ASource.Height, ASource.Width);
  Result.SetSize(iSize, iSize);
  Result.Clear(TAlphaColorRec.Null);
  if Result.Canvas.BeginScene then
  begin
    try
      Result.Canvas.Fill.Bitmap.Bitmap.Assign(ASource);
      Result.Canvas.Fill.Kind := TBrushKind.Bitmap;
      Result.Canvas.FillEllipse(TRectF.Create(0, 0, iSize, iSize), 1);
    finally
      Result.Canvas.EndScene;
    end;
  end;
end;
function FormatDateTimeToStr(ADate: TDateTime): String ;
var
  wJahr: word;
  wMonat: word;
  wTag: word;
  wStunde: word;
  wMinute: word;
  wSekunde: word;
  wMSek: word;
begin
  Result := '';
  DecodeDateTime(ADate,wJahr,wMonat,wTag,wStunde,wMinute,wSekunde,wMSek);
  if (wStunde = 0) and (wMinute = 0) and (wSekunde = 0)  then
    Result:=  AddZeros(IntToStr(wTag), 2) + '.' + AddZeros(IntToStr(wMonat), 2) + '.' +IntToStr(wJahr)
  else
    Result:= AddZeros(IntToStr(wTag), 2) + '.' + AddZeros(IntToStr(wMonat), 2) + '.' +IntToStr(wJahr) + ' ' +
             AddZeros(IntToStr(wStunde), 2) + ':' + AddZeros(IntToStr(wMinute), 2) +':' + AddZeros(IntToStr(wSekunde), 2)+ '.000';
end;
function GetBuchungsart(ATyp: integer; AVon,ABis: TDate) : integer;
var
  qry_BA: TFDQuery;
begin
  qry_BA:= TFDQuery.Create(nil);
  qry_BA.Connection:= dmmain.con_PCM;

  qry_BA.SQL.Text:=  'SELECT Count(*) as Anzahl ' +
                              'FROM buchungen zeb ' +
                              'LEFT OUTER JOIN Fehltag zeft ON zeft.Kuerzel = zeb.Fehltag ' +
                              'WHERE Kommen <> ''00:00'' and  zeb.Datum >= :Von and zeb.Datum <= :Bis AND Buchungsart = :Typ';
  qry_BA.ParamByName('Von').asDate:= AVon;
  qry_BA.ParamByName('Bis').asDate:= ABis;
  qry_BA.ParamByName('Typ').asInteger:= ATyp;
  qry_BA.open;
  Result:= qry_BA.FieldByName('Anzahl').AsInteger;
  qry_BA.close;
  FreeAndNil(qry_BA);
end;
function GetCountFromTableAuto_Login: integer;
var
  qry_Work: TFDQuery;
begin
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SELECT_COUNT_AUTOLOGIN;
  qry_Work.open;
  Result:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  Freeandnil(qry_Work);
end;
function GetCountFromTableLogin: integer;
var
  qry_Work: TFDQuery;
begin
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SELECT_COUNT_LOGIN;
  qry_Work.open;
  Result:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  Freeandnil(qry_Work);
end;
function GetCountFromTableServer: integer;
var
  qry_Work: TFDQuery;
begin
  qry_Work:= TFDQuery.Create(nil);
  qry_Work.Connection:= dmmain.con_PCM;
  qry_Work.SQL.Text:= sSQL_SELECT_COUNT_Server;
  qry_Work.open;
  Result:= qry_Work.FieldByName('Anzahl').AsInteger;
  qry_Work.Close;
  Freeandnil(qry_Work);
end;
function GetDeviceType: string;
var
  DeviceService: IFMXDeviceService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXDeviceService, IInterface(DeviceService)) then
  begin
    case DeviceService.GetDeviceClass of
      TDeviceInfo.TDeviceClass.Phone: Result := 'Phone';
      TDeviceInfo.TDeviceClass.Tablet: Result := 'Tablet';
      TDeviceInfo.TDeviceClass.Desktop: Result := 'Desktop';
      TDeviceInfo.TDeviceClass.Unknown: Result := 'unbekanntes Gerät';
    else
      Result := 'unbekanntes Gerät';
    end;
  end
  else
    Result := 'Dieses Gerät wird nicht unterstützt';
end;
function GetFehltagSum(AFeiertag, ATyp, ABezahlt: integer;AVon,ABis:TDate) : double;
var
  qry_FT: TFDQuery;
begin
  qry_FT:= TFDQuery.Create(nil);
  qry_FT.Connection:= dmmain.con_PCM;
  qry_FT.SQL.Text:=  'SELECT IFNULL(SUM((Zeb.SollstundenI / zeft.faktor)),0) as Anzahl ' +
                     'FROM buchungen zeb ' +
                     'LEFT OUTER JOIN Fehltag zeft ON zeft.Kuerzel = zeb.Fehltag ' +
                     'WHERE  zeb.Feiertag <> :Feiertag AND zeb.Sollstunden = :Zeit and zeb.Datum >= :Von and zeb.Datum <= :Bis AND zeft.Typ = :Typ AND zeft.Bezahlt = :Bezahlt';
  qry_FT.ParamByName('Zeit').AsTime:= StrToTime('08:00');
  qry_FT.ParamByName('Von').asDate:= AVon;
  qry_FT.ParamByName('Bis').asDate:= ABis;
  qry_FT.ParamByName('Feiertag').AsInteger:= AFeiertag;
  qry_FT.ParamByName('Typ').AsInteger:= ATyp;
  qry_FT.ParamByName('Bezahlt').AsInteger:= ABezahlt;
  qry_FT.open;
  result:= qry_FT.FieldByName('Anzahl').AsFloat / 480;
  qry_FT.close;
  Freeandnil(qry_FT);
end;
function GetFeiertage(AVon,ABis: TDate) : double;
var
  qry_FT: TFDQuery;
begin
  qry_FT:= TFDQuery.Create(nil);
  qry_FT.Connection:= dmmain.con_PCM;
  qry_FT.SQL.Text:= 'SELECT IFNULL(Sum(if(Feiertag = 2, 0.5,1)),0) AS Anzahl ' +
                    'FROM buchungen zeb ' +
                    'WHERE zeb.Sollstunden = :Zeit and zeb.Datum >= :Von and zeb.Datum <= :Bis AND zeb.feiertag > 0';
  qry_FT.ParamByName('Zeit').AsTime:= StrToTime('08:00');
  qry_FT.ParamByName('Von').asDate:= AVon;
  qry_FT.ParamByName('Bis').asDate:= ABis;
  qry_FT.open;
  Result:= qry_FT.FieldByName('Anzahl').AsFloat;
  qry_FT.close;
  Freeandnil(qry_FT);
end;
function GetTimeValue(AValue: integer) : String;
var
  iHour,iMin: integer;
  sHour,sMin: String;
begin
  iHour:= AValue div 60;
  iMin:= AValue mod 60;
  sHour:= IntToStr(iHour);
  if iMin < 10 then
    sMin:= '0' + IntToStr(iMin)
  else
    sMin:= IntToStr(iMin);
  if Length(sHour) = 1 then
    sHour:= '0' + sHour;
  result:= sHour + ':' + sMin
end;
function GetWeekDay(ADateTime: TDateTime) : String;
begin
  case DayOfWeek(ADateTime) of
    1: Result:= 'So.';
    2: Result:= 'Mo.';
    3: Result:= 'Di.';
    4: Result:= 'Mi.';
    5: Result:= 'Do.';
    6: Result:= 'Fr.';
    7: Result:= 'Sa.';
  end;
end;
{$EndRegion Functions}
// procedures
{$Region procedures}
// Updatefunktionen
{$Region Helperfunctions}
procedure UpdateFieldValues_String(AField, ATable, AValue: String; AID:Integer);Overload;
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsString:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_Ansistring(AField, ATable: String; AValue: Ansistring; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').asMemo:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_TDateTime(AField, ATable: String; AValue: TDateTime; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsDateTime:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_TDate(AField, ATable: String; AValue: TDate; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsDate:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_Boolean(AField, ATable: String; AValue: Boolean; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsBoolean:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_Integer(AField, ATable: String; AValue: Integer; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsInteger:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
procedure UpdateFieldValues_Float(AField, ATable: String; AValue: Double; AID:Integer);Overload
var
  qry_Update: TFDQuery;
begin
  qry_Update:= TFDQuery.Create(nil);
  qry_Update.Connection:= dmmain.con_PCM;
  qry_Update.SQL.Text:= 'Update ' + ATable + ' Set ' + AField + '=:AValue Where ID = :ID';
  qry_Update.ParamByName('Avalue').AsFloat:= AValue;
  qry_Update.ParamByName('ID').AsInteger:= AID;
  qry_Update.ExecSQL;
  FreeAndNil(qry_Update);
end;
{$EndRegion Helperfunctions}
// SaveFunctions
{$Region SaveFunctions}
procedure SaveLogin(AUsername, APassword: String; AUserID, AServerID: Integer;AFirstStart: Boolean);
var
  iCount: integer;
  qry_Sync: TFDQuery;
begin
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  qry_Sync.SQL.Text:= sSQL_SEL_COUNT_login;
  qry_Sync.Open;
  iCount:= qry_Sync.FieldByName('Anzahl').AsInteger;
  qry_Sync.Close;
  if (AFirstStart) and (iCount = 0)  then
  begin
    qry_Sync.SQL.Text := sSQL_INS_All_login;
    qry_Sync.ParamByName('ID_Benutzer').AsInteger := AUserID;
    qry_Sync.ParamByName('Benutzername').AsString := AUsername;
    qry_Sync.ParamByName('Passwort').AsString := APassword;
    qry_Sync.ParamByName('FirstStart').AsBoolean := True;
    qry_Sync.ParamByName('ID_Server').AsInteger := AServerID;
    qry_Sync.ExecSQL;
  end else
  begin
    qry_Sync.SQL.Text := sSQL_UPD_ALL_login;
    qry_Sync.ParamByName('ID_Benutzer').AsInteger := AUSerID;
    qry_Sync.ParamByName('Benutzername').AsString := AUsername;
    qry_Sync.ParamByName('Passwort').AsString := APassword;
    qry_Sync.ParamByName('FirstStart').AsBoolean := False;
    qry_Sync.ParamByName('ID_Server').AsInteger := AServerID;
    qry_Sync.ExecSQL;
  end;
  FreeandNil(qry_Sync);
end;
{$EndRegion SaveFunctions}
// Synch from App to Server
{$Region ApptoServer}
procedure SyncConfig_ToServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_SyncConfig_ToServer: TFDQuery;
begin
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_SyncConfig_ToServer:= TFDQuery.Create(nil);
  qry_SyncConfig_ToServer.Connection:= dmmain.con_PCM;
  qry_SyncConfig_ToServer.FetchOptions.Mode:= fmall;
  qry_SyncConfig_ToServer.FetchOptions.RecordCountMode:= cmtotal;
  qry_SyncConfig_ToServer.SQL.Text:= 'SELECT DeviceID, DeviceToken FROM Auto_login';
  qry_SyncConfig_ToServer.open;
  if qry_SyncConfig_ToServer.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_SyncConfig_ToServer.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Benutzer', TJSONNumber.Create(AUSerID)));
      joResponseJSONData.AddPair(TJSONPair.Create('DeviceToken', TJSONString.Create(qry_SyncConfig_ToServer.FieldByName('DeviceToken').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('DeviceID', TJSONString.Create(qry_SyncConfig_ToServer.FieldByName('DeviceID').asString)));
      {$IFDEF ANDROID}
      joResponseJSONData.AddPair(TJSONPair.Create('DeviceType', TJSONNumber.Create(0)));
      {$ENDIF ANDROID}
      {$IFDEF IOS}
      joResponseJSONData.AddPair(TJSONPair.Create('DeviceType', TJSONNumber.Create(1)));
      {$ENDIF IOS}

      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_SyncConfig_ToServer.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Device', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetDeviceID', rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_SyncConfig_ToServer.Close;
  FreeandNil(qry_SyncConfig_ToServer);
end;
procedure SyncKontakte_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_SyncKontakte_ToServer: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Kontakte werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;

  qry_SyncKontakte_ToServer:= TFDQuery.Create(nil);
  qry_SyncKontakte_ToServer.Connection:= dmmain.con_PCM;
  qry_SyncKontakte_ToServer.FetchOptions.Mode:= fmall;
  qry_SyncKontakte_ToServer.FetchOptions.RecordCountMode:= cmtotal;
  qry_SyncKontakte_ToServer.SQL.Text:= 'SELECT ID, Anrede,Vorname, Nachname, Strasse, PLZ,ort,Telefon, Handy, Email, Geburtsdatum, Geschlecht, Familienstand, Staatsangehoerigkeit, ' +                               'KOnfession, Firma, StrasseFirma, PLZFirma,OrtFirma,TelefonFirma, HandyFirma, Emailfirma, IFNULL(Kontakte_ID,0) AS ID_Kontakt, ID as Bild,  Deleted ' +
                      'FROM Kontakte';
  if not bAll then
      qry_SyncKontakte_ToServer.SQL.Text:= qry_SyncKontakte_ToServer.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_SyncKontakte_ToServer.open;
  if qry_SyncKontakte_ToServer.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_SyncKontakte_ToServer.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_SyncKontakte_ToServer.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Salutation', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Anrede').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Name', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Vorname').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Surname', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Nachname').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Street_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Strasse').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Postalcode_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('PLZ').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Place_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Ort').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Phone_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Telefon').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Mobile_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Handy').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Mail_private', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Email').asString)));
      if qry_SyncKontakte_ToServer.Fieldbyname('Geburtsdatum').asString = '' then
        joResponseJSONData.AddPair(TJSONPair.Create('Birthday', TJSONString.Create(DateToStr(StrToDate('30.12.1899')))))
      else
        joResponseJSONData.AddPair(TJSONPair.Create('Birthday', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Geburtsdatum').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Gender', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Geschlecht').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Maritalstatus', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Familienstand').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Nationality', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Staatsangehoerigkeit').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Denomination', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('KOnfession').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Company', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Firma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Street_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('StrasseFirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Postalcode_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('PLZFirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Place_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('OrtFirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Phone_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('TelefonFirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Mobile_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('HandyFirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Mail_business', TJSONString.Create(qry_SyncKontakte_ToServer.Fieldbyname('Emailfirma').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Contact',TJSONNumber.Create(qry_SyncKontakte_ToServer.Fieldbyname('ID_Kontakt').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_SyncKontakte_ToServer.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_SyncKontakte_ToServer.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Contacts', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetContacts?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_SyncKontakte_ToServer.Close;
  qry_SyncKontakte_ToServer.SQL.Text:= 'UPDATE Kontakte SET Geaendertam = null';
  qry_SyncKontakte_ToServer.ExecSQL;
  qry_SyncKontakte_ToServer.SQL.Text:= 'Delete FROM Kontakte WHERE DELETED = true';
  qry_SyncKontakte_ToServer.ExecSQL;
  FreeAndNil(qry_SyncKontakte_ToServer);
end;
procedure SyncKalender_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_SyncKalender_ToServer: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Kalender werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_SyncKalender_ToServer:= TFDQuery.Create(nil);
  qry_SyncKalender_ToServer.Connection:= dmmain.con_PCM;
  qry_SyncKalender_ToServer.FetchOptions.Mode:= fmall;
  qry_SyncKalender_ToServer.FetchOptions.RecordCountMode:= cmtotal;
  qry_SyncKalender_ToServer.SQL.Text:= 'SELECT ID, Caption,EventType,Location,Message as TerminText,Start,Finish,CompleteDay,Reminder,ReminderDate,ifnull(ReminderMinutesBeforeStart,0) as ReminderMinutesBeforeStart, Kalendername,'+
                      'IFNULL(Kalender_ID,0) AS ID_Kalender, Deleted FROM Kalender ';
  if not bAll then
    qry_SyncKalender_ToServer.SQL.Text:= qry_SyncKalender_ToServer.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_SyncKalender_ToServer.open;
  while not qry_SyncKalender_ToServer.eof do
  begin
    if qry_SyncKalender_ToServer.RecordCount > 0 then
    begin
      if not Assigned(jaDetails) then
        jaDetails := TJSONArray.Create;
      while not qry_SyncKalender_ToServer.eof do
      begin
        if not Assigned(joResponseJSONData) then
          joResponseJSONData := TJSONObject.Create;
        joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_SyncKalender_ToServer.Fieldbyname('ID_Kalender').asInteger)));
        joResponseJSONData.AddPair(TJSONPair.Create('EventType', TJSONNumber.Create(qry_SyncKalender_ToServer.Fieldbyname('EventType').AsInteger)));
        joResponseJSONData.AddPair(TJSONPair.Create('Caption', TJSONString.Create(qry_SyncKalender_ToServer.Fieldbyname('Caption').asString)));
        joResponseJSONData.AddPair(TJSONPair.Create('Location', TJSONString.Create(qry_SyncKalender_ToServer.Fieldbyname('Location').asString)));
        joResponseJSONData.AddPair(TJSONPair.Create('Message', TJSONString.Create(qry_SyncKalender_ToServer.Fieldbyname('TerminText').asString)));
        joResponseJSONData.AddPair(TJSONPair.Create('Start', TJSONString.Create(DateTimeToStr(qry_SyncKalender_ToServer.Fieldbyname('Start').asDateTime))));
        joResponseJSONData.AddPair(TJSONPair.Create('Finish', TJSONString.Create(DateTimeToStr(qry_SyncKalender_ToServer.Fieldbyname('Finish').asDateTime))));
        joResponseJSONData.AddPair(TJSONPair.Create('CompleteDay', TJSONBool.Create(qry_SyncKalender_ToServer.Fieldbyname('CompleteDay').AsBoolean)));
        joResponseJSONData.AddPair(TJSONPair.Create('Reminder', TJSONBool.Create(qry_SyncKalender_ToServer.Fieldbyname('Reminder').AsBoolean)));
        joResponseJSONData.AddPair(TJSONPair.Create('ReminderDate', TJSONString.Create(DateTimeToStr(qry_SyncKalender_ToServer.Fieldbyname('ReminderDate').asDateTime))));
        joResponseJSONData.AddPair(TJSONPair.Create('ReminderBeforeStart', TJSONNumber.Create(qry_SyncKalender_ToServer.Fieldbyname('ReminderMinutesBeforeStart').asInteger)));
        joResponseJSONData.AddPair(TJSONPair.Create('Calendername', TJSONString.Create(qry_SyncKalender_ToServer.Fieldbyname('Kalendername').asString)));
        joResponseJSONData.AddPair(TJSONPair.Create('ID_Calender', TJSONNumber.Create(qry_SyncKalender_ToServer.Fieldbyname('ID').AsInteger)));
        joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_SyncKalender_ToServer.Fieldbyname('Deleted').asBoolean)));
        jaDetails.Add(joResponseJSONData);
        joResponseJSONData:= nil;
        qry_SyncKalender_ToServer.Next;
      end;
      joResponseJSON.AddPair(TJSONPair.Create('Calendar', jaDetails));
      JSONResult := dmmain.RestRequest(joResponseJSON,'SetCalendar?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
      bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
      if bHasError then
        WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
    end;
  end;
  qry_SyncKalender_ToServer.Close;
  qry_SyncKalender_ToServer.SQL.Text:= 'UPDATE Kalender SET Geaendertam = null';
  qry_SyncKalender_ToServer.ExecSQL;
  qry_SyncKalender_ToServer.SQL.Text:= 'Delete FROM Kalender WHERE DELETED = true';
  qry_SyncKalender_ToServer.ExecSQL;
  FreeAndNil(qry_SyncKalender_ToServer);
end;
procedure SyncPasswort_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_SyncPasswort_ToServer: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Passwörter werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_SyncPasswort_ToServer:= TFDQuery.Create(nil);
  qry_SyncPasswort_ToServer.Connection:= dmmain.con_PCM;
  qry_SyncPasswort_ToServer.FetchOptions.Mode:= fmall;
  qry_SyncPasswort_ToServer.FetchOptions.RecordCountMode:= cmtotal;
  qry_SyncPasswort_ToServer.SQL.Text:= 'SELECT ID,PWTYP,Bezeichnung,user,password,link,VPN_SharedSecret,' +
                                       'APP_IP,ifnull(APP_Port,0) as APP_Port ,APP_Verschluesselung,MAIL_Posteingangsserver,ifnull(MAIL_PosteingangsPort,0) as MAIL_PosteingangsPort,' +
                                       'MAIL_PosteingangsVerschluesselung,' +
                                       'MAIL_Postausgangsserver,' +
                                       'ifnull(MAIL_PostausgangsPort,0) as MAIL_PostausgangsPort,' +
                                       'MAIL_PostausgangsVerschluesselung,IFNULL(passwoerter_ID,0) AS ID_Password, Deleted, WLAN FROM Passwoerter';
  if not bAll then
    qry_SyncPasswort_ToServer.SQL.Text:= qry_SyncPasswort_ToServer.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_SyncPasswort_ToServer.open;
  if qry_SyncPasswort_ToServer.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_SyncPasswort_ToServer.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_SyncPasswort_ToServer.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Passwordtype', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('PWTYP').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Passwordname', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('Bezeichnung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('User', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('user').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Password', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('password').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Link', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('link').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('VPN_SharedSecret', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('VPN_SharedSecret').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('APP_IP', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('APP_IP').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('APP_Port', TJSONNumber.Create(qry_SyncPasswort_ToServer.Fieldbyname('APP_Port').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('APP_Encryption', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('APP_Verschluesselung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Incomingmail_Server', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_Posteingangsserver').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Incomingmail_Port', TJSONNumber.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_PosteingangsPort').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Incomingmail_Encryption', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_PosteingangsVerschluesselung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Outgoingmail_Server', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_Postausgangsserver').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Outgoingmail_Port', TJSONNumber.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_PostausgangsPort').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Outgoingmail_Encryption', TJSONString.Create(qry_SyncPasswort_ToServer.Fieldbyname('MAIL_PostausgangsVerschluesselung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Password',TJSONNumber.Create(qry_SyncPasswort_ToServer.Fieldbyname('ID_Password').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_SyncPasswort_ToServer.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_SyncPasswort_ToServer.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Passwords', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetPasswords?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_SyncPasswort_ToServer.Close;
  qry_SyncPasswort_ToServer.SQL.Text:= 'UPDATE Passwoerter SET Geaendertam = null';
  qry_SyncPasswort_ToServer.ExecSQL;
  qry_SyncPasswort_ToServer.SQL.Text:= 'Delete FROM Passwoerter WHERE DELETED = true';
  qry_SyncPasswort_ToServer.ExecSQL;
  FreeAndNil(qry_SyncPasswort_ToServer);
end;
procedure SyncSerials_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_SyncSerials_ToServer: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Serials werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_SyncSerials_ToServer:= TFDQuery.Create(nil);
  qry_SyncSerials_ToServer.Connection:= dmmain.con_PCM;
  qry_SyncSerials_ToServer.FetchOptions.Mode:= fmall;
  qry_SyncSerials_ToServer.FetchOptions.RecordCountMode:= cmtotal;
  qry_SyncSerials_ToServer.SQL.Text:= 'SELECT ID, App,USER,Serial,Bezeichnung, IFNULL(Serials_ID,0) AS ID_Serials, Deleted ' +
                      'FROM Serials';
  if not bAll then
    qry_SyncSerials_ToServer.SQL.Text:= qry_SyncSerials_ToServer.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_SyncSerials_ToServer.open;

  if qry_SyncSerials_ToServer.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_SyncSerials_ToServer.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_SyncSerials_ToServer.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Serialname', TJSONString.Create(qry_SyncSerials_ToServer.Fieldbyname('App').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('User', TJSONString.Create(qry_SyncSerials_ToServer.Fieldbyname('user').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Serialkey', TJSONString.Create(qry_SyncSerials_ToServer.Fieldbyname('Serial').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('SerialType', TJSONString.Create(qry_SyncSerials_ToServer.Fieldbyname('Bezeichnung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Serials',TJSONNumber.Create(qry_SyncSerials_ToServer.Fieldbyname('ID_Serials').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_SyncSerials_ToServer.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_SyncSerials_ToServer.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Serials', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetSerials?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_SyncSerials_ToServer.Close;
  qry_SyncSerials_ToServer.SQL.Text:= 'UPDATE Serials SET Geaendertam = null';
  qry_SyncSerials_ToServer.ExecSQL;
  qry_SyncSerials_ToServer.SQL.Text:= 'Delete FROM Serials WHERE DELETED = true';
  qry_SyncSerials_ToServer.ExecSQL;
  FreeAndNil(qry_SyncSerials_ToServer);
end;
procedure SyncFinanzenEin_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Einnahmen werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  qry_Sync.FetchOptions.Mode:= fmall;
  qry_Sync.FetchOptions.RecordCountMode:= cmtotal;
  qry_Sync.SQL.Text:= 'SELECT ID, Quelle,Betrag, Bezeichnung, IFNULL(Finanzen_Einnahmen_ID,0) AS ID_Einnahmen, Deleted, FixBetrag ' +
                             'FROM FinanzenEinnahmen';
  if not bAll then
    qry_Sync.SQL.Text:= qry_Sync.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_Sync.open;
  if qry_Sync.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_Sync.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_Sync.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Transmitter', TJSONString.Create(qry_Sync.Fieldbyname('Quelle').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Amount', TJSONNumber.Create(qry_Sync.Fieldbyname('Betrag').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('Description', TJSONString.Create(qry_Sync.Fieldbyname('Bezeichnung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Fixedamount', TJSONNumber.Create(qry_Sync.Fieldbyname('FixBetrag').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Receipts',TJSONNumber.Create(qry_Sync.Fieldbyname('ID_Einnahmen').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_Sync.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_Sync.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Receipts', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetReceipts?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_Sync.Close;
  qry_Sync.SQL.Text:= 'UPDATE FinanzenEinnahmen SET Geaendertam = null';
  qry_Sync.ExecSQL;
  qry_Sync.SQL.Text:= 'Delete FROM FinanzenEinnahmen WHERE DELETED = true';
  qry_Sync.ExecSQL;
  FreeAndNil(qry_Sync);
end;
procedure SyncFinanzenAus_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Ausgaben werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  qry_Sync.FetchOptions.Mode:= fmall;
  qry_Sync.FetchOptions.RecordCountMode:= cmtotal;
  qry_Sync.SQL.Text:= 'SELECT ID, Name,Beschreibung,Kontonummer,Bankleitzahl,Betrag,Fixkosten,Gueltig_Monat,Gueltig_Jahr,Verwendungszweck, IFNULL(Finanzen_Ausgaben_ID,0) AS ID_Ausgaben, Deleted, FixBetrag ' +
                      'FROM FinanzenAusgaben';
  if not bAll then
    qry_Sync.SQL.Text:= qry_Sync.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_Sync.open;
  if qry_Sync.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
      jaDetails := TJSONArray.Create;
    while not qry_Sync.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_Sync.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Receiver', TJSONString.Create(qry_Sync.Fieldbyname('Name').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Description', TJSONString.Create(qry_Sync.Fieldbyname('Beschreibung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Accountnumber', TJSONString.Create(qry_Sync.Fieldbyname('Kontonummer').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Bankcode', TJSONString.Create(qry_Sync.Fieldbyname('Bankleitzahl').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Amount', TJSONNumber.Create(qry_Sync.Fieldbyname('Betrag').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('Fixedcosts', TJSONBool.Create(qry_Sync.Fieldbyname('Fixkosten').AsBoolean)));
      joResponseJSONData.AddPair(TJSONPair.Create('Validmonth', TJSONNumber.Create(qry_Sync.Fieldbyname('Gueltig_Monat').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Validyear', TJSONNumber.Create(qry_Sync.Fieldbyname('Gueltig_Jahr').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Use', TJSONString.Create(qry_Sync.Fieldbyname('Verwendungszweck').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Fixedamount', TJSONNumber.Create(qry_Sync.Fieldbyname('FixBetrag').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Expenditure',TJSONNumber.Create(qry_Sync.Fieldbyname('ID_Ausgaben').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_Sync.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_Sync.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Expenditure', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetExpenditure?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_Sync.Close;
  qry_Sync.SQL.Text:= 'UPDATE FinanzenAusgaben SET Geaendertam = null';
  qry_Sync.ExecSQL;
  qry_Sync.SQL.Text:= 'Delete FROM FinanzenAusgaben WHERE DELETED = true';
  qry_Sync.ExecSQL;
  FreeAndNil(qry_Sync);
end;
procedure SyncBelege_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Belege werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  qry_Sync.FetchOptions.Mode:= fmall;
  qry_Sync.FetchOptions.RecordCountMode:= cmtotal;
  qry_Sync.SQL.Text:= 'SELECT ID, Nummer,Datum,Aussteller,Betrag,Kategorie,Monat,Jahr,'+
                      'IFNULL(Belege_ID,0) AS ID_Belege, Deleted FROM Belege ';
  if not bAll then
    qry_Sync.SQL.Text:= qry_Sync.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_Sync.open;
  if qry_Sync.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
        jaDetails := TJSONArray.Create;
    while not qry_Sync.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_Sync.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Number', TJSONString.Create(qry_Sync.Fieldbyname('Nummer').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Date', TJSONString.Create(DateToStr(qry_Sync.Fieldbyname('Datum').AsDateTime))));
      joResponseJSONData.AddPair(TJSONPair.Create('Exhibitor', TJSONString.Create(qry_Sync.Fieldbyname('Aussteller').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Amount', TJSONNumber.Create(qry_Sync.Fieldbyname('Betrag').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('Categorie', TJSONNumber.Create(qry_Sync.Fieldbyname('Kategorie').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Month', TJSONNumber.Create(qry_Sync.Fieldbyname('Monat').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Year', TJSONNumber.Create(qry_Sync.Fieldbyname('Jahr').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Vouchers',TJSONNumber.Create(qry_Sync.Fieldbyname('ID_Belege').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_Sync.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_Sync.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Vouchers', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetVouchers?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_Sync.Close;
  qry_Sync.SQL.Text:= 'UPDATE Belege SET Geaendertam = null';
  qry_Sync.ExecSQL;
  qry_Sync.SQL.Text:= 'Delete FROM Belege WHERE DELETED = true';
  qry_Sync.ExecSQL;
  FreeAndNil(qry_Sync);
end;
procedure SyncGutscheine_ToServer(const AUserID: Integer; bAll: boolean; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
begin
  AWaitFrame.SetWaitMessage('Gutscheine werden synchronisiert...', 'Synchronisierung');
  joResponseJSON:= nil;
  joResponseJSONData:= nil;
  jaDetails:= nil;
  if not Assigned(joResponseJSON) then
    joResponseJSON := TJSONObject.Create;
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  qry_Sync.FetchOptions.Mode:= fmall;
  qry_Sync.FetchOptions.RecordCountMode:= cmtotal;
  qry_Sync.SQL.Text:= 'SELECT ID,Nummer,Bezeichnung,Wert,RestWert,Datum,AbfragePin,'+
                      'IFNULL(Gutschein_ID,0) AS ID_Gutschein, Deleted FROM Gutschein ';
  if not bAll then
    qry_Sync.SQL.Text:= qry_Sync.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
  qry_Sync.open;
  if qry_Sync.RecordCount > 0 then
  begin
    if not Assigned(jaDetails) then
        jaDetails := TJSONArray.Create;
    while not qry_Sync.eof do
    begin
      if not Assigned(joResponseJSONData) then
        joResponseJSONData := TJSONObject.Create;
      joResponseJSONData.AddPair(TJSONPair.Create('ID', TJSONNumber.Create(qry_Sync.Fieldbyname('ID').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Number', TJSONString.Create(qry_Sync.Fieldbyname('Nummer').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Description', TJSONString.Create(qry_Sync.Fieldbyname('Bezeichnung').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('Date', TJSONString.Create(DateToStr(qry_Sync.Fieldbyname('Datum').AsDateTime))));
      joResponseJSONData.AddPair(TJSONPair.Create('Value', TJSONNumber.Create(qry_Sync.Fieldbyname('Wert').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('Remaining_value', TJSONNumber.Create(qry_Sync.Fieldbyname('Restwert').asFloat)));
      joResponseJSONData.AddPair(TJSONPair.Create('Pincode', TJSONString.Create(qry_Sync.Fieldbyname('AbfragePin').asString)));
      joResponseJSONData.AddPair(TJSONPair.Create('ID_Giftcards',TJSONNumber.Create(qry_Sync.Fieldbyname('ID_Gutschein').asInteger)));
      joResponseJSONData.AddPair(TJSONPair.Create('Deleted', TJSONBool.Create(qry_Sync.Fieldbyname('Deleted').asBoolean)));
      jaDetails.Add(joResponseJSONData);
      joResponseJSONData:= nil;
      qry_Sync.Next;
    end;
    joResponseJSON.AddPair(TJSONPair.Create('Giftcards', jaDetails));
    JSONResult := dmmain.RestRequest(joResponseJSON,'SetGiftcards?ID_User='+ IntToStr(AUserID), rmPUT) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if bHasError then
      WriteLog('nicht Erfolgreich synchronisiert. ErroCode:' + JSONResult.GetValue<TJSONBool>('ErrorCode').ToString,1,false);
  end;
  qry_Sync.Close;
  qry_Sync.SQL.Text:= 'UPDATE Belege SET Geaendertam = null';
  qry_Sync.ExecSQL;
  qry_Sync.SQL.Text:= 'Delete FROM Belege WHERE DELETED = true';
  qry_Sync.ExecSQL;
  FreeAndNil(qry_Sync);




    //  joResponseJSON:= nil;
//  joResponseJSONData:= nil;
//  jaDetails:= nil;
//  if not Assigned(joResponseJSON) then
//    joResponseJSON := TJSONObject.Create;
//  qry_Sync:= TFDQuery.Create(nil);
//  qry_Sync.Connection:= dmmain.con_PCM;
//  qry_Sync.FetchOptions.Mode:= fmall;
//  qry_Sync.FetchOptions.RecordCountMode:= cmtotal;
//  qry_Sync.SQL.Text:= 'SELECT ID,Nummer,Bezeichnung,Wert,RestWert,Datum,AbfragePin,'+
//                      'IFNULL(Gutschein_ID,0) AS ID_Gutschein, Deleted FROM Gutschein ';
//  if not bAll then
//    qry_Sync.SQL.Text:= qry_Sync.SQL.Text +  ' WHERE Geaendertam IS NOT NULL';
//  qry_Sync.open;
//
////  dmMain.SMGutscheineRest.ParamByName('ID_Benutzer').AsInteger := AUserID;
////  dmMain.SMGutscheineRest.ParamByName('Data').AsDataSet:= qry_Sync;
////  dmMain.SMGutscheineRest.ExecuteMethod;
//  qry_Sync.Close;
//  qry_Sync.SQL.Text:= 'UPDATE Gutschein SET Geaendertam = null';
//  qry_Sync.ExecSQL;
//  qry_Sync.SQL.Text:= 'Delete FROM Gutschein WHERE DELETED = true';
//  qry_Sync.ExecSQL;
//  FreeAndNil(qry_Sync);
end;
{$EndRegion ApptoServer}
// Synch from Server to App
{$Region ServertoApp}
procedure SyncKontakte_FromServer(AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: Integer;
  iKontakte_ID: integer;
  sSalutation: String;
  sName: String;
  sSurname: String;
  sStreet_private: String;
  sPostalcode_private: String;
  sPlace_private: String;
  sPhone_private: String;
  sMobile_private: String;
  sMail_private: String;
  sBirthday: String;
  sGender: String;
  sMaritalstatus: String;
  sNationality: String;
  sDenomination: String;
  sCompany: String;
  sStreet_business: String;
  sPostalcode_business: String;
  sPlace_business: String;
  sPhone_business: String;
  sMobile_business: String;
  sMail_business: String;
begin
  AWaitFrame.SetWaitMessage('Kontakte werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetContacts?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Contacts');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iKontakte_ID);
        JSonValue.TryGetValue<String>('Salutation',sSalutation);
        JSonValue.TryGetValue<String>('Name',sName);
        JSonValue.TryGetValue<String>('Surname',sSurname);
        JSonValue.TryGetValue<String>('Street_private', sStreet_private);
        JSonValue.TryGetValue<String>('Postalcode_private',sPostalcode_private);
        JSonValue.TryGetValue<String>('Place_private',sPlace_private);
        JSonValue.TryGetValue<String>('Phone_private',sPhone_private);
        JSonValue.TryGetValue<String>('Mobile_private',sMobile_private);
        JSonValue.TryGetValue<String>('Mail_private',sMail_private);
        JSonValue.TryGetValue<String>('Birthday',sBirthday);
        JSonValue.TryGetValue<String>('Gender',sGender);
        JSonValue.TryGetValue<String>('Maritalstatus',sMaritalstatus);
        JSonValue.TryGetValue<String>('Nationality',sNationality);
        JSonValue.TryGetValue<String>('Denomination',sDenomination);
        JSonValue.TryGetValue<String>('Company',sCompany);
        JSonValue.TryGetValue<String>('Street_business',sStreet_business);
        JSonValue.TryGetValue<String>('Postalcode_business',sPostalcode_business);
        JSonValue.TryGetValue<String>('Place_business',sPlace_business);
        JSonValue.TryGetValue<String>('Phone_business',sPhone_business);
        JSonValue.TryGetValue<String>('Mobile_business',smobile_business);
        JSonValue.TryGetValue<String>('Mail_business',sMail_business);


        qry_Sync.SQL.Text:= 'SELECT ID FROM Kontakte WHERE Kontakte_ID = :Kontakte_ID';
        qry_Sync.ParamByName('Kontakte_ID').AsInteger := iKontakte_ID;
        qry_Sync.open;
        if qry_Sync.RecordCount > 0 then
        begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if sBirthday<> '' then UpdateFieldValues_TDate('Geburtsdatum','Kontakte',StrToDate(sBirthday),iSyncID);
          if sCompany <> '' then UpdateFieldValues_String('Firma','Kontakte',sCompany,iSyncID);
          if sPhone_private <> '' then UpdateFieldValues_String('Telefon','Kontakte',sPhone_private,iSyncID);
          if sMobile_private <> '' then UpdateFieldValues_String('Handy','Kontakte',sMobile_private,iSyncID);
          if sPhone_business <> '' then UpdateFieldValues_String('TelefonFirma','Kontakte',sPhone_business,iSyncID);
          if smobile_business <> '' then UpdateFieldValues_String('HandyFirma','Kontakte',smobile_business,iSyncID);
          if sMail_private <> '' then UpdateFieldValues_String('Email','Kontakte',sMail_private,iSyncID);
          if sMail_business <> '' then UpdateFieldValues_String('EmailFirma','Kontakte',sMail_business,iSyncID);
          if sStreet_private <> '' then	UpdateFieldValues_String('Strasse','Kontakte',sStreet_private,iSyncID);
          if sPostalcode_private <> '' then UpdateFieldValues_String('PLZ','Kontakte',sPostalcode_private,iSyncID);
          if sPlace_private <> '' then UpdateFieldValues_String('Ort','Kontakte',sPlace_private,iSyncID);
          if sStreet_business <> '' then UpdateFieldValues_String('StrasseFirma','Kontakte',sStreet_business,iSyncID);
          if sPostalcode_business <> '' then	UpdateFieldValues_String('PLZFirma','Kontakte',sPostalcode_business,iSyncID);
          if sPlace_business <> '' then	UpdateFieldValues_String('OrtFirma','Kontakte',sPlace_business,iSyncID);
          if sSalutation <> '' then UpdateFieldValues_String('Anrede','Kontakte',sSalutation,iSyncID);
          if sGender <> '' then UpdateFieldValues_String('Geschlecht','Kontakte',sGender,iSyncID);
          if sMaritalstatus<> '' then	UpdateFieldValues_String('Familienstand','Kontakte',sMaritalstatus,iSyncID);
          if sNationality <> '' then UpdateFieldValues_String('Staatsangehoerigkeit','Kontakte',sNationality,iSyncID);
          if sDenomination <> '' then UpdateFieldValues_String('Konfession','Kontakte',sDenomination,iSyncID);
          if sName <> '' then	UpdateFieldValues_String('Vorname','Kontakte',sName,iSyncID);
          if sSurname <> '' then UpdateFieldValues_String('Nachname','Kontakte',sSurname,iSyncID);
          if iKontakte_ID <> -1 then UpdateFieldValues_Integer('Kontakte_ID','Kontakte',iKontakte_ID,iSyncID);
  //        if bmPicture <> nil then
  //        begin
  //          qry_Sync.SQL.Text:= 'Update Kontakte SET Bild = :Bild ' +
  //                                     'WHERE Nachname = :Nachname AND Vorname = :Vorname';
  //          qry_Sync.ParamByName('Bild').AsString := Base64FromBitmap(bmPicture);
  //          qry_Sync.ParamByName('Vorname').AsString := sFirstName;
  //          qry_Sync.ParamByName('Nachname').AsString := dmMain.SMKontakte.FieldByName('Nachname').AsString;;
  //          qry_Sync.ExecSQL;
  //        end;
        end
        else begin
          qry_Sync.SQL.Text := 'INSERT INTO Kontakte (Kontakte_ID,Anrede,Vorname, Nachname, Strasse, PLZ, Ort, Telefon, Handy, Email, Geburtsdatum,'+
                               'Geschlecht, Familienstand, Staatsangehoerigkeit,Konfession,Firma,StrasseFirma,PLZFirma,OrtFirma,TelefonFirma,HandyFirma,EmailFirma) VALUES ' +
                               '(:Kontakte_ID,:Anrede,:Vorname, :Nachname, :Strasse, :PLZ, :Ort, :Telefon, :Handy, :Email, :Geburtsdatum, :Geschlecht, :Familienstand, :Staatsangehoerigkeit,' +
                               ':Konfession,:Firma,:StrasseFirma,:PLZFirma,:OrtFirma,:TelefonFirma,:HandyFirma,:EmailFirma)';
          qry_Sync.ParamByName('Kontakte_ID').AsInteger := iKontakte_ID;
          qry_Sync.ParamByName('Anrede').AsString := sSalutation;
          qry_Sync.ParamByName('Vorname').AsString := sName;
          qry_Sync.ParamByName('Nachname').AsString := sSurname;
          qry_Sync.ParamByName('Strasse').AsString := sStreet_private;
          qry_Sync.ParamByName('PLZ').AsString := sPostalcode_private;
          qry_Sync.ParamByName('Ort').AsString := sPlace_private;
          qry_Sync.ParamByName('Telefon').AsString := sPhone_private;
          qry_Sync.ParamByName('Handy').AsString := sMobile_private;
          qry_Sync.ParamByName('Email').AsString := sMail_private;
          if sBirthday = '' then
            qry_Sync.ParamByName('Geburtsdatum').AsDate := StrToDate('30.12.1899')
          else
            qry_Sync.ParamByName('Geburtsdatum').AsDate := StrToDate(sBirthday);
          qry_Sync.ParamByName('Geschlecht').AsString := sGender;
          qry_Sync.ParamByName('Familienstand').AsString := sMaritalstatus;
          qry_Sync.ParamByName('Staatsangehoerigkeit').AsString := sNationality;
          qry_Sync.ParamByName('Konfession').AsString := sDenomination;
          qry_Sync.ParamByName('Firma').AsString := sCompany;
          qry_Sync.ParamByName('StrasseFirma').AsString := sStreet_business;
          qry_Sync.ParamByName('PLZFirma').AsString := sPostalcode_business;
          qry_Sync.ParamByName('OrtFirma').AsString := sPlace_business;
          qry_Sync.ParamByName('TelefonFirma').AsString := sPhone_business;
          qry_Sync.ParamByName('HandyFirma').AsString := smobile_business ;
          qry_Sync.ParamByName('EmailFirma').AsString := sMail_business;
          qry_Sync.ExecSQL;
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  qry_Sync.SQL.Text:= 'Update Kontakte set Geburtsdatum = NULL Where Geburtsdatum = :Datum';
  qry_Sync.ParamByName('Datum').AsDate:= StrToDate('30.12.1899');
  qry_Sync.ExecSQL;
  FreeAndNil(qry_Sync);
end;
procedure SyncKalender_FromServer(const AUserID:Integer; AWaitFrame: TWaitForm);
var
  dFinishUpdate: TDateTime;
  dNewFinishUpdate: TDateTime;
  dNewReminderDateUpdate: TDateTime;
  dNewStartUpdate: TDateTime;
  dStartUpdate: TDateTime;
  iID: integer;
  qry_Synch1: TFDQuery;
  qry_Sync: TFDQuery;
  wJahrCur: word;
  wMonatCUr: word;
  wTagCur: word;
  wJahrVar: word;
  wMonatVar: word;
  wTagVar: word;
  wStundeVar: word;
  wMinuteVar: word;
  wSekundeVar: word;
  wMsekundeVar: word;
  iSyncID: Integer;
  iKalender_ID: Integer;
  iEventType: Integer;
  sCaption: String;
  sLocation: String;
  sStart: String;
  sFinish: String;
  bCompleteDay: boolean;
  bReminder: boolean;
  sReminderdate: String;
  iReminderbeforestart: integer;
  sCalendername: String;
  iID_Calenderapp: integer;
  sReccurrencetext: String;
begin
  AWaitFrame.SetWaitMessage('Kalender werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetCalendar?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Calendar');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iKalender_ID);
        JSonValue.TryGetValue<Integer>('EventType',iEventType);
        JSonValue.TryGetValue<string>('Caption',sCaption);
        JSonValue.TryGetValue<string>('Location',sLocation);
        JSonValue.TryGetValue<string>('Message',sMessage);
        JSonValue.TryGetValue<string>('Start',sStart);
        JSonValue.TryGetValue<string>('Finish',sFinish);
        JSonValue.TryGetValue<Boolean>('CompleteDay',bCompleteDay);
        JSonValue.TryGetValue<Boolean>('Reminder',bReminder);
        JSonValue.TryGetValue<string>('Reminderdate',sReminderdate);
        JSonValue.TryGetValue<integer>('Reminderbeforestart',iReminderbeforestart);
        JSonValue.TryGetValue<string>('Calendername',sCalendername);
        JSonValue.TryGetValue<integer>('ID_Calenderapp',iID_Calenderapp);
        JSonValue.TryGetValue<string>('Reccurrencetext',sReccurrencetext);

        qry_Sync.SQL.Text:= 'SELECT ID FROM kalender WHERE Kalender_ID = :ID_Kalender_App';
        qry_Sync.ParamByName('ID_Kalender_App').asInteger := iKalender_ID;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
          qry_Sync.SQL.Text := 'INSERT INTO kalender (Kalender_ID,EventType,Caption,Location,Message,Start,Finish,CompleteDay,Reminder,' +
                               'ReminderDate,ReminderMinutesBeforeStart, Kalendername, Wiederholungtext) VALUES ' +
                               '(:Kalender_ID,:EventType,:Caption,:Location,:Message,:Start,:Finish,:CompleteDay,:Reminder, ' +
                               ':ReminderDate,:ReminderMinutesBeforeStart, :Kalendername,:Wiederholungtext)';
          qry_Sync.ParamByName('Kalender_ID').AsInteger := iKalender_ID;
          qry_Sync.ParamByName('EventType').AsInteger := iEventType;
          qry_Sync.ParamByName('Caption').AsString := sCaption;
          qry_Sync.ParamByName('Location').AsString := sLocation;
          qry_Sync.ParamByName('Message').AsString := sMessage;
          qry_Sync.ParamByName('Start').AsDateTime := StrToDateTime(sStart);
          qry_Sync.ParamByName('Finish').AsDateTime := StrToDateTime(sFinish);
          qry_Sync.ParamByName('CompleteDay').AsBoolean := bCompleteDay;
          if StrToDateTimeDef(sReminderDate,StrToDateTime('01.01.2023 00:00')) < Now() then
            qry_Sync.ParamByName('Reminder').AsBoolean := false
          else
            qry_Sync.ParamByName('Reminder').AsBoolean := bReminder;
          qry_Sync.ParamByName('ReminderDate').AsDateTime := StrToDateTimeDef(sReminderDate,StrToDateTime('01.01.2023 00:00'));
          qry_Sync.ParamByName('ReminderMinutesBeforeStart').asInteger := iReminderBeforeStart;
          qry_Sync.ParamByName('Kalendername').AsString := sCalendername;
          qry_Sync.ParamByName('Wiederholungtext').AsString := sReccurrencetext;
          qry_Sync.ExecSQL;
        end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if StrToDateTime(sStart) >= Now() then
          begin
            qry_Sync.Close;
            if iKalender_ID <> -1 then UpdateFieldValues_Integer('Kalender_ID','Kalender',iKalender_ID,iSyncID);
            if iEventType <> -1 then UpdateFieldValues_Integer('EventType','Kalender',iEventType,iSyncID);
            if sLocation <> '' then UpdateFieldValues_String('Location','Kalender',sLocation,iSyncID);
            if sStart <> ''  then UpdateFieldValues_TDateTime('Start','Kalender',StrToDateTime(sStart),iSyncID);
            if sFinish <> ''  then UpdateFieldValues_TDateTime('Finish','Kalender',StrToDateTime(sFinish),iSyncID);
            if BoolToStr(bCompleteDay) <> ''  then UpdateFieldValues_Boolean('CompleteDay','Kalender',bCompleteDay,iSyncID);
            if BoolToStr(bReminder) <> ''  then UpdateFieldValues_Boolean('Reminder','Kalender',bReminder,iSyncID);
            if iReminderbeforestart <> 0 then UpdateFieldValues_integer('ReminderMinutesBeforeStart','Kalender',iReminderbeforestart,iSyncID);
            if sMessage <> ''  then UpdateFieldValues_String('Message','Kalender',sMessage,iSyncID);
            if sReminderDate <> ''  then UpdateFieldValues_TDateTime('ReminderDate','Kalender',StrToDateTime(sReminderDate),iSyncID);
            if sCalendername <> '' then UpdateFieldValues_String('Kalendername','Kalender',sCalendername,iSyncID);
          end;
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  qry_Sync.SQL.text:='DELETE FROM Kalender WHERE Date(start) < DATE() and (Kalendername like ''Müll%'' or Kalendername like ''Feiertage %'')';
  qry_Sync.ExecSQL;
  qry_Sync.SQL.text:= 'SELECT ID, START, FINISH, ReminderDate FROM Kalender Where Kalendername = ''Geburtstag'' and Date(START) < DATE()';
  qry_Sync.Open;
  while not qry_Sync.Eof do
  begin
    qry_Synch1:= TFDQuery.Create(nil);
    qry_Synch1.Connection:= dmmain.con_PCM;
    iID := qry_Sync.FieldByName('ID').asInteger;
    DecodeDate(Date(), wJahrCur,wMonatCUr,wTagCur);
    wJahrCur := wJahrCur + 1;
    dStartUpdate:= qry_Sync.FieldByName('START').asDateTime;
    DecodeDateTime(dStartUpdate, wJahrVar,wMonatVar,wTagVar,wStundeVar,wMinuteVar, wSekundeVar, wMsekundeVar);
    dNewStartUpdate := EncodeDateTime(wJahrCur,wMonatvar,wTagVar, wStundeVar,wMinuteVar,wSekundeVar,0);
    dFinishUpdate:= qry_Sync.FieldByName('FINISH').asDateTime;
    DecodeDateTime(dFinishUpdate, wJahrVar,wMonatVar,wTagVar,wStundeVar,wMinuteVar, wSekundeVar, wMsekundeVar);
    dNewFinishUpdate := EncodeDateTime(wJahrCur,wMonatvar,wTagVar, wStundeVar,wMinuteVar,wSekundeVar,0);
    DecodeDateTime(dFinishUpdate, wJahrVar,wMonatVar,wTagVar,wStundeVar,wMinuteVar, wSekundeVar, wMsekundeVar);
    dNewReminderDateUpdate := EncodeDateTime(wJahrCur,wMonatvar,wTagVar, wStundeVar,wMinuteVar,wSekundeVar,0);
    qry_Synch1.SQL.text:= 'Update kalender Set Start = :Start, Finish= :Finish, ReminderDate= :ReminderDate Where ID = :ID';
    qry_Synch1.ParamByName('Start').asDateTime:= dNewStartUpdate;
    qry_Synch1.ParamByName('Finish').asDateTime:= dNewFinishUpdate;
    qry_Synch1.ParamByName('ReminderDate').asDateTime:= dNewReminderDateUpdate;
    qry_Synch1.ParamByName('ID').asInteger:= iID;
    qry_Synch1.ExecSQl;
    qry_Sync.Next;
    qry_Synch1.Free;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
procedure SyncPasswort_FromServer(const AUserID:Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: integer;
  iPasswort_ID: integer;
  sPasswordname: String;
  sUser: String;
  sPassword: String;
  sLink: String;
  sVPN_SharedSecret: String;
  sAPP_IP: String;
  iAPP_Port: integer;
  sAPP_Encryption: String;
  sIncomingmail_Server: String;
  iIncomingmail_Port: integer;
  sIncomingmail_Encryption: String;
  sOutgoingmail_Server: String;
  iOutgoingmail_Port: integer;
  sOutgoingmail_Encryption: String;
  sPasswordtype: String;
  sWlankey: String;
begin
  AWaitFrame.SetWaitMessage('Passwörter werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil); // fehler
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetPasswords?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Passwords');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iPasswort_ID);
        JSonValue.TryGetValue<string>('Passwordname',sPasswordname);
        JSonValue.TryGetValue<string>('User',sUser);
        JSonValue.TryGetValue<string>('Password',sPassword);
        JSonValue.TryGetValue<string>('Link',sLink);
        JSonValue.TryGetValue<string>('VPN_SharedSecret',sVPN_SharedSecret);
        JSonValue.TryGetValue<string>('APP_IP',sAPP_IP);
        JSonValue.TryGetValue<integer>('APP_Port',iAPP_Port);
        JSonValue.TryGetValue<string>('APP_Encryption',sAPP_Encryption);
        JSonValue.TryGetValue<string>('Incomingmail_Server',sIncomingmail_Server);
        JSonValue.TryGetValue<integer>('Incomingmail_Port',iIncomingmail_Port);
        JSonValue.TryGetValue<string>('Incomingmail_Encryption',sIncomingmail_Encryption);
        JSonValue.TryGetValue<string>('Outgoingmail_Server',sOutgoingmail_Server);
        JSonValue.TryGetValue<integer>('Outgoingmail_Port',iOutgoingmail_Port);
        JSonValue.TryGetValue<string>('Outgoingmail_Encryption',sOutgoingmail_Encryption);
        JSonValue.TryGetValue<string>('Passwordtype',sPasswordtype);
        JSonValue.TryGetValue<string>('Wlankey',sWlankey);


        qry_Sync.SQL.Text:= 'SELECT ID FROM Passwoerter WHERE passwoerter_ID = :passwoerter_ID';
        qry_Sync.ParamByName('passwoerter_ID').AsInteger := iPasswort_ID;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
         qry_Sync.SQL.Text := 'INSERT INTO passwoerter (passwoerter_ID,Bezeichnung,user,password,link,VPN_SharedSecret,'+
                                      'APP_IP,APP_Port,APP_Verschluesselung,MAIL_Posteingangsserver,MAIL_PosteingangsPort,'+
                                      'MAIL_PosteingangsVerschluesselung,'+
                                      'MAIL_Postausgangsserver,'+
                                      'MAIL_PostausgangsPort,'+
                                      'MAIL_PostausgangsVerschluesselung,PWTyp,WLAN) VALUES ' +
                                      '(:passwoerter_ID,:Bezeichnung,:user,:password,:link,:VPN_SharedSecret,:APP_IP,'+
                                      ':APP_Port,:APP_Verschluesselung,:MAIL_Posteingangsserver,:MAIL_PosteingangsPort,'+
                                      ':MAIL_PosteingangsVerschluesselung, '+
                                      ':MAIL_Postausgangsserver,'+
                                      ':MAIL_PostausgangsPort,'+
                                      ':MAIL_PostausgangsVerschluesselung,:PWTyp,:WLAN)';
          qry_Sync.ParamByName('passwoerter_ID').asInteger := iPasswort_ID;
          qry_Sync.ParamByName('Bezeichnung').AsString := sPasswordname;
          qry_Sync.ParamByName('user').AsString := sUser;
          qry_Sync.ParamByName('password').AsString := sPassword;
          qry_Sync.ParamByName('link').AsString := sLink;
          qry_Sync.ParamByName('VPN_SharedSecret').AsString := sVPN_SharedSecret;
          qry_Sync.ParamByName('APP_IP').AsString := sAPP_IP;
          qry_Sync.ParamByName('APP_Port').asInteger := iAPP_Port;
          qry_Sync.ParamByName('APP_Verschluesselung').AsString := sAPP_Encryption;
          qry_Sync.ParamByName('MAIL_Posteingangsserver').AsString := sIncomingmail_Server;
          qry_Sync.ParamByName('MAIL_PosteingangsPort').asInteger := iIncomingmail_Port;
          qry_Sync.ParamByName('MAIL_PosteingangsVerschluesselung').AsString := sIncomingmail_Encryption;
          qry_Sync.ParamByName('MAIL_Postausgangsserver').AsString := sOutgoingmail_Server;
          qry_Sync.ParamByName('MAIL_PostausgangsPort').asInteger := iOutgoingmail_Port;
          qry_Sync.ParamByName('MAIL_PostausgangsVerschluesselung').AsString := sOutgoingmail_Encryption;
          qry_Sync.ParamByName('PWTyp').AsString := sPasswordtype;
          qry_Sync.ParamByName('WLAN').AsString := sWlankey;
          qry_Sync.ExecSQL;
        end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if sUser <> '' then UpdateFieldValues_String('User','passwoerter',sUser,iSyncID);
          if sPasswordname <> '' then UpdateFieldValues_String('Bezeichnung','passwoerter',sPasswordname,iSyncID);
          if sPassword <> '' then UpdateFieldValues_String('PASSWORD','passwoerter',sPassword,iSyncID);
          if sLink <> '' then UpdateFieldValues_String('link','passwoerter',slink,iSyncID);
          if sWlankey <> '' then UpdateFieldValues_String('WLAN','passwoerter',sWlankey,iSyncID);
          if sVPN_SharedSecret <> '' then UpdateFieldValues_String('VPN_SharedSecret','passwoerter',sVPN_SharedSecret,iSyncID);
          if sAPP_IP <> '' then UpdateFieldValues_String('APP_IP','passwoerter',sAPP_IP,iSyncID);
          if IntToStr(iAPP_Port) <> '' then UpdateFieldValues_Integer('APP_Port','passwoerter',iAPP_Port,iSyncID);
          if sAPP_Encryption <> '' then UpdateFieldValues_String('APP_Verschluesselung','passwoerter',sAPP_Encryption,iSyncID);
          if sIncomingmail_Server <> '' then UpdateFieldValues_String('MAIL_Posteingangsserver','passwoerter',sIncomingmail_Server,iSyncID);
          if IntToStr(iIncomingmail_Port) <> '' then UpdateFieldValues_Integer('MAIL_PosteingangsPort','passwoerter',iIncomingmail_Port,iSyncID);
          if sIncomingmail_Encryption <> '' then UpdateFieldValues_String('MAIL_PosteingangsVerschluesselung','passwoerter',sIncomingmail_Encryption,iSyncID);
          if sOutgoingmail_Server <> '' then UpdateFieldValues_String('MAIL_Postausgangsserver','passwoerter',sOutgoingmail_Server,iSyncID);
          if IntToStr(iOutgoingmail_Port) <> '' then UpdateFieldValues_Integer('MAIL_PostausgangsPort','passwoerter',iOutgoingmail_Port,iSyncID);
          if sOutgoingmail_Encryption <> '' then UpdateFieldValues_String('MAIL_PostausgangsVerschluesselung','passwoerter',sOutgoingmail_Encryption,iSyncID);
          if sPasswordtype <> '' then UpdateFieldValues_String('PWTyp','passwoerter',sPasswordtype,iSyncID);
          if IntToStr(iPasswort_ID) <> '' then UpdateFieldValues_Integer('passwoerter_ID','passwoerter',iPasswort_ID,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
procedure SyncSerials_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: integer;
  iSerial_ID: integer;
  sSerialname: String;
  sUser: String;
  sSerialkey: String;
  sSerialType: String;
begin
  AWaitFrame.SetWaitMessage('Serials werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetSerials?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Serials');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iSerial_ID);
        JSonValue.TryGetValue<string>('Serialname',sSerialname);
        JSonValue.TryGetValue<string>('User',sUser);
        JSonValue.TryGetValue<string>('Serialkey',sSerialkey);
        JSonValue.TryGetValue<string>('SerialType',sSerialType);
        qry_Sync.SQL.Text:= 'SELECT ID FROM Serials WHERE Serials_ID = :Serials_ID';
        qry_Sync.ParamByName('Serials_ID').asInteger := iSerial_ID;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
          qry_Sync.SQL.Text := 'INSERT INTO Serials (Serials_ID,App,USER,Serial,Bezeichnung) VALUES ' +
                               '(:Serials_ID,:App,:USER,:Serial,:Bezeichnung)';
          qry_Sync.ParamByName('Serials_ID').asInteger := iSerial_ID;
          qry_Sync.ParamByName('App').AsString := sSerialname;
          qry_Sync.ParamByName('USER').AsString := sUser;
          qry_Sync.ParamByName('Serial').AsString := sSerialkey;
          qry_Sync.ParamByName('Bezeichnung').AsString := sSerialType;
          qry_Sync.ExecSQL;
        end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if sUser <> '' then UpdateFieldValues_String('User','Serials',sUser,iSyncID);
          if sSerialname <> '' then UpdateFieldValues_String('App','Serials',sSerialname,iSyncID);
          if sSerialkey <> '' then UpdateFieldValues_String('Serial','Serials',sSerialkey,iSyncID);
          if IntToStr(iSerial_ID) <> '' then UpdateFieldValues_Integer('Serials_ID','Serials',iSerial_ID,iSyncID);
          if sSerialType <> '' then UpdateFieldValues_String('Bezeichnung','Serials',sSerialType,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
procedure SyncFinanzenEin_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: integer;
  iFinanzEin_ID: integer;
  sTransmitter: String;
  fAmount: double;
  sDescription: String;
  fFixedamount: double;
begin
  AWaitFrame.SetWaitMessage('Einnahmen werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetReceipts?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Receipts');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iFinanzEin_ID);
        JSonValue.TryGetValue<string>('Transmitter',sTransmitter);
        JSonValue.TryGetValue<Float64>('Amount',fAmount);
        JSonValue.TryGetValue<string>('Description',sDescription);
        JSonValue.TryGetValue<Float64>('Fixedamount',fFixedamount);
        qry_Sync.SQL.Text:= 'SELECT ID FROM FinanzenEinnahmen WHERE Finanzen_Einnahmen_ID = :Finanzen_Einnahmen_ID';
        qry_Sync.ParamByName('Finanzen_Einnahmen_ID').AsInteger:=  iFinanzEin_ID;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
        qry_Sync.SQL.Text := 'INSERT INTO FinanzenEinnahmen (Finanzen_Einnahmen_ID,Quelle,Betrag, Bezeichnung,FixBetrag) VALUES (:Finanzen_Einnahmen_ID,:Quelle,:Betrag, :Bezeichnung,:FixBetrag)';
        qry_Sync.ParamByName('Finanzen_Einnahmen_ID').AsInteger := iFinanzEin_ID;
        qry_Sync.ParamByName('Quelle').AsString := sTransmitter;
        qry_Sync.ParamByName('Betrag').AsFloat := fAmount;
        qry_Sync.ParamByName('FixBetrag').AsFloat := fAmount;
        qry_Sync.ParamByName('Bezeichnung').AsString := sDescription;
        qry_Sync.ExecSQL;
      end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if sDescription <> '' then UpdateFieldValues_String('Bezeichnung','FinanzenEinnahmen',sDescription,iSyncID);
          if FloatToStr(fAmount) <> '' then UpdateFieldValues_Float('Betrag','FinanzenEinnahmen',fAmount,iSyncID);
          if FloatToStr(fFixedamount) <> '' then UpdateFieldValues_Float('FixBetrag','FinanzenEinnahmen',fFixedamount,iSyncID);
          if sTransmitter <> '' then UpdateFieldValues_String('Quelle','FinanzenEinnahmen',sTransmitter,iSyncID);
          if IntToStr(iFinanzEin_ID) <> '' then UpdateFieldValues_Integer('Finanzen_Einnahmen_ID','FinanzenEinnahmen',iFinanzEin_ID,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
procedure SyncFinanzenAus_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: Integer;
  iID_Expenditure: integer;
  sReceiver: String;
  sDescription: String;
  sAccountnumber: String;
  sBankcode: String;
  fAmount: double;
  bFixedcosts: boolean;
  iValidmonth: integer;
  iValidyear: integer;
  sUse: String;
  fFixedamount: double;
begin
  AWaitFrame.SetWaitMessage('Ausgaben werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetExpenditure?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Expenditure');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iID_Expenditure);
        JSonValue.TryGetValue<string>('Receiver',sReceiver);
        JSonValue.TryGetValue<string>('Description',sDescription);
        JSonValue.TryGetValue<string>('Accountnumber',sAccountnumber);
        JSonValue.TryGetValue<string>('Bankcode',sBankcode);
        JSonValue.TryGetValue<Float64>('Amount',fAmount);
        JSonValue.TryGetValue<Boolean>('Fixedcosts',bFixedcosts);
        JSonValue.TryGetValue<Integer>('Validmonth',iValidmonth);
        JSonValue.TryGetValue<Integer>('Validyear',iValidyear);
        JSonValue.TryGetValue<string>('Use',sUse);
        JSonValue.TryGetValue<Float64>('Fixedamount',fFixedamount);
        qry_Sync.SQL.Text:= 'SELECT ID FROM FinanzenAusgaben WHERE Finanzen_Ausgaben_ID = :Finanzen_Ausgaben_ID';
        qry_Sync.ParamByName('Finanzen_Ausgaben_ID').AsInteger := iID_Expenditure;
        qry_Sync.open;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
          qry_Sync.SQL.Text := 'INSERT INTO FinanzenAusgaben (Finanzen_Ausgaben_ID,Name,Beschreibung,Kontonummer,Bankleitzahl,Betrag,Fixkosten,Gueltig_Monat,Gueltig_Jahr,Verwendungszweck, FixBetrag) VALUES '+
                                  '(:Finanzen_Ausgaben_ID,:Name,:Beschreibung,:Kontonummer,:Bankleitzahl,:Betrag,:Fixkosten,:Gueltig_Monat,:Gueltig_Jahr,:Verwendungszweck,:FixBetrag)';
          qry_Sync.ParamByName('Finanzen_Ausgaben_ID').Asinteger := iID_Expenditure;
          qry_Sync.ParamByName('Name').AsString := sReceiver;
          qry_Sync.ParamByName('Beschreibung').AsString := sDescription;
          qry_Sync.ParamByName('Kontonummer').AsString := sAccountnumber;
          qry_Sync.ParamByName('Bankleitzahl').AsString := sBankcode;
          qry_Sync.ParamByName('Betrag').AsFloat := fAmount;
          qry_Sync.ParamByName('FixBetrag').AsFloat := fFixedamount;
          qry_Sync.ParamByName('Fixkosten').asBoolean := bFixedcosts;
          qry_Sync.ParamByName('Gueltig_Monat').Asinteger := iValidmonth;
          qry_Sync.ParamByName('Gueltig_Jahr').Asinteger := iValidyear;
          qry_Sync.ParamByName('Verwendungszweck').AsString := sUse;
          qry_Sync.ExecSQL;
        end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if FloatToStr(fAmount) <> '' then UpdateFieldValues_Float('Betrag','FinanzenAusgaben',fAmount,iSyncID);
          if FloatToStr(fFixedamount) <> '' then UpdateFieldValues_Float('FixBetrag','FinanzenAusgaben',fFixedamount,iSyncID);
          if sReceiver <> '' then UpdateFieldValues_String('Name','FinanzenAusgaben',sReceiver,iSyncID);
          if sDescription <> '' then UpdateFieldValues_String('Beschreibung','FinanzenAusgaben',sDescription,iSyncID);
          if sAccountnumber <> '' then UpdateFieldValues_String('Kontonummer','FinanzenAusgaben',sAccountnumber,iSyncID);
          if sBankcode <> '' then UpdateFieldValues_String('Bankleitzahl','FinanzenAusgaben',sBankcode,iSyncID);
          if BoolToStr(bFixedcosts) <> ''  then UpdateFieldValues_Boolean('Fixkosten','FinanzenAusgaben',bFixedcosts,iSyncID);
          if IntToStr(iValidmonth) <> '' then UpdateFieldValues_Integer('Gueltig_Monat','FinanzenAusgaben',iValidmonth,iSyncID);
          if IntToStr(iValidyear) <> '' then UpdateFieldValues_Integer('Gueltig_Jahr','FinanzenAusgaben',iValidyear,iSyncID);
          if sUse <> ''  then UpdateFieldValues_String('Verwendungszweck','FinanzenAusgaben',sUse,iSyncID);
          if IntToStr(iID_Expenditure) <> '' then UpdateFieldValues_Integer('Finanzen_Ausgaben_ID','FinanzenAusgaben',iID_Expenditure,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
procedure SyncBelege_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_SyncBelege_FromServer: TFDQuery;
  iSyncID: integer;
  iID_Vouchers: integer;
  sNumber: string;
  sDate: string;
  sExhibitor: string;
  fAmount: double;
  iCategorie: integer;
  iMonth: integer;
  iYear: integer;
begin
  AWaitFrame.SetWaitMessage('Belege werden synchronisiert...', 'Synchronisierung');
  qry_SyncBelege_FromServer:= TFDQuery.Create(nil);
  qry_SyncBelege_FromServer.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetVouchers?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Vouchers');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iID_Vouchers);
        JSonValue.TryGetValue<string>('Number',sNumber);
        JSonValue.TryGetValue<string>('Date',sDate);
        JSonValue.TryGetValue<string>('Exhibitor',sExhibitor);
        JSonValue.TryGetValue<Float64>('Amount',fAmount);
        JSonValue.TryGetValue<Integer>('Categorie',iCategorie);
        JSonValue.TryGetValue<Integer>('Month',iMonth);
        JSonValue.TryGetValue<Integer>('Year',iYear);
        qry_SyncBelege_FromServer.SQL.Text:= 'SELECT ID FROM Belege WHERE Belege_ID = :Finanzen_Belege_ID';
        qry_SyncBelege_FromServer.ParamByName('Finanzen_Belege_ID').AsInteger := iID_Vouchers;
        qry_SyncBelege_FromServer.open;
        qry_SyncBelege_FromServer.open;
        if qry_SyncBelege_FromServer.RecordCount = 0 then
        begin
          qry_SyncBelege_FromServer.SQL.Text := 'INSERT INTO Belege (Belege_ID,Nummer,Datum, Aussteller,Betrag,Kategorie,Jahr,Monat) VALUES (:Belege_ID,:Nummer,:Datum, :Aussteller,:Betrag,:Kategorie,:Jahr,:Monat)';
          qry_SyncBelege_FromServer.ParamByName('Belege_ID').Asinteger := iID_Vouchers;
          qry_SyncBelege_FromServer.ParamByName('Nummer').AsString := sNumber;
          qry_SyncBelege_FromServer.ParamByName('Datum').AsDate := StrToDate(sDate);
          qry_SyncBelege_FromServer.ParamByName('Aussteller').AsString := sExhibitor;
          qry_SyncBelege_FromServer.ParamByName('Betrag').AsFloat := famount;
          qry_SyncBelege_FromServer.ParamByName('Kategorie').AsInteger := iCategorie;
          qry_SyncBelege_FromServer.ParamByName('Jahr').AsInteger := iYear;
          qry_SyncBelege_FromServer.ParamByName('Monat').AsInteger := iMonth;
          qry_SyncBelege_FromServer.ExecSQL;
        end
        else begin
          iSyncID:= qry_SyncBelege_FromServer.FieldByName('ID').AsInteger;
          if sNumber <> '' then UpdateFieldValues_String('Nummer','Belege',sNumber,iSyncID);
          if sDate <> '' then UpdateFieldValues_TDate('Datum','Belege',StrToDate(sDate),iSyncID);
          if sExhibitor <> '' then UpdateFieldValues_String('Aussteller','Belege',sExhibitor,iSyncID);
          if FloatToStr(fAmount) <> '' then UpdateFieldValues_Float('Betrag','Belege',fAmount,iSyncID);
          if IntToStr(iCategorie) <> ''  then UpdateFieldValues_Integer('Kategorie','Belege',iCategorie,iSyncID);
          if IntToStr(iYear) <> '' then UpdateFieldValues_Integer('Jahr','Belege',iYear,iSyncID);
          if IntToStr(iMonth) <> '' then UpdateFieldValues_Integer('Monat','Belege',iMonth,iSyncID);
          if IntToStr(iID_Vouchers) <> '' then UpdateFieldValues_Integer('Belege_ID','Belege',iID_Vouchers,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_SyncBelege_FromServer.Close;
  FreeAndNil(qry_SyncBelege_FromServer);
end;
procedure SyncGutscheine_FromServer(const AUserID: Integer; AWaitFrame: TWaitForm);
var
  qry_Sync: TFDQuery;
  iSyncID: integer;
  iID_Giftcards: integer;
  sNumber: string;
  sDescription: string;
  sDate: string;
  fValue: double;
  fRemaining_value: double;
  sPincode: string;
begin
  AWaitFrame.SetWaitMessage('Gutscheine werden synchronisiert...', 'Synchronisierung');
  qry_Sync:= TFDQuery.Create(nil);
  qry_Sync.Connection:= dmmain.con_PCM;
  try
    JSONResult := dmmain.RestRequest(nil,'GetGiftCards?ID_User='+ IntToStr(AUserID),rmPOST) as TJSONObject;
    bHasError:= StrToBool(JSONResult.GetValue<TJSONBool>('HasError').ToString);
    if not bHasError then
    begin
      jaDetails :=  JSONResult.GetValue<TJSONArray>('Giftcards');
      for var JSonValue in jaDetails do
      begin
        JSonValue.TryGetValue<Integer>('ID',iID_Giftcards);
        JSonValue.TryGetValue<string>('Number',sNumber);
        JSonValue.TryGetValue<string>('Description',sDescription);
        JSonValue.TryGetValue<string>('Date',sDate);
        JSonValue.TryGetValue<Float64>('Value',fValue);
        JSonValue.TryGetValue<Float64>('Remaining_value',fRemaining_value);
        JSonValue.TryGetValue<string>('Pincode',sPincode);

        qry_Sync.SQL.Text:= 'SELECT ID FROM gutschein WHERE gutschein_ID = :Finanzen_Gutscheine_ID';
        qry_Sync.ParamByName('Finanzen_Gutscheine_ID').AsInteger := iID_Giftcards;
        qry_Sync.open;
        qry_Sync.open;
        if qry_Sync.RecordCount = 0 then
        begin
          qry_Sync.SQL.Text := 'INSERT INTO gutschein (Gutschein_ID,Nummer,Bezeichnung, Datum,Wert,Restwert,Abfragepin) VALUES (:Gutschein_ID,:Nummer,:Bezeichnung, :Datum,:Wert,:Restwert,:Abfragepin)';
          qry_Sync.ParamByName('gutschein_ID').Asinteger := iID_Giftcards;
          qry_Sync.ParamByName('Nummer').AsString := sNumber;
          qry_Sync.ParamByName('Bezeichnung').AsString := sDescription;
          qry_Sync.ParamByName('Datum').AsDate := StrToDate(sDate);
          qry_Sync.ParamByName('Wert').AsFloat := fValue;
          qry_Sync.ParamByName('Restwert').AsFloat := fRemaining_value;
          qry_Sync.ParamByName('Abfragepin').AsString := sPincode;
          qry_Sync.ExecSQL;
        end
        else begin
          iSyncID:= qry_Sync.FieldByName('ID').AsInteger;
          if sNumber <> '' then UpdateFieldValues_String('Nummer','gutschein',sNumber,iSyncID);
          if sDescription <> '' then UpdateFieldValues_String('Bezeichnung','gutschein',sDescription,iSyncID);
          if sDate <> '' then UpdateFieldValues_TDate('Datum','gutschein',StrToDate(sDate),iSyncID);
          if FloatToStr(fValue) <> '' then UpdateFieldValues_Float('Wert','gutschein',fValue,iSyncID);
          if FloatToStr(fRemaining_value) <> '' then UpdateFieldValues_Float('Restwert','gutschein',fRemaining_value,iSyncID);
          if sPincode <> '' then UpdateFieldValues_String('Abfragepin','gutschein',sPincode,iSyncID);
          if IntToStr(iID_Giftcards) <> '' then UpdateFieldValues_Integer('gutschein_ID','gutschein',iID_Giftcards,iSyncID);
        end;
      end;
    end;
  except
    on e:exception do
    begin
      WriteLog(e.Message,0,false);
    end;
  end;
  qry_Sync.Close;
  FreeAndNil(qry_Sync);
end;
{$EndRegion ServertoApp}
// Synch
{$Region Synch}
procedure Synchronisation(const AUserID, AServerID: Integer; AWaitFrame: TWaitForm; bALL: Boolean);
begin
  //Kontakte Synchronisieren
  try
    SyncKontakte_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncKontakte_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    //Kalender synchronisieren
    SyncKalender_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    Synckalender_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    //Passwörter
    SyncPasswort_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncPasswort_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Serials
    SyncSerials_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncSerials_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Einnahmen
    SyncFinanzenEin_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncFinanzenEin_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Ausgaben
    SyncFinanzenAus_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncFinanzenAus_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Belege
    SyncBelege_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncBelege_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Gutscheine
    SyncGutscheine_ToServer(AUserID,bAll,AWaitFrame);
  except
  end;
  try
    SyncGutscheine_FromServer(AUserID,AWaitFrame);
  except
  end;
  try
    // Login Synchronisieren
    SyncConfig_ToServer(AUserID,AWaitFrame);
  except
  end;
end;
{$EndRegion Synch}
procedure BerechneMonat(AMonat,AJahr: integer);
	procedure WriteMonatswert(ARest: Double;AaktGLZ,AMonat,AJahr,ASollzeit,AIStzeit,AMehrarbeit,APausen,AFeiertag: integer; AUrlaub_bezahlt,AUrlaub_unbezahlt,AKrank_bezahlt,AKrank_unbezahlt: double);
	var
  	iAnzahl: integer;
  	qry_MW: TFDQuery;
	begin
    qry_MW:= TFDQuery.Create(nil);
    qry_MW.Connection:= dmmain.con_PCM;
    qry_MW.SQL.Text:= 'SELECT Count(*) as Anzahl From Monatswerte Where Monat = :Monat and Jahr = :Jahr and ID_Benutzer = :ID';
    qry_MW.ParamByName('monat').AsInteger:= AMonat;
    qry_MW.ParamByName('jahr').AsInteger:= AJahr;
    qry_MW.ParamByName('ID').AsInteger:= dmmain.iUserID;
    qry_MW.open;
    iAnzahl:= qry_MW.FieldByName('Anzahl').AsInteger;
    qry_MW.Close;
    if iAnzahl > 0 then
    begin
      qry_MW.SQL.Text:= 'Update Monatswerte ' +
                    'Set Sollzeit = :Sollzeit, ' +
                    'aktuelleMehrarbeit = :aktuelleMehrarbeit,'+
                    'IStzeit = :IStzeit, ' +
                    'Mehrarbeit = :Mehrarbeit, ' +
                    'Pausen = :Pausen, ' +
                    'Feiertag = :Feiertag, ' +
                    'Urlaub_bezahlt = :Urlaub_bezahlt, ' +
                    'Urlaub_unbezahlt = :Urlaub_unbezahlt, ' +
                    'Krank_bezahlt = :Krank_bezahlt, ' +
                    'Krank_unbezahlt = :Krank_unbezahlt, ' +
                    'Resturlaub = :Resturlaub ' +
                    'Where Monat = :Monat and Jahr = :Jahr and ID_Benutzer = :ID';
      qry_MW.ParamByName('aktuelleMehrarbeit').AsInteger:= AaktGLZ + AMehrarbeit;
      qry_MW.ParamByName('Sollzeit').AsInteger:= ASollzeit;
      qry_MW.ParamByName('IStzeit').AsInteger:= AIStzeit;
      qry_MW.ParamByName('Mehrarbeit').AsInteger:= AMehrarbeit;
      qry_MW.ParamByName('Pausen').AsInteger:= APausen;
      qry_MW.ParamByName('Feiertag').AsInteger:= AFeiertag;
      qry_MW.ParamByName('Urlaub_bezahlt').AsFloat:= AUrlaub_bezahlt;
      qry_MW.ParamByName('Urlaub_unbezahlt').AsFloat:= AUrlaub_unbezahlt;
      qry_MW.ParamByName('Krank_bezahlt').AsFloat:= AKrank_bezahlt;
      qry_MW.ParamByName('Krank_unbezahlt').AsFloat:= AKrank_unbezahlt;
      qry_MW.ParamByName('Resturlaub').AsFloat:= ARest;
      qry_MW.ParamByName('monat').AsInteger:= AMonat;
      qry_MW.ParamByName('jahr').AsInteger:= AJahr;
      qry_MW.ParamByName('ID').AsInteger:= dmmain.iUserID;
      qry_MW.ExecSQL;
    end
    else begin
      qry_MW.SQL.Text:= 'Insert into Monatswerte ' +
                    '(aktuelleMehrarbeit,Resturlaub,Sollzeit,IStzeit,Mehrarbeit,Pausen,Feiertag,Urlaub_bezahlt,Urlaub_unbezahlt,Krank_bezahlt,Krank_unbezahlt,Monat,Jahr,ID_Benutzer) Values ' +
                    '(:aktuelleMehrarbeit,:Resturlaub,:Sollzeit,:IStzeit,:Mehrarbeit,:Pausen,:Feiertag,:Urlaub_bezahlt,:Urlaub_unbezahlt,:Krank_bezahlt,:Krank_unbezahlt,:Monat,:Jahr,:ID)';
      qry_MW.ParamByName('aktuelleMehrarbeit').AsInteger:= AaktGLZ + AMehrarbeit;
      qry_MW.ParamByName('Resturlaub').AsFloat:= ARest;
      qry_MW.ParamByName('Sollzeit').AsInteger:= ASollzeit;
      qry_MW.ParamByName('IStzeit').AsInteger:= AIStzeit;
      qry_MW.ParamByName('Mehrarbeit').AsInteger:= AMehrarbeit;
      qry_MW.ParamByName('Pausen').AsInteger:= APausen;
      qry_MW.ParamByName('Feiertag').AsInteger:= AFeiertag;
      qry_MW.ParamByName('Urlaub_bezahlt').AsFloat:= AUrlaub_bezahlt;
      qry_MW.ParamByName('Urlaub_unbezahlt').AsFloat:= AUrlaub_unbezahlt;
      qry_MW.ParamByName('Krank_bezahlt').AsFloat:= AKrank_bezahlt;
      qry_MW.ParamByName('Krank_unbezahlt').AsFloat:= AKrank_unbezahlt;
      qry_MW.ParamByName('monat').AsInteger:= AMonat;
      qry_MW.ParamByName('jahr').AsInteger:= AJahr;
      qry_MW.ParamByName('ID').AsInteger:= dmmain.iUserID;
      qry_MW.ExecSQL;
    end;
    Freeandnil(qry_MW);
  end;
  function GetMehrarbeitVorMonat(AJahr,AMonat: integer): integer;
	var
	  qry_MA: TFDQuery;
	begin
    qry_MA:= TFDQuery.Create(nil);
    qry_MA.Connection:= dmmain.con_PCM;
    qry_MA.SQL.Text:= 'Select aktuelleMehrarbeit From Monatswerte Where ID_Benutzer = :ID and Jahr = :Jahr and Monat = :Monat';
    qry_MA.ParamByName('ID').AsInteger:= dmmain.iUserID;
    qry_MA.ParamByName('Jahr').AsInteger:= AJahr;
    qry_MA.ParamByName('Monat').AsInteger:= AMonat;
    qry_MA.open;
    result:= qry_MA.FieldByName('aktuelleMehrarbeit').AsInteger;
    qry_MA.close;
    Freeandnil(qry_MA);
	end;
  function GetULVorjahr(AJahr,AMonat: integer) : double;
	var
	  qry_UL: TFDQuery;
	begin
    qry_UL:= TFDQuery.Create(nil);
    qry_UL.Connection:= dmmain.con_PCM;
    qry_UL.SQL.Text:= 'Select Resturlaub From Monatswerte Where ID_Benutzer = :ID and Jahr = :Jahr and Monat = :Monat';
    qry_UL.ParamByName('ID').AsInteger:= dmmain.iUserID;
    qry_UL.ParamByName('Jahr').AsInteger:= AJahr;
    qry_UL.ParamByName('Monat').AsInteger:= AMonat;
    qry_UL.open;
    result:= qry_UL.FieldByName('Resturlaub').AsFloat;
    qry_UL.Close;
    FreeAndNil(qry_UL);
	end;
	function GetULVormonat(AJahr,AMonat: integer) : double;
	var
  	qry_UL: TFDQuery;
	begin
    qry_UL:= TFDQuery.Create(nil);
    qry_UL.Connection:= dmmain.con_PCM;
    qry_UL.SQL.Text:= 'Select Resturlaub From Monatswerte Where ID_Benutzer = :ID and Jahr = :Jahr and Monat = :Monat';
    qry_UL.ParamByName('ID').AsInteger:= dmmain.iUserID;
    qry_UL.ParamByName('Jahr').AsInteger:= AJahr;
    qry_UL.ParamByName('Monat').AsInteger:= AMonat;
    qry_UL.open;
    result:= qry_UL.FieldByName('Resturlaub').AsFloat;
    qry_UL.Close;
    FreeAndNil(qry_UL);
	end;
var
  iSollzeit: integer;
  iIStzeit: integer;
  iMehrarbeit: integer;
  iFeiertag: integer;
  iPausen: integer;
  iUrlaub_bezahlt: double;
  iUrlaub_unbezahlt: double;
  iKrank_bezahlt: double;
  iKrank_unbezahlt: double;
  fULges: double;
  fResturlaub: double;
  fULgen: double;
  fJahresAnspruch: double;
  iaktGLZ: integer;
  iVMonat: integer;
  ivJahr: integer;
  fOffsetResturlaub: double;
  iOffsetResturlaubJahr: integer;
  qry_Work1: TFDQuery;
begin
  iVMonat := AMonat -1;
  iVJahr:= Ajahr;
  if iVMonat = 0 then
  begin
    iVMonat := 12;
    iVJahr:= Ajahr-1;
  end;
  fResturlaub:= GetULVorMonat(iVJahr,iVMonat);
  iaktGLZ:= GetMehrarbeitVorMonat(iVJahr,iVMonat);
  fULgen:= GetFehltagSum(1,1,1,StartOfAMonth(AJahr,AMonat) ,EndOfAMonth(AJahr,AMonat));
  fJahresAnspruch:= 30;
  qry_Work1:= TFDQuery.Create(nil);
  qry_Work1.Connection:= dmmain.con_PCM;
  qry_Work1.SQL.Text:= 'SELECT OffsetResturlaubJahr,OffsetResturlaub From kontakte';
  qry_Work1.Open;
  fOffsetResturlaub:= qry_Work1.FieldByName('OffsetResturlaub').AsFloat;
  iOffsetResturlaubJahr:= qry_Work1.FieldByName('OffsetResturlaubJahr').AsInteger;
  qry_Work1.Close;
  if (iOffsetResturlaubJahr = iVJahr) and (iVMonat = 12) then
  begin
    fResturlaub:= fOffsetResturlaub;
  end;
  qry_Work1.SQL.Text:= 'SELECT IFNULL(SUM(SollstundenI),0) AS Sollstunden,' +
                       'IFNULL(SUM(ArbeitszeitI),0) AS Arbeitszeit,' +
                       'IFNULL(SUM(MehrarbeitI),0) AS Mehrarbeit,' +
                       'IFNULL(SUM(PausenI),0) AS Pausen,' +
                       'IFNULL(SUM(FeiertagI),0) AS Feiertag ' +
                       'FROM buchungen ' +
                       'WHERE Datum BETWEEN :Von AND :Bis';

  qry_Work1.ParamByName('Von').AsDate:= StartofAMonth(Ajahr,AMonat);
  qry_Work1.ParamByName('Bis').AsDate:= EndofAMonth(Ajahr,AMonat);
  qry_Work1.Open;
  iSollzeit:= qry_Work1.FieldByName('Sollstunden').AsInteger;
  iIStzeit:= qry_Work1.FieldByName('Arbeitszeit').AsInteger;
  iMehrarbeit:= qry_Work1.FieldByName('Mehrarbeit').AsInteger;
  iPausen:= qry_Work1.FieldByName('Pausen').AsInteger;
  iFeiertag:= qry_Work1.FieldByName('Feiertag').AsInteger;
  qry_Work1.Close;
  iUrlaub_bezahlt:= GetFehltagSum(1,1,1,StartOfAMonth(AJahr,AMonat) ,EndOfAMonth(AJahr,AMonat));
  iUrlaub_unbezahlt:= GetFehltagSum(1,1,2,StartOfAMonth(AJahr,AMonat) ,EndOfAMonth(AJahr,AMonat));
  iKrank_bezahlt:= GetFehltagSum(1,2,1,StartOfAMonth(AJahr,AMonat) ,EndOfAMonth(AJahr,AMonat));
  iKrank_unbezahlt:= GetFehltagSum(1,2,2,StartOfAMonth(AJahr,AMonat) ,EndOfAMonth(AJahr,AMonat));
  qry_Work1.close;
  Freeandnil(qry_Work1);
  if AMonat = 1 then
    fULges:=  fResturlaub - fULgen + fJahresAnspruch
  else
    fULges:=  fResturlaub - fULgen;
  WriteMonatswert(fUlges,iaktGLZ, AMonat,AJahr,iSollzeit,iIStzeit,iMehrarbeit,iPausen,iFeiertag,iUrlaub_bezahlt,iUrlaub_unbezahlt,iKrank_bezahlt,iKrank_unbezahlt);
end;
procedure BerechneTage(ATag,AMonat,AJahr: integer);
  procedure GetKorrekturAssistent(AKommen,AGehen,Pause1Beginn,Pause1Ende,Pause2Beginn,Pause2Ende,ASollStunden:TTime);
  begin
    if ASollStunden <> StrToTime('00:00') then
    begin
    end;
  end;
var
  iArbeitszeit: integer;
  iFehltag: integer;
  iFeiertag: integer;
  iMehrarbeit: integer;
  iPause1: integer;
  iPause2: integer;
  iSollstunden: integer;
  qry_Calc,qry_Calc2: TFDQuery;
begin
  qry_Calc:= TFDQuery.Create(nil);
  qry_Calc.Connection:= dmmain.con_PCM;
  qry_Calc2:= TFDQuery.Create(nil);
  qry_Calc2.Connection:= dmmain.con_PCM;
  if ATag = 0 then
  begin
    qry_Calc.SQL.Text:= 'SELECT ze_b.*, ze_FT.* FROM buchungen ze_B ' +
                        'LEFT OUTER  JOIN Fehltag ze_ft ON ze_ft.Kuerzel = ze_B.Fehltag ' +
                        'WHERE Year(ze_B.Datum) = :Jahr and Month(ze_B.Datum) = :Monat order by ze_B.Datum';
    qry_Calc.ParamByName('Monat').AsInteger:= AMonat;
    qry_Calc.ParamByName('jahr').AsInteger:= AJahr;
  end
  else begin
    qry_Calc.SQL.Text:= 'SELECT ze_b.*, ze_FT.* FROM buchungen ze_B ' +
                        'LEFT OUTER  JOIN Fehltag ze_ft ON ze_ft.Kuerzel = ze_B.Fehltag ' +
                        'WHERE ze_B.Datum = :Datum order by ze_B.Datum';
    qry_Calc.ParamByName('Datum').AsDate:= EncodeDate(AJahr,AMonat,ATag);
  end;
  qry_Calc.open;
  while not qry_Calc.eof do
  begin
     iFehltag:= 0;
    iFeiertag:= 0;
    iSollstunden:= 0;
    if qry_Calc.FieldByName('Datum').asDateTime < Date then
    begin
      iSollstunden:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
      if ((qry_Calc.FieldByName('Bezahlt').AsInteger = 1) and  (qry_Calc.FieldByName('Faktor').AsInteger = 1))  then
        iFehltag:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
      if  ((qry_Calc.FieldByName('Bezahlt').AsInteger = 1) and  (qry_Calc.FieldByName('Faktor').AsInteger = 2)) then
        iFehltag:= Round(MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00')) / 2);
      if (qry_Calc.FieldByName('Feiertag').AsInteger = 2) then
        iFeiertag:= Round(MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00')) / 2);
      if (qry_Calc.FieldByName('Feiertag').AsInteger = 1) then
        iFeiertag:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
      if (iFeiertag = iFehltag) and (iFeiertag = 480) then
        iFehltag := 0;
      iArbeitszeit:= MinutesBetween(qry_Calc.FieldByName('Gehen').asDateTime,qry_Calc.FieldByName('Kommen').asDateTime);
      iPause1:= MinutesBetween(qry_Calc.FieldByName('Pause1Ende').asDateTime,qry_Calc.FieldByName('Pause1Beginn').asDateTime);
      iPause2:= MinutesBetween(qry_Calc.FieldByName('Pause2Ende').asDateTime,qry_Calc.FieldByName('Pause2Beginn').asDateTime);
//      GetKorrekturAssistent(qry_Calc.FieldByName('Kommen').asDateTime,qry_Calc.FieldByName('Gehen').asDateTime,
//                            qry_Calc.FieldByName('Pause1Beginn').asDateTime,qry_Calc.FieldByName('Pause1Ende').asDateTime,
//                            qry_Calc.FieldByName('Pause2Beginn').asDateTime,qry_Calc.FieldByName('Pause2Ende').asDateTime,
//                            qry_Calc.FieldByName('Sollstunden').asDateTime);
    end
    else begin
      if qry_Calc.FieldByName('Datum').asDateTime = Date then
      begin
        iSollstunden:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
        if ((qry_Calc.FieldByName('Bezahlt').AsInteger = 1) and  (qry_Calc.FieldByName('Faktor').AsInteger = 1))  then
          iFehltag:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
        if  ((qry_Calc.FieldByName('Bezahlt').AsInteger = 1) and  (qry_Calc.FieldByName('Faktor').AsInteger = 2)) then
          iFehltag:= Round(MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00')) / 2);
        if (qry_Calc.FieldByName('Feiertag').AsInteger = 2) then
          iFeiertag:= Round(MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00')) / 2);
        if (qry_Calc.FieldByName('Feiertag').AsInteger = 1) then
          iFeiertag:= MinutesBetween(qry_Calc.FieldByName('Sollstunden').asDateTime,StrToTime('00:00'));
        if (iFeiertag = iFehltag) and (iFeiertag = 480) then
          iFehltag := 0;
      end;
      // Arbeitszeit
      if (qry_Calc.FieldByName('Kommen').asDateTime <> StrToTime('00:00:00')) and (qry_Calc.FieldByName('Gehen').asDateTime = StrToTime('00:00:00')) then
      begin
        iArbeitszeit:= MinutesBetween(TimeOf(Now),qry_Calc.FieldByName('Kommen').asDateTime);
      end
      else begin
        iArbeitszeit:= MinutesBetween(qry_Calc.FieldByName('Gehen').asDateTime,qry_Calc.FieldByName('Kommen').asDateTime);
      end;
      // Pause 1
      if (qry_Calc.FieldByName('Pause1Beginn').asDateTime <> StrToTime('00:00:00')) and (qry_Calc.FieldByName('Pause1Ende').asDateTime = StrToTime('00:00:00')) then
      begin
        iPause1:= 0
      end
      else begin
        iPause1:= MinutesBetween(qry_Calc.FieldByName('Pause1Ende').asDateTime,qry_Calc.FieldByName('Pause1Beginn').asDateTime);
      end;
      // Pause 2
      if (qry_Calc.FieldByName('Pause2Beginn').asDateTime <> StrToTime('00:00:00')) and (qry_Calc.FieldByName('Pause2Ende').asDateTime = StrToTime('00:00:00')) then
      begin
        iPause2:= 0
      end
      else begin
        iPause2:= MinutesBetween(qry_Calc.FieldByName('Pause2Ende').asDateTime,qry_Calc.FieldByName('Pause2Beginn').asDateTime);
      end;
    end;
    iMehrarbeit:= iArbeitszeit - iSollstunden - iPause1 - iPause2 + iFehltag + iFeiertag;
    qry_Calc2.SQL.Text:= 'Update buchungen set ' +
                              'SollstundenI = :SollstundenI,' +
                              'ArbeitszeitI = :ArbeitszeitI,' +
                              'Arbeitszeit = :Arbeitszeit,' +
                              'MehrarbeitI = :MehrarbeitI,' +
                              'Mehrarbeit = :Mehrarbeit,' +
                              'PausenI = :PausenI,' +
                              'FeiertagI = :FeiertagI ' +
                              'Where Datum = :Datum';
    qry_Calc2.ParamByname('SollstundenI').AsInteger:= iSollstunden;
    qry_Calc2.ParamByname('ArbeitszeitI').AsInteger:= iArbeitszeit - iPause1 - iPause2 + iFehltag + iFeiertag;
    if (iArbeitszeit - iPause1 - iPause2 + iFehltag + iFeiertag) < 0 then
    begin
      qry_Calc2.ParamByname('Arbeitszeit').asString:= '-' + GetTimeValue((iArbeitszeit - iPause1 - iPause2 + iFehltag + iFeiertag) * -1);
    end
    else begin
      qry_Calc2.ParamByname('Arbeitszeit').asString:= GetTimeValue(iArbeitszeit - iPause1 - iPause2 + iFehltag + iFeiertag);
    end;
    qry_Calc2.ParamByname('MehrarbeitI').AsInteger:= iMehrarbeit;
    if iMehrarbeit < 0  then
      qry_Calc2.ParamByname('Mehrarbeit').asString:= '-' + GetTimeValue(iMehrarbeit *-1)
    else
      qry_Calc2.ParamByname('Mehrarbeit').asString:= GetTimeValue(iMehrarbeit);
    qry_Calc2.ParamByname('PausenI').AsInteger:= iPause1 + iPause2;
    qry_Calc2.ParamByname('FeiertagI').AsInteger:= iFeiertag;
    qry_Calc2.ParamByname('Datum').AsDate:= qry_Calc.FieldByName('Datum').AsDateTime;
    qry_Calc2.execsql;
    qry_Calc.next;
  end;
  qry_Calc.close;
  FreeAndNil(qry_Calc2);
  FreeAndNil(qry_Calc);
end;
procedure ClearAllTablesByID(AID: Integer; AColumnName: String);
var
  bLoescheTabelle: Boolean;
  qry_TabellenInfo,
  qry_LoescheTabelle: TFDQuery;
  sTabellenName: String;
begin
  qry_TabellenInfo := TFDQuery.Create(nil);
  try
    qry_TabellenInfo.Connection := dmmain.con_PCM;
    qry_LoescheTabelle := TFDQuery.Create(nil);
    try
      qry_LoescheTabelle.Connection := dmmain.con_PCM;
      qry_TabellenInfo.Open('SELECT name FROM sqlite_master WHERE type = ''table''');
      while not qry_TabellenInfo.Eof do
      begin
        bLoescheTabelle := False;
        sTabellenName := qry_TabellenInfo.FieldByName('name').AsString;
        qry_LoescheTabelle.Open('PRAGMA table_info(' + QuotedStr(sTabellenName) + ')');
        while not qry_LoescheTabelle.Eof do
        begin
          if qry_LoescheTabelle.FieldByName('name').AsString = AColumnName then
          begin
            bLoescheTabelle := True;
            Break;
          end;
          qry_LoescheTabelle.Next;
        end;
        qry_LoescheTabelle.Close;
        if bLoescheTabelle then
          qry_LoescheTabelle.ExecSQL('DELETE FROM ' + sTabellenName + ' WHERE ' + AColumnName + ' = ' + IntToStr(AID));
        qry_TabellenInfo.Next;
      end;
    finally
      qry_LoescheTabelle.Close;
      FreeAndNil(qry_LoescheTabelle);
    end;

  finally
    qry_TabellenInfo.Close;
    FreeAndNil(qry_TabellenInfo);
  end;

end;
procedure CreateDatabase;
var
  iDatenBankVersion: integer;
  qry_ErzeugeTabelle: TFDQuery;
begin
  qry_ErzeugeTabelle:= TFDQuery.Create(nil);
  qry_ErzeugeTabelle.Connection:= dmmain.con_PCM;
  qry_ErzeugeTabelle.SQL.text:= sSQL_SELECT_USERVERSION_PRAGMASYSTEM;
  qry_ErzeugeTabelle.Open;
  iDatenBankVersion := qry_ErzeugeTabelle.FieldByName('user_Version').AsInteger;
  qry_ErzeugeTabelle.Close;
  FreeAndNil(qry_ErzeugeTabelle);
  if iDatenBankVersion < 1 then
  begin
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_SERVER);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Login);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Autologin);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_LastBooking);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_SynchBooking);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Buchungen);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Fehltag);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Fehltage);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Monatswerte);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_Kontakte);
    dmmain.con_PCM.ExecSQL(sSQL_UPDATE_USERVERSION_PRAGMASYSTEM + IntToStr(iDatenBankVersion + 1));
  end;
end;
procedure CreateDatabasePCMAPP;
var
  iDatenBankVersion: integer;
  qry_ErzeugeTabelle: TFDQuery;
begin
  qry_ErzeugeTabelle:= TFDQuery.Create(nil);
  qry_ErzeugeTabelle.Connection:= dmmain.con_PCM;
  qry_ErzeugeTabelle.SQL.text:= ssQL_SEL_PRAGMA_SYSTEM;
  qry_ErzeugeTabelle.Open;
  iDatenBankVersion := qry_ErzeugeTabelle.FieldByName('user_Version').AsInteger;
  qry_ErzeugeTabelle.Close;
  FreeAndNil(qry_ErzeugeTabelle);
  if iDatenBankVersion < 1 then
  begin
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_ServerAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_LoginAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_AutologinAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_KontakteAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_KalenderAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_PasswordsAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_SerialsAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_EinnahmenAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_AusgabenAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_BelegeAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_GutscheinAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_CalAboAPP);
    dmmain.con_PCM.ExecSQL(sSQL_CREATE_TABLE_TempCalAPP);
    dmmain.con_PCM.ExecSQL(sSQL_UPDATE_USERVERSION_PRAGMASYSTEM + IntToStr(iDatenBankVersion + 1));
  end;
end;
procedure DeleteAllTables;
begin
  dmmain.con_PCM.ExecSQL(sSQL_UPDATE_WRITABLE_SCHEMA_PRAGMASYSTEM + '1');
  dmmain.con_PCM.ExecSQL(sSQL_DELETE_ALL_TABLES_SYSTEM);
  dmmain.con_PCM.ExecSQL(sSQL_UPDATE_WRITABLE_SCHEMA_PRAGMASYSTEM + '0');
  dmmain.con_PCM.ExecSQL(sSQL_UPDATE_USERVERSION_PRAGMASYSTEM + '0');
  dmmain.con_PCM.Connected := False;
  dmmain.con_PCM.Connected := True;
end;
procedure WriteLog(AMessage: String; ATyp: Integer; ANewFile: boolean);
var
  sTyp: String;
  sTag: String;
  sPath: string;
  {$IFDEF Android}
  slLog: TStringList;
  {$ENDIF Android}
  {$IFDEF MSWINDOWS}
  f: TextFile;
  {$ENDIF MSWINDOWS}
  qry_Log: TFDQuery;
  iLog: integer;
begin
  qry_Log:= TFDQuery.Create(nil);
  qry_Log.Connection:= dmmain.con_PCM;
  qry_Log.SQL.text:= 'Select ifnull(Log,1) AS Log From Auto_login';
  qry_Log.Open;
  if qry_Log.RecordCount = 0 then
    iLog:= 0
  else
    iLog := qry_Log.FieldByName('Log').AsInteger;
  qry_Log.Close;
  FreeAndNil(qry_log);
  if iLog = 0 then
  begin
    exit;
  end;
  case ATyp of
  0: sTyp:= ' Hinweis: ';
  1: sTyp:= ' Warnung: ';
  2: sTyp:= ' Fehler: ';
  end;

  case DayOfWeek(Date) of
  1: sTag := 'So';
  2: sTag := 'Mo';
  3: sTag := 'Di';
  4: sTag := 'Mi';
  5: sTag := 'Do';
  6: sTag := 'Fr';
  7: sTag := 'Sa';
  end;

  {$IFDEF Android}
  try
    sPath := system.IOUtils.TPath.Combine(system.IOUtils.TPath.GetSharedDocumentsPath, 'Logs');
    if not system.IOUtils.TDirectory.Exists(sPath) then
    begin
      system.IOUtils.TDirectory.CreateDirectory(sPath);
    end;
    Try
      system.IOUtils.TFile.OpenWrite(system.IOUtils.TPath.Combine(sPath, 'PCMAPP.txt'));
    except
      system.IOUtils.TFile.WriteAllText(system.IOUtils.TPath.Combine(sPath, 'PCMAPP.txt'),FormatDateTime('dd.mm.yyyy hh:mm:ss', Now) +  sTyp + AMessage);
    end;
    if not ANewFile then
    begin
      slLog:= TStringList.Create;
      try
        slLog.LoadFromFile(system.IOUtils.TPath.Combine(sPath, 'PCMAPP.txt'));
        slLog.Add(FormatDateTime('dd.mm.yyyy hh:mm:ss', Now) +  sTyp + AMessage);
        slLog.SaveToFile(system.IOUtils.TPath.Combine(sPath, 'PCMAPP.txt'));
      finally
        FreeandNil(slLog);
      end;
    end
    else begin
      system.IOUtils.TFile.WriteAllText(system.IOUtils.TPath.Combine(sPath, 'PCMAPP.txt'),FormatDateTime('dd.mm.yyyy hh:mm:ss', Now) +  sTyp + AMessage);
    end;
  except
  end;
  {$ENDIF Android}
  {$IFDEF MSWINDOWS}
  if not DirectoryExists(GetEnvironmentVariable('LOCALAPPDATA') + '\PCM') then
    CreateDir(GetEnvironmentVariable('LOCALAPPDATA') + '\PCM');
  sPath := GetEnvironmentVariable('LOCALAPPDATA') + '\PCM\PCMTime' + sTag + '.log';
  AssignFile(f, sPath);
  if FileExists(sPath) then
    Append(f)
  else
    Rewrite(f);
  Writeln(f, DateTimeToStr(Now()) + ' ' + sTyp + AMessage);
  CloseFile(f);
  {$ENDIF MSWINDOWS}
end;
{$EndRegion procedures}
end.
