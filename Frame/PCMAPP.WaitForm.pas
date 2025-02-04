unit PCMAPP.WaitForm;

interface

uses
  {$Region Uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Effects, System.Threading;
  {$EndRegion Uses}
type
  {$Region Types}
  TWaitForm = class(TFrame)
    anInd_Wait: TAniIndicator;
    lbl_WaitText: TLabel;
    lo_FrameWait: TLayout;
    rec_Main: TRectangle;
    rec_FrameWait: TRectangle;
    lo_FrameWaitHeader: TLayout;
    lbl_WaitTitle: TLabel;
    ln_FrameWait: TLine;
    lo_FrameWaitDetail: TLayout;
    shef_FrameWait: TShadowEffect;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Execute(AWaitText, AWaitTitle: String; bShow: Boolean);
    procedure HideFW;
    procedure SetWaitMessage(AWaitText, AWaitTitle: String);
  end;
  {$Region Types}

implementation

{$R *.fmx}

uses  PCMAPP.Main;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
constructor TWaitForm.Create(AOwner: TComponent);
  procedure SetDesign;
  var
    RecColor,TextColor: Cardinal;
    iDesignStyle: Integer;
  begin
    TextColor:=TAlphaColorRec.White;
    RecColor:=TAlphaColorRec.White;
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    {$ENDIF MSWINDOWS}

    case iDesignStyle of
      0: // Calypso
      begin
        TextColor:= TAlphaColorRec.White;
        RecColor:= $FF223D5A;
      end;
      1: // Diamond
      begin
        TextColor:= TAlphaColorRec.Black;
        {$IFDEF MSWINDOWS}
        RecColor:= $FF3DC9ED;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        RecColor:= $FFE67A6E;
        {$ENDIF ANDROID}
      end;
      2:
      begin
        TextColor:= TAlphaColorRec.White;
        {$IFDEF MSWINDOWS}
        RecColor:= $FF936639;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        RecColor:= $FF2B2B2B;
        {$ENDIF ANDROID}
      end;
      3:
      begin
        TextColor:= TAlphaColorRec.White;
        {$IFDEF MSWINDOWS}
        RecColor:= $FF0E7F9C;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        RecColor:= $FF202A2E;
        {$ENDIF ANDROID}
      end;
      {$IFDEF MSWINDOWS}
      4: // Ubuntu Rot
      begin
        TextColor:= TAlphaColorRec.White;
        RecColor:= $FF250C12;
      end;
      {$ENDIF MSWINDOWS}
    end;
    lbl_WaitTitle.FontColor:= TextColor;
    lbl_WaitText.FontColor:= TextColor;
    rec_FrameWait.Fill.Color:= RecColor;
  end;
begin
  inherited;
  SetDesign;
end;
procedure TWaitForm.Execute(AWaitText, AWaitTitle: String; bShow: Boolean);
begin
  lbl_WaitText.Text := AWaitText;
  lbl_WaitTitle.Text := AWaitTitle;
  lo_FrameWait.BringToFront;
  if Visible = False then
  begin
    anInd_Wait.BringToFront;
    anInd_Wait.Enabled := bShow;
    anInd_Wait.Visible := bShow;
    Visible := True;
  end;
end;
procedure TWaitForm.HideFW;
begin
  TThread.Synchronize(nil,
  procedure()  begin
    Visible := False;
    anInd_Wait.Enabled := False;
  end);
end;
procedure TWaitForm.SetWaitMessage(AWaitText, AWaitTitle: String);
begin
  TThread.Synchronize(nil,
  procedure()
  begin
    lbl_WaitText.Text := AWaitText;
    lbl_WaitTitle.Text := AWaitTitle;
//    anInd_Wait.BringToFront;
//    anInd_Wait.Enabled := true;
//    anInd_Wait.Visible := true;
//    Visible := True;
  end);
end;
{$EndRegion Helperfunctions}
end.
