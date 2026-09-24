unit PCMAPP.ContactSync;

interface

uses System.SysUtils, System.JSON, System.Generics.Collections, Data.DB,
  FireDAC.Comp.Client;

procedure ReconcileContactIDs(AConnection: TFDConnection; AContacts: TJSONArray);

implementation

type
  TContactRef = record
    LocalID, ServerID: Integer;
    Key, NameKey: string;
  end;

function Part(const S: string): string;
var V: string;
begin
  V := LowerCase(Trim(S));
  Result := IntToStr(Length(V)) + ':' + V;
end;

function ContactKey(const FirstName, LastName, Company, Phone, Mobile,
  WorkPhone, WorkMobile, Email, WorkEmail: string): string;
begin
  // Require more than a name: never join namesakes based on their name alone.
//  if ((Trim(FirstName + LastName + Company) = '') or
//      (Trim(Phone + Mobile + WorkPhone + WorkMobile + Email + WorkEmail) = '')) then
  if ((Trim(FirstName + LastName + Company) = '')) then
    Exit('');
  // Keep phone numbers exact; country codes/extensions must not be guessed.
  Result := Part(FirstName) + Part(LastName) + Part(Company) + Part(Phone) +
    Part(Mobile) + Part(WorkPhone) + Part(WorkMobile) + Part(Email) + Part(WorkEmail);
end;

function JSONString(AValue: TJSONValue; const AName: string): string;
begin
  Result := '';
  AValue.TryGetValue<string>(AName, Result);
end;

procedure ReconcileContactIDs(AConnection: TFDConnection; AContacts: TJSONArray);
var
  Q: TFDQuery;
  Local: TList<TContactRef>;
  RemoteIDs, RemoteCounts, LocalCounts: TDictionary<string, Integer>;
  LinkedIDs: TDictionary<Integer, Integer>;
  RemoteNames: TDictionary<string, Boolean>;
  V: TJSONValue;
  R: TContactRef;
  Key, NameKey: string;
  ID, Count, ExistingID: Integer;
  OwnTransaction: Boolean;
begin
  Local := TList<TContactRef>.Create;
  RemoteIDs := TDictionary<string, Integer>.Create;
  RemoteCounts := TDictionary<string, Integer>.Create;
  LocalCounts := TDictionary<string, Integer>.Create;
  LinkedIDs := TDictionary<Integer, Integer>.Create;
  RemoteNames := TDictionary<string, Boolean>.Create;
  Q := TFDQuery.Create(nil);
  try
    for V in AContacts do
    begin
      ID := 0;
      if not V.TryGetValue<Integer>('ID', ID) or (ID <= 0) then
        raise Exception.Create('Kontaktdownload: ungueltige Server-ID');
      NameKey := Part(JSONString(V,'Name')) + Part(JSONString(V,'Surname')) + Part(JSONString(V,'Company'));
      RemoteNames.AddOrSetValue(NameKey, True);
      Key := ContactKey(JSONString(V,'Name'), JSONString(V,'Surname'),
        JSONString(V,'Company'), JSONString(V,'Phone_private'),
        JSONString(V,'Mobile_private'), JSONString(V,'Phone_business'),
        JSONString(V,'Mobile_business'), JSONString(V,'Mail_private'),
        JSONString(V,'Mail_business'));
      if Key = '' then Continue;
      Count := 0;
      RemoteCounts.TryGetValue(Key, Count);
      RemoteCounts.AddOrSetValue(Key, Count + 1);
      RemoteIDs.AddOrSetValue(Key, ID);
    end;
    Q.Connection := AConnection;
    Q.Open('SELECT ID, Kontakte_ID, Vorname, Nachname, Firma, Telefon, Handy, ' +
      'TelefonFirma, HandyFirma, Email, EmailFirma FROM Kontakte WHERE IFNULL(Deleted,0)=0');
    while not Q.Eof do
    begin
      R.LocalID := Q.FieldByName('ID').AsInteger;
      R.ServerID := Q.FieldByName('Kontakte_ID').AsInteger;
      R.NameKey := Part(Q.FieldByName('Vorname').AsString) + Part(Q.FieldByName('Nachname').AsString) + Part(Q.FieldByName('Firma').AsString);
      R.Key := ContactKey(Q.FieldByName('Vorname').AsString,
        Q.FieldByName('Nachname').AsString, Q.FieldByName('Firma').AsString,
        Q.FieldByName('Telefon').AsString, Q.FieldByName('Handy').AsString,
        Q.FieldByName('TelefonFirma').AsString, Q.FieldByName('HandyFirma').AsString,
        Q.FieldByName('Email').AsString, Q.FieldByName('EmailFirma').AsString);
      Local.Add(R);
      if R.ServerID > 0 then LinkedIDs.AddOrSetValue(R.ServerID, R.LocalID);
      if R.Key <> '' then
      begin
        Count := 0;
        LocalCounts.TryGetValue(R.Key, Count);
        LocalCounts.AddOrSetValue(R.Key, Count + 1);
      end;
      Q.Next;
    end;
    Q.Close;
    // Validate everything before changing any mapping or sending any upload.
    for R in Local do
      if R.ServerID <= 0 then
      begin
        if R.Key = '' then
          raise Exception.CreateFmt('Kontakt ID %d: Zuordnung ohne Telefonnummer oder E-Mail nicht sicher. Kontakt bitte pruefen.', [R.LocalID]);
        if not RemoteIDs.ContainsKey(R.Key) and RemoteNames.ContainsKey(R.NameKey) then
          raise Exception.CreateFmt('Kontakt ID %d: gleicher Name mit abweichenden Kontaktdaten auf dem Server. Bitte Zuordnung pruefen; kein erneuter Upload.', [R.LocalID]);
        if LocalCounts[R.Key] > 1 then
          raise Exception.CreateFmt('Kontakt ID %d: mehrere gleiche lokale Kontakte. Bitte Duplikate pruefen; kein erneuter Upload.', [R.LocalID]);
        if RemoteCounts.TryGetValue(R.Key, Count) then
        begin
          if Count > 1 then
            raise Exception.CreateFmt('Kontakt ID %d: mehrere passende Serverkontakte. Bitte Duplikate pruefen; kein erneuter Upload.', [R.LocalID]);
          ID := RemoteIDs[R.Key];
          if LinkedIDs.TryGetValue(ID, ExistingID) and (ExistingID <> R.LocalID) then
            raise Exception.CreateFmt('Kontakt ID %d: Serverkontakt ist bereits lokal zugeordnet. Bitte Duplikate pruefen.', [R.LocalID]);
        end;
      end;
    OwnTransaction := not AConnection.InTransaction;
    if OwnTransaction then AConnection.StartTransaction;
    try
      for R in Local do
        if (R.ServerID <= 0) and RemoteIDs.TryGetValue(R.Key, ID) then
          AConnection.ExecSQL('UPDATE Kontakte SET Kontakte_ID = :ServerID ' +
            'WHERE ID = :LocalID AND IFNULL(Kontakte_ID,0)<=0', [ID, R.LocalID]);
      if OwnTransaction then AConnection.Commit;
    except
      if OwnTransaction then AConnection.Rollback;
      raise;
    end;
  finally
    Q.Free;
    RemoteNames.Free;
    LinkedIDs.Free;
    LocalCounts.Free;
    RemoteCounts.Free;
    RemoteIDs.Free;
    Local.Free;
  end;
end;
end.

