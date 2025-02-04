unit PCMAPP.Gutschein.Detail;

interface

uses
  {$Region Uses}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.Threading, FMX.Effects,
  FMX.Objects,DateUtils,FMX.DialogService.Async,
  System.Math,FMX.VirtualKeyboard, FMX.Platform, FMX.DateTimeCtrls, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.Memo.Types, FMX.EditBox, FMX.NumberBox,
  zint_render_fmx_bmp,zint,
  {$IFDEF ANDROID}
  DW.BarcodeReader,
  DW.Permissions.Helpers,
  DW.Consts.Android,
 {$ENDIF ANDROID}
  System.Permissions, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary;
  {$EndRegion Uses}
type
  {$Region Type}
  Tfrm_PCMAPP_GutscheinDetail = class(TForm)
    al_Gutschein: TActionList;
    btn_Back: TButton;
    btn_BarcodeFromImage: TButton;
    btn_BarcodeFromKamera: TButton;
    btn_Cancel: TButton;
    btn_Edit: TButton;
    btn_Save: TButton;
    dtp_Datum: TDateEdit;
    edt_Bezeichnung: TEdit;
    edt_Nummer: TEdit;
    edt_Pin: TEdit;
    edt_Wert: TNumberBox;
    edt_WertRest: TNumberBox;
    img_Result: TImage;
    img_Scan: TImage;
    lbl_Barcode: TLabel;
    lbl_Bezeichnung: TLabel;
    lbl_Datum: TLabel;
    lbl_ModulName: TLabel;
    lbl_Nummer: TLabel;
    lbl_Pin: TLabel;
    lbl_Restwert: TLabel;
    lbl_Wert: TLabel;
    lo_Buttons: TLayout;
    lo_Form: TLayout;
    lo_Left: TLayout;
    lo_Main: TLayout;
    lo_Right: TLayout;
    rec_Barcode: TRectangle;
    TakePhotoFromCameraAction: TTakePhotoFromCameraAction;
    TakePhotoFromLibraryAction: TTakePhotoFromLibraryAction;
    tb_Main: TRectangle;
    vsbx_GutscheinDetailView: TVertScrollBox;
    vsbx_Main: TVertScrollBox;
    procedure btn_BackClick(Sender: TObject);
    procedure btn_BarcodeFromImageClick(Sender: TObject);
    procedure btn_BarcodeFromKameraClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure edt_NummerChange(Sender: TObject);
    procedure edt_WertEnter(Sender: TObject);
    procedure edt_WertRestEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryActionDidFinishTaking(Image: TBitmap);
    procedure img_ResultDblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    bNeedOffset: Boolean;
    dBounds: TRectF;
    qry_Gutschein: TFDQuery;
    {$IFDEF ANDROID}
    barcdReader: TBarcodeReader;
    procedure ReaderBarcodeHandler(Sender: TObject; const ABarcodes: TBarcodes; const AError: string);
    {$ENDIF ANDROID}
    function  GenSymbol: TZintSymbol;
    procedure GenBarcode;


    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public-Deklarationen }
  end;
  {$EndRegion Type}
var
  frm_PCMAPP_GutscheinDetail: Tfrm_PCMAPP_GutscheinDetail;

implementation

{$R *.fmx}

uses
  PCMApp.Datamodul,
  PCMAPP.Gutschein.Barcode,
  PCMApp.Main,
  PCMApp.Funktionen,
  PCMAPP.SQL;

////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
function Tfrm_PCMAPP_GutscheinDetail.GenSymbol: TZintSymbol;
var
  sEAN: string;
  iImageHeight: integer;
begin
  Result := TZintSymbol.Create(nil);

  Result.input_mode := UNICODE_MODE;
  Result.output_options:=Result.output_options or BARCODE_BOX;
  iImageHeight:= Round(img_Result.Height) -50;
  Result.height:= iImageHeight;
  Result.border_width:=0;
  Result.whitespace_width:=2;
  case Length(StringReplace(edt_Nummer.Text,' ','',[rfIgnorecase,rfReplaceAll])) of
    13:
    begin
      Result.SymbolType := TZintSymbology(zsEANX);
      sEAN:= Copy(StringReplace(edt_Nummer.Text,' ','',[rfIgnorecase,rfReplaceAll]),1,12);
      Result.Encode(sEAN , true);
    end;
    19:
    begin
      Result.SymbolType := TZintSymbology(zsCODE128);
      Result.Encode(StringReplace(edt_Nummer.Text,' ','',[rfIgnorecase,rfReplaceAll]) , true);
    end;
    39:
    begin
      Result.SymbolType := TZintSymbology(zsAZTEC);
      Result.Encode(StringReplace(edt_Nummer.Text,' ','',[rfIgnorecase,rfReplaceAll]) , true);
    end;
  end;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.img_ResultDblClick(Sender: TObject);
begin
  Application.CreateForm(Tfrm_PCMAPP_GutscheinBarcodeDetail,frm_PCMAPP_GutscheinBarcodeDetail);
  frm_PCMAPP_GutscheinBarcodeDetail.img_BarCode.Bitmap := img_Result.Bitmap;
  frm_PCMAPP_GutscheinBarcodeDetail.show;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.GenBarcode;
var
  symbol : TZintSymbol;
  bmp : TBitmap;
  rt  : TZintBMPRenderTarget;
begin
   symbol := GenSymbol;
   bmp:=TBitmap.Create(round(img_Result.Width),round(img_Result.Height));
   rt:=TZintBMPRenderTarget.Create(nil);
   rt.HAlign := TZintHAlign(1);
   rt.VAlign := TZintVAlign(1);
   rt.Bitmap:=bmp;
   rt.RenderAdjustMode:=ramScale;
   rt.Font.Family:='Courier New';
   rt.ShowText:=True;
   Symbol.Render(rt);
   rt.Free;
   img_Result.Bitmap:=bmp;
   bmp.Free;
   symbol.Free;
end;
{$IFDEF ANDROID}
procedure Tfrm_PCMAPP_GutscheinDetail.ReaderBarcodeHandler(Sender: TObject; const ABarcodes: TBarcodes; const AError: string);
var
  LBarcode: TBarcode;
begin
  for LBarcode in ABarcodes do
  begin
    edt_Nummer.Text:= LBarcode.Value;
  end;
end;
{$ENDIF ANDROID}
procedure Tfrm_PCMAPP_GutscheinDetail.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if bNeedOffset and (dBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom, 2 * ClientHeight - dBounds.Top);
  end;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.RestorePosition;
begin
  vsbx_Main.ViewportPosition := PointF(vsbx_Main.ViewportPosition.X, 0);
  lo_Main.Align := TAlignLayout.Client;
  vsbx_Main.RealignContent;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  bNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbx_Main.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(dBounds))) and
       (LFocusRect.Bottom > dBounds.Top) then
    begin
      bNeedOffset := True;
      lo_Main.Align := TAlignLayout.Horizontal;
      vsbx_Main.RealignContent;
      Application.ProcessMessages;
      vsbx_Main.ViewportPosition :=
        PointF(vsbx_Main.ViewportPosition.X,
               LFocusRect.Bottom - (dBounds.Top - 48));
    end;
  end;
  if not bNeedOffset then
    RestorePosition;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
begin
  {$IFDEF ANDROID}
  img_Scan.Bitmap.Assign(Image);
  barcdReader.Scan(Image);
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCMAPP_GutscheinDetail.TakePhotoFromLibraryActionDidFinishTaking(Image: TBitmap);
begin
  {$IFDEF ANDROID}
  img_Scan.Bitmap.Assign(Image);
  barcdReader.Scan(Image);
  {$ENDIF ANDROID}
end;
{$EndRegion Helperfunctions}
////////////////////////////////////////////////////////////////////////////////
// Button FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Buttonfunctions}
procedure Tfrm_PCMAPP_GutscheinDetail.btn_BackClick(Sender: TObject);
begin
  frm_PCMAPP_GutscheinDetail.close;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.btn_BarcodeFromImageClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  TakePhotoFromLibraryAction.ExecuteTarget(btn_BarcodeFromImage);
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCMAPP_GutscheinDetail.btn_BarcodeFromKameraClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  TakePhotoFromCameraAction.ExecuteTarget(btn_BarcodeFromKamera);
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCMAPP_GutscheinDetail.btn_CancelClick(Sender: TObject);
begin
  if frm_PCM_Main.bNeu then
  begin
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    frm_PCM_Main.bNeu:= false;
    frm_PCMAPP_GutscheinDetail.close;
  end
  else begin
    qry_Gutschein.SQL.Text:= SQL_SEL_ALL_Gutscheine_Where_ID;
    qry_Gutschein.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Gutschein.open;
    edt_Nummer.Text:= qry_Gutschein.FieldByName('Nummer').AsString;
    edt_Bezeichnung.Text:= qry_Gutschein.FieldByName('Bezeichnung').AsString;
    dtp_Datum.Date:= qry_Gutschein.FieldByName('Datum').AsDateTime;
    edt_Wert.Value:= qry_Gutschein.FieldByName('Wert').AsFloat;
    edt_WertRest.value:= qry_Gutschein.FieldByName('Restwert').AsFloat;
    edt_Pin.text:= qry_Gutschein.FieldByName('AbfragePin').asString;
    qry_Gutschein.Close;
    edt_Nummer.enabled:= false;
    edt_Bezeichnung.enabled:= false;
    dtp_Datum.enabled:= false;
    edt_Wert.enabled:= false;
    edt_WertRest.enabled:= false;
    edt_Pin.enabled:= false;
    btn_BarcodeFromKamera.enabled:= false;
    btn_BarcodeFromImage.enabled:= false;
    btn_Back.Visible:= true;
    btn_Cancel.Visible:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
  end;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.btn_EditClick(Sender: TObject);
begin
  btn_Back.Visible:= false;
  btn_Cancel.Visible:= true;
  btn_Edit.Visible:= false;
  btn_save.Visible:= true;
  edt_Nummer.enabled:= true;
  edt_Bezeichnung.enabled:= true;
  dtp_Datum.enabled:= true;
  edt_Wert.enabled:= true;
  edt_WertRest.enabled:= true;
  edt_Pin.enabled:= true;
  btn_BarcodeFromKamera.enabled:= true;
  btn_BarcodeFromImage.enabled:= true;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.btn_SaveClick(Sender: TObject);
begin
  if (edt_Nummer.Text = '') and (edt_Bezeichnung.Text = '') then
  begin
    ShowMessage('Nummer oder Bezeichnung darf nicht leer sein!');
    exit;
  end;
  if not frm_PCM_Main.bNeu then
  begin
    qry_Gutschein.SQL.Text:= sSQL_UPD_ALL_Gutschein_WHERE_ID;
    qry_Gutschein.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Gutschein.ParamByName('Nummer').AsString:= edt_Nummer.Text;
    qry_Gutschein.ParamByName('Bezeichnung').AsString:= edt_Bezeichnung.Text;
    qry_Gutschein.ParamByName('Datum').AsDate:= dtp_Datum.Date;
    qry_Gutschein.ParamByName('Wert').AsFloat:= edt_Wert.value;
    qry_Gutschein.ParamByName('Restwert').AsFloat:= edt_WertRest.Value;
    qry_Gutschein.ParamByName('AbfragePin').AsString:= edt_Pin.Text;
    qry_Gutschein.ExecSQl;
    with frm_PCM_Main.lv_Gutschein.Items[frm_PCM_Main.iListviewID] do
    begin
      Text:= 'Bez: ' + edt_Bezeichnung.Text + ', Datum: ' + DateToStr(dtp_Datum.Date);
      Detail:= 'Wert: ' +  FormatCurr(',0.00 €;-,0.00 €', edt_Wert.value) + ', Rest: ' + FormatCurr(',0.00 €;-,0.00 €',edt_WertRest.value);
    end;
  end
  else begin
    qry_Gutschein.SQL.Text:= sSQL_INS_ALL_Gutschein;
    qry_Gutschein.ParamByName('Nummer').AsString:= edt_Nummer.Text;
    qry_Gutschein.ParamByName('Bezeichnung').AsString:= edt_Bezeichnung.Text;
    qry_Gutschein.ParamByName('Datum').AsDate:= dtp_Datum.Date;
    qry_Gutschein.ParamByName('Wert').AsFloat:= edt_Wert.value;
    qry_Gutschein.ParamByName('Restwert').AsFloat:= edt_WertRest.Value;
    qry_Gutschein.ParamByName('AbfragePin').AsString:= edt_Pin.Text;
    qry_Gutschein.ExecSQl;
    frm_PCM_Main.lv_Gutschein.Items.Clear;
    frm_PCM_Main.lv_Gutschein.BeginUpdate;
    frm_PCM_Main.CreateGridGutschein;
    frm_PCM_Main.lv_Gutschein.EndUpdate;
    frm_PCM_Main.bNeu:= false;
  end;
  edt_Nummer.enabled:= false;
  edt_Bezeichnung.enabled:= false;
  dtp_Datum.enabled:= false;
  edt_Wert.enabled:= false;
  edt_WertRest.enabled:= false;
  edt_Pin.enabled:= false;
  btn_BarcodeFromKamera.enabled:= false;
  btn_BarcodeFromImage.enabled:= false;
  btn_Back.Visible:= true;
  btn_Cancel.Visible:= false;
  btn_Edit.Visible:= true;
  btn_save.Visible:= false;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.edt_NummerChange(Sender: TObject);
begin
  GenBarcode;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.edt_WertEnter(Sender: TObject);
begin
  edt_Wert.SelectAll;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.edt_WertRestEnter(Sender: TObject);
begin
  edt_WertRest.SelectAll;
end;
{$EndRegion Buttonfunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
constructor Tfrm_PCMAPP_GutscheinDetail.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF ANDROID}
  barcdReader := TBarcodeReader.Create;
  barcdReader.Formats := [TBarcodeFormat.All];
  barcdReader.OnBarcode := ReaderBarcodeHandler;
  {$ENDIF ANDROID}
end;
destructor Tfrm_PCMAPP_GutscheinDetail.Destroy;
begin
  {$IFDEF ANDROID}
  barcdReader.Free;
  {$ENDIF ANDROID}
  inherited;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeandNil(qry_Gutschein);
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormCreate(Sender: TObject);
begin
  vsbx_Main.OnCalcContentBounds := CalcContentBoundsProc;
  {$IFDEF MSWINDOWS}
  frm_PCMAPP_GutscheinDetail.BorderStyle:=TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = System.UITypes.igiDoubleTap then
  begin
    Application.CreateForm(Tfrm_PCMAPP_GutscheinBarcodeDetail,frm_PCMAPP_GutscheinBarcodeDetail);
    frm_PCMAPP_GutscheinBarcodeDetail.img_BarCode.Bitmap := img_Result.Bitmap;
    frm_PCMAPP_GutscheinBarcodeDetail.show;
  end;

end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormShow(Sender: TObject);
  procedure SetDesign;
  var
    iDesignStyle: Integer;
  begin
    {$IFDEF ANDROID}
    iDesignStyle:= frm_PCM_Main.iDesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= frm_PCM_Main.iDesignwin;
    btn_BarcodeFromKamera.Visible:= false;
    btn_BarcodeFromImage.Visible:= false;
    {$ENDIF MSWINDOWS}
    case iDesignStyle of
      0: // Calypso
      begin
        frm_PCMAPP_GutscheinDetail.StyleBook:= dmMain.stB_0;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      1: // Diamond
      begin
        frm_PCMAPP_GutscheinDetail.StyleBook:= dmMain.stB_1;
        btn_Back.ImageIndex:= 2;
        btn_Cancel.ImageIndex:= 18;
        btn_Edit.ImageIndex:= 20;
        btn_Save.ImageIndex:= 22;
      end;
      2:
      begin
        frm_PCMAPP_GutscheinDetail.StyleBook:= dmMain.stB_2;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      3:
      begin
        frm_PCMAPP_GutscheinDetail.StyleBook:= dmMain.stB_3;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$IFDEF MSWINDOWS}
      4:
      begin
        frm_PCMAPP_GutscheinDetail.StyleBook:= dmMain.stB_4;
//        TextColor:= TAlphaColorRec.White;
        btn_Back.ImageIndex:= 3;
        btn_Cancel.ImageIndex:= 19;
        btn_Edit.ImageIndex:= 21;
        btn_Save.ImageIndex:= 23;
      end;
      {$ENDIF MSWINDOWS}
    end;
  end;
begin
  SetDesign;
  qry_Gutschein:= TFDQuery.Create(nil);
  qry_Gutschein.Connection:= dmmain.con_PCM;
  dmmain.wfWaitFrame.Execute('Gutscheindetails laden...', 'Gutscheine', True);
  {$IFDEF MSWINDOWS}
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  tb_main.Margins.Top:= 0;
  {$ENDIF MSWINDOWS}
  try
    qry_Gutschein.SQL.Text:= SQL_SEL_ALL_Gutscheine_Where_ID;
    qry_Gutschein.ParamByName('ID').asInteger:= frm_PCM_Main.iID;
    qry_Gutschein.open;
    edt_Nummer.Text:= qry_Gutschein.FieldByName('Nummer').AsString;
    edt_Bezeichnung.Text:= qry_Gutschein.FieldByName('Bezeichnung').AsString;
    dtp_Datum.Date:= qry_Gutschein.FieldByName('Datum').AsDateTime;
    edt_Wert.Value:= qry_Gutschein.FieldByName('Wert').AsFloat;
    edt_WertRest.value:= qry_Gutschein.FieldByName('Restwert').AsFloat;
    edt_Pin.text:= qry_Gutschein.FieldByName('AbfragePin').asString;
    qry_Gutschein.Close;
    edt_Nummer.enabled:= false;
    edt_Bezeichnung.enabled:= false;
    dtp_Datum.enabled:= false;
    edt_Wert.enabled:= false;
    edt_WertRest.enabled:= false;
    edt_Pin.enabled:= false;
    btn_Edit.Visible:= true;
    btn_save.Visible:= false;
    if edt_Nummer.Text <> '' then
    begin
      try
//        {$IFDEF ANDROID}
        GenBarcode;
//        {$ENDIF ANDROID}
      except
        img_Result.Bitmap:= nil;
      end;
    end
    else begin
      img_Result.Bitmap:= nil;
    end;
    if frm_PCM_Main.bNeu then
    begin
      edt_Nummer.enabled:= true;
      edt_Bezeichnung.enabled:= true;
      dtp_Datum.enabled:= true;
      dtp_Datum.Date:= Now;
      edt_Wert.enabled:= true;
      edt_WertRest.enabled:= true;
      edt_Pin.enabled:= true;
      btn_Back.Visible:= false;
      btn_Cancel.Visible:= true;
      btn_Edit.Visible:= false;
      btn_save.Visible:= true;
    end;
    dmmain.wfWaitFrame.HideFW;
  except
    on E:Exception do
    begin
      Write(e.message,2,false);
      qry_Gutschein.Close;
      dmmain.wfWaitFrame.HideFW;
      frm_PCM_Main.bNeu:= false;
    end;
  end;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
  RestorePosition;
end;
procedure Tfrm_PCMAPP_GutscheinDetail.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
  UpdateKBBounds;
end;
{$EndRegion Formfunctions}
end.

