unit U_Frame_Weitere;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FireDAC.Stan.Def, FireDAC.FMXUI.Wait, FMX.Gestures, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FMX.Objects, FMX.Controls.Presentation,
  FMX.ListBox, FMX.Layouts,FMX.DialogService.Async;

type
  TFrameWeitere = class(TFrame)
    FDSQLiteBackup1: TFDSQLiteBackup;
    gstmagrSystem: TGestureManager;
    lbMainMenu: TListBox;
    li1PCMNotenrechner: TListBoxItem;
    Image2: TImage;
    Label10: TLabel;
    li2li1PCMVokabeltrainer: TListBoxItem;
    Image5: TImage;
    Label12: TLabel;
    li3PCMFitness: TListBoxItem;
    Image11: TImage;
    Label6: TLabel;
    Line38: TLine;
    Line1: TLine;
    Line2: TLine;
    procedure li3PCMFitnessClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure Execute;
  end;

implementation

{$R *.fmx}

uses U_Main, U_dm_Main, U_Main_Fitness;//, U_Main_Fitness;

procedure TFrameWeitere.Execute;
begin
  frmMain.tcMore.ActiveTab := frmMain.ti1ConfigConfig;
  frmMain.lblModulName.Text := 'Weitere Module';
  frmMain.DisableToolButtons;
  frmMain.btnSynchronisation.Visible := True;
  frmMain.btnBackSystem.Visible := True;
end;
procedure TFrameWeitere.li3PCMFitnessClick(Sender: TObject);
begin
//  case frmmain.iTag of
//    1:
//    begin
//      frmmain.tcMainApp.ActiveTab:= frmmain.ti2MainKontakte;
//      frmmain.btnbackSystem.visible:= false;
//    end;
//    2:
//    begin
//      frmmain.tcMainApp.ActiveTab:= frmmain.ti3MainKalender;
//      frmmain.btnbackSystem.visible:= false;
//    end;
//    3:
//    begin
//      frmmain.tcMainApp.ActiveTab:= frmmain.ti4MainPasswort;
//      frmmain.btnbackSystem.visible:= false;
//    end;
//    4:
//    begin
//      frmmain.tcMainApp.ActiveTab:= frmmain.ti5MainFinanzen;
//      frmmain.btnbackSystem.visible:= false;
//    end;
//  end;
//  frmMainFit.Show
end;

end.
