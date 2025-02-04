unit PCMAPP.Kalenderabo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Threading;

type
  TFrameAbo = class(TFrame)
    lvCalabo: TListView;
    qryCalAbo: TFDQuery;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure Execute;
  end;

implementation

{$R *.fmx}

uses PCMApp.Main,PCMAPP.Datamodul;

procedure TFrameAbo.Execute;
var
  i: integer;
  TextColor: Cardinal;
begin
  lvCalabo.BeginUpdate;

  lvCalabo.EndUpdate;
  frmMain.tcMore.ActiveTab := frmMain.ti1ConfigConfig;
  frmMain.lblModulName.Text := 'Kalenderabo';
  frmMain.Set_DisableToolButtons;
  frmMain.btnSynchronisation.Visible := True;
  frmMain.btnBackSystem.Visible := True;
end;

end.
