unit PCMAPP.CalendarFields;

interface

uses FireDAC.Comp.Client;

procedure ConfigureCalendarFields(const Connection: TFDConnection);

implementation

uses FireDAC.Stan.Option, FireDAC.Stan.Intf;

procedure ConfigureCalendarFields(const Connection: TFDConnection);
begin
  // Old SQLite databases declare Message as VARCHAR(255), although SQLite
  // stores longer values. Map the field before any query creates its fields.
  Connection.FormatOptions.OwnMapRules := True;
  with Connection.FormatOptions.MapRules.Add do
  begin
    NameMask := 'Message';
    TargetDataType := dtWideMemo;
  end;
end;

end.
