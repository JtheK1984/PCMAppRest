unit PCMAPP.BackgroundTasks;

interface

uses System.SysUtils;

procedure RunAppTask(const Work: TProc);
procedure BeginAppShutdown;
function AppTasksIdle: Boolean;

implementation

uses System.Classes, System.Threading, System.Generics.Collections;

var Tasks: TList<ITask>; Closing: Boolean;

procedure PruneTasks;
var I: Integer;
begin
  for I := Tasks.Count - 1 downto 0 do
    if Tasks[I].Status in [TTaskStatus.Completed, TTaskStatus.Canceled,
      TTaskStatus.Exception] then Tasks.Delete(I);
end;

procedure RunAppTask(const Work: TProc);
var Task: ITask;
begin
  TMonitor.Enter(Tasks);
  try
    if Closing then Exit;
    PruneTasks;
    Task := TTask.Create(Work);
    Tasks.Add(Task);
    Task.Start;
  finally TMonitor.Exit(Tasks); end;
end;

procedure BeginAppShutdown;
begin
  TMonitor.Enter(Tasks);
  try Closing := True; finally TMonitor.Exit(Tasks); end;
end;

function AppTasksIdle: Boolean;
begin
  TMonitor.Enter(Tasks);
  try
    PruneTasks;
    Result := Tasks.Count = 0;
  finally TMonitor.Exit(Tasks); end;
end;

initialization
  Tasks := TList<ITask>.Create;
finalization
  Tasks.Free;
end.
