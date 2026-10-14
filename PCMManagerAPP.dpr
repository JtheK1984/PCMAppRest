program PCMManagerAPP;



uses
  PCMAPP.CalendarFields in 'Helper\PCMAPP.CalendarFields.pas',
  System.StartUpCopy,
  FMX.Forms,
  PCMAPP.Main in 'PCMAPP.Main.pas' {frm_PCM_Main},
  PCMAPP.Datamodul in 'DB\PCMAPP.Datamodul.pas' {dmmain: TDataModule},
  PCMAPP.CalendarHolidayDays.Style in 'Helper\PCMAPP.CalendarHolidayDays.Style.pas',
  PCMAPP.Calendar.Helpers in 'Helper\PCMAPP.Calendar.Helpers.pas',
  PCMAPP.Import.Kontakte in 'Frame\PCMAPP.Import.Kontakte.pas' {frm_PCMAPP_ImportKontakte: TFrame},
  PCMAPP.Server in 'Frame\PCMAPP.Server.pas' {frm_PCMAPP_Server},
  PCMAPP.System in 'Frame\PCMAPP.System.pas' {frm_PCMAPP_System: TFrame},
  PCMAPP.WaitForm in 'Frame\PCMAPP.WaitForm.pas' {WaitForm: TFrame},
  PCMApp.Ausgaben.Detail in 'FrameDetail\PCMApp.Ausgaben.Detail.pas' {frm_PCMAPP_AusgabenDetail},
  PCMApp.Belege.Detail in 'FrameDetail\PCMApp.Belege.Detail.pas' {frm_PCMAPP_BelegeDetail},
  PCMAPP.Einnahmen.Detail in 'FrameDetail\PCMAPP.Einnahmen.Detail.pas' {frm_PCMAPP_EinnahmenDetail},
  PCMAPP.Gutschein.Barcode in 'FrameDetail\PCMAPP.Gutschein.Barcode.pas' {frm_PCMAPP_GutscheinBarcodeDetail},
  PCMAPP.Gutschein.Detail in 'FrameDetail\PCMAPP.Gutschein.Detail.pas' {frm_PCMAPP_GutscheinDetail},
  PCMAPP.Kalender.Detail in 'FrameDetail\PCMAPP.Kalender.Detail.pas' {frm_PCMAPP_KalenderDetail},
  PCMAPP.Kalenderabo.Detail in 'FrameDetail\PCMAPP.Kalenderabo.Detail.pas' {frm_PCMAPP_CalAboDetail},
  PCMAPP.Kontakte.Detail in 'FrameDetail\PCMAPP.Kontakte.Detail.pas' {frm_PCMAPP_KontakteDetail},
  PCMAPP.Passwort.Detail in 'FrameDetail\PCMAPP.Passwort.Detail.pas' {frm_PCMAPP_PasswortDetail},
  PCMAPP.Serial.Detail in 'FrameDetail\PCMAPP.Serial.Detail.pas' {frm_PCMAPP_SerialDetail},
  PCMAPP.Ical in 'Helper\PCMAPP.Ical.pas',
  PCMAPP.SQL in 'SQL\PCMAPP.SQL.pas' {$R *.res},
  PCMApp.Funktionen in 'Helper\PCMApp.Funktionen.pas',
  PCMAPP.ContactSync in 'PCMAPP.ContactSync.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(Tdmmain, dmmain);
  Application.CreateForm(Tfrm_PCM_Main, frm_PCM_Main);
  Application.Run;
end.
