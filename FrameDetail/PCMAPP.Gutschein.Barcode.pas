unit PCMAPP.Gutschein.Barcode;

interface

uses
  {$Region Uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Gestures, FMX.Controls.Presentation, FMX.Layouts,System.Threading;
  {$EndRegion Uses}
type
  {$Region Type}
  Tfrm_PCMAPP_GutscheinBarcodeDetail = class(TForm)
    btn_Back: TButton;
    img_BarCode: TImage;
    lbl_ModulName: TLabel;
    lo_Left: TLayout;
    rec_Barcode: TRectangle;
    tb_Main: TRectangle;
    procedure btn_BackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;  var Handled: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    iLastDistance: Integer;
  public
    { Public declarations }
  end;
  {$EndRegion Type}
var
  frm_PCMAPP_GutscheinBarcodeDetail: Tfrm_PCMAPP_GutscheinBarcodeDetail;

implementation

{$R *.fmx}

uses
  System.Math, PCMApp.Main, PCMApp.Datamodul;

////////////////////////////////////////////////////////////////////////////////
// Button FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Buttonfunctions}
procedure Tfrm_PCMAPP_GutscheinBarcodeDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_GutscheinBarcodeDetail.close;
end;
{$EndRegion Buttonfunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCMAPP_GutscheinBarcodeDetail.FormCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_GutscheinBarcodeDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_GutscheinBarcodeDetail.FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  ctrlObj: IControl;
  img_Barcode: TImage;
  dImageCenter: TPointF;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    ctrlObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if ctrlObj is TImage then
    begin
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin
        { zoom the image }
        img_Barcode := TImage(ctrlObj.GetObject);
        dImageCenter := img_Barcode.Position.Point + PointF(img_Barcode.Width / 2,
          img_Barcode.Height / 2);
        img_Barcode.Width := Max(img_Barcode.Width + (EventInfo.Distance - iLastDistance), 10);
        img_Barcode.Height := Max(img_Barcode.Height + (EventInfo.Distance - iLastDistance), 10);
        img_Barcode.Position.X := dImageCenter.X - img_Barcode.Width / 2;
        img_Barcode.Position.Y := dImageCenter.Y - img_Barcode.Height / 2;
      end;
      iLastDistance := EventInfo.Distance;
    end;
  end;
end;
procedure Tfrm_PCMAPP_GutscheinBarcodeDetail.FormShow(Sender: TObject);
  procedure SetDesign;
  var
    iDesignStyle: integer;
  begin
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    {$ENDIF MSWINDOWS}
    case iDesignStyle of
      0: // Calypso
      begin
        frm_PCMAPP_GutscheinBarcodeDetail.StyleBook:= dmMain.stB_0;
        btn_Back.ImageIndex:= 3;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_GutscheinBarcodeDetail.StyleBook:= dmMain.stB_1;
        btn_Back.ImageIndex:= 2;
      end;
      2:
      begin
        frm_PCMAPP_GutscheinBarcodeDetail.StyleBook:= dmMain.stB_2;
        btn_Back.ImageIndex:= 3;
      end;
      3:
      begin
        frm_PCMAPP_GutscheinBarcodeDetail.StyleBook:= dmMain.stB_3;
        btn_Back.ImageIndex:= 3;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_GutscheinBarcodeDetail.StyleBook:= dmMain.stB_4;
        btn_Back.ImageIndex:= 3;
      end;
      {$ENDIF MSWINDOWS}
    end;
  end;
begin
  SetDesign;
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
end;
{$EndRegion Formfunctions}
end.
