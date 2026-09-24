program ContactSyncTests;
{$APPTYPE CONSOLE}
uses System.SysUtils, System.JSON, Data.DB, FireDAC.Comp.Client,
 FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Def,
 FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.SQLite,
 FireDAC.Phys.SQLiteWrapper.Stat,
 PCMAPP.ContactSync in '..\PCMAPP.ContactSync.pas';
var C: TFDConnection; A: TJSONArray; Passed: Integer;
procedure Check(Value: Boolean; const Msg: string);
begin if not Value then raise Exception.Create(Msg); end;
procedure Reset;
begin
 C.ExecSQL('DELETE FROM Kontakte'); A.Free; A := TJSONArray.Create;
end;
procedure Local(ID, ServerID: Integer; const Phone: string);
begin
 C.ExecSQL('INSERT INTO Kontakte (ID,Kontakte_ID,Vorname,Nachname,Firma,Telefon,Geaendertam) VALUES (?,?,''Anna'',''Test'','''',?,''2026-09-24 12:00:00'')',[ID,ServerID,Phone]);
end;
procedure Remote(ID: Integer; const Phone: string);
var O: TJSONObject;
begin
 O := TJSONObject.Create;
 O.AddPair('ID', TJSONNumber.Create(ID)); O.AddPair('Name','Anna');
 O.AddPair('Surname','Test'); O.AddPair('Company','');
 O.AddPair('Phone_private',Phone); A.AddElement(O);
end;
procedure Reject(const Msg: string);
var Raised: Boolean;
begin
 Raised := False;
 try ReconcileContactIDs(C,A); except on E: Exception do Raised := True; end;
 Check(Raised,Msg); Inc(Passed);
end;
begin
 Passed := 0; A := nil; C := TFDConnection.Create(nil);
 try
 C.Params.Values['DriverID'] := 'SQLite'; C.Params.Values['Database'] := ':memory:';
 C.LoginPrompt := False; C.Connected := True;
 C.ExecSQL('CREATE TABLE Kontakte(ID INTEGER PRIMARY KEY, Kontakte_ID INTEGER, Vorname TEXT, Nachname TEXT, Firma TEXT, Telefon TEXT, Handy TEXT, TelefonFirma TEXT, HandyFirma TEXT, Email TEXT, EmailFirma TEXT, Deleted INTEGER, Geaendertam TEXT)');
 Reset; Local(1,0,'12345'); Remote(42,'12345');
 ReconcileContactIDs(C,A); ReconcileContactIDs(C,A);
 Check(C.ExecSQLScalar('SELECT Kontakte_ID FROM Kontakte WHERE ID=1')=42,'server ID not linked');
 Check(C.ExecSQLScalar('SELECT COUNT(*) FROM Kontakte')=1,'duplicate after repeat');
 Check(C.ExecSQLScalar('SELECT COUNT(*) FROM Kontakte WHERE Geaendertam IS NOT NULL')=1,'dirty flag lost'); Inc(Passed);
 Reset; Local(1,0,'12345'); ReconcileContactIDs(C,A);
 Check(C.ExecSQLScalar('SELECT Kontakte_ID FROM Kontakte')=0,'new contact incorrectly linked');
 Remote(42,'12345'); ReconcileContactIDs(C,A);
 Check(C.ExecSQLScalar('SELECT Kontakte_ID FROM Kontakte')=42,'post-upload mapping failed'); Inc(Passed);
 Reset; Local(1,0,'12345'); Local(2,0,'12345'); Remote(42,'12345'); Reject('local duplicates not rejected');
 Reset; Local(1,0,'12345'); Remote(42,'12345'); Remote(43,'12345'); Reject('server duplicates not rejected');
 Reset; Local(1,0,'12345'); Remote(42,'99999'); Reject('namesake falsely matched');
 Reset; Local(1,0,''); Remote(42,''); Reject('name-only falsely matched');
 Reset; Local(1,42,'12345'); Local(2,0,'12345'); Remote(42,'12345'); Reject('already linked duplicate accepted');
 Reset; Local(1,0,'12345'); Local(2,0,''); Remote(42,'12345'); Reject('invalid batch accepted');
 Check(C.ExecSQLScalar('SELECT Kontakte_ID FROM Kontakte WHERE ID=1')=0,'partial mapping despite failure');
 Reset; Local(1,42,'12345'); Remote(42,'99999'); ReconcileContactIDs(C,A);
 Check(C.ExecSQLScalar('SELECT Kontakte_ID FROM Kontakte')=42,'known ID changed'); Inc(Passed);
 Reset; Local(1,0,'12345'); Remote(0,'12345'); Reject('invalid ID accepted');
 Writeln('PASS: ',Passed,' contact reconciliation scenarios');
 finally A.Free; C.Free; end;
end.
