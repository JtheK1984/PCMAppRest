unit PCMAPP.Datamodul;

interface

uses
  {$Region Uses}
  {$IFDEF ANDROID}
  Posix.Unistd,
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
  FireDAC.Comp.UI,
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
  FMX.Controls,
  FMX.dialogs,
  FMX.Forms,
  FMX.ImgList,
  FMX.Types,
  IdIPAddress,
  IdSSLOpenSSL,
  IdGlobal,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdStack,
  IdTCPClient,
  IdTCPConnection,
  IniFiles,
  IPPeerClient,
  REST.Authenticator.Basic,
  REST.Backend.BindSource,
  REST.Backend.KinveyProvider,
  REST.Backend.PushTypes,
  REST.Client,
  REST.Types,
  System.Beacon,
  System.Beacon.Components,
  System.Bluetooth,
  System.Bluetooth.Components,
  System.Classes,
  System.ImageList,
  System.IOUtils,
  System.JSON,
  System.Notification,
  System.PushNotification,
  System.Sensors,
  System.Sensors.Components,
  System.SysUtils,
  PCMAPP.WaitForm, System.Net.URLClient, System.Net.HttpClient;
  {$EndRegion Uses}
type
  {$Region Types}
  Tdmmain = class(TDataModule)
    con_PCM: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    con_Restore: TFDConnection;
    locsens_Location: TLocationSensor;
    physdrvlnk: TFDPhysSQLiteDriverLink;
    stB_0: TStyleBook;
    stB_1: TStyleBook;
    stB_2: TStyleBook;
    stB_3: TStyleBook;
    stB_4: TStyleBook;
    imglst_Frame: TImageList;
    RestRequestGoogle: TRESTRequest;
    RESTClientPCM: TRESTClient;
    HTTPBasicAuthenticatorPCM: THTTPBasicAuthenticator;
    procedure con_PCMAfterConnect(Sender: TObject);
    procedure con_PCMBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure locsens_LocationLocationChanged(Sender: TObject; const [Ref] OldLocation, NewLocation: TLocationCoord2D);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    bServerAvailable: boolean;
    fLat, fLon: Double;
    iUserID: Integer;
    sDeviceId: string;
    sDeviceToken: string;
    sHostname, sPort: String;
    wfWaitFrame: TWaitForm;
    function RestRequest(ARequestBody: TJSONObject; AResource: String; AGETPOST: TRESTRequestMethod = rmPOST; const AUsername: string = ''; const APassword: string = ''): TJSONObject;
  end;
  {$EndRegion Types}
var
  {$Region Var}
  dmmain: Tdmmain;
  {$EndRegion Var}
implementation
{%CLASSGROUP 'FMX.Controls.TControl'}
uses
  {$Region Uses}
  PCMAPP.CalendarFields,
  PCMAPP.Funktionen,
  PCMAPP.Main,
  PCMAPP.SQL;
  {$EndRegion Uses}
{$R *.dfm}
function Tdmmain.RestRequest(ARequestBody: TJSONObject; AResource: String;
  AGETPOST: TRESTRequestMethod; const AUsername, APassword: string): TJSONObject;
var
  LClient: TRESTClient;
  LAuth: THTTPBasicAuthenticator;
  LRequest: TRESTRequest;
  LQuery: TFDQuery;
  LJSON: TJSONValue;
  LUsername, LPassword: string;
begin
  Result := nil;
  LUsername := AUsername;
  LPassword := APassword;
  if LUsername = '' then
  begin
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := CurrentPCMConnection;
      LQuery.SQL.Text := sSQL_SEL_All_AUtologin;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        LUsername := LQuery.FieldByName('Benutzername').AsString;
        LPassword := LQuery.FieldByName('Passwort').AsString;
      end
      else begin
        LUsername := frm_PCM_Main.edt_Benutzername.text;
        LPassword := frm_PCM_Main.edt_Passwort.text;
      end;
    finally
      LQuery.Free;
    end;
  end;
  if LUsername = '' then
    raise Exception.Create('REST: kein Benutzername vorhanden');
  if sHostname = '' then
    raise Exception.Create('REST: kein Server konfiguriert');
  LClient := TRESTClient.Create(nil);
  LAuth := THTTPBasicAuthenticator.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  try
    LAuth.Username := LUsername;
    LAuth.Password := LPassword;
    LClient.Authenticator := LAuth;
    LClient.BaseURL := 'https://' + sHostname + ':' + sPort + '/PCM/api/v1/';
    LRequest.Client := LClient;
    LRequest.Timeout := 30000;
    LRequest.AcceptEncoding := 'gzip, deflate';
    LRequest.Method := AGETPOST;
    LRequest.Resource := AResource;
    if ARequestBody <> nil then
      LRequest.Body.Add(ARequestBody.ToJSON, ctAPPLICATION_JSON);
    LRequest.Execute;
    if (LRequest.Response.StatusCode < 200) or (LRequest.Response.StatusCode >= 300) then
      raise Exception.CreateFmt('REST %s: HTTP %d', [AResource, LRequest.Response.StatusCode]);
    LJSON := TJSONObject.ParseJSONValue(LRequest.Response.JSONText);
    if not (LJSON is TJSONObject) then
    begin
      LJSON.Free;
      raise Exception.Create('REST ' + AResource + ': ung??ltige JSON-Antwort');
    end;
    Result := TJSONObject(LJSON);
  finally
    LRequest.Free;
    LClient.Free;
    LAuth.Free;
  end;
end;
////////////////////////////////////////////////////////////////////////////////
// DATAMODUL FUNCTIONS                                                        //
////////////////////////////////////////////////////////////////////////////////
{$Region DATAMODUL FUNCTIONS}
procedure Tdmmain.con_PCMAfterConnect(Sender: TObject);
begin
  CreateDatabasePCMAPP;
end;
procedure Tdmmain.con_PCMBeforeConnect(Sender: TObject);
begin
  ConfigureCalendarFields(con_PCM);
  con_PCM.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'PCMApp.s3db');
end;
procedure Tdmmain.DataModuleCreate(Sender: TObject);
begin
  con_PCM.Connected := True;
end;
procedure Tdmmain.DataModuleDestroy(Sender: TObject);
begin
  con_PCM.Connected := False;
  con_Restore.Connected := False;
  locsens_Location.Active := False;
end;
procedure Tdmmain.locsens_LocationLocationChanged(Sender: TObject; const [Ref] OldLocation, NewLocation: TLocationCoord2D);
begin
  fLat  := NewLocation.Latitude;
  fLon := NewLocation.Longitude;
end;
{$EndRegion DATAMODUL FUNCTIONS}
end.



