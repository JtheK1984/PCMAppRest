unit PCMAPP.Main;

interface

uses
  {$Region Uses}
  {$IFDEF ANDROID}
  Androidapi.AppGlue,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.Java.Net,
  Androidapi.JNI.Embarcadero,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Javatypes,
  Androidapi.JNI.Net,
  Androidapi.JNI.Java.Security,
  Androidapi.JNI.Os,
  Androidapi.JNIBridge,
  Androidapi.NativeActivity,
  FMX.BiometricAuth,
  FMX.PushNotification.Android,
  FMX.VirtualKeyboard,
  {$ENDIF ANDROID}
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  Data.DB,
  Data.SqlExpr,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.UI.Intf,
  FMX.ActnList,
  FMX.Ani,
  FMX.Calendar,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.DateTimeCtrls,
  FMX.Dialogs,
  FMX.DialogService,
  FMX.DialogService.Async,
  FMX.Edit,
  FMX.EditBox,
  FMX.Forms,
  FMX.Gestures,
  FMX.Graphics,
  FMX.Grid,
  FMX.Grid.Style,
  FMX.ImgList,
  FMX.Memo,
  FMX.Memo.Types,
  FMX.MultiView,
  FMX.NumberBox,
  FMX.Layouts,
  FMX.ListBox,
  FMX.ListView,
  FMX.ListView.Adapters.Base,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  FMX.Objects,
  FMX.Platform,
  FMX.PhoneDialer,
  FMX.ScrollBox,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.TreeView,
  FMX.Types,
  IdIPAddress,
  IdGlobal,
  IdHashMessageDigest,
  IdStack,
  REST.Backend.BindSource,
  REST.Backend.KinveyProvider,
  REST.Backend.KinveyPushDevice,
  REST.Backend.PushDevice,
  REST.Backend.PushTypes,
  System.Actions,
  System.Classes,
  system.DateUtils,
  System.ImageList,
  System.JSON,IdTCPClient,
  system.math,
  System.Messaging,
  System.NetEncoding,
  System.Notification,
  System.PushNotification,
  System.Permissions,
  System.Rtti,
  System.StrUtils,
  System.SysUtils,
  System.Threading,
  System.Types,
  System.UITypes,
  System.Variants,
  PCMAPP.Ausgaben.Detail,
  PCMAPP.Einnahmen.Detail,
  PCMAPP.Kontakte.Detail,
  PCMAPP.Kalender.Detail,
  PCMAPP.Passwort.Detail,
  PCMAPP.Serial.Detail,
  PCMAPP.System,
  PCMAPP.WaitForm, REST.Types, REST.Client, REST.Authenticator.Basic,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;
  {$EndRegion Uses}
type
  {$Region Types}
  TStringArray = TArray<TDateTime>;

  Tfrm_PCM_Main = class(TForm)
    btn_AddData: TButton;
    btn_BackSystem: TButton;
    btn_CloseApp: TButton;
    btn_FinanzenAusFixDetail: TButton;
    btn_FinanzenAusVarDetail: TButton;
    btn_FinanzenEinDetailGesamt: TButton;
    btn_FixAusgaben: TButton;
    btn_FixEinnahmen: TButton;
    btn_GutscheineVisible: TButton;
    btn_lock: TButton;
    btn_Login: TButton;
    btn_LoginBiometrie: TButton;
    btn_Multiview: TButton;
    btn_NullAusgaben: TButton;
    btn_NullEinnahmen: TButton;
    btn_Search: TButton;
    btn_Synchronisation: TButton;
    btn_TouchMeLabel: TLabel;
    btn_Unlock: TButton;
    btn_UserImg: TButton;
    cal_Calendar: TCalendar;
    cbx_Jahr: TComboBox;
    cbx_Monat: TComboBox;
    crl_BelegeMain: TCircle;
    crl_BelegeSub: TCircle;
    crl_CalendarSub: TCircle;
    crl_CalndarMain: TCircle;
    crl_ContactsMain: TCircle;
    crl_ContactsSub: TCircle;
    crl_FinanceMain: TCircle;
    crl_FinanceSub: TCircle;
    crl_GiftCardsMain: TCircle;
    crl_GiftCardsSub: TCircle;
    crl_passwordMain: TCircle;
    crl_passwordSub: TCircle;
    crl_SerialMain: TCircle;
    crl_SerialSub: TCircle;
    edt_Benutzername: TEdit;
    edt_Passwort: TEdit;
    edt_Server: TEdit;
    fa_BelegeCircle: TFloatAnimation;
    fa_BelegeGiftCards: TFloatAnimation;
    fa_Calendar: TFloatAnimation;
    fa_CalendarCircle: TFloatAnimation;
    fa_Contacts: TFloatAnimation;
    fa_ContactsCircle: TFloatAnimation;
    fa_Finance: TFloatAnimation;
    fa_GiftCardsCircle: TFloatAnimation;
    fa_Password: TFloatAnimation;
    fa_PasswordCircle: TFloatAnimation;
    fa_SerialCircle: TFloatAnimation;
    fa_Serials: TFloatAnimation;
    img_Ausgaben: TImage;
    img_Beleg: TImage;
    img_Belege: TImage;
    img_Biometric: TImage;
    img_Calabo: TImage;
    img_Calander: TImage;
    img_Close: TImage;
    img_Contact: TImage;
    img_Contacts: TImage;
    img_Einnahmen: TImage;
    img_Finance: TImage;
    img_Finanzen: TImage;
    img_GiftCards: TImage;
    img_Gutschein: TImage;
    img_Home: TImage;
    img_HomeBelege: TImage;
    img_HomeCalendar: TImage;
    img_HomeContacts: TImage;
    img_HomeFinance: TImage;
    img_HomeGiftCards: TImage;
    img_HomePassword: TImage;
    img_HomeSerial: TImage;
    img_kalender: TImage;
    img_Logo: TImage;
    img_Logout: TImage;
    img_More: TImage;
    img_Optionen: TImage;
    img_Password: TImage;
    img_Passwords: TImage;
    img_Serial: TImage;
    img_Serials: TImage;
    imglst_main: TImageList;
    kp_KinveyProvider: TKinveyProvider;
    lbl_AusgabenFix: TLabel;
    lbl_AusgabenFixDetail: TLabel;
    lbl_AusgabenFixGesDetail: TLabel;
    lbl_AusgabenFixGesLabel: TLabel;
    lbl_AusgabenFixLabel: TLabel;
    lbl_AusgabenVar: TLabel;
    lbl_AusgabenVarDetail: TLabel;
    lbl_AusgabenVarGesDetail: TLabel;
    lbl_AusgabenVarGesLabel: TLabel;
    lbl_AusgabenVarLabel: TLabel;
    lbl_Belege: TLabel;
    lbl_BelegeDesc: TLabel;
    lbl_BelegeDetail: TLabel;
    lbl_BelegeEmpty: TLabel;
    lbl_CalaboBody: TLabel;
    lbl_CalaboHeader: TLabel;
    lbl_CalendarDesc: TLabel;
    lbl_CalendarDetail: TLabel;
    lbl_CalendarHeader: TLabel;
    lbl_CalenderEmpty: TLabel;
    lbl_CloseBody: TLabel;
    lbl_CloseHeader: TLabel;
    lbl_ContactsDesc: TLabel;
    lbl_ContactsDetail: TLabel;
    lbl_ContactsEmpty: TLabel;
    lbl_ContactsHeader: TLabel;
    lbl_CreateAccount: TLabel;
    lbl_Einnahmen: TLabel;
    lbl_EinnahmenDetail: TLabel;
    lbl_EinnahmenGesDetail: TLabel;
    lbl_EinnahmenGesLabel: TLabel;
    lbl_EinnahmenLabel: TLabel;
    lbl_FinanceDesc: TLabel;
    lbl_FinanceGesamtDetail: TLabel;
    lbl_FinanceHeader: TLabel;
    lbl_FinanceRestDetail: TLabel;
    lbl_FinanzenAusFixDetail: TLabel;
    lbl_FinanzenAusVarDetail: TLabel;
    lbl_FinanzenEinDetailGesamt: TLabel;
    lbl_FinanzenFixGesamt: TLabel;
    lbl_FinanzenFixGesamtLabel: TLabel;
    lbl_FinanzenImg: TLayout;
    lbl_FinanzenVarGesamt: TLabel;
    lbl_FinanzenVarGesamtLabel: TLabel;
    lbl_Gesamt: TLabel;
    lbl_GesamtHeader: TLabel;
    lbl_GesamtKompDetail: TLabel;
    lbl_GesamtKompLabel: TLabel;
    lbl_GesamtLabel: TLabel;
    lbl_GiftCards: TLabel;
    lbl_GiftCardsDesc: TLabel;
    lbl_GiftCardsDetail: TLabel;
    lbl_GiftCardsEmpty: TLabel;
    lbl_Jahr: TLabel;
    lbl_Kind: TLabel;
    lbl_LogoutBody: TLabel;
    lbl_LogoutHeader: TLabel;
    lbl_ModulName: TLabel;
    lbl_Monat: TLabel;
    lbl_MVAusgaben: TLabel;
    lbl_MVBelege: TLabel;
    lbl_MVContact: TLabel;
    lbl_MVEinnahmen: TLabel;
    lbl_MVFinanzen: TLabel;
    lbl_MVGutschein: TLabel;
    lbl_MVHome: TLabel;
    lbl_MVKalender: TLabel;
    lbl_MVMore: TLabel;
    lbl_MVPassword: TLabel;
    lbl_MVSerials: TLabel;
    lbl_OptionenBody: TLabel;
    lbl_OptionenHeader: TLabel;
    lbl_PasswordHeader: TLabel;
    lbl_PasswortDesc: TLabel;
    lbl_PasswortDetail: TLabel;
    lbl_PasswortEmpty: TLabel;
    lbl_Rest: TLabel;
    lbl_RestLabel: TLabel;
    lbl_SerialDesc: TLabel;
    lbl_SerialDetail: TLabel;
    lbl_SerialEmpty: TLabel;
    lbl_SerialHeader: TLabel;
    ln_Belege: TLine;
    ln_Calender: TLine;
    ln_Contacts: TLine;
    ln_Finance: TLine;
    ln_FinanzenAusFixDetail: TLine;
    ln_FinanzenAusVarDetail: TLine;
    ln_FinanzenEinDetailGesamt: TLine;
    ln_GiftCards: TLine;
    ln_Password: TLine;
    ln_Serials: TLine;
    lo_01FinanzenDatum: TLayout;
    lo_02Einnahmen: TLayout;
    lo_03AusgabenVar: TLayout;
    lo_04AusgabenFix: TLayout;
    lo_05GesamtHeader: TLayout;
    lo_06EinnahmenGes: TLayout;
    lo_07AusgabenVarGes: TLayout;
    lo_08AusgabenFixGes: TLayout;
    lo_09Trenn: TLayout;
    lo_10GesamtKomp: TLayout;
    lo_AusgabenImg: TLayout;
    lo_AusgabenLabel: TLayout;
    lo_Belege: TLayout;
    lo_BelegeDetail: TLayout;
    lo_BelegeImg: TLayout;
    lo_BelegeLabel: TLayout;
    lo_BelegeMain: TLayout;
    lo_CalaboDetail: TLayout;
    lo_CalaboImage: TLayout;
    lo_Calendar: TLayout;
    lo_CalendarDetails: TLayout;
    lo_CalendarMain: TLayout;
    lo_CloseImg: TLayout;
    lo_CloseLabel: TLayout;
    lo_ConfigConfig: TLayout;
    lo_ConfigImportContacts: TLayout;
    lo_ContactImg: TLayout;
    lo_ContactLabel: TLayout;
    lo_Contacts: TLayout;
    lo_ContactsDetail: TLayout;
    lo_ContactsMain: TLayout;
    lo_DetailFrame: TLayout;
    lo_EinnahmenImg: TLayout;
    lo_EinnahmenLabel: TLayout;
    lo_Finance: TLayout;
    lo_FinanceDetail: TLayout;
    lo_FinanceMain: TLayout;
    lo_FinanzenAusFixDetail: TLayout;
    lo_FinanzenAusVarDetail: TLayout;
    lo_FinanzenEinDetailGesamt: TLabel;
    lo_FinanzenEinDetailGesamtLabel: TLabel;
    lo_FinanzenEingDetailGesamt: TLayout;
    lo_FinanzenLabel: TLayout;
    lo_Frame: TLayout;
    lo_GiftCards: TLayout;
    lo_GiftCardsDetail: TLayout;
    lo_GiftCardsMain: TLayout;
    lo_GutscheinImg: TLayout;
    lo_GutscheinLabel: TLayout;
    lo_HomeImage: TLayout;
    lo_HomeLabel: TLayout;
    lo_Jahr: TLayout;
    lo_KalenderImg: TLayout;
    lo_KalenderLabel: TLayout;
    lo_LoginBody: TLayout;
    lo_LoginFooter: TLayout;
    lo_LoginHeader: TLayout;
    lo_LogoutImg: TLayout;
    lo_LogoutLabel: TLayout;
    lo_Main: TLayout;
    lo_MainLeft: TLayout;
    lo_MainPCM: TLayout;
    lo_MainRight: TLayout;
    lo_Monat: TLayout;
    lo_MoreImg: TLayout;
    lo_MoreLabel: TLayout;
    lo_OptionenImg: TLayout;
    lo_OptionenLabel: TLayout;
    lo_Password: TLayout;
    lo_PasswordDetail: TLayout;
    lo_PasswordImg: TLayout;
    lo_PasswordLabel: TLayout;
    lo_PasswordMain: TLayout;
    lo_Serials: TLayout;
    lo_SerialsDetail: TLayout;
    lo_SerialsImg: TLayout;
    lo_SerialsLabel: TLayout;
    lo_SerialsMain: TLayout;
    lstbx_Menu: TListBox;
    lstbx_More: TListBox;
    lstbxitm_101Home: TListBoxItem;
    lstbxitm_102Contact: TListBoxItem;
    lstbxitm_103Kalender: TListBoxItem;
    lstbxitm_104Password: TListBoxItem;
    lstbxitm_105Serials: TListBoxItem;
    lstbxitm_106Finanzen: TListBoxItem;
    lstbxitm_107Eingang: TListBoxItem;
    lstbxitm_108Ausgaben: TListBoxItem;
    lstbxitm_109Belege: TListBoxItem;
    lstbxitm_110Gutschein: TListBoxItem;
    lstbxitm_111More: TListBoxItem;
    lstbxitm_1Optionen: TListBoxItem;
    lstbxitm_2Calabo: TListBoxItem;
    lstbxitm_3Abmelden: TListBoxItem;
    lstbxitm_3Beenden: TListBoxItem;
    lv_Ausgaben: TListView;
    lv_Belege: TListView;
    lv_Calabo: TListView;
    lv_Einnahmen: TListView;
    lv_Gutschein: TListView;
    lv_Kalender: TListView;
    lv_KalenderKompakt: TListView;
    lv_Kontakte: TListView;
    lv_Passwort: TListView;
    lv_Serials: TListView;
    mem_FinanzenAusVarDetailBesch: TMemo;
    mem_FinanzenAusVarDetailBetrag: TMemo;
    mem_FinanzenEinDetailBesch: TMemo;
    mem_FinanzenEinDetailBetrag: TMemo;
    mem_FinanzenFixDetailBesch: TMemo;
    mem_FinanzenfixDetailBetrag: TMemo;
    mv_Menu: TMultiView;
    nc_PushNotification: TNotificationCenter;
    pe_PushEvents: TPushEvents;
    pie_Belege: TPie;
    pie_Calender: TPie;
    pie_Contacts: TPie;
    pie_Finance: TPie;
    pie_GuftCards: TPie;
    pie_Password: TPie;
    pie_Serial: TPie;
    qry_work: TFDQuery;
    qry_work_Sub: TFDQuery;
    rec_1Contacts: TRectangle;
    rec_1Einnahmen: TRectangle;
    rec_2AusgabenVar: TRectangle;
    rec_2Calendar: TRectangle;
    rec_3AusgabenFix: TRectangle;
    rec_3Password: TRectangle;
    rec_3PasswordSerials: TRectangle;
    rec_3Serials: TRectangle;
    rec_4Fincance: TRectangle;
    rec_5Belege: TRectangle;
    rec_5BelegeGiftCards: TRectangle;
    rec_5GiftCards: TRectangle;
    rec_Belege: TRectangle;
    rec_BelegeHeader: TRectangle;
    rec_BelegeLine: TRectangle;
    rec_Calander: TRectangle;
    rec_CalenderHeader: TRectangle;
    rec_CalenderLine: TRectangle;
    rec_Contacts: TRectangle;
    rec_ContactsHeader: TRectangle;
    rec_ContactsLine: TRectangle;
    rec_CreateAccount: TRectangle;
    rec_Finance: TRectangle;
    rec_FinanceHeader: TRectangle;
    rec_FinanceLine: TRectangle;
    rec_Gesamt: TRectangle;
    rec_giftCards: TRectangle;
    rec_GiftcardsHeader: TRectangle;
    rec_GiftCardsLine: TRectangle;
    rec_Main: TRectangle;
    rec_Password: TRectangle;
    rec_PasswordHeader: TRectangle;
    rec_PasswordLine: TRectangle;
    rec_Rest: TRectangle;
    rec_Serials: TRectangle;
    rec_SerialsHeader: TRectangle;
    rec_SerialsLine: TRectangle;
    rec_Summe: TRectangle;
    tc_Finanzen: TTabControl;
    tc_FinanzenDetail: TTabControl;
    tc_FinanzenOverview: TTabControl;
    tc_Kalender: TTabControl;
    tc_main: TTabControl;
    tc_MainApp: TTabControl;
    tc_More: TTabControl;
    tc_PassSerial: TTabControl;
    ti_1Aktuell: TTabItem;
    ti_1ConfigMenu: TTabItem;
    ti_1Komprimiert: TTabItem;
    ti_1Login: TTabItem;
    ti_1MainHome: TTabItem;
    ti_2ConfigImportContacts: TTabItem;
    ti_2Detail: TTabItem;
    ti_2Einnahmen: TTabItem;
    ti_2MainKontakte: TTabItem;
    ti_2MainProgram: TTabItem;
    ti_3ActiveFrame: TTabItem;
    ti_3Ausgaben: TTabItem;
    ti_3ConfigConfig: TTabItem;
    ti_3MainKalender: TTabItem;
    ti_4Belege: TTabItem;
    ti_4Calabo: TTabItem;
    ti_4DetailFrame: TTabItem;
    ti_4MainPasswort: TTabItem;
    ti_5Finger: TTabItem;
    ti_5MainFinanzen: TTabItem;
    ti_6Gutschein: TTabItem;
    ti_7More: TTabItem;
    ti_FinanzenAusFixDetail: TTabItem;
    ti_FinanzenAusVarDetail: TTabItem;
    ti_FinanzenEinDetail: TTabItem;
    ti_kalender: TTabItem;
    ti_Kompakt: TTabItem;
    ti_Passwort: TTabItem;
    ti_Serial: TTabItem;
    tmr_PushNotification: TTimer;
    trvw_calender: TTreeView;
    trvw_Contacts: TTreeView;
    trvw_FinanceDesc: TTreeView;
    trvw_FinanceDetail: TTreeView;
    trvwitm_Calender: TTreeViewItem;
    trvwitm_Email: TTreeViewItem;
    trvwitm_FinanceDescAusFix: TTreeViewItem;
    trvwitm_FinanceDescAusVar: TTreeViewItem;
    trvwitm_FinanceDescBelege: TTreeViewItem;
    trvwitm_FinanceDescEin: TTreeViewItem;
    trvwitm_FinanceDescGesamt: TTreeViewItem;
    trvwitm_FinanceDetailAusFix: TTreeViewItem;
    trvwitm_FinanceDetailAusVar: TTreeViewItem;
    trvwitm_FinanceDetailBelege: TTreeViewItem;
    trvwitm_FinanceDetailEin: TTreeViewItem;
    trvwitm_FinanceDetailGesamt: TTreeViewItem;
    trvwitm_Mobile: TTreeViewItem;
    trvwitm_Name: TTreeViewItem;
    trvwitm_Place: TTreeViewItem;
    trvwitm_Street: TTreeViewItem;
    vsbx_ConfigConfig: TVertScrollBox;
    vsbx_Finanzen: TVertScrollBox;
    vsbx_FinanzenAusFixDetail: TScrollBox;
    vsbx_FinanzenAusVarDetail: TScrollBox;
    vsbx_FinanzenEinDetailGesamt: TScrollBox;
    vsbx_FinanzenKomprimiert: TScrollBox;
    vsbx_Login: TVertScrollBox;
    wtcsr_WaitCursor: TFDGUIxWaitCursor;
    rec_buchungenInfo: TRectangle;
    Layout1: TLayout;
    Button2: TButton;
    Info: TLabel;
    Layout8: TLayout;
    Label7: TLabel;
    Image1: TImage;
    Layout9: TLayout;
    Label6: TLabel;
    Layout10: TLayout;
    Label8: TLabel;
    Layout11: TLayout;
    Label9: TLabel;
    Layout12: TLayout;
    Label10: TLabel;
    Layout13: TLayout;
    Label11: TLabel;
    lo_BuchungungenLegende: TLayout;
    Button1: TButton;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Layout2: TLayout;
    Label1: TLabel;
    Image7: TImage;
    Layout3: TLayout;
    Label2: TLabel;
    Image3: TImage;
    btn_KalenderFilter: TButton;
    {$IFDEF ANDROID}
    procedure BiometricAuth1AuthenticateSuccess(Sender: TObject);
    procedure BiometricAuth1AuthenticateFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
    {$ENDIF ANDROID}
    procedure btn_AddDataClick(Sender: TObject);
    procedure btn_BackSystemClick(Sender: TObject);
    procedure btn_CloseAppClick(Sender: TObject);
    procedure btn_DetailBackClick(Sender: TObject);
    procedure btn_FixAusgabenClick(Sender: TObject);
    procedure btn_FixEinnahmenClick(Sender: TObject);
    procedure btn_GutscheineVisibleClick(Sender: TObject);
    procedure btn_lockClick(Sender: TObject);
    procedure btn_LoginClick(Sender: TObject);
    procedure btn_NullAusgabenClick(Sender: TObject);
    procedure btn_NullEinnahmenClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_SynchronisationClick(Sender: TObject);
    procedure btn_UnlockClick(Sender: TObject);
    procedure cal_CalendarDateSelected(Sender: TObject);
    procedure cbx_MonatChange(Sender: TObject);
    procedure fa_ContactsFinish(Sender: TObject);
    procedure fa_CalendarFinish(Sender: TObject);
    procedure fa_paswordFinish(Sender: TObject);
    procedure fa_SerialsFinish(Sender: TObject);
    procedure fa_financeFinish(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;const Action: TTouchAction);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure img_BiometricClick(Sender: TObject);
    procedure lbl_CreateAccountNewClick(Sender: TObject);
    procedure lstbxitm_101HomeClick(Sender: TObject);
    procedure lstbxitm_102ContactClick(Sender: TObject);
    procedure lstbxitm_103KalenderClick(Sender: TObject);
    procedure lstbxitm_104PasswordClick(Sender: TObject);
    procedure lstbxitm_105SerialsClick(Sender: TObject);
    procedure lstbxitm_106FinanzenClick(Sender: TObject);
    procedure lstbxitm_107EingangClick(Sender: TObject);
    procedure lstbxitm_108AusgabenClick(Sender: TObject);
    procedure lstbxitm_109BelegeClick(Sender: TObject);
    procedure lstbxitm_110GutscheinClick(Sender: TObject);
    procedure lstbxitm_111MoreClick(Sender: TObject);
    procedure lstbxitm_1OptionenClick(Sender: TObject);
    procedure lstbxitm_2CalaboClick(Sender: TObject);
    procedure lstbxitm_3AbmeldenClick(Sender: TObject);
    procedure lstbxitm_3BeendenClick(Sender: TObject);
    procedure lv_AusgabenDblClick(Sender: TObject);
    procedure lv_AusgabenDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_AusgabenItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_AusgabenKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_AusgabenPullRefresh(Sender: TObject);
    procedure lv_BelegeDblClick(Sender: TObject);
    procedure lv_BelegeDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_BelegeItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure lv_BelegeKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_BelegePullRefresh(Sender: TObject);
    procedure lv_CalaboDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_CalaboItemClick(const Sender: TObject;  const AItem: TListViewItem);
    procedure lv_EinnahmenDblClick(Sender: TObject);
    procedure lv_EinnahmenDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_EinnahmenItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_EinnahmenKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_EinnahmenPullRefresh(Sender: TObject);
    procedure lv_GutscheinDblClick(Sender: TObject);
    procedure lv_GutscheinDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_GutscheinItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_GutscheinKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_GutscheinPullRefresh(Sender: TObject);
    procedure lv_KalenderDblClick(Sender: TObject);
    procedure lv_KalenderDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_KalenderItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_KalenderKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_KalenderKompaktDblClick(Sender: TObject);
    procedure lv_KalenderKompaktDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_KalenderKompaktItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure lv_KalenderKompaktKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_KalenderPullRefresh(Sender: TObject);
    procedure lv_KontakteDblClick(Sender: TObject);
    procedure lv_KontakteDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_KontakteItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_KontakteKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_KontaktePullRefresh(Sender: TObject);
    procedure lv_PasswortDblClick(Sender: TObject);
    procedure lv_PasswortDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_PasswortItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_PasswortKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_PasswortPullRefresh(Sender: TObject);
    procedure lv_SerialsDblClick(Sender: TObject);
    procedure lv_SerialsDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
    procedure lv_SerialsItemClick(const Sender: TObject;const AItem: TListViewItem);
    procedure lv_SerialsKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lv_SerialsPullRefresh(Sender: TObject);
    procedure rec_1EinnahmenClick(Sender: TObject);
    procedure rec_2AusgabenVarClick(Sender: TObject);
    procedure rec_3AusgabenFixClick(Sender: TObject);
    procedure tc_FinanzenChange(Sender: TObject);
    procedure tc_MainAppChange(Sender: TObject);
    procedure tc_mainChange(Sender: TObject);
    procedure tmr_PushNotificationTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_KalenderFilterClick(Sender: TObject);
 private
    { Private-Deklarationen }
    {$IFDEF ANDROID}
    baBiometric: TBiometricAuth;
    sCallPhonePermission: string;
    evsrvEventService: IFMXApplicationEventService;
    pdsrvPhoneDialerService: IFMXPhoneDialerService;
    {$ENDIF ANDROID}
    {$IFDEF ANDROID}
    FPushConnection: TPushServiceConnection;
    {$ENDIF ANDROID}
    dBounds: TRectF;
    bNeedOffset: Boolean;
    bOpened: boolean;
    iProgramm: integer;
    iServerID: integer;
    iTouchPosX: Single;
    iTouchPosY: Single;
  public
    { Public-Deklarationen }
    {$IFDEF ANDROID}
    clpbrdsrvClipboardService: IFMXClipboardService;
    {$ENDIF ANDROID}
    aryList: TStringArray;
    bFirstLogin: boolean;
    bHasBiometric: boolean;
    bKontakte: boolean;
    bNeu: boolean;
    bNofinger: boolean;
    iAnimation: integer;
    iDesignAPP: integer;
    iDesignWin: integer;
    iID: integer;
    iItemIndex: integer;
    iItemTag: integer;
    iListviewID: integer;
    iTags: integer;
    idTCPClient: TIdTCPClient;
    sDeviceDetail: string;
    sDeviceId: string;
    sDeviceToken: string;
    sDisplayname: string;
    snglClientHeight: Single;
    snglClientWidth: Single;
    sOSDetail: string;
    sPhoneNumber: string;
    sProviderDetail: string;
    {$IFDEF ANDROID}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplicationEventMessageHandler(const Sender: TObject; const M: TMessage);
    procedure DisplayRationaleDialers(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure Listening(const AIsListening: Boolean);
    procedure TakePhoneCallPermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    {$ENDIF ANDROID}
    procedure AutoLogin(sBenutzername, sPasswort: String);
    procedure AfterLogin(AFirstStart: Boolean);
    procedure BerechneModulFinanzen;
    procedure CloseDetailFrame(AModulName: String; iDetailFrame: Integer);
    procedure CreateBelegeGridConfig;
    procedure CreateCalAboGrid;
    procedure CreateDashboard;
    procedure CreateFinAusGridConfig;
    procedure CreateFinEinGridConfig;
    procedure CreateFormServer;
    procedure CreateFrameKontakteTelefon;
    procedure CreateFrameSystem;
    procedure CreateGridGutschein;
    procedure CreateKontaktuebersichtGridConfig;
    procedure CreateKalGridConfig(Afilter: Boolean);
    procedure CreateKalToday;
    procedure CreatePWDGridConfig;
    procedure CreateSerialGridConfig;
    procedure Logout;
    procedure MakeCall(Sender: TObject);
    procedure OnServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
    procedure OnReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
    procedure ResizeLayout;
    procedure SetAnimation(AAnimation: integer);
    procedure SetAutoLogin(sUsername, sPasswort: String; iID_MA_Stammdaten, iID_Server: Integer; bAutoLogin: Boolean);
    procedure SetDesign(ADesignApp,ADesignWin: integer);
    procedure SetDisableToolButtons;
    procedure SetServerList;
    procedure ShowStartpage;
  end;
  {$EndRegion Uses}
var
  {$Region Var}
  frm_PCM_Main: Tfrm_PCM_Main;
  {$EndRegion Var}
const
  {$Region Const}
  sAPPName = 'PCM - APP';
  {$EndRegion Const}
implementation
{$R *.fmx}
uses
  {$Region Uses}
  PCMApp.Belege.Detail,
  PCMAPP.Calendar.Helpers,
  PCMAPP.Datamodul,
  PCMAPP.Funktionen,
  PCMAPP.Gutschein.Detail,
  PCMAPP.Import.Kontakte,
  PCMAPP.Kalenderabo.Detail,
  PCMAPP.Server,
  PCMAPP.SQL;
  {$EndRegion Uses}
////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS                                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Helperfunctions}
procedure ShowLoginMessage(const AMessage: string);
begin
  if TThread.CurrentThread.ThreadID = MainThreadID then
    ShowMessage(AMessage)
  else
    TThread.Synchronize(nil,
      procedure begin ShowMessage(AMessage); end);
end;

procedure Tfrm_PCM_Main.AfterLogin(AFirstStart: Boolean);
begin
  if TThread.CurrentThread.ThreadID = MainThreadID then
    ShowStartPage
  else
    TThread.Synchronize(nil,
      procedure begin ShowStartPage; end);
end;
procedure Tfrm_PCM_Main.AutoLogin(sBenutzername, sPasswort: String);
var
  bLocalaccount: boolean;
  slocalBenutzername: String;
  slocalPasswort: String;
begin

    {$IFDEF MSWINDOWS}
    btn_CloseApp.Visible:= true;
    {$ENDIF MSWINDOWS}
    dmmain.wfWaitFrame.Execute('Auto Login...', 'Login', True);
    TTask.Run(
    procedure()
    begin
      try
        try
      qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
      qry_Work.Open;
      bLocalaccount:= qry_Work.FieldByName('Localaccount').AsBoolean;
      slocalBenutzername:= qry_Work.FieldByName('Benutzername').AsString;
      slocalPasswort:= qry_Work.FieldByName('Passwort').AsString;
      qry_Work.Close;
      if bLocalaccount then
      begin
        if (sBenutzername = slocalBenutzername) and (sPasswort = slocalPasswort) then
        begin
          bFirstLogin:= false;
          dmmain.iUserID:= 0;
          SetAutoLogin(sBenutzername, sPasswort, dmmain.iUserID, iServerID, true);
          AfterLogin(True);
        end
        else
        begin
          TThread.Synchronize(nil,
          procedure()
          begin
            if (sBenutzername = slocalBenutzername) and (sPasswort <> slocalPasswort) then
              ShowMessage('Passwort stimmt nicht überein.');
            if (sBenutzername <> slocalBenutzername) and (sPasswort = slocalPasswort) then
              ShowMessage('Benutzer stimmt nicht überein.');
            if (sBenutzername <> slocalBenutzername) and (sPasswort <> slocalPasswort) then
              ShowMessage('Benutzer und Passwort stimmen nicht überein.');
          end);
        end;
      end
      else
      begin
        SetServerlist;
        if iServerID <> -1 then
        begin
          qry_Work.SQL.Text := sSQL_SEL_ALL_Login_Where_BenutzerIDServer;
          qry_Work.ParamByName('User').AsString := sBenutzername;
          qry_Work.ParamByName('ID_Server').AsInteger := iServerID;
          qry_Work.Open();
          if qry_Work.RecordCount > 0 then
          begin
            if (qry_Work.FieldByName('Passwort').AsString = sPasswort) then
            begin
              dmmain.iUserID := qry_Work.FieldByName('ID_MA_Stammdaten').AsInteger;
              if dmmain.bServerAvailable then
              begin
                try
                  Synchronisation(dmmain.iUserID, iServerID, dmmain.wfWaitFrame,false);
                except
                  on E: Exception do ShowLoginMessage('Synchronisierung: ' + E.Message);
                end;
              end;
              qry_Work.Close;
              qry_Work.SQL.Text := sSQL_SEL_ALL_Login_Where_IDBenutzerIDServer;
              qry_Work.ParamByName('ID_MA_Stammdaten').AsInteger := dmmain.iUserID;
              qry_Work.ParamByName('ID_Server').AsInteger := iServerID;
              qry_Work.Open;
              qry_Work.Close;
              AfterLogin(False);
            end else
            begin
              TThread.Synchronize(nil,
              procedure()
              begin
                iServerID := -1;
                tc_Main.ActiveTab := ti_1Login;
                ShowMessage('Ihre gespeicherten Logindaten stimmen nicht mehr überein. Bitte Login erneut eingeben.');
              end);
            end;
          end else
          begin
            TThread.Synchronize(nil,
            procedure()
            begin
              iServerID := -1;
              tc_Main.ActiveTab := ti_1Login;
              ShowMessage('Ihre gespeicherten Logindaten stimmen nicht mehr überein. Bitte Login erneut eingeben.');
            end);
          end;
        end else
        begin
          TThread.Synchronize(nil,
          procedure()
          begin
            iServerID := -1;
            tc_Main.ActiveTab := ti_1Login;
            ShowMessage('Der hinterlegte Server ist nicht mehr vorhanden.');
          end);
        end;

      end;
      except
          on E: Exception do ShowLoginMessage('Login: ' + E.Message);
        end;
      finally
        dmmain.wfWaitFrame.HideFW;
      end;
    end);
end;
procedure Tfrm_PCM_Main.BerechneModulFinanzen;
var
  fEinnamen: double;
  ffixkosten: double;
  fgesamt: double;
  fvarKosten: double;
  wJahr: word;
  wMonat: word;
  wTag: word;
begin
  DecodeDate(Now,wJahr,wMonat,wTag);
  cbx_Jahr.OnChange:= nil;
  cbx_Monat.OnChange:= nil;
  cbx_Jahr.ItemIndex:= cbx_Jahr.Items.IndexOf(IntToStr(wJahr));
  cbx_Monat.ItemIndex:= wMonat - 1;
  qry_work.SQL.Text := sSQL_SEL_SUMBetrag_Einnahmen;
  qry_work.open;
  fEinnamen:= qry_work.FieldByName('Einnahmen').AsFloat;
  qry_work.close;

  qry_work.SQL.Text := sSQL_SEL_SUMBetrag_varKosten;
  qry_work.ParamByName('Monat').AsInteger:= cbx_Monat.ItemIndex + 1;
  qry_work.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
  qry_work.ParamByName('Fixkosten').AsBoolean:= false;
  qry_work.open;
  fvarKosten:= qry_work.FieldByName('varKosten').AsFloat;
  qry_work.close;
  qry_work.SQL.Text := sSQL_SEL_SUMBetrag_fixKosten;
  qry_work.ParamByName('Fixkosten').AsBoolean:= true;
  qry_work.open;
  ffixkosten:= qry_work.FieldByName('fixKosten').AsFloat;
  qry_work.close;
  lbl_EinnahmenDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fEinnamen);
  lo_FinanzenEinDetailGesamt.Text:= lbl_EinnahmenDetail.Text;
  lbl_EinnahmenGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fEinnamen);
  lbl_AusgabenVarDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fvarKosten);
  lbl_FinanzenVarGesamt.Text:= lbl_AusgabenVarDetail.Text;
  lbl_AusgabenVarGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fvarKosten);
  lbl_AusgabenFixDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', ffixkosten);
  lbl_FinanzenFixGesamt.Text:=lbl_AusgabenFixDetail.Text;
  lbl_AusgabenFixGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', ffixkosten);
  fgesamt:= fEinnamen - fvarKosten - ffixkosten;
  lbl_GesamtKompDetail.text:= FormatCurr(',0.00 €;-,0.00 €', fgesamt);
  mem_FinanzenEinDetailBesch.Lines.Clear;
  mem_FinanzenEinDetailBetrag.Lines.Clear;
  qry_work.SQL.Text := sSQL_SEL_QUelleBetrag_Einnahmen;
  qry_work.open;
  while not qry_work.Eof do
  begin
    mem_FinanzenEinDetailBesch.Lines.Add(qry_work.FieldByName('Quelle').asString);
    mem_FinanzenEinDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_work.FieldByName('Einnahmen').asFloat));
    qry_work.Next;
  end;
  qry_work.close;
  mem_FinanzenAusVarDetailBesch.Lines.Clear;
  mem_FinanzenAusVarDetailBetrag.Lines.Clear;
  qry_work.SQL.Text := sSQL_SEL_ALL_varKosten;
  qry_work.ParamByName('Monat').AsInteger:= cbx_Monat.ItemIndex + 1;
  qry_work.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
  qry_work.ParamByName('Fixkosten').AsBoolean:= false;
  qry_work.open;
  while not qry_work.Eof do
  begin
    mem_FinanzenAusVarDetailBesch.Lines.Add(qry_work.FieldByName('Name').asString);
    mem_FinanzenAusVarDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_work.FieldByName('varKosten').asFloat));
    qry_work.Next;
  end;
  qry_work.close;
  mem_FinanzenFixDetailBesch.Lines.Clear;
  mem_FinanzenfixDetailBetrag.Lines.Clear;
  qry_work.SQL.Text := sSQL_SEL_ALL_fixKosten;
  qry_work.ParamByName('Fixkosten').AsBoolean:= true;
  qry_work.open;
  while not qry_work.Eof do
  begin
    mem_FinanzenFixDetailBesch.Lines.Add(qry_work.FieldByName('Name').asString);
    mem_FinanzenfixDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_work.FieldByName('fixKosten').asFloat));
    qry_work.Next;
  end;
  qry_work.close;
  SetDisableToolButtons;
  lbl_ModulName.Text := 'Finanzen';
  lv_Ausgaben.Items.Clear;
  lv_Ausgaben.BeginUpdate;
  CreateFinAusGridConfig;
  lv_Ausgaben.EndUpdate;
  lv_Einnahmen.Items.Clear;
  lv_Einnahmen.BeginUpdate;
  CreateFinEinGridConfig;
  lv_Einnahmen.EndUpdate;
  lv_Belege.Items.Clear;
  lv_Belege.BeginUpdate;
  CreateBelegeGridConfig;
  lv_Belege.EndUpdate;
  btn_Search.Visible:= true;
  btn_AddData.Visible:= True;
  {$IFDEF MSWINDOWS}
  cbx_Jahr.OnChange:= cbx_MonatChange;
  cbx_Monat.OnChange:= cbx_MonatChange;
  btn_Search.visible:= false;
  tc_PassSerial.Margins.Left:= 16;
  tc_PassSerial.Margins.Right:= 16;
  lv_Einnahmen.SearchVisible:= true;
  lv_Ausgaben.SearchVisible:= true;
  lv_Belege.SearchVisible:= true;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.CreateDashboard;
var
  dtDateTime: TDateTime;
  fBelege: double;
  fEinnamenU: double;
  fFixkostenU: double;
  fGesamtU: double;
  fvarKostenU: double;
  iANzahlBelege: integer;
  sVon: string;
  sBis: string;
  tBis: Ttime;
  tVon: Ttime;
  trvwitm_Termine : TTreeViewItem;
  wJahr: Word;
  wMonat: Word;
  wTag: Word;
begin
  try
    qry_Work_sub:= TFDQuery.Create(nil);
    qry_Work_sub.Connection:= dmmain.con_PCM;
    DecodeDate(Now,wJahr,wMonat,wTag);
    // Kontakte
    qry_Work_sub.SQL.Text := sSQL_SEL_Count_Kontakte_Where_Deleted;
    qry_Work_sub.Open;
    lbl_ContactsDetail.Text:= qry_Work_sub.FieldByName('Anzahl').AsString;
    qry_Work_sub.Close;
    // Kalender
    qry_Work_sub.SQL.Text := sSQL_SEL_Count_Kalender_Where_Deleted;
    qry_Work_sub.Open;
    lbl_CalendarDetail.Text:= qry_Work_sub.FieldByName('Anzahl').AsString;
    qry_Work_sub.Close;
    // Kalender
    qry_Work_sub.SQL.Text := sSQL_SEL_ALL_Kalender_Where_DeletedBegEndRec;
    qry_Work_sub.ParamByName('Datum').AsDate:= Date;
    qry_Work_sub.Open;
    trvw_calender.Clear;
    trvwitm_Termine := TTreeViewItem.Create(Self);
    trvwitm_Termine.StyledSettings:=  trvwitm_Termine.StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.other];
    trvwitm_Termine.TextSettings.Font.Size:= 12;
    trvwitm_Termine.TextSettings.Font.Style:= [TFontStyle.fsBold];
    trvwitm_Termine.Text:= 'heutige Termine:';
    trvwitm_Termine.Parent := trvw_calender;
    while not qry_Work_sub.Eof do
    begin
      dtDateTime:= CheckReccurence(qry_Work_sub.FieldByName('ID').asInteger,qry_Work_sub.FieldByName('Start').AsDateTime,Date,qry_Work_sub.FieldByName('wiederholungtext').asString);
      if ((DateOf(dtDateTime) = Date) and (qry_Work_sub.FieldByName('wiederholungtext').asString <> '')) or (qry_Work_sub.FieldByName('wiederholungtext').asString = '') then
      begin
        trvwitm_Termine := TTreeViewItem.Create(Self);
        trvwitm_Termine.StyledSettings:=  trvwitm_Termine.StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.other];
        trvwitm_Termine.TextSettings.Font.Size:= 12;
        if qry_Work_sub.FieldByName('CompleteDay').AsBoolean then
        begin
          trvwitm_Termine.Text:= 'ganztägig: ' + qry_Work_sub.FieldByName('Caption').AsString
        end
        else begin
          tVon:= qry_Work_sub.FieldByName('Start').AsDateTime;
          sVon:= TimeToStr(tvon);

          tbis:= qry_Work_sub.FieldByName('Finish').AsDateTime;
          sbis:= TimeToStr(tbis);
          trvwitm_Termine.Text:= Copy(svon,1,5) + ' - ' + Copy(sbis,1,5) +  ': ' + qry_Work_sub.FieldByName('Caption').AsString;
        end;
        trvwitm_Termine.Parent := trvw_calender;
      end;
      qry_Work_sub.Next;
    end;
    qry_Work_sub.Close;
    // Belege
    qry_Work_sub.SQL.Text := sSQL_SEL_COUNT_Where_DeletedMonthYear;
    qry_Work_sub.ParamByName('Monat').AsInteger := wMonat;
    qry_Work_sub.ParamByName('Jahr').AsInteger := wJahr;
    qry_Work_sub.Open;
    iANzahlBelege:= qry_Work_sub.FieldByName('Anzahl').AsInteger;
    qry_Work_sub.close;
    if iANzahlBelege > 0 then
    begin
      qry_Work_sub.SQL.Text := sSQL_SEL_SUMBetrag_Belege;
      qry_Work_sub.ParamByName('Monat').AsInteger := wMonat;
      qry_Work_sub.ParamByName('Jahr').AsInteger := wJahr;
      qry_Work_sub.Open;
      fBelege:= qry_Work_sub.FieldByName('Anzahl').AsFloat;
      lbl_BelegeDetail.Text:= FormatCurr(',0.00 €;-,0.00 €',fBelege);
      qry_Work_sub.close;
    end
    else begin
      fBelege:= 0.0;
      lbl_BelegeDetail.Text:= FormatCurr(',0.00 €;-,0.00 €',fBelege);
    end;


    qry_Work_sub.SQL.Text := sSQL_SEL_SUMBetrag_Einnahmen;
    qry_Work_sub.open;
    fEinnamenU:= qry_Work_sub.FieldByName('Einnahmen').AsFloat;
    qry_Work_sub.close;
    qry_Work_sub.SQL.Text := sSQL_SEL_SUMBetrag_varKosten;
    qry_Work_sub.ParamByName('Monat').AsInteger:= wMonat;
    qry_Work_sub.ParamByName('Jahr').AsInteger:= wJahr;
    qry_Work_sub.ParamByName('Fixkosten').AsBoolean:= false;
    qry_Work_sub.open;
    fvarKostenU:= qry_Work_sub.FieldByName('varKosten').AsFloat;
    qry_Work_sub.close;
    qry_Work_sub.SQL.Text := sSQL_SEL_SUMBetrag_fixKosten;
    qry_Work_sub.ParamByName('Fixkosten').AsBoolean:= true;
    qry_Work_sub.open;
    fFixkostenU:= qry_Work_sub.FieldByName('fixKosten').AsFloat;
    qry_Work_sub.close;
    fGesamtU:= fEinnamenU - fvarKostenU - ffixkostenU - fBelege;
    trvw_FinanceDetail.Items[0].Text:= FormatCurr(',0.00 €;-,0.00 €',fEinnamenU);
    trvw_FinanceDetail.Items[1].Text:= FormatCurr(',0.00 €;-,0.00 €',fvarKostenU);
    trvw_FinanceDetail.Items[2].Text:= FormatCurr(',0.00 €;-,0.00 €',ffixkostenU);
    trvw_FinanceDetail.Items[3].Text:= FormatCurr(',0.00 €;-,0.00 €',fBelege);
    trvw_FinanceDetail.Items[4].Text:= FormatCurr(',0.00 €;-,0.00 €',fgesamtU);
    lbl_FinanceRestDetail.Text:= FormatCurr(',0.00 €;-,0.00 €',fgesamtU);
    lbl_FinanceGesamtDetail.Text:= 'ges.' + FormatCurr(',0.00 €;-,0.00 €',fEinnamenU);
    fgesamtU:= 360 - Round(360 / 100 * (fEinnamenU - fvarKostenU - ffixkostenU - fBelege) / fEinnamenU * 100);
    pie_Finance.EndAngle:=fgesamtU;

    // Passwörter
    qry_Work_sub.SQL.Text := sSQL_SEL_Count_Passwords_Where_Deleted;
    qry_Work_sub.Open;
    lbl_PasswortDetail.Text:= qry_Work_sub.FieldByName('Anzahl').AsString;
    qry_Work_sub.Close;


    // Serials
    qry_Work_sub.SQL.Text := sSQL_SEL_Count_Serials_Where_Deleted;
    qry_Work_sub.Open;
    lbl_SerialDetail.Text:= qry_Work_sub.FieldByName('Anzahl').AsString;
    qry_Work_sub.Close;

    // Gutscheine
    qry_Work_sub.SQL.Text := sSQL_SEL_Count_Gutscheine_Where_Deleted;
    qry_Work_sub.Open;
    iANzahlBelege:= qry_Work_sub.FieldByName('Anzahl').AsInteger;
    qry_Work_sub.close;

    if iANzahlBelege > 0 then
    begin
      qry_Work_sub.SQL.Text := sSQL_SEL_SUMRestwert_Gutscheine_Where_Deleted;
      qry_Work_sub.Open;
      lbl_GiftCardsDetail.Text:= FormatCurr(',0.00 €;-,0.00 €',qry_Work_sub.FieldByName('Anzahl').AsFloat);
      qry_Work_sub.close;
    end
    else begin
      lbl_GiftCardsDetail.Text:= FormatCurr(',0.00 €;-,0.00 €',0.0);
    end;
  except
  end;
end;
procedure Tfrm_PCM_Main.CreateFormServer;
begin
  Application.CreateForm(Tfrm_PCMAPP_Server, frm_PCMAPP_Server);
  frm_PCMAPP_Server.Show;
end;
procedure Tfrm_PCM_Main.CreateFrameSystem;
var
  frm_FrameSystem: Tfrm_PCMAPP_System;
begin
  lo_ConfigConfig.DeleteChildren;
  frm_FrameSystem := Tfrm_PCMAPP_System.Create(lo_ConfigConfig);
  frm_FrameSystem.Parent := lo_ConfigConfig;
  frm_FrameSystem.Align := TAlignLayout.Client;
  frm_FrameSystem.Execute;
end;
procedure Tfrm_PCM_Main.CreateFrameKontakteTelefon;
var
  frm_FrameKontakteTelefon: Tfrm_PCMAPP_ImportKontakte;
begin
  try
    bKontakte:= true;
    lo_DetailFrame.DeleteChildren;
  except
  end;
  frm_FrameKontakteTelefon := Tfrm_PCMAPP_ImportKontakte.Create(lo_ConfigImportContacts);
  frm_FrameKontakteTelefon.Parent := lo_ConfigImportContacts;
  frm_FrameKontakteTelefon.Align := TAlignLayout.Client;
end;
procedure Tfrm_PCM_Main.CloseDetailFrame(AModulName: String; iDetailFrame: Integer);
begin
  TThread.Queue(nil,
  procedure
  begin
    SetDisableToolButtons;
    lbl_ModulName.Text := AModulName;
    case iDetailFrame of
    1:
      begin
        tc_Main.ActiveTab := ti_3ActiveFrame;
        lo_DetailFrame.DeleteChildren;
      end;
    2:
      begin
        tc_Main.ActiveTab := ti_4DetailFrame;
      end;
    4:
      begin
        tc_Main.ActiveTab := ti_3ActiveFrame;
        lo_DetailFrame.DeleteChildren;
      end;
    5:
      begin
        lo_DetailFrame.DeleteChildren;
        lo_Frame.DeleteChildren;
      end;
    6:
      begin
        lo_DetailFrame.DeleteChildren;
        lo_Frame.DeleteChildren;
        tc_Main.ActiveTab := ti_1Login;
      end;
    end;
  end);
end;
procedure Tfrm_PCM_Main.MakeCall(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if pdsrvPhoneDialerService <> nil then
  begin
    if sPhoneNumber <> '' then
    begin
      PermissionsService.RequestPermissions([sCallPhonePermission], TakePhoneCallPermissionRequestResult, DisplayRationaleDialers)
    end;
  end
  else begin
     TDialogService.ShowMessage('Anruffunktion auf diesem Gerät nicht vorhanden.');
  end;
  {$else}
  TDialogService.ShowMessage('Anruffunktion auf diesem Gerät nicht vorhanden.');
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.ResizeLayout;
begin
  rec_3Password.Width:= Round((frm_PCM_Main.ClientWidth - 44) / 2);
  rec_3Serials.Width:= Round((frm_PCM_Main.ClientWidth - 44) / 2);
  rec_5Belege.Width:= Round((frm_PCM_Main.ClientWidth - 44) / 2);
  rec_5GiftCards.Width:= Round((frm_PCM_Main.ClientWidth - 44) / 2);
  lo_jahr.Width:= Round((frm_PCM_Main.ClientWidth - 48) / 2);
  lo_monat.Width:=  Round((frm_PCM_Main.ClientWidth - 48) / 2);
  rec_buchungenInfo.Width:= frm_PCM_Main.ClientWidth-96;
  rec_buchungenInfo.Position.x:= 32;
  rec_buchungenInfo.Position.Y:= Round(frm_PCM_Main.ClientHeight / 2) - Round(rec_buchungenInfo.Height / 2);
end;
procedure Tfrm_PCM_Main.SetAnimation(AAnimation: integer);
begin
  rec_5BelegeGiftCards.Align:= TAlignLayout.None;
  rec_4Fincance.Align:= TAlignLayout.None;
  rec_3PasswordSerials.Align:= TAlignLayout.None;
  rec_3Serials.Align:= TAlignLayout.None;
  rec_3Password.Align:= TAlignLayout.None;
  rec_2Calendar.Align:= TAlignLayout.None;
  rec_1Contacts.Align:= TAlignLayout.None;
  rec_1Contacts.Width:= frm_PCM_Main.ClientWidth - 32;
  rec_2Calendar.Width:= frm_PCM_Main.ClientWidth - 32;
  rec_3PasswordSerials.Width:= frm_PCM_Main.ClientWidth - 32;
  rec_4Fincance.Width:= frm_PCM_Main.ClientWidth - 32;
  rec_5BelegeGiftCards.Width:= frm_PCM_Main.ClientWidth - 32;
  case AAnimation of
  // Keine Animation
  0:
    begin
      rec_1Contacts.Align:= TAlignLayout.Top;
      rec_2Calendar.Align:= TAlignLayout.Top;
      rec_3PasswordSerials.Align:= TAlignLayout.Top;
      rec_3Password.Align:= TAlignLayout.Left;
      rec_3Password.Width:= frm_PCM_Main.ClientWidth / 2 - 24;
      rec_3Serials.Align:= TAlignLayout.Right;
      rec_3Serials.Width:= frm_PCM_Main.ClientWidth / 2 - 24;
      rec_4Fincance.Align:= TAlignLayout.Top;
      rec_5BelegeGiftCards.Align:= TAlignLayout.Top;
      rec_5Belege.Align:= TAlignLayout.Left;
      rec_5Belege.Width:= frm_PCM_Main.ClientWidth / 2 - 24;
      rec_5GiftCards.Align:= TAlignLayout.Right;
      rec_5GiftCards.Width:= frm_PCM_Main.ClientWidth / 2 - 24
    end;
  // von allen Richtungen
  1:
    begin
      fa_Contacts.Trigger:= '';
      fa_Calendar.Trigger:= '';
      fa_Password.Trigger:= '';
      fa_Serials.Trigger:= '';
      fa_Finance.Trigger:= '';
      fa_BelegeGiftCards.Trigger:= '';

      rec_1Contacts.Visible:= true;
      rec_2Calendar.Visible:= true;
      rec_3Password.Visible:= true;
      rec_3Serials.Visible:= true;
      rec_4Fincance.Visible:= true;
      rec_5BelegeGiftCards.Visible:= true;

      fa_Contacts.OnFinish:= nil;
      fa_Calendar.OnFinish:= nil;
      fa_Password.OnFinish:= nil;
      fa_Serials.OnFinish:= nil;
      fa_Finance.OnFinish:= nil;

      fa_Contacts.StartValue:= -192;
      fa_Calendar.StartValue:= -184;
      fa_Password.StartValue:= -184;
      fa_Serials.StartValue:= (frm_PCM_Main.ClientWidth / 2) - 8 + 200;
      fa_Finance.StartValue:= 216;
      fa_BelegeGiftCards.StartValue:= 838;

      fa_Contacts.StopValue:= 8;
      fa_Calendar.StopValue:= 16;
      fa_Password.StopValue:= 0;
      fa_Serials.StopValue:= (frm_PCM_Main.ClientWidth /2) - 12;
      fa_Finance.StopValue:= 16;
      fa_BelegeGiftCards.StopValue:= 638;

      fa_Contacts.PropertyName:= 'Position.Y';
      fa_Calendar.PropertyName:= 'Position.X';
      fa_Password.PropertyName:= 'Position.X';
      fa_Serials.PropertyName:= 'Position.X';
      fa_Finance.PropertyName:= 'Position.X';
      fa_BelegeGiftCards.PropertyName:= 'Position.Y';

      fa_Contacts.Stop;
      fa_Calendar.Stop;
      fa_Password.Stop;
      fa_Serials.Stop;
      fa_Finance.Stop;
      fa_BelegeGiftCards.Stop;

      fa_Contacts.Start;
      fa_Calendar.Start;
      fa_Password.Start;
      fa_Serials.Start;
      fa_Finance.Start;
      fa_BelegeGiftCards.Start;
    end;
  2:
    begin
      fa_Contacts.Trigger:= '';
      fa_Calendar.Trigger:= '';
      fa_Password.Trigger:= '';
      fa_Serials.Trigger:= '';
      fa_Finance.Trigger:= '';
      fa_BelegeGiftCards.Trigger:= '';

      rec_1Contacts.Visible:= true;
      rec_2Calendar.Visible:= true;
      rec_3Password.Visible:= true;
      rec_3Serials.Visible:= true;
      rec_4Fincance.Visible:= true;
      rec_5BelegeGiftCards.Visible:= true;

      fa_Contacts.OnFinish:= nil;
      fa_Calendar.OnFinish:= nil;
      fa_Password.OnFinish:= nil;
      fa_Serials.OnFinish:= nil;
      fa_Finance.OnFinish:= nil;

      fa_Contacts.StartValue:= -184;
      fa_Calendar.StartValue:= -184;
      fa_Password.StartValue:= -184;
      fa_Serials.StartValue:= (frm_PCM_Main.ClientWidth / 2) - 16 -184;
      fa_Finance.StartValue:= -184;
      fa_BelegeGiftCards.StartValue:= -184;

      fa_Contacts.StopValue:= 16;
      fa_Calendar.StopValue:= 16;
      fa_Password.StopValue:= 0;
      fa_Serials.StopValue:= (frm_PCM_Main.ClientWidth /2) - 12;
      fa_Finance.StopValue:= 16;
      fa_BelegeGiftCards.StopValue:= 16;

      fa_Contacts.PropertyName:= 'Position.X';
      fa_Calendar.PropertyName:= 'Position.X';
      fa_Password.PropertyName:= 'Position.X';
      fa_Serials.PropertyName:= 'Position.X';
      fa_Finance.PropertyName:= 'Position.X';
      fa_BelegeGiftCards.PropertyName:= 'Position.X';

      fa_Contacts.Stop;
      fa_Calendar.Stop;
      fa_Password.Stop;
      fa_Serials.Stop;
      fa_Finance.Stop;
      fa_BelegeGiftCards.Stop;

      fa_Contacts.Start;
      fa_Calendar.Start;
      fa_Password.Start;
      fa_Serials.Start;
      fa_Finance.Start;
      fa_BelegeGiftCards.Start;
    end;
  3:
    begin
      fa_Contacts.Trigger:= '';
      fa_Calendar.Trigger:= 'IsVisible=true';
      fa_Password.Trigger:= 'IsVisible=true';
      fa_Serials.Trigger:= 'IsVisible=true';
      fa_Finance.Trigger:= 'IsVisible=true';
      fa_BelegeGiftCards.Trigger:= 'IsVisible=true';

      rec_1Contacts.Visible:= true;
      rec_2Calendar.Visible:= false;
      rec_3Password.Visible:= false;
      rec_3Serials.Visible:= false;
      rec_4Fincance.Visible:= false;
      rec_5BelegeGiftCards.Visible:= false;


      fa_Contacts.OnFinish:= fa_ContactsFinish;
      fa_Calendar.OnFinish:= fa_CalendarFinish;
      fa_Password.OnFinish:= fa_paswordFinish;
      fa_Serials.OnFinish:= fa_SerialsFinish;
      fa_Finance.OnFinish:= fa_financeFinish;


      fa_Contacts.StartValue:= -84;
      fa_Calendar.StartValue:= -84;
      fa_Password.StartValue:= -84;
      fa_Serials.StartValue:= (frm_PCM_Main.ClientWidth / 2) - 16 -84;
      fa_Finance.StartValue:= -84;
      fa_BelegeGiftCards.StartValue:= -84;

      fa_Contacts.StopValue:= 16;
      fa_Calendar.StopValue:= 16;
      fa_Password.StopValue:= 0;
      fa_Serials.StopValue:= (frm_PCM_Main.ClientWidth /2) - 12;
      fa_Finance.StopValue:= 16;
      fa_BelegeGiftCards.StopValue:= 16;

      fa_Contacts.PropertyName:= 'Position.X';
      fa_Calendar.PropertyName:= 'Position.X';
      fa_Password.PropertyName:= 'Position.X';
      fa_Serials.PropertyName:= 'Position.X';
      fa_Finance.PropertyName:= 'Position.X';
      fa_BelegeGiftCards.PropertyName:= 'Position.X';

      fa_Contacts.Stop;
//      fa_Calendar.Stop;
//      fa_Password.Stop;
//      fa_Serials.Stop;
//      fa_Finance.Stop;
//      fa_BelegeGiftCards.Stop;

      fa_Contacts.Start;
//      fa_Calendar.Start;
//      fa_Password.Start;
//      fa_Serials.Start;
//      fa_Finance.Start;
//      fa_BelegeGiftCards.Start;
    end;
  end;
//  rec1.Align:= TAlignLayout.Top;
//  rec_2Calendar.Align:= TAlignLayout.Top;
//  rec_3PasswordSerials.Align:= TAlignLayout.Top;
//  rec_3Password.Align:= TAlignLayout.left;
//  rec_3Serials.Align:= TAlignLayout.right;
//  rec_4Fincance.Align:= TAlignLayout.Top;
//  rec_5BelegeGiftCards.Align:= TAlignLayout.Top;
//  rec_5left.Align:= TAlignLayout.left;
//  rec_5GiftCards.Align:= TAlignLayout.right;
end;
procedure Tfrm_PCM_Main.SetAutoLogin(sUsername, sPasswort: String; iID_MA_Stammdaten, iID_Server: Integer; bAutoLogin: Boolean);
begin
  qry_Work.SQL.Text := sSQL_SEL_COUNT_Autologin;
  qry_Work.open;
  if qry_Work.FieldByName('ANZAHL').AsInteger = 0 then
  begin
    qry_Work.Close;
    qry_Work.SQL.Text := sSQL_INS_All_Autologin_Without_localaccount;
    qry_Work.ParamByName('Benutzername').AsString := sUsername;
    qry_Work.ParamByName('Passwort').AsString := sPasswort;
    qry_Work.ParamByName('Autologin').AsBoolean := true;
    qry_Work.ParamByName('ID').AsInteger := iID_MA_Stammdaten;
    qry_Work.ParamByName('ID_Server').AsInteger := iID_Server;
    qry_Work.ParamByName('Design').AsInteger := 0;
    qry_Work.ParamByName('DesignApp').AsInteger := 0;
    qry_Work.ParamByName('DesignWin').AsInteger := 0;
    qry_Work.ExecSQL;

    if sDeviceToken <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_DEVICETOKEN_Autologin;
      qry_Work.ParamByName('DeviceToken').AsString := sDeviceToken;
      qry_Work.ExecSQL;
    end;

    if sDeviceID <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_DEVICEID_Autologin;
      qry_Work.ParamByName('DeviceID').AsString := sDeviceID;
      qry_Work.ExecSQL;
    end;

  end
  else begin
    qry_Work.Close;
    if sUsername <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_Benutzer_Autologin;
      qry_Work.ParamByName('Benutzername').AsString := sUsername;
      qry_Work.ExecSQL;
    end;
    if sPasswort <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_Passwort_Autologin;
      qry_Work.ParamByName('Passwort').AsString := sPasswort;
      qry_Work.ExecSQL;
    end;
    if sDeviceToken <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_DEVICETOKEN_Autologin;
      qry_Work.ParamByName('DeviceToken').AsString := sDeviceToken;
      qry_Work.ExecSQL;
    end;
    if sDeviceID <> '' then
    begin
      qry_Work.SQL.Text := sSQL_UPD_DEVICEID_Autologin;
      qry_Work.ParamByName('DeviceID').AsString := sDeviceID;
      qry_Work.ExecSQL;
    end;
  end;
end;
procedure Tfrm_PCM_Main.SetDesign(ADesignApp,ADesignWin: integer);
var
  cdlDetailColor: Cardinal;
  cdlTextColor: Cardinal;
  cdlCirclecolor: Cardinal;
  iCount: Integer;
  iDesignStyle: integer;
begin
  if Assigned(dmmain.wfWaitFrame) then
    FreeAndNil(dmmain.wfWaitFrame);
  dmmain.wfWaitFrame := TWaitForm.Create(lo_MainPCM);
  dmmain.wfWaitFrame.Parent := lo_MainPCM;
  dmmain.wfWaitFrame.Visible := False;
  cdlDetailColor:=TAlphaColorRec.White;
  cdlTextColor:= TAlphaColorRec.White;
  cdlCirclecolor:= TAlphaColorRec.White;
  try
    {$IFDEF ANDROID}
    iDesignStyle:= ADesignapp;
    {$ENDIF ANDROID}
    {$IFDEF MSWINDOWS}
    iDesignStyle:= ADesignwin;
    {$ENDIF MSWINDOWS}
    case iDesignStyle of
      0: // Calypso
      begin
        frm_PCM_Main.StyleBook:= dmMain.stB_0;
        btn_Multiview.ImageIndex:= 1;
        btn_BackSystem.ImageIndex:= 3;
        btn_Search.ImageIndex:= 5;
        btn_AddData.ImageIndex:= 7;
        btn_CloseApp.ImageIndex:= 9;
        btn_Synchronisation.ImageIndex:= 11;
        btn_UserImg.ImageIndex:= 13;
        btn_lock.ImageIndex:= 15;
        btn_Unlock.ImageIndex:= 17;
        cdlDetailColor:=TAlphaColorRec.White;
        cdlTextColor:= TAlphaColorRec.White;
        cdlCirclecolor:= $FF223D5A;
      end;
      1: // Hell
      begin
        frm_PCM_Main.StyleBook:= dmMain.stB_1;
        btn_Multiview.ImageIndex:= 0;
        btn_BackSystem.ImageIndex:= 2;
        btn_Search.ImageIndex:= 4;
        btn_AddData.ImageIndex:= 6;
        btn_CloseApp.ImageIndex:= 8;
        btn_Synchronisation.ImageIndex:= 10;
        btn_UserImg.ImageIndex:= 12;
        btn_lock.ImageIndex:= 14;
        btn_Unlock.ImageIndex:= 16;
        cdlDetailColor:= TAlphaColorRec.Black;
        cdlTextColor:= TAlphaColorRec.Black;
        {$IFDEF MSWINDOWS}
        cdlCirclecolor:= $FF3DC9ED;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        cdlCirclecolor:= $FFE67A6E;
        {$ENDIF ANDROID}
      end;
      2: // Dunkel
      begin
        frm_PCM_Main.StyleBook:= dmMain.stB_2;
        btn_Multiview.ImageIndex:= 1;
        btn_BackSystem.ImageIndex:= 3;
        btn_Search.ImageIndex:= 5;
        btn_AddData.ImageIndex:= 7;
        btn_CloseApp.ImageIndex:= 9;
        btn_Synchronisation.ImageIndex:= 11;
        btn_UserImg.ImageIndex:= 13;
        btn_lock.ImageIndex:= 15;
        btn_Unlock.ImageIndex:= 17;
        cdlDetailColor:=TAlphaColorRec.White;
        cdlTextColor:= TAlphaColorRec.White;
        {$IFDEF MSWINDOWS}
        cdlCirclecolor:= $FF936639;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        cdlCirclecolor:= $FF2B2B2B;
        {$ENDIF ANDROID}
      end;
      3: // Dunkel Blau
      begin
        frm_PCM_Main.StyleBook:= dmMain.stB_3;
        btn_Multiview.ImageIndex:= 1;
        btn_BackSystem.ImageIndex:= 3;
        btn_Search.ImageIndex:= 5;
        btn_AddData.ImageIndex:= 7;
        btn_CloseApp.ImageIndex:= 9;
        btn_Synchronisation.ImageIndex:= 11;
        btn_UserImg.ImageIndex:= 13;
        btn_lock.ImageIndex:= 15;
        btn_Unlock.ImageIndex:= 17;
        cdlDetailColor:=TAlphaColorRec.White;
        cdlTextColor:= TAlphaColorRec.White;
        {$IFDEF MSWINDOWS}
        cdlCirclecolor:= $FF0E7F9C;
        {$ENDIF MSWINDOWS}
        {$IFDEF ANDROID}
        cdlCirclecolor:= $FF202A2E;
        {$ENDIF ANDROID}
      end;
    {$IFDEF MSWINDOWS}
    4:
      begin
        frm_PCM_Main.StyleBook:= dmMain.stB_4;
        btn_Multiview.ImageIndex:= 1;
        btn_BackSystem.ImageIndex:= 3;
        btn_Search.ImageIndex:= 5;
        btn_AddData.ImageIndex:= 7;
        btn_CloseApp.ImageIndex:= 9;
        btn_Synchronisation.ImageIndex:= 11;
        btn_UserImg.ImageIndex:= 13;
        btn_lock.ImageIndex:= 15;
        btn_Unlock.ImageIndex:= 17;
        cdlDetailColor:= TAlphaColorRec.White;
        cdlTextColor:= TAlphaColorRec.White;
        cdlCirclecolor:= $FF250C12;
      end;
    {$ENDIF MSWINDOWS}
    end;
    //Dashboard
    rec_1Contacts.Fill.Color:= cdlCirclecolor;
    crl_ContactsSub.Fill.Color:= cdlCirclecolor;
    rec_2Calendar.Fill.Color:= cdlCirclecolor;
    crl_CalendarSub.Fill.Color:= cdlCirclecolor;
    rec_3Password.Fill.Color:= cdlCirclecolor;
    crl_passwordSub.Fill.Color:= cdlCirclecolor;
    rec_3Serials.Fill.Color:= cdlCirclecolor;
    crl_SerialSub.Fill.Color:= cdlCirclecolor;
    rec_4Fincance.Fill.Color:= cdlCirclecolor;
    crl_FinanceSub.Fill.Color:= cdlCirclecolor;
    rec_5Belege.Fill.Color:= cdlCirclecolor;
    crl_BelegeSub.Fill.Color:= cdlCirclecolor;
    rec_5GiftCards.Fill.Color:= cdlCirclecolor;
    crl_GiftCardsSub.Fill.Color:= cdlCirclecolor;
    // Finanzen
    ln_FinanzenEinDetailGesamt.stroke.Color:= cdlTextColor;
    ln_FinanzenAusVarDetail.Stroke.Color:= cdlTextColor;
    ln_FinanzenAusFixDetail.Stroke.Color:= cdlTextColor;
    frm_PCM_Main.lv_Kontakte.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Kontakte.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Kalender.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Kalender.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_KalenderKompakt.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_KalenderKompakt.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Passwort.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Passwort.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Serials.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Serials.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Ausgaben.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Ausgaben.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Einnahmen.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Einnahmen.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Gutschein.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Gutschein.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Belege.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Belege.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;
    frm_PCM_Main.lv_Calabo.ItemAppearanceObjects.ItemObjects.Detail.TextColor := cdlDetailColor;
    frm_PCM_Main.lv_Calabo.ItemAppearanceObjects.ItemObjects.Text.TextColor:= cdlTextColor;

    for iCount := 0 to cbx_Monat.count - 1 do
    begin
      cbx_Monat.ListBox.ListItems[iCount].StyledSettings:= cbx_Monat.ListBox.ListItems[iCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Monat.ListBox.ListItems[iCount].TextSettings.Font.Size:= 12;
      cbx_Monat.ListBox.ListItems[iCount].TextSettings.FontColor:= TAlphaColors.White;
    end;

    for iCount := 0 to cbx_Jahr.count - 1 do
    begin
      cbx_Jahr.ListBox.ListItems[iCount].StyledSettings:= cbx_Jahr.ListBox.ListItems[iCount].StyledSettings - [TStyledSetting.Size,TStyledSetting.Style,TStyledSetting.FontColor,TStyledSetting.Other];
      cbx_Jahr.ListBox.ListItems[iCount].TextSettings.Font.Size:= 12;
      cbx_Jahr.ListBox.ListItems[iCount].TextSettings.FontColor:= TAlphaColors.White;
    end;
  except
  end;
end;
procedure Tfrm_PCM_Main.SetDisableToolButtons;
begin
  btn_AddData.Visible := false;
  btn_Synchronisation.Visible := False;
  btn_BackSystem.Visible := False;
  btn_Search.Visible := False;
end;
procedure Tfrm_PCM_Main.SetServerList;
begin
  try
    iServerID:= -1;
    qry_Work_Sub.SQL.Text := sSQL_SEL_All_Server;
    qry_Work_Sub.Open;
    while not qry_Work_Sub.Eof do
    begin
      edt_Server.Text:= qry_Work_Sub.FieldByName('Bezeichnung').AsString;
      dmmain.sHostname:= qry_Work_Sub.FieldByName('Hostname').AsString;
      dmmain.sPort:= qry_Work_Sub.FieldByName('Port').AsString;
      iServerID:= qry_Work_Sub.FieldByName('ID').AsInteger;
      qry_Work_Sub.Next;
    end;
    qry_Work_Sub.Close;
  except
  end;
end;
procedure Tfrm_PCM_Main.ShowStartpage;
begin
  lbl_Modulname.Text:= 'Startseite';
  iTags:= 0;
  tc_Main.ActiveTab:= ti_2MainProgram;
  CreateDashboard;
  tc_MainApp.ActiveTab:= ti_1MainHome;
  SetAnimation(iAnimation);
end;
{$EndRegion Helperfunctions}
////////////////////////////////////////////////////////////////////////////////
// LOGIN FUNCTIONS                                                            //
////////////////////////////////////////////////////////////////////////////////
{$Region Loginfunctions}
procedure Tfrm_PCM_Main.btn_lockClick(Sender: TObject);
begin
  btn_Lock.Visible:= false;
  btn_UnLock.Visible:= true;
  edt_Passwort.Password:= false;
end;
procedure Tfrm_PCM_Main.btn_UnlockClick(Sender: TObject);
begin
  btn_Lock.Visible:= true;
  btn_UnLock.Visible:= false;
  edt_Passwort.Password:= true;
end;
procedure Tfrm_PCM_Main.lbl_CreateAccountNewClick(Sender: TObject);
begin
  CreateFormServer;
end;
procedure Tfrm_PCM_Main.btn_LoginClick(Sender: TObject);
  procedure LoginFirstStart;
  var
    bLocalaccount: boolean;
    bSynch: Boolean;
    slocalBenutzername: String;
    slocalPasswort: String;
    sBenutzername: String;
    sPasswort: String;
  begin
    {$IFDEF ANDROID}
    if (bHasBiometric) then
    begin
      TDialogServiceAsync.MessageDialog('Möchten Sie Ihren Fingerabdruck zum Anmelden verwenden?',
      TMsgDlgType.mtInformation, mbYesNo, TMsgDlgBtn.mbNo, 0,
        procedure(const AResult: TModalResult)
        begin
          qry_Work.SQL.Text := 'UPDATE Auto_Login SET FingerAuthenticate = :Finger,Autologin = :Autologin';
          if AResult = mrYes then
          begin
            qry_Work.ParamByName('Finger').AsBoolean:= true;
            qry_Work.ParamByName('Autologin').AsBoolean:= false;
          end
          else begin
            qry_Work.ParamByName('Finger').AsBoolean:= false;
            qry_Work.ParamByName('Autologin').AsBoolean:= false;
          end;
          qry_Work.ExecSQL;
        end);
    end
    else begin
      TDialogServiceAsync.MessageDialog('Möchten Sie automatisches Login aktivieren?',
      TMsgDlgType.mtInformation, mbYesNo, TMsgDlgBtn.mbNo, 0,
        procedure(const AResult: TModalResult)
        begin
          qry_Work.SQL.Text := 'UPDATE Auto_Login SET FingerAuthenticate = :Finger,Autologin = :Autologin';
          if AResult = mrYes then
          begin
            qry_Work.ParamByName('Finger').AsBoolean:= false;
            qry_Work.ParamByName('Autologin').AsBoolean:= true;
          end
          else begin
            qry_Work.ParamByName('Finger').AsBoolean:= false;
            qry_Work.ParamByName('Autologin').AsBoolean:= false;
          end;
          qry_Work.ExecSQL;
        end);
    end;
    {$EndIF ANDROID}
    sBenutzername := edt_Benutzername.Text;
    sPasswort := edt_Passwort.Text;
    btn_Login.Enabled := False;
    dmmain.wfWaitFrame.Execute('Erstes Login...', 'Login', True);
    TTask.Run(
    procedure ()
    begin
      try
        try
      qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
      qry_Work.Open;
      bLocalaccount:= qry_Work.FieldByName('Localaccount').AsBoolean;
      slocalBenutzername:= qry_Work.FieldByName('Benutzername').AsString;
      slocalPasswort:= qry_Work.FieldByName('Passwort').AsString;
      qry_Work.Close;
      if bLocalaccount then
      begin
        if (sBenutzername = slocalBenutzername) and (sPasswort = slocalPasswort) then
        begin
          bFirstLogin:= true;
          dmmain.iUserID:= 0;
          SetAutoLogin(sBenutzername, sPasswort, dmmain.iUserID, iServerID, true);
          AfterLogin(True);
        end
        else
        begin
          TThread.Synchronize(nil,
          procedure()
          begin
            if (sBenutzername = slocalBenutzername) and (sPasswort <> slocalPasswort) then
              ShowMessage('Passwort stimmt nicht überein.');
            if (sBenutzername <> slocalBenutzername) and (sPasswort = slocalPasswort) then
              ShowMessage('Benutzer stimmt nicht überein.');
            if (sBenutzername <> slocalBenutzername) and (sPasswort <> slocalPasswort) then
              ShowMessage('Benutzer und Passwort stimmen nicht überein.');
          end);
        end;
      end
      else
      begin
        bSynch := False;
        SetServerList;
        if iServerID <> -1 then
        begin
          if dmmain.bServerAvailable then
          begin
            if CheckLogin(sBenutzername, sPasswort) then
            begin
              bFirstLogin:= true;
              SetAutoLogin(sBenutzername, sPasswort, dmmain.iUserID, iServerID, true);
              qry_Work_Sub.SQL.Text := sSQL_UPD_FIRSTSTART_login;
              qry_Work_Sub.ParamByName('Bool').AsBoolean := False;
              qry_Work_Sub.ParamByName('ID').AsInteger := dmmain.iUserID;
              qry_Work_Sub.ParamByName('ID_Server').AsInteger := iServerID;
              qry_Work_Sub.ExecSQL;
              SaveLogin(sBenutzername, sPasswort,dmmain.iUserID, iServerID,true);
              try
                  Synchronisation(dmmain.iUserID, iServerID, dmmain.wfWaitFrame,false);
                except
                  on E: Exception do ShowLoginMessage('Synchronisierung: ' + E.Message);
                end;
              AfterLogin(True);
            end else
            begin
              TThread.Synchronize(nil,
              procedure()
              begin
                ShowMessage('Benutzername oder Passwort falsch. Bitte geben Sie ein gültiges Login ein.');
              end);
            end;
          end else
          begin
            TThread.Synchronize(nil,
            procedure()
            begin
              ShowMessage('Für die erste Verwendung der App wird eine Verbindung zum Server vorrausgesetzt. Bitte überprüfen.');
            end);
          end;

        end else
        begin
          TThread.Synchronize(nil,
          procedure()
          begin
            ShowMessage('Es wurde noch kein Server konfiguriert. Bitte Server unter Einstellungen konfigurieren.');
          end);
        end;
      end;
      except
          on E: Exception do ShowLoginMessage('Login: ' + E.Message);
        end;
      finally
        dmmain.wfWaitFrame.HideFW;
        TThread.Queue(nil, procedure begin btn_Login.Enabled := True; end);
      end;
    end);
  end;
  procedure Login;
  var
    bLocalaccount: boolean;
    slocalBenutzername: String;
    slocalPasswort: String;
    sBenutzername: String;
    sPasswort: String;
  begin
    sBenutzername := edt_Benutzername.Text;
    sPasswort := edt_Passwort.Text;
    btn_Login.Enabled := False;
    dmmain.wfWaitFrame.Execute('Login...', 'Login',True);
    TTask.Run(
    procedure ()
    begin
      try
        try
      qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
      qry_Work.Open;
      bLocalaccount:= qry_Work.FieldByName('Localaccount').AsBoolean;
      slocalBenutzername:= qry_Work.FieldByName('Benutzername').AsString;
      slocalPasswort:= qry_Work.FieldByName('Passwort').AsString;
      qry_Work.Close;
      if bLocalaccount then
      begin
        if (sBenutzername = slocalBenutzername) and (sPasswort = slocalPasswort) then
        begin
          bFirstLogin:= false;
          dmmain.iUserID:= 0;
          SetAutoLogin(sBenutzername, sPasswort, dmmain.iUserID, iServerID, true);
          AfterLogin(True);
        end
        else
        begin
          if (sBenutzername = slocalBenutzername) and (sPasswort <> slocalPasswort) then
            ShowLoginMessage('Passwort stimmt nicht überein.');
          if (sBenutzername <> slocalBenutzername) and (sPasswort = slocalPasswort) then
            ShowLoginMessage('Benutzer stimmt nicht überein.');
          if (sBenutzername <> slocalBenutzername) and (sPasswort <> slocalPasswort) then
            ShowLoginMessage('Benutzer und Passwort stimmen nicht überein.');
        end;
      end
      else
      begin
        SetServerList;
        if iServerID <> -1 then
        begin
          qry_Work.Close;
          qry_Work.SQL.Text := sSQL_SEL_ALL_Login_Where_BenutzerIDServer;
          qry_Work.ParamByName('User').AsString := sBenutzername;
          qry_Work.ParamByName('ID_Server').AsInteger := iServerID;
          qry_Work.Open;
          if qry_Work.RecordCount > 0 then
          begin
            if (qry_Work.FieldByName('Passwort').AsString = sPasswort) then
            begin
              dmmain.iUserID := qry_Work.FieldByName('ID_MA_Stammdaten').AsInteger;
              SetAutoLogin(sBenutzername, sPasswort, dmmain.iUserID, iServerID, True);
              qry_Work.Close;
              if dmmain.bServerAvailable then
              begin
                SaveLogin(sBenutzername, sPasswort,dmmain.iUserID, iServerID,false);
                try
                  Synchronisation(dmmain.iUserID, iServerID, dmmain.wfWaitFrame,false);
                except
                  on E: Exception do ShowLoginMessage('Synchronisierung: ' + E.Message);
                end
              end;
              try
  //              SynchRestCal(wfWaitFrame);
              except
              end;
              qry_Work.Close;
              qry_Work.SQL.Text := sSQL_SEL_ALL_Login_Where_IDBenutzerIDServer;
              qry_Work.ParamByName('ID_MA_Stammdaten').AsInteger := dmmain.iUserID;
              qry_Work.ParamByName('ID_Server').AsInteger := iServerID;
              qry_Work.Open;
              qry_Work.Close;
              AfterLogin(False);
            end else
            begin
              ShowLoginMessage('Benutzername oder Passwort falsch. Bitte geben Sie ein gültiges Login ein.');
            end;
          end else
          begin
            ShowLoginMessage('Benutzername oder Passwort falsch. Bitte geben Sie ein gültiges Login ein.');
          end;
        end else
        begin
          ShowLoginMessage('Es wurde noch kein Server konfiguriert. Bitte Server unter Einstellungen konfigurieren.');
        end;
      end;
      except
          on E: Exception do ShowLoginMessage('Login: ' + E.Message);
        end;
      finally
        dmmain.wfWaitFrame.HideFW;
        TThread.Queue(nil, procedure begin btn_Login.Enabled := True; end);
      end;
    end);
//    LoginTask.Start;
  end;
begin
  qry_Work.Close;
  qry_Work.SQL.Text := sSQL_SEL_ALL_Login_Where_Benutzer;
  qry_Work.ParamByName('User').AsString := edt_Benutzername.Text;
  qry_Work.Open;
  if (qry_Work.RecordCount = 0) or (qry_Work.FieldByName('FirstStart').AsBoolean = True) then
  begin
    LoginFirstStart;
  end else
  begin
    Login;
  end;
end;
{$EndRegion Loginfunctions}
////////////////////////////////////////////////////////////////////////////////
// BIOMETRIC / PERMISSION FUNCTIONS                                           //
////////////////////////////////////////////////////////////////////////////////
{$Region Biometricfunctions}
procedure Tfrm_PCM_Main.img_BiometricClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  baBiometric.GetBiometryKind;
  baBiometric.Authenticate;
  {$ENDIF ANDROID}
end;
{$IFDEF ANDROID}
procedure Tfrm_PCM_Main.BiometricAuth1AuthenticateFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
begin
  tc_Main.ActiveTab:= ti_1Login;
end;
procedure Tfrm_PCM_Main.BiometricAuth1AuthenticateSuccess(Sender: TObject);
begin
  qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
  qry_Work.Open;
  AutoLogin(qry_Work.FieldByName('Benutzername').AsString, qry_Work.FieldByName('Passwort').AsString);
  qry_Work.Close;
end;
procedure Tfrm_PCM_Main.Listening(const AIsListening: Boolean);
begin
end;
procedure Tfrm_PCM_Main.ApplicationEventMessageHandler(const Sender: TObject; const M: TMessage);
begin
end;
constructor Tfrm_PCM_Main.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TApplicationEventMessage, ApplicationEventMessageHandler);
  Listening(False);
end;
destructor Tfrm_PCM_Main.Destroy;
begin
  FreeAndNil(FPushConnection);
  TMessageManager.DefaultManager.Unsubscribe(TApplicationEventMessage, ApplicationEventMessageHandler);
  inherited;
end;
////////////////////////////////////////////////////////////////////////////////
// PERMISSION FUNCTIONS                                                       //
////////////////////////////////////////////////////////////////////////////////
procedure Tfrm_PCM_Main.DisplayRationaleDialers(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage('The app needs to be able to support your making phone calls',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;
procedure Tfrm_PCM_Main.TakePhoneCallPermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    pdsrvPhoneDialerService.Call(StringReplace(sPhoneNumber, ' ', '-', [rfReplaceAll]))
  end;
end;
{$ENDIF ANDROID}
{$EndRegion Biometricfunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM FUNCTIONS                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Formfunctions}
procedure Tfrm_PCM_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseDetailFrame('Beenden', 5);
  if Assigned(dmmain.wfWaitFrame) then
    FreeAndNil(dmmain.wfWaitFrame);
  Action := TCloseAction.caFree;
end;
procedure Tfrm_PCM_Main.FormCreate(Sender: TObject);
begin
  FormatSettings.LongTimeFormat:= 'HH:mm:ss';
  FormatSettings.ShortTimeFormat:= 'HH:mm';
  FormatSettings.ShortDateFormat:= 'dd.mm.yyyy';
  try
    iServerID := -1;
    {$IFDEF ANDROID}
    if not TPlatformServices.Current.SupportsPlatformService (IFMXClipboardService, IInterface (clpbrdsrvClipboardService)) then
       raise Exception.Create ( 'Can not get access to clipboard service!');
    if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, evsrvEventService) then
      sCallPhonePermission := JStringToString(TJManifest_permission.JavaClass.CALL_PHONE);
    TPlatformServices.Current.SupportsPlatformService(IFMXPhoneDialerService, pdsrvPhoneDialerService);
    {$ENDIF ANDROID}
    qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
    qry_Work.Open;
    if qry_Work.RecordCount > 0 then
    begin
      iAnimation:= qry_Work.FieldByName('Design').AsInteger;
      iDesignAPP:= qry_Work.FieldByName('DesignApp').AsInteger;
      iDesignwin:= qry_Work.FieldByName('DesignWin').AsInteger;
    end
    else begin
      iAnimation:= 0;
      iDesignAPP:= 0;
      iDesignwin:= 0;
    end;
    SetDesign(iDesignAPP,iDesignwin);
    qry_Work.close;
  except
  end;
end;
procedure Tfrm_PCM_Main.FormShow(Sender: TObject);
  function GetCodename(VerString: string): string;
  begin
    Result:= 'Windows';
    {$IFDEF ANDROID}
    case AnsiIndexStr(VerString, ['1.0','1.5','1.6','2.0','2.1','2.2','2.3','3','4.0','4.1','4.2','4.3','4.4','5','6','7','8','9','10','11','12','13','14','15']) of
    0: Result:= 'Android 1.0: BASE';
    1: Result:= 'Android 1.5: CUPCAKE';
    2: Result:= 'Android 1.6: DONUT';
    3: Result:= 'Android 2.0: ECLAIR';
    4: Result:= 'Android 2.1: ECLAIR';
    5: Result:= 'Android 2.2: FROYO';
    6: Result:= 'Android 2.3: GINGERBREAD';
    7: Result:= 'Android 3: HONEYCOMB';
    8: Result:= 'Android 4.0: ICE_CREAM_SANDWICH';
    9: Result:= 'Android 4.1: JELLY_BEAN';
    10: Result:= 'Android 4.2: JELLY_BEAN';
    11: Result:= 'Android 4.3: JELLY_BEAN';
    12: Result:= 'Android 4.4: KITKAT';
    13: Result:= 'Android 5:	LOLLIPOP';
    14: Result:= 'Android 6:	MARSHMALLOW';
    15: Result:= 'Android 7:	NOUGAT';
    16: Result:= 'Android 8:	OREO';
    17: Result:= 'Android 9:	PIE';
    18: Result:= 'Android 10:	ANDROID Q';
    19: Result:= 'Android 11:	RED VELVET CAKE';
    20: Result:= 'Android 12:	SNOW CONE';
    21: Result:= 'Android 13:	TIRAMISU';
    22: Result:= 'Android 14:	UPSIDE DOWN CAKE';
    23: Result:= 'Android 15:	VANILLA ICE';
    end;
    {$ENDIF ANDROID}
  end;
{$IFDEF ANDROID}
var
   pshsrvPushService: TPushService;
   PushChannel: TChannel;
{$ENDIF ANDROID}
begin
  WriteLog('PCM - APP FormShow',0,true);
  {$IFDEF ANDROID}
  PermissionsService.RequestPermissions([ 'android.permission.READ_MEDIA_AUDIO',
                                          'android.permission.READ_MEDIA_IMAGES',
                                          'android.permission.READ_MEDIA_AUDIO',
                                          'android.permission.CAMERA',
                                          'android.permission.POST_NOTIFICATIONS',
                                          'android.permission.READ_CONTACTS',
                                          'android.permission.CALL_PHONE'
                                          ],
  procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
  begin
//    if AGrantResults[0] = TPermissionStatus.Granted
  end);
  btn_CloseApp.Visible:= false;
  baBiometric:= TBioMetricauth.Create(nil);
  baBiometric.BiometricStrengths := [ TBiometricStrength.DeviceCredential,TBiometricStrength.Strong,TBiometricStrength.Weak];
  baBiometric.PromptTitle:= 'PCM - APP entsperren';
  baBiometric.PromptSubTitle:= 'Bitte bestätigen Sie Ihre Identität per Fingerabdruck';
  baBiometric.PromptCancelButtonText := 'Cancel';
  baBiometric.OnAuthenticateFail:= BiometricAuth1AuthenticateFail;
  baBiometric.OnAuthenticateSuccess:= BiometricAuth1AuthenticateSuccess;
  if baBiometric.CanAuthenticate then
  begin
    bHasBiometric:= true;
  end
  else begin
    bHasBiometric:= false;
  end;
  PushChannel := nc_PushNotification.CreateChannel('pcm_push', 'PCM-Benachrichtigungen');
  try
    PushChannel.Importance := TImportance.High;
    nc_PushNotification.CreateOrUpdateChannel(PushChannel);
  finally
    PushChannel.Free;
  end;
  pshsrvPushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.FCM);
  if (pshsrvPushService <> nil) and (FPushConnection = nil) then
  begin
    FPushConnection := TPushServiceConnection.Create(pshsrvPushService);
    FPushConnection.OnChange := OnServiceConnectionChange;
    FPushConnection.OnReceiveNotification := OnReceiveNotificationEvent;
    FPushConnection.Active := True;
    OnServiceConnectionChange(FPushConnection, [TPushService.TChange.DeviceToken]);
  end;
  {$ENDIF ANDROID}
  tc_more.ActiveTab:= ti_1ConfigMenu;

//  if Length(Notifications) > 0 then
//  begin
////    WriteLog('-----------------------------------------',0,false);
////    WriteLog('DataKey = ' + Notifications[0].DataKey,0,false);
////    WriteLog('Json = ' + Notifications[0].Json.ToString,0,false);
////    WriteLog('DataObject = ' +
////    Notifications[0].DataObject.ToString,0,false);
////    WriteLog('-----------------------------------------',0,false);
//  end;
  SetDisableToolButtons;
  rec_main.Visible:= false;
  bOpened:= false;
  iProgramm:= 1;
  tc_Main.ActiveTab := ti_1Login;
  btn_CloseApp.Visible:= false;
  snglClientWidth := frm_PCM_Main.Width;
  snglClientHeight := frm_PCM_Main.Height;
  rec_main.Height := 48;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  lstbxitm_3Beenden.Visible:= true;
  FMX.Types.VKAutoShowMode:= TVKAutoShowMode.never;
  rec_main.Margins.Top:= 0;
  frm_PCM_Main.BorderStyle:= TFmxFormBorderStyle.None;
  {$ENDIF MSWINDOWS}
  {$IFDEF ANDROID}
  vsbx_Login.Touch.InteractiveGestures := [TInteractiveGesture.Pan];
  sDeviceDetail := JStringToString(TJBuild.JavaClass.MANUFACTURER) + ' ' + JStringToString(TJBuild.JavaClass.MODEL);
  sOSDetail := GetCodename(JStringToString(TJBuild_VERSION.JavaClass.RELEASE));// + '' + JStringToString(TJBuild_VERSION.JavaClass.RELEASE);
  try
    if pdsrvPhoneDialerService <> nil then
    begin
      sProviderDetail := pdsrvPhoneDialerService.GetCarrier.GetCarrierName;
    end
    else begin
      sProviderDetail:= 'kein Provider vorhanden'
    end;
  except
  end;
  {$ENDIF ANDROID}
  SetServerList;
  if iServerID <> -1 then
    dmmain.bServerAvailable:= CheckServerConnection;
  qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
  qry_Work.Open;
  if qry_Work.RecordCount > 0 then
  begin
    edt_Benutzername.text:= qry_Work.FieldByName('Benutzername').AsString;
    {$ifdef MSWINDOWS}
    AutoLogin(qry_Work.FieldByName('Benutzername').AsString, qry_Work.FieldByName('Passwort').AsString);
    qry_Work.Close;
    {$ENDIF MSWINDOWS}
    {$IFDEF ANDROID}
    if qry_Work.FieldByName('FingerAuthenticate').AsBoolean = True then
    begin
      qry_Work.Close;
      img_BiometricClick(Self);
      tc_Main.ActiveTab:= ti_1Login;
    end
    else begin
      if qry_Work.FieldByName('Autologin').AsBoolean = True then
      begin
        AutoLogin(qry_Work.FieldByName('Benutzername').AsString, qry_Work.FieldByName('Passwort').AsString);
        qry_Work.Close;
      end;
    end;
    {$ENDIF ANDROID}
  end;
end;
procedure Tfrm_PCM_Main.FormResize(Sender: TObject);
begin
  ResizeLayout;
end;
procedure Tfrm_PCM_Main.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds.Create(0, 0, 0, 0);
  bNeedOffset := False;
end;
procedure Tfrm_PCM_Main.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  dBounds := TRectF.Create(Bounds);
  dBounds.TopLeft := ScreenToClient(dBounds.TopLeft);
  dBounds.BottomRight := ScreenToClient(dBounds.BottomRight);
end;
procedure Tfrm_PCM_Main.FormTouch(Sender: TObject; const Touches: TTouches; const Action: TTouchAction);
begin
  iTouchPosY := Touches[0].Location.Y;
  iTouchPosX := Touches[0].Location.X;
end;
{$EndRegion Formfunctions}
////////////////////////////////////////////////////////////////////////////////
// FORM OTHER FUNCTIONS                                                       //
////////////////////////////////////////////////////////////////////////////////
{$Region Other Form Functions}
procedure Tfrm_PCM_Main.btn_AddDataClick(Sender: TObject);
begin
  bNeu:= true;
  iID:= 0;
  iListviewID:= 0;
  if tc_MainApp.ActiveTab = ti_2MainKontakte then
  begin
    Application.CreateForm(Tfrm_PCMAPP_KontakteDetail,frm_PCMAPP_KontakteDetail);
    frm_PCMAPP_KontakteDetail.Show;
  end;
  if tc_MainApp.ActiveTab = ti_3MainKalender then
  begin
    Application.CreateForm(Tfrm_PCMAPP_KalenderDetail,frm_PCMAPP_KalenderDetail);
    frm_PCMAPP_KalenderDetail.Show;
  end;
  if tc_MainApp.ActiveTab = ti_4MainPasswort then
  begin
    if tc_PassSerial.ActiveTab = ti_Passwort then
    begin
      Application.CreateForm(Tfrm_PCMAPP_PasswortDetail,frm_PCMAPP_PasswortDetail);
      frm_PCMAPP_PasswortDetail.Show;
    end;
    if tc_PassSerial.ActiveTab = ti_Serial then
    begin
      Application.CreateForm(Tfrm_PCMAPP_SerialDetail,frm_PCMAPP_SerialDetail);
      frm_PCMAPP_SerialDetail.Show;
    end;
  end;
  if tc_MainApp.ActiveTab = ti_5MainFinanzen then
  begin
    if tc_Finanzen.ActiveTab = ti_3Ausgaben then
    begin
      Application.CreateForm(Tfrm_PCMAPP_AusgabenDetail,frm_PCMAPP_AusgabenDetail);
      frm_PCMAPP_AusgabenDetail.Show;
    end;
    if tc_Finanzen.ActiveTab = ti_2Einnahmen then
    begin
      Application.CreateForm(Tfrm_PCMAPP_EinnahmenDetail,frm_PCMAPP_EinnahmenDetail);
      frm_PCMAPP_EinnahmenDetail.Show;
    end;
    if tc_Finanzen.ActiveTab = ti_4Belege then
    begin
      Application.CreateForm(Tfrm_PCMAPP_BelegeDetail,frm_PCMAPP_BelegeDetail);
      frm_PCMAPP_BelegeDetail.Show;
    end;
  end;
  if tc_MainApp.ActiveTab = ti_6Gutschein then
  begin
    Application.CreateForm(Tfrm_PCMAPP_GutscheinDetail,frm_PCMAPP_GutscheinDetail);
    frm_PCMAPP_GutscheinDetail.Show;
  end;
  if tc_MainApp.ActiveTab = ti_7More then
   begin
    Application.CreateForm(Tfrm_PCMAPP_CalAboDetail,frm_PCMAPP_CalAboDetail);
    frm_PCMAPP_CalAboDetail.Show;
  end;
end;
procedure Tfrm_PCM_Main.btn_BackSystemClick(Sender: TObject);
begin
  btn_Multiview.visible:= true;
  try
    lo_ConfigImportContacts.DeleteChildren;
  except
  end;
  case iTags of
    1:
    begin
      tc_MainApp.ActiveTab:= ti_2MainKontakte;
      btn_backSystem.visible:= false;
    end;
    2:
    begin
      tc_MainApp.ActiveTab:= ti_3MainKalender;
      btn_backSystem.visible:= false;
    end;
    3:
    begin
      tc_MainApp.ActiveTab:= ti_4MainPasswort;
      btn_backSystem.visible:= false;
    end;
    4:
    begin
      tc_MainApp.ActiveTab:= ti_5MainFinanzen;
      btn_backSystem.visible:= false;
    end;
    5:
    begin
      tc_MainApp.ActiveTab:= ti_6Gutschein;
      btn_backSystem.visible:= false;
    end;
    6:
    begin
      tc_More.ActiveTab:= ti_1ConfigMenu;
      btn_backSystem.visible:= false;
      btn_Synchronisation.Visible:= true;
      btn_AddData.Visible:= false;
    end;
    7:
    begin
      tc_More.ActiveTab:= ti_3ConfigConfig;
      iTags:= 6;
    end;
  end;
end;
procedure Tfrm_PCM_Main.btn_CloseAppClick(Sender: TObject);
begin
  Application.Terminate;
end;
procedure Tfrm_PCM_Main.btn_SearchClick(Sender: TObject);
begin
  if tc_MainApp.ActiveTab = ti_2MainKontakte then
  begin
    lv_Kontakte.SearchVisible := not lv_Kontakte.SearchVisible;
  end;
  if tc_MainApp.ActiveTab = ti_3MainKalender then
  begin
    lv_Kalender.SearchVisible := not lv_Kalender.SearchVisible;
  end;
  if tc_MainApp.ActiveTab = ti_4MainPasswort then
  begin
    if tc_PassSerial.ActiveTab = ti_Serial then
      lv_Serials.SearchVisible := not lv_Serials.SearchVisible
    else
      lv_Passwort.SearchVisible := not lv_Passwort.SearchVisible;
  end;
  if tc_MainApp.ActiveTab = ti_5MainFinanzen then
  begin
    if tc_Finanzen.ActiveTab = ti_2Einnahmen then
      lv_Einnahmen.SearchVisible := not lv_Einnahmen.SearchVisible;
    if tc_Finanzen.ActiveTab = ti_3Ausgaben then
      lv_Ausgaben.SearchVisible := not lv_Ausgaben.SearchVisible;
    if tc_Finanzen.ActiveTab = ti_4Belege then
      lv_Belege.SearchVisible := not lv_Belege.SearchVisible;
  end;
  if tc_MainApp.ActiveTab = ti_6Gutschein then
  begin
    lv_Gutschein.SearchVisible := not lv_Gutschein.SearchVisible
  end;
end;
procedure Tfrm_PCM_Main.tc_mainChange(Sender: TObject);
begin
  if tc_Main.ActiveTab = ti_5Finger then
  begin
    SetDisableToolButtons;
    img_BiometricClick(Sender);
    lbl_ModulName.Text := 'Authentifizierung';
  end;
  if tc_Main.ActiveTab = ti_1Login then
  begin
    rec_main.Visible:= false;
    SetDisableToolButtons;
    qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
    qry_Work.Open;
    if qry_Work.RecordCount > 0 then
    begin
      if qry_Work.FieldByName('FingerAuthenticate').AsBoolean = True then
      begin
        btn_LoginBiometrie.visible:= true;
      end
      else begin
        btn_LoginBiometrie.visible:= false;
      end;
    end
    else begin
      btn_LoginBiometrie.visible:= false;
    end;
    lbl_ModulName.Text := 'Login';
  end
  else begin
    rec_main.Visible:= true;
  end;
end;
procedure Tfrm_PCM_Main.tc_MainAppChange(Sender: TObject);
begin
  if tc_MainApp.ActiveTab = ti_6Gutschein then
  begin
    itags:= 5;
    SetDisableToolButtons;
    lbl_ModulName.Text := 'Gutscheine';
    lv_Gutschein.Items.Clear;
    lv_Gutschein.BeginUpdate;
    CreateGridGutschein;;
    lv_Gutschein.EndUpdate;
    btn_Search.visible:= True;
    btn_AddData.Visible:= True;
  end;
  if tc_MainApp.ActiveTab = ti_7More then
  begin
    itags:= 6;
    SetDisableToolButtons;
    lbl_ModulName.Text := 'Weitere Optionen';
    btn_Synchronisation.Visible:= true;
  end;
end;
procedure Tfrm_PCM_Main.tc_FinanzenChange(Sender: TObject);
begin
  SetDisableToolButtons;
  if tc_Finanzen.ActiveTab = ti_1Aktuell then
  begin
    BerechneModulFinanzen;
    btn_Search.Visible:= false;
    btn_AddData.Visible:= false;
  end;
  if tc_Finanzen.ActiveTab = ti_3Ausgaben then
  begin
    btn_Search.Visible:= true;
    btn_AddData.Visible:= true;
  end;
  if tc_Finanzen.ActiveTab = ti_2Einnahmen then
  begin
    btn_Search.Visible:= true;
    btn_AddData.Visible:= true;
  end;
  if tc_Finanzen.ActiveTab = ti_4Belege then
  begin
    btn_Search.Visible:= true;
    btn_AddData.Visible:= true;
  end;
end;
procedure Tfrm_PCM_Main.Logout;
begin
  edt_Benutzername.Text := '';
  edt_Passwort.Text := '';
  dmmain.iUserID := 0;
  iServerID := -1;
end;
{$EndRegion Other Form Functions}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Notification and Token                                                     //
////////////////////////////////////////////////////////////////////////////////
{$Region Notification Token}
procedure Tfrm_PCM_Main.tmr_PushNotificationTimer(Sender: TObject);
var
  notNotification: TNotification;
  qry_Notification: TFDQuery;
  qry_NotificationUpdate: TFDQuery;
  sAlertBody: string;
  sWochentagBeginn: string;
  sWochentagEnde: string;
begin
  qry_Notification:= TFDQuery.Create(nil);
  qry_Notification.Connection:= dmmain.con_PCM;
  qry_Notification.ResourceOptions.SilentMode:=True;
  qry_Notification.SQL.Text:= sSQL_SEL_ALL_Kalender_Where_ReminderDate;
  qry_Notification.ParamByName('DateTime').AsDateTime:= Now();
  qry_Notification.open;
  while not qry_Notification.Eof do
  begin
    sWochentagBeginn:= GetWeekDay(qry_Notification.FieldByName('Start').AsDateTime);
    sWochentagEnde:= GetWeekDay(qry_Notification.FieldByName('Finish').AsDateTime);
    if qry_Notification.FieldByName('CompleteDay').AsBoolean then
    begin
      if qry_Notification.FieldByName('Finish').AsDateTime - qry_Notification.FieldByName('Start').AsDateTime  = 1 then
      begin
        sAlertBody:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Notification.FieldByName('Start').AsDateTime);
      end
      else begin
        sAlertBody:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Notification.FieldByName('Start').AsDateTime) + ' - ' + sWochentagEnde + ' ' + FormatDateTime('dd.mm.yyyy',qry_Notification.FieldByName('Finish').AsDateTime);
      end;
    end
    else begin
      if qry_Notification.FieldByName('Finish').AsDateTime - qry_Notification.FieldByName('Start').AsDateTime  = 1 then
      begin
        sAlertBody:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Notification.FieldByName('Start').AsDateTime)
      end
      else begin
        sAlertBody:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy hh:mm',qry_Notification.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Notification.FieldByName('Finish').AsDateTime);
      end;
    end;
    notNotification:= nc_PushNotification.CreateNotification;
    try
      notNotification.Number:=18;
      notNotification.Title:= qry_Notification.FieldByName('Caption').asString;
      notNotification.AlertBody:= sAlertBody;
      nc_PushNotification.PresentNotification(notNotification);
    finally
      FreeandNil(notNotification);
      qry_NotificationUpdate:= TFDQuery.Create(nil);
      qry_NotificationUpdate.Connection:= dmmain.con_PCM;
      qry_NotificationUpdate.SQL.Text:= sSQL_UPD_Reminder_Kalender_Where_ID;
      qry_NotificationUpdate.ParamByName('ID').AsInteger := qry_Notification.FieldByName('ID').AsInteger;
      qry_NotificationUpdate.ExecSQL;
      FreeANdNil(qry_NotificationUpdate)
    end;
    qry_Notification.next;
  end;
  qry_Notification.Close;
  qry_Notification.ResourceOptions.SilentMode:=false;
  FreeANdNil(qry_Notification);
end;
procedure Tfrm_PCM_Main.OnServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
var
  pshsrvPushService: TPushService;
  TokenQuery: TFDQuery;
begin
  pshsrvPushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.FCM);
  if (pshsrvPushService <> nil) and (TPushService.TChange.DeviceToken in PushChanges) then
  begin
    sDeviceToken := pshsrvPushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];
    sDeviceID := pshsrvPushService.DeviceIDValue[TPushService.TDeviceIDNames.DeviceID];
    if (sDeviceToken <> '') and Assigned(dmmain) and dmmain.con_PCM.Connected then
    begin
      TokenQuery := TFDQuery.Create(nil);
      try
        TokenQuery.Connection := dmmain.con_PCM;
        TokenQuery.SQL.Text := 'UPDATE Auto_login SET DeviceToken = :Token, DeviceID = :DeviceID';
        TokenQuery.ParamByName('Token').AsString := sDeviceToken;
        TokenQuery.ParamByName('DeviceID').AsString := sDeviceID;
        TokenQuery.ExecSQL;
      finally
        TokenQuery.Free;
      end;
    end;
  end;
end;
procedure Tfrm_PCM_Main.OnReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
var
  notNotification: TNotification;
  sBody, sTitle: string;
  NotificationJSON: TJSONObject;
  function ReadText(const Key: string): string;
  var
    Value: TJSONValue;
  begin
    Result := '';
    Value := NotificationJSON.Values[Key];
    if Value is TJSONString then
      Result := TJSONString(Value).Value;
  end;
begin
  if (ServiceNotification = nil) or (ServiceNotification.Json = nil) then
    Exit;
  NotificationJSON := ServiceNotification.Json;
  sTitle := ReadText('gcm.notification.title');
  if sTitle = '' then
    sTitle := ReadText('gcm.n.title');
  if sTitle = '' then
    NotificationJSON.TryGetValue<string>('notification.title', sTitle);
  sBody := ReadText('gcm.notification.body');
  if sBody = '' then
    sBody := ReadText('gcm.n.body');
  if sBody = '' then
    NotificationJSON.TryGetValue<string>('notification.body', sBody);
  if (sTitle = '') and (sBody = '') then
    Exit;
  notNotification := nc_PushNotification.CreateNotification;
  try
    notNotification.ChannelId := 'pcm_push';
    notNotification.Title := sTitle;
    notNotification.AlertBody := sBody;
    nc_PushNotification.PresentNotification(notNotification);
  finally
    notNotification.Free;
  end;
end;
{$EndRegion Notification Token}
////////////////////////////////////////////////////////////////////////////////
// Multiview Menu                                                             //
////////////////////////////////////////////////////////////////////////////////
{$Region Multiview}
procedure Tfrm_PCM_Main.lstbxitm_101HomeClick(Sender: TObject);
begin
  itags:= 0;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  mv_Menu.HideMaster;
  CreateDashboard;
  lbl_ModulName.Text := 'Startseite';
  tc_MainApp.ActiveTab := ti_1MainHome;
  SetDisableToolButtons;
  SetAnimation(iAnimation);
end;
procedure Tfrm_PCM_Main.lstbxitm_102ContactClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 1;
  dmmain.wfWaitFrame.Execute('Kontakte laden...', 'Kontakte', True);
  TTask.Run(
  procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      SetDisableToolButtons;
      lbl_ModulName.Text := 'Kontakte';
      lv_Kontakte.Items.Clear;
      lv_Kontakte.BeginUpdate;
      CreateKontaktuebersichtGridConfig;
      lv_Kontakte.EndUpdate;
      btn_Search.visible:= True;
      btn_AddData.Visible:= True;
      {$IFDEF MSWINDOWS}
      btn_CloseApp.Visible:= true;
//      btn_Search.visible:= false;
      lv_Kontakte.Margins.Left:= 16;
      lv_Kontakte.Margins.Right:= 16;
      lv_Kontakte.SearchVisible:= true;
      {$ENDIF MSWINDOWS}
      tc_MainApp.ActiveTab:= ti_2MainKontakte;
      dmmain.wfWaitFrame.HideFW;
    end);
  end);
end;
procedure Tfrm_PCM_Main.lstbxitm_103KalenderClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 2;
  TTask.Run(
    procedure()
    begin
      TThread.Synchronize(nil,
      procedure()
      begin
        SetDisableToolButtons;
        lbl_ModulName.Text := 'Kalender';
        lv_Kalender.Items.Clear;
        lv_Kalender.BeginUpdate;
        CreateKalGridConfig(True);
        lv_Kalender.EndUpdate;
        btn_Search.visible:= True;
        btn_AddData.Visible:= True;
        {$IFDEF MSWINDOWS}
        btn_CloseApp.Visible:= true;
      //  btn_Search.visible:= false;
        tc_Kalender.Margins.Left:= 16;
        tc_Kalender.Margins.Right:= 16;
        lv_Kalender.SearchVisible:= true;
        {$ENDIF MSWINDOWS}
        cal_Calendar.Model.ShowWeekends:= true;
        tc_Kalender.ActiveTab:= ti_Kompakt;
        tc_MainApp.ActiveTab:= ti_3MainKalender;
        dmmain.wfWaitFrame.HideFW;
  	  end);
  end);
end;
procedure Tfrm_PCM_Main.lstbxitm_104PasswordClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 3;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  SetDisableToolButtons;
  lbl_ModulName.Text := 'Passwörter / Serials';
  lv_Passwort.Items.Clear;
  lv_Passwort.BeginUpdate;
  CreatePWDGridConfig;
  lv_Passwort.EndUpdate;
  lv_Serials.Items.Clear;
  lv_Serials.BeginUpdate;
  CreateSerialGridConfig;
  lv_Serials.EndUpdate;
  btn_Search.Visible:= true;
  btn_AddData.Visible:= True;
  tc_MainApp.ActiveTab:= ti_4MainPasswort;
  tc_PassSerial.ActiveTab:= ti_Passwort;
  {$IFDEF MSWINDOWS}
  btn_Search.visible:= false;
  tc_PassSerial.Margins.Left:= 16;
  tc_PassSerial.Margins.Right:= 16;
  lv_Passwort.SearchVisible:= true;
  lv_Serials.SearchVisible:= true;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lstbxitm_105SerialsClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 3;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  SetDisableToolButtons;
  lbl_ModulName.Text := 'Passwörter / Serials';
  lv_Passwort.Items.Clear;
  lv_Passwort.BeginUpdate;
  CreatePWDGridConfig;
  lv_Passwort.EndUpdate;
  lv_Serials.Items.Clear;
  lv_Serials.BeginUpdate;
  CreateSerialGridConfig;
  lv_Serials.EndUpdate;
  btn_Search.Visible:= true;
  btn_AddData.Visible:= True;
  tc_MainApp.ActiveTab:= ti_4MainPasswort;
  tc_PassSerial.ActiveTab:= ti_Serial;
  {$IFDEF MSWINDOWS}
  btn_Search.visible:= false;
  tc_PassSerial.Margins.Left:= 16;
  tc_PassSerial.Margins.Right:= 16;
  lv_Passwort.SearchVisible:= true;
  lv_Serials.SearchVisible:= true;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lstbxitm_106FinanzenClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  itags:= 4;
  BerechneModulFinanzen;
  tc_MainApp.ActiveTab:= ti_5MainFinanzen;
  tc_Finanzen.ActiveTab:= ti_1Aktuell;
end;
procedure Tfrm_PCM_Main.lstbxitm_107EingangClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 4;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  BerechneModulFinanzen;
  tc_MainApp.ActiveTab:= ti_5MainFinanzen;
  tc_Finanzen.ActiveTab:= ti_2Einnahmen;
end;
procedure Tfrm_PCM_Main.lstbxitm_108AusgabenClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 4;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  BerechneModulFinanzen;
  tc_MainApp.ActiveTab:= ti_5MainFinanzen;
  tc_Finanzen.ActiveTab:= ti_3Ausgaben;
end;
procedure Tfrm_PCM_Main.lstbxitm_109BelegeClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  itags:= 4;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  BerechneModulFinanzen;
  tc_MainApp.ActiveTab:= ti_5MainFinanzen;
  tc_Finanzen.ActiveTab:= ti_4Belege;
end;
procedure Tfrm_PCM_Main.lstbxitm_110GutscheinClick(Sender: TObject);
begin
  itags:= 5;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  mv_Menu.HideMaster;
  SetDisableToolButtons;
  lbl_ModulName.Text := 'Gutscheine';
  lv_Gutschein.Items.Clear;
  lv_Gutschein.BeginUpdate;
  CreateGridGutschein;;
  lv_Gutschein.EndUpdate;
  btn_Search.visible:= True;
  btn_AddData.Visible:= True;
  tc_MainApp.ActiveTab:= ti_6Gutschein;
  {$IFDEF MSWINDOWS}
  btn_Search.visible:= false;
  lv_Gutschein.Margins.Left:= 16;
  lv_Gutschein.Margins.Right:= 16;
  lv_Gutschein.SearchVisible:= true;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lstbxitm_111MoreClick(Sender: TObject);
begin
  mv_Menu.HideMaster;
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  itags:= 6;
  tc_MainApp.ActiveTab := ti_7More;
  tc_More.ActiveTab:= ti_1ConfigMenu;
  SetDisableToolButtons;
  lbl_ModulName.Text := 'Weitere Optionen';
  btn_Synchronisation.Visible:= true;
end;
{$EndRegion Multiview}
////////////////////////////////////////////////////////////////////////////////
// ANIMATION                                                                  //
////////////////////////////////////////////////////////////////////////////////
{$Region Animation}
procedure Tfrm_PCM_Main.fa_ContactsFinish(Sender: TObject);
begin
  rec_1Contacts.Align:= TAlignLayout.Top;
  rec_2Calendar.Align:= TAlignLayout.Top;
  rec_3PasswordSerials.Align:= TAlignLayout.Top;
  rec_3Password.Align:= TAlignLayout.left;
  rec_3Serials.Align:= TAlignLayout.right;
  rec_4Fincance.Align:= TAlignLayout.Top;
  rec_5BelegeGiftCards.Align:= TAlignLayout.Top;
  rec_5Belege.Align:= TAlignLayout.left;
  rec_5GiftCards.Align:= TAlignLayout.right;
end;
procedure Tfrm_PCM_Main.fa_CalendarFinish(Sender: TObject);
begin
  rec_3Password.Visible:= true;
end;
procedure Tfrm_PCM_Main.fa_paswordFinish(Sender: TObject);
begin
  rec_3Serials.Visible:= true;
end;
procedure Tfrm_PCM_Main.fa_SerialsFinish(Sender: TObject);
begin
  rec_4Fincance.Visible:= true;
end;
procedure Tfrm_PCM_Main.fa_financeFinish(Sender: TObject);
begin
  rec_5BelegeGiftCards.Position.Y:= 568;
  rec_5BelegeGiftCards.Visible:= true;
end;
{$EndRegion Animation}
////////////////////////////////////////////////////////////////////////////////
// Modulgrids                                                                 //
////////////////////////////////////////////////////////////////////////////////
{$Region Modulgrids}
////////////////////////////////////////////////////////////////////////////////
// Kontakte                                                                   //
////////////////////////////////////////////////////////////////////////////////
{$Region Kontakte}
procedure Tfrm_PCM_Main.lv_KontakteDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
var
  qry_KontakteDelete: TFDQuery;
begin
  qry_KontakteDelete:= TFDQuery.Create(Self);
  qry_KontakteDelete.Connection:= dmmain.con_PCM;
  qry_KontakteDelete.SQL.Text:= sSQL_UPD_DELETED_Kontakte_Where_ID;
  qry_KontakteDelete.ParamByName('ID').AsInteger:= lv_Kontakte.Items.Item[AIndex].Tag;
  qry_KontakteDelete.ExecSQL;
  FreeandNil(qry_KontakteDelete);
end;
procedure Tfrm_PCM_Main.lv_KontakteKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_KontakteDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_KontakteDelete:= TFDQuery.Create(Self);
    qry_KontakteDelete.Connection:= dmmain.con_PCM;
    qry_KontakteDelete.SQL.Text:= sSQL_UPD_DELETED_Kontakte_Where_ID;
    qry_KontakteDelete.ParamByName('ID').AsInteger:= lv_Kontakte.Items.Item[iItemIndex].Tag;
    qry_KontakteDelete.ExecSQL;
    FreeandNil(qry_KontakteDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_KontakteItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_KontakteDetail,frm_PCMAPP_KontakteDetail);
    frm_PCMAPP_KontakteDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_KontakteDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_KontakteDetail,frm_PCMAPP_KontakteDetail);
    frm_PCMAPP_KontakteDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_KontaktePullRefresh(Sender: TObject);
begin
  dmmain.wfWaitFrame.Execute('Kontakte synchronisieren...', 'Kontakte', True);
  TTask.Run(
  Procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      SyncKontakte_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
      lv_Kontakte.Items.Clear;
      lv_Kontakte.BeginUpdate;
      CreateKontaktuebersichtGridConfig;
      lv_Kontakte.EndUpdate;
      dmmain.wfWaitFrame.HideFW;
    end);
  end)
end;
procedure Tfrm_PCM_Main.CreateKontaktuebersichtGridConfig;
var
  bmpPic : TBitmap;
  lstvwitm_Kontakte: TListViewItem;
  qry_Kontakte: TFDQuery;
begin
  dmmain.wfWaitFrame.Execute('Kontakte laden...', 'Kontakte', True);
  qry_Kontakte:= TFDQuery.Create(Self);
  qry_Kontakte.Connection:= dmmain.con_PCM;
  qry_Kontakte.SQL.Text:= sSQL_SEL_ALL_Kontakte_Where_Deleted;
  qry_Kontakte.open;
  if not qry_Kontakte.Eof then
  begin
    while not qry_Kontakte.Eof do
    begin
      lstvwitm_Kontakte:= lv_Kontakte.Items.Add;
      lstvwitm_Kontakte.Tag:= qry_Kontakte.FieldByName('ID').AsInteger;
      lstvwitm_Kontakte.Detail:= qry_Kontakte.FieldByName('Firma').AsString;
      lstvwitm_Kontakte.Text:= qry_Kontakte.FieldByName('Vorname').AsString + ' ' + qry_Kontakte.FieldByName('Nachname').AsString;
      if qry_Kontakte.FieldByName('Bild').AsString <> '' then
      begin;
        bmpPic:= BitmapFromBase64(qry_Kontakte.FieldByName('Bild').AsString);
        lstvwitm_Kontakte.Bitmap := CreateRoundPhoto(bmpPic);
      end
      else begin
        lstvwitm_Kontakte.ImageIndex := 0;
      end;
      qry_Kontakte.Next;
    end;
  end;
  FreeandNil(qry_Kontakte);
  dmmain.wfWaitFrame.HideFW;
end;
{$EndRegion Kontakte}
////////////////////////////////////////////////////////////////////////////////
// Kalender                                                                   //
////////////////////////////////////////////////////////////////////////////////
{$Region Kalender}
procedure Tfrm_PCM_Main.Button1Click(Sender: TObject);
begin
  rec_buchungenInfo.Visible:= true;
end;
procedure Tfrm_PCM_Main.Button2Click(Sender: TObject);
begin
  rec_buchungenInfo.Visible:= false;
end;
procedure Tfrm_PCM_Main.btn_KalenderFilterClick(Sender: TObject);
begin
  if btn_KalenderFilter.Tag = 0 then
  begin
    btn_KalenderFilter.Tag:= 1;
    btn_KalenderFilter.Text:= 'alle Einträge';
    lv_Kalender.Items.Clear;
    lv_Kalender.BeginUpdate;
    CreateKalGridConfig(false);
    lv_Kalender.EndUpdate;
  end
  else begin
    btn_KalenderFilter.Tag:= 0;
    btn_KalenderFilter.Text:= 'nur aktuelles Jahr';
    lv_Kalender.Items.Clear;
    lv_Kalender.BeginUpdate;
    CreateKalGridConfig(true);
    lv_Kalender.EndUpdate;
  end;
end;
procedure Tfrm_PCM_Main.lv_KalenderDeletingItem(Sender: TObject; AIndex: Integer;var ACanDelete: Boolean);
var
  qry_KalenderDelete: TFDQuery;
begin
  qry_KalenderDelete:= TFDQuery.Create(Self);
  qry_KalenderDelete.Connection:= dmmain.con_PCM;
  qry_KalenderDelete.SQL.Text:= sSQL_UPD_DeleteCalItem;
  qry_KalenderDelete.ParamByName('ID').AsInteger:= lv_Kalender.Items.Item[AIndex].Tag;
  qry_KalenderDelete.ExecSQL;
  FreeandNil(qry_KalenderDelete);
end;
procedure Tfrm_PCM_Main.lv_KalenderKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_KalenderDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_KalenderDelete:= TFDQuery.Create(Self);
    qry_KalenderDelete.Connection:= dmmain.con_PCM;
    qry_KalenderDelete.SQL.Text:= sSQL_UPD_DeleteCalItem;
    qry_KalenderDelete.ParamByName('ID').AsInteger:= lv_Kalender.Items.Item[iItemIndex].Tag;
    qry_KalenderDelete.ExecSQL;
    FreeandNil(qry_KalenderDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_KalenderItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_KalenderDetail,frm_PCMAPP_KalenderDetail);
    frm_PCMAPP_KalenderDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_KalenderDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_KalenderDetail,frm_PCMAPP_KalenderDetail);
    frm_PCMAPP_KalenderDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_KalenderKompaktDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
var
  qry_KalenderDelete: TFDQuery;
begin
  qry_KalenderDelete:= TFDQuery.Create(Self);
  qry_KalenderDelete.Connection:= dmmain.con_PCM;
  qry_KalenderDelete.SQL.Text:= sSQL_UPD_DeleteCalItem;
  qry_KalenderDelete.ParamByName('ID').AsInteger:= lv_KalenderKompakt.Items.Item[AIndex].Tag;
  qry_KalenderDelete.ExecSQL;
  FreeandNil(qry_KalenderDelete);
end;
procedure Tfrm_PCM_Main.lv_KalenderKompaktKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_KalenderDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_KalenderDelete:= TFDQuery.Create(Self);
    qry_KalenderDelete.Connection:= dmmain.con_PCM;
    qry_KalenderDelete.SQL.Text:= sSQL_UPD_DeleteCalItem;
    qry_KalenderDelete.ParamByName('ID').AsInteger:= lv_KalenderKompakt.Items.Item[iItemIndex].Tag;
    qry_KalenderDelete.ExecSQL;
    FreeandNil(qry_KalenderDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_KalenderKompaktItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_KalenderDetail,frm_PCMApp_KalenderDetail);
    frm_PCMAPP_KalenderDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_KalenderKompaktDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_KalenderDetail,frm_PCMAPP_KalenderDetail);
    frm_PCMAPP_KalenderDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_KalenderPullRefresh(Sender: TObject);
begin
  dmmain.wfWaitFrame.Execute('Kalender synchronisieren...', 'Kalender', True);
  TTask.Run(
  Procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      Synckalender_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
      lv_Kalender.Items.Clear;
      lv_Kalender.BeginUpdate;
      if btn_KalenderFilter.Tag = 0 then
        CreateKalGridConfig(true)
      else
        CreateKalGridConfig(false);
      lv_Kalender.EndUpdate;
      dmmain.wfWaitFrame.HideFW;
    end);
  end)
end;
procedure Tfrm_PCM_Main.CreateKalGridConfig(AFilter: boolean);
var
  dtDateTime: TDateTime;
  lstvwitm_Kalender: TListViewItem;
  qry_Kalender: TFDQuery;
  sWochentagBeginn: string;
  sWochentagEnde: string;
begin
  qry_Kalender:= TFDQuery.Create(Self);
  qry_Kalender.Connection:= dmmain.con_PCM;
  if AFilter then
  begin
    qry_Kalender.SQL.Text:= 'SELECT ID, Caption, Start,Finish, CompleteDay,kalendername, wiederholungtext ' +
                            'FROM Kalender ' +
                            'WHERE (Deleted <> true or deleted is null) and (Wiederholungtext <> '''' or Date(Start) >= :Datum) ' +
                            'order by start asc';
    qry_Kalender.ParamByName('Datum').AsDate:= Date;
  end
  else begin
    qry_Kalender.SQL.Text:= 'SELECT ID, Caption, Start,Finish, CompleteDay,kalendername, wiederholungtext ' +
                            'FROM Kalender ' +
                            'WHERE (Deleted <> true or deleted is null) ' +
                            'order by start asc';
  end;
  qry_Kalender.open;
  if not qry_Kalender.Eof then
  begin
    while not qry_Kalender.Eof do
    begin
      sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
      sWochentagEnde:= GetWeekDay(qry_Kalender.FieldByName('Finish').AsDateTime);
      lstvwitm_Kalender:= lv_Kalender.Items.Add;
      lstvwitm_Kalender.Tag:= qry_Kalender.FieldByName('ID').AsInteger;
      lstvwitm_Kalender.Text:= qry_Kalender.FieldByName('Caption').AsString;
      lstvwitm_Kalender.ImageIndex:= 13;
      dtDateTime:= CheckReccurence(qry_Kalender.FieldByName('ID').asInteger,qry_Kalender.FieldByName('Start').asDatetime,Date,qry_Kalender.FieldByName('wiederholungtext').asString);
      if ((DateOf(dtDateTime) = Date) and (qry_Kalender.FieldByName('wiederholungtext').asString <> '')) or (qry_Kalender.FieldByName('wiederholungtext').asString = '') then
      begin
        sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
        if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
        begin
          lstvwitm_Kalender.Detail:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',Date)
        end
        else begin
          lstvwitm_Kalender.Detail:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',dtDateTime) + ' ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
        end;
        lstvwitm_Kalender.ImageIndex:= 1;
        case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
          0: lstvwitm_Kalender.ImageIndex:= 7;
          1: lstvwitm_Kalender.ImageIndex:= 6;
          2: lstvwitm_Kalender.ImageIndex:= 8;
          3: lstvwitm_Kalender.ImageIndex:= 9;
          4: lstvwitm_Kalender.ImageIndex:= 10;
        end;
      end
      else begin
        dtDateTime:= qry_Kalender.FieldByName('Start').AsDateTime;
        if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
        begin
          if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
          begin
            lstvwitm_Kalender.Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime);
          end
          else begin
            lstvwitm_Kalender.Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + sWochentagEnde + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Finish').AsDateTime);
          end;
        end
        else begin
          if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
          begin
            lstvwitm_Kalender.Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime)
          end
          else begin
            lstvwitm_Kalender.Detail:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
          end;
        end;
        if qry_Kalender.FieldByName('Kalendername').AsString = 'Geburtstag' then
        begin
          lstvwitm_Kalender.ImageIndex:= 11;
        end;
        case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
          0: lstvwitm_Kalender.ImageIndex:= 7;
          1: lstvwitm_Kalender.ImageIndex:= 6;
          2: lstvwitm_Kalender.ImageIndex:= 8;
          3: lstvwitm_Kalender.ImageIndex:= 9;
          4: lstvwitm_Kalender.ImageIndex:= 10;
        end;
      end;
      aryList:= aryList + [dtDateTime];
      qry_Kalender.Next;
    end;
  end;
//    cal_Calendar.Model.Data['Events']:=TValue.From<TStringArray>(aryList);
  FreeandNil(qry_Kalender);
  CreateKalToday;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCM_Main.CreateKalToday;
var
  dtDateTime: TDateTime;
  iIndex: integer;
  lstvwitm_KalenderToday: TListViewItem;
  qry_Kalender: TFDQuery;
  sBetreff: String;
  sWochentagBeginn: string;
  sWochentagEnde: string;
begin
  qry_Kalender:= TFDQuery.Create(Self);
  qry_Kalender.Connection:= dmmain.con_PCM;
  qry_Kalender.SQL.Text:= sSQL_SEL_ALL_Kalender_Where_Deleted;
  qry_Kalender.open;
  lv_KalenderKompakt.Items.Clear;
  if not qry_Kalender.Eof then
  begin
    qry_work.SQL.Text:= sSQL_DEL_TempCal;
    qry_work.ExecSQL;
    while not qry_Kalender.Eof do
    begin
      sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
      sWochentagEnde:= GetWeekDay(qry_Kalender.FieldByName('Finish').AsDateTime);
      dtDateTime:= CheckReccurence(qry_Kalender.FieldByName('ID').asInteger,qry_Kalender.FieldByName('Start').asDatetime,Date,qry_Kalender.FieldByName('wiederholungtext').asString);
      iIndex:= 1;
      if qry_Kalender.FieldByName('Kalendername').AsString = 'Geburtstag' then
      begin
        iIndex:= 11;
      end;
      case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
        0: iIndex:= 7;
        1: iIndex:= 6;
        2: iIndex:= 8;
        3: iIndex:= 9;
        4: iIndex:= 10;
      end;
      if ((DateOf(dtDateTime) = Date) and (qry_Kalender.FieldByName('wiederholungtext').asString <> '')) then
      begin
        sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
        qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
        qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
        qry_work_Sub.open;
        if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
        begin
          qry_work.SQL.Text:= sSQL_INS_TempCal;
          qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
          qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
          qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
          if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
          begin
            qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',Date);
            qry_work.ParamByName('Start').AsString:= FormatDateTime('hh:mm',Date);
          end
          else begin
            qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',dtDateTime) + ' ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
            qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
          end;
          qry_work.ExecSQL;
        end;
        qry_work_Sub.Close;
      end
      else begin
        dtDateTime:= qry_Kalender.FieldByName('Start').AsDateTime;
        if (DateOf(dtDateTime) = Date) then
        begin
          if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
          begin
            qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
            qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
            qry_work_Sub.open;
            if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
            begin
              qry_work.SQL.Text:= sSQL_INS_TempCal;
              qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
              qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
              qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
              if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
              begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime);
                qry_work.ParamByName('Start').AsString:= FormatDateTime('hh:mm',Date);
              end
              else begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + sWochentagEnde + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Finish').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end;
              qry_work.ExecSQL;
            end;
            qry_work_Sub.Close;
          end
          else begin
            qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
            qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
            qry_work_Sub.open;
            if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
            begin
              qry_work.SQL.Text:= sSQL_INS_TempCal;
              qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
              qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
              qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
              if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
              begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end
              else begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end;
              qry_work.ExecSQL;
            end;
            qry_work_Sub.Close;
          end;
        end;
      end;
      qry_Kalender.Next;
    end;
    qry_work.SQL.Text:= sSQL_SEL_ALL_TempCal;
    qry_work.open;
    while not qry_work.eof do
    begin
      lstvwitm_KalenderToday:= lv_KalenderKompakt.Items.Add;
      lstvwitm_KalenderToday.Tag:= qry_Kalender.FieldByName('ID').AsInteger;
      sBetreff:= qry_work.FieldByName('Text').AsString;
      lstvwitm_KalenderToday.ImageIndex:= qry_work.FieldByName('Itemindex').AsInteger;
      lstvwitm_KalenderToday.Tag:= qry_work.FieldByName('ID_Kalender').AsInteger;
      lstvwitm_KalenderToday.Text:=sBetreff;
      lstvwitm_KalenderToday.Detail:= qry_work.FieldByName('Detail').AsString;
      qry_work.Next;
    end;
    qry_work.Close;
  end;
  dmmain.wfWaitFrame.HideFW;
end;
procedure Tfrm_PCM_Main.cal_CalendarDateSelected(Sender: TObject);
var
  dtDateTime:TDateTime;
  iIndex: integer;
  lstvwitm_KalenderSelect: TListViewItem;
  qry_Kalender: TFDQuery;
  sBetreff: String;
  sWochentagBeginn: string;
  sWochentagEnde: string;
begin
  dmmain.wfWaitFrame.Execute('Kalender laden...', 'Kalender', True);
  qry_Kalender:= TFDQuery.Create(Self);
  qry_Kalender.Connection:= dmmain.con_PCM;
  qry_Kalender.FetchOptions.Mode:= fmall;
  qry_Kalender.FetchOptions.RecordCountMode:= cmtotal;
  qry_Kalender.SQL.Text:= sSQL_SEL_ALL_Kalender;

  qry_Kalender.open;
  lv_KalenderKompakt.Items.Clear;
  if not qry_Kalender.Eof then
  begin
    qry_work.SQL.Text:= sSQL_DEL_TempCal;
    qry_work.ExecSQL;
    while not qry_Kalender.Eof do
    begin
      sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
      sWochentagEnde:= GetWeekDay(qry_Kalender.FieldByName('Finish').AsDateTime);
      dtDateTime:= CheckReccurence(qry_Kalender.FieldByName('ID').asInteger,qry_Kalender.FieldByName('Start').asDatetime,cal_Calendar.Date,qry_Kalender.FieldByName('wiederholungtext').asString);
      if ((DateOf(dtDateTime) = cal_Calendar.Date) and (qry_Kalender.FieldByName('wiederholungtext').asString <> '')) then
      begin
        iIndex:= 13;
        if qry_Kalender.FieldByName('Kalendername').AsString = 'Geburtstag' then
        begin
          iIndex:= 11;
        end;
        sWochentagBeginn:= GetWeekDay(qry_Kalender.FieldByName('Start').AsDateTime);
        qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
        qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
        qry_work_Sub.open;
        case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
        0: iIndex:= 7;
        1: iIndex:= 6;
        2: iIndex:= 8;
        3: iIndex:= 9;
        4: iIndex:= 10;
      end;
        if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
        begin
          qry_work.SQL.Text:= sSQL_INS_TempCal;
          qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
          qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
          qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
          if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
          begin
            qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',Date);
            qry_work.ParamByName('Start').AsString:= FormatDateTime('hh:mm',Date);
          end
          else begin
            qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + FormatDateTime('dd.mm.yyyy',dtDateTime) + ' ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
            qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
          end;
          qry_work.ExecSQL;
        end;
        qry_work_Sub.Close;
      end
      else begin
        iIndex:= 1;
        dtDateTime:= qry_Kalender.FieldByName('Start').AsDateTime;
        if (DateOf(dtDateTime) = cal_Calendar.Date) then
        begin
          if qry_Kalender.FieldByName('CompleteDay').AsBoolean then
          begin
            qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
            qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
            qry_work_Sub.open;
            case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
            0: iIndex:= 7;
            1: iIndex:= 6;
            2: iIndex:= 8;
            3: iIndex:= 9;
            4: iIndex:= 10;
            end;
            if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
            begin
              qry_work.SQL.Text:= sSQL_INS_TempCal;
              qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
              qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
              qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
              if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
              begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime);
                qry_work.ParamByName('Start').AsString:= FormatDateTime('hh:mm',Date);
              end
              else begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + sWochentagEnde + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Finish').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end;
              qry_work.ExecSQL;
            end;
            qry_work_Sub.Close;
          end
          else begin
            qry_work_sub.SQL.Text:= sSQL_SEL_COUNT_TempCal;
            qry_work_sub.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
            qry_work_Sub.open;
            case AnsiIndexStr(qry_Kalender.FieldByName('Caption').AsString, ['Gelber Sack', 'Restmüll','Biomüll', 'Papier','Giftmobil']) of
              0: iIndex:= 7;
              1: iIndex:= 6;
              2: iIndex:= 8;
              3: iIndex:= 9;
              4: iIndex:= 10;
            end;
            if qry_work_Sub.FieldByName('Anzahl').AsInteger = 0 then
            begin
              qry_work.SQL.Text:= sSQL_INS_TempCal;
              qry_work.ParamByName('Text').AsString :=  qry_Kalender.FieldByName('Caption').AsString;
              qry_work.ParamByName('Itemindex').AsInteger:= iIndex;
              qry_work.ParamByName('ID_Kalender').AsInteger:= qry_Kalender.FieldByName('ID').asInteger;
              if qry_Kalender.FieldByName('Finish').AsDateTime - qry_Kalender.FieldByName('Start').AsDateTime  = 1 then
              begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy',qry_Kalender.FieldByName('Start').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end
              else begin
                qry_work.ParamByName('Detail').AsString:= sWochentagBeginn + ' ' + FormatDateTime('dd.mm.yyyy hh:mm',qry_Kalender.FieldByName('Start').AsDateTime) + ' - ' + FormatDateTime('hh:mm',qry_Kalender.FieldByName('Finish').AsDateTime);
                qry_work.ParamByName('Start').AsDateTime:= StrToTime(FormatDateTime('hh:mm',qry_Kalender.FieldByName('Start').AsDateTime));
              end;
              qry_work.ExecSQL;
            end;
            qry_work_Sub.Close;
          end;
        end;
      end;
      qry_Kalender.Next;
    end;
    qry_work.SQL.Text:= sSQL_SEL_ALL_TempCal;
    qry_work.open;
    while not qry_work.eof do
    begin
      lstvwitm_KalenderSelect:= lv_KalenderKompakt.Items.Add;
      lstvwitm_KalenderSelect.Tag:= qry_Kalender.FieldByName('ID').AsInteger;
      sBetreff:= qry_work.FieldByName('Text').AsString;
      lstvwitm_KalenderSelect.ImageIndex:= qry_work.FieldByName('Itemindex').AsInteger;
      lstvwitm_KalenderSelect.Tag:= qry_work.FieldByName('ID_Kalender').AsInteger;
      lstvwitm_KalenderSelect.Text:=sBetreff;
      lstvwitm_KalenderSelect.Detail:= qry_work.FieldByName('Detail').AsString;
      qry_work.Next;
    end;
    qry_work.Close;
  end;
  FreeandNil(qry_Kalender);
  dmmain.wfWaitFrame.HideFW;
end;
{$EndRegion KalenderKontakte}
////////////////////////////////////////////////////////////////////////////////
// Passwort                                                                   //
////////////////////////////////////////////////////////////////////////////////
{$Region Passwort}
procedure Tfrm_PCM_Main.lv_PasswortDeletingItem(Sender: TObject; AIndex: Integer;var ACanDelete: Boolean);
var
  qry_PasswortDelete: TFDQuery;
begin
  qry_PasswortDelete:= TFDQuery.Create(Self);
  qry_PasswortDelete.Connection:= dmmain.con_PCM;
  qry_PasswortDelete.SQL.Text:= sSQL_UPD_DeletePWDItem;
  qry_PasswortDelete.ParamByName('ID').AsInteger:= lv_Passwort.Items.Item[AIndex].Tag;
  qry_PasswortDelete.ExecSQL;
  FreeandNil(qry_PasswortDelete);
end;
procedure Tfrm_PCM_Main.lv_PasswortKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_PasswortDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_PasswortDelete:= TFDQuery.Create(Self);
    qry_PasswortDelete.Connection:= dmmain.con_PCM;
    qry_PasswortDelete.SQL.Text:= sSQL_UPD_DeletePWDItem;
    qry_PasswortDelete.ParamByName('ID').AsInteger:= lv_Passwort.Items.Item[iItemIndex].Tag;
    qry_PasswortDelete.ExecSQL;
    FreeandNil(qry_PasswortDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_PasswortItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_PasswortDetail,frm_PCMAPP_PasswortDetail);
    frm_PCMAPP_PasswortDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_PasswortDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_PasswortDetail,frm_PCMAPP_PasswortDetail);
    frm_PCMAPP_PasswortDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_PasswortPullRefresh(Sender: TObject);
begin
  dmmain.wfWaitFrame.Execute('Passwörter synchronisieren...', 'Passwörter', True);
  TTask.Run(
  Procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      SyncPasswort_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
      lv_Passwort.Items.Clear;
      lv_Passwort.BeginUpdate;
      CreatePWDGridConfig;
      lv_Passwort.EndUpdate;
    end);
  end)
end;
procedure Tfrm_PCM_Main.CreatePWDGridConfig;
var
  lstvwitm_Passwort: TListViewItem;
  qry_Passwort: TFDQuery;
begin
  qry_Passwort:= TFDQuery.Create(Self);
  qry_Passwort.Connection:= dmmain.con_PCM;
  qry_Passwort.SQL.Text:= sSQL_SEL_ALL_Password_WHERE_DELETED;
  qry_Passwort.open;
  if not qry_Passwort.Eof then
  begin
    while not qry_Passwort.Eof do
    begin
      lstvwitm_Passwort:= lv_Passwort.Items.Add;
      lstvwitm_Passwort.Tag:= qry_Passwort.FieldByName('ID').AsInteger;
      lstvwitm_Passwort.Text:= qry_Passwort.FieldByName('Bezeichnung').AsString;
      lstvwitm_Passwort.Detail:= qry_Passwort.FieldByName('PWTyp').AsString;
      lstvwitm_Passwort.ImageIndex:= 2;
      qry_Passwort.Next;
    end;
  end;
  FreeandNil(qry_Passwort);
end;
{$EndRegion Passwort}
////////////////////////////////////////////////////////////////////////////////
// Serials                                                                    //
////////////////////////////////////////////////////////////////////////////////
{$Region Serials}
procedure Tfrm_PCM_Main.lv_SerialsDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
var
  qry_SerialDelete: TFDQuery;
begin
  qry_SerialDelete:= TFDQuery.Create(Self);
  qry_SerialDelete.Connection:= dmmain.con_PCM;
  qry_SerialDelete.SQL.Text:= sSQL_UPD_Delete_SerialItem;
  qry_SerialDelete.ParamByName('ID').AsInteger:= lv_Serials.Items.Item[AIndex].Tag;
  qry_SerialDelete.ExecSQL;
  FreeandNil(qry_SerialDelete);
end;
procedure Tfrm_PCM_Main.lv_SerialsKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_SerialDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_SerialDelete:= TFDQuery.Create(Self);
    qry_SerialDelete.Connection:= dmmain.con_PCM;
    qry_SerialDelete.SQL.Text:= sSQL_UPD_Delete_SerialItem;
    qry_SerialDelete.ParamByName('ID').AsInteger:= lv_Serials.Items.Item[iItemIndex].Tag;
    qry_SerialDelete.ExecSQL;
    FreeandNil(qry_SerialDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_SerialsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_SerialDetail,frm_PCMAPP_SerialDetail);
    frm_PCMAPP_SerialDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_SerialsDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_SerialDetail,frm_PCMAPP_SerialDetail);
    frm_PCMAPP_SerialDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_SerialsPullRefresh(Sender: TObject);
begin
  dmmain.wfWaitFrame.Execute('Serials synchronisieren...', 'Serials', True);
  TTask.Run(
  Procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      SyncSerials_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
      lv_Serials.Items.Clear;
      lv_Serials.BeginUpdate;
      CreateSerialGridConfig;
      lv_Serials.EndUpdate;
    end);
  end)
end;
procedure Tfrm_PCM_Main.CreateSerialGridConfig;
var
  lstvwitm_Serial: TListViewItem;
  qry_Serial: TFDQuery;
begin
  qry_Serial:= TFDQuery.Create(Self);
  qry_Serial.Connection:= dmmain.con_PCM;
  qry_Serial.SQL.Text:= sSQL_SEL_ALL_Serials_Where_Deleted;
  qry_Serial.open;
  if not qry_Serial.Eof then
  begin
    while not qry_Serial.Eof do
    begin
      lstvwitm_Serial:= lv_Serials.Items.Add;
      lstvwitm_Serial.Tag:= qry_Serial.FieldByName('ID').AsInteger;
      lstvwitm_Serial.Text:= qry_Serial.FieldByName('App').AsString;
      lstvwitm_Serial.Detail:= qry_Serial.FieldByName('Bezeichnung').AsString;
      lstvwitm_Serial.ImageIndex:= 3;
      qry_Serial.Next;
    end;
  end;
  FreeandNil(qry_Serial);
end;
{$EndRegion Serials}
////////////////////////////////////////////////////////////////////////////////
// Finanzen                                                                   //
////////////////////////////////////////////////////////////////////////////////
{$Region Finanzen}
  // Einnahmen
  {$Region Einnahmen}
  procedure Tfrm_PCM_Main.btn_FixEinnahmenClick(Sender: TObject);
  begin
    qry_Work.SQL.Text:= sSQL_UPD_BetragFix_Einnahmen;
    qry_Work.ExecSQL;
    lv_Einnahmen.Items.Clear;
    lv_Einnahmen.BeginUpdate;
    CreateFinEinGridConfig;
    lv_Einnahmen.EndUpdate;
  end;
  procedure Tfrm_PCM_Main.btn_NullEinnahmenClick(Sender: TObject);
  begin
    qry_Work.SQL.Text:= sSQL_UPD_BetragNull_Einnahmen;
    qry_Work.ExecSQL;
    lv_Einnahmen.Items.Clear;
    lv_Einnahmen.BeginUpdate;
    CreateFinEinGridConfig;
    lv_Einnahmen.EndUpdate;
  end;
  procedure Tfrm_PCM_Main.lv_EinnahmenDeletingItem(Sender: TObject; AIndex: Integer;var ACanDelete: Boolean);
  var
    qry_EinnahmenDelete: TFDQuery;
  begin
    qry_EinnahmenDelete:= TFDQuery.Create(Self);
    qry_EinnahmenDelete.Connection:= dmmain.con_PCM;
    qry_EinnahmenDelete.SQL.Text:= sSQL_UPD_Delete_EinnahmeItem;
    qry_EinnahmenDelete.ParamByName('ID').AsInteger:= lv_Einnahmen.Items.Item[AIndex].Tag;
    qry_EinnahmenDelete.ExecSQL;
    FreeandNil(qry_EinnahmenDelete);
  end;
  procedure Tfrm_PCM_Main.lv_EinnahmenKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  var
    qry_EinnahmenDelete: TFDQuery;
  begin
    if Key = 46 then
    begin
      qry_EinnahmenDelete:= TFDQuery.Create(Self);
      qry_EinnahmenDelete.Connection:= dmmain.con_PCM;
      qry_EinnahmenDelete.SQL.Text:= sSQL_UPD_Delete_EinnahmeItem;
      qry_EinnahmenDelete.ParamByName('ID').AsInteger:= lv_Einnahmen.Items.Item[iItemindex].Tag;
      qry_EinnahmenDelete.ExecSQL;
      FreeandNil(qry_EinnahmenDelete);
    end;
  end;
  procedure Tfrm_PCM_Main.lv_EinnahmenItemClick(const Sender: TObject; const AItem: TListViewItem);
  begin
    iItemIndex := AItem.Index;
    iItemTag:= AItem.Tag;
    {$IFDEF ANDROID}
    if AItem.Index >= 0 then
    begin
      iID:= AItem.Tag;
      iListviewID:= AItem.Index;
      Application.CreateForm(Tfrm_PCMAPP_EinnahmenDetail,frm_PCMAPP_EinnahmenDetail);
      frm_PCMAPP_EinnahmenDetail.Show;
    end;
    {$ENDIF ANDROID}
  end;
  procedure Tfrm_PCM_Main.lv_EinnahmenDblClick(Sender: TObject);
  begin
    {$IFDEF MSWINDOWS}
    if iItemIndex >= 0 then
    begin
      iID:= iItemTag;
      iListviewID:= iItemIndex;
      Application.CreateForm(Tfrm_PCMAPP_EinnahmenDetail,frm_PCMAPP_EinnahmenDetail);
      frm_PCMAPP_EinnahmenDetail.Show;
    end;
    iItemIndex:= -1;
    {$ENDIF MSWINDOWS}
  end;
  procedure Tfrm_PCM_Main.lv_EinnahmenPullRefresh(Sender: TObject);
  begin
    dmmain.wfWaitFrame.Execute('Einnahmen synchronisieren...', 'Finanzen', True);
    TTask.Run(
    Procedure()
    begin
      TThread.Synchronize(nil,
      procedure()
      begin
        SyncFinanzenEin_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
        lv_Einnahmen.Items.Clear;
        lv_Einnahmen.BeginUpdate;
        CreateFinEinGridConfig;
        lv_Einnahmen.EndUpdate;
      end);
    end)
  end;
  procedure Tfrm_PCM_Main.CreateFinEinGridConfig;
  var
    lstvwitm_Einnahmen: TListViewItem;
    qry_Einnahmen: TFDQuery;
  begin
    qry_Einnahmen:= TFDQuery.Create(Self);
    qry_Einnahmen.Connection:= dmmain.con_PCM;
    qry_Einnahmen.SQL.Text:= sSQL_SEL_ALL_Einnahmen_WHERE_DELETED;
    qry_Einnahmen.open;
    if not qry_Einnahmen.Eof then
    begin
      while not qry_Einnahmen.Eof do
      begin
        lstvwitm_Einnahmen:= lv_Einnahmen.Items.Add;
        lstvwitm_Einnahmen.Tag:= qry_Einnahmen.FieldByName('ID').AsInteger;
        lstvwitm_Einnahmen.Detail:= FormatCurr(',0.00 €;-,0.00 €', qry_Einnahmen.FieldByName('Betrag').AsFloat);
        lstvwitm_Einnahmen.Text:= qry_Einnahmen.FieldByName('Quelle').AsString;
        lstvwitm_Einnahmen.ImageIndex:= 4;
        qry_Einnahmen.Next;
      end;
    end;
    FreeandNil(qry_Einnahmen);
  end;
  {$EndRegion Einnahmen}
  // Ausgaben
  {$Region Ausgaben}
  procedure Tfrm_PCM_Main.btn_FixAusgabenClick(Sender: TObject);
  begin
    qry_Work.SQL.Text:= sSQL_UPD_BetragFix_Ausgaben;
    qry_Work.ExecSQL;
    lv_Ausgaben.Items.Clear;
    lv_Ausgaben.BeginUpdate;
    CreateFinAusGridConfig;
    lv_Ausgaben.EndUpdate;
  end;
  procedure Tfrm_PCM_Main.btn_NullAusgabenClick(Sender: TObject);
  begin
    qry_Work.SQL.Text:= sSQL_UPD_BetragNull_Ausgaben;
    qry_Work.ExecSQL;
    lv_Ausgaben.Items.Clear;
    lv_Ausgaben.BeginUpdate;
    CreateFinAusGridConfig;
    lv_Ausgaben.EndUpdate;
  end;
  procedure Tfrm_PCM_Main.lv_AusgabenDeletingItem(Sender: TObject; AIndex: Integer;var ACanDelete: Boolean);
  var
    qry_AusgabenDelete: TFDQuery;
  begin
    qry_AusgabenDelete:= TFDQuery.Create(Self);
    qry_AusgabenDelete.Connection:= dmmain.con_PCM;
    qry_AusgabenDelete.SQL.Text:= sSQL_UPD_Delete_AusgabeItem;
    qry_AusgabenDelete.ParamByName('ID').AsInteger:= lv_Ausgaben.Items.Item[AIndex].Tag;
    qry_AusgabenDelete.ExecSQL;
    FreeandNil(qry_AusgabenDelete);
  end;
  procedure Tfrm_PCM_Main.lv_AusgabenKeyDown(Sender: TObject; var Key: Word;  var KeyChar: Char; Shift: TShiftState);
  var
    qry_AusgabenDelete: TFDQuery;
  begin
    if Key = 46 then
    begin
      qry_AusgabenDelete:= TFDQuery.Create(Self);
      qry_AusgabenDelete.Connection:= dmmain.con_PCM;
      qry_AusgabenDelete.SQL.Text:= sSQL_UPD_Delete_AusgabeItem;
      qry_AusgabenDelete.ParamByName('ID').AsInteger:= lv_Ausgaben.Items.Item[iItemindex].Tag;
      qry_AusgabenDelete.ExecSQL;
      FreeandNil(qry_AusgabenDelete);
    end;
  end;
  procedure Tfrm_PCM_Main.lv_AusgabenItemClick(const Sender: TObject; const AItem: TListViewItem);
  begin
    iItemIndex := AItem.Index;
    iItemTag:= AItem.Tag;
    {$IFDEF ANDROID}
    if AItem.Index >= 0 then
    begin
      iID:= AItem.Tag;
      iListviewID:= AItem.Index;
      Application.CreateForm(Tfrm_PCMAPP_AusgabenDetail,frm_PCMAPP_AusgabenDetail);
      frm_PCMAPP_AusgabenDetail.Show;
    end;
    {$ENDIF ANDROID}
  end;
  procedure Tfrm_PCM_Main.lv_AusgabenDblClick(Sender: TObject);
  begin
    {$IFDEF MSWINDOWS}
    if iItemIndex >= 0 then
    begin
      iID:= iItemTag;
      iListviewID:= iItemIndex;
      Application.CreateForm(Tfrm_PCMAPP_AusgabenDetail,frm_PCMAPP_AusgabenDetail);
      frm_PCMAPP_AusgabenDetail.Show;
    end;
    iItemIndex:= -1;
    {$ENDIF MSWINDOWS}
  end;
  procedure Tfrm_PCM_Main.lv_AusgabenPullRefresh(Sender: TObject);
  begin
    dmmain.wfWaitFrame.Execute('Ausgaben synchronisieren...', 'Finanzen', True);
    TTask.Run(
    Procedure()
    begin
      TThread.Synchronize(nil,
      procedure()
      begin
        SyncFinanzenAus_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
        lv_Ausgaben.Items.Clear;
        lv_Ausgaben.BeginUpdate;
        CreateFinAusGridConfig;
        lv_Ausgaben.EndUpdate;
      end);
    end)
  end;
  procedure Tfrm_PCM_Main.CreateFinAusGridConfig;
  var
    lstvwitm_Ausgaben: TListViewItem;
    qry_Ausgaben: TFDQuery;
  begin
    qry_Ausgaben:= TFDQuery.Create(Self);
    qry_Ausgaben.Connection:= dmmain.con_PCM;
    qry_Ausgaben.SQL.Text:= sSQL_SEL_ALL_Ausgaben;
    qry_Ausgaben.open;
    if not qry_Ausgaben.Eof then
    begin
      while not qry_Ausgaben.Eof do
      begin
        lstvwitm_Ausgaben:= lv_Ausgaben.Items.Add;
        lstvwitm_Ausgaben.Tag:= qry_Ausgaben.FieldByName('ID').AsInteger;
        lstvwitm_Ausgaben.Detail:= FormatCurr(',0.00 €;-,0.00 €', qry_Ausgaben.FieldByName('Betrag').AsFloat);
        lstvwitm_Ausgaben.Text:= qry_Ausgaben.FieldByName('Name').AsString;
        lstvwitm_Ausgaben.ImageIndex:= 5;
        qry_Ausgaben.Next;
      end;
    end;
    FreeandNil(qry_Ausgaben);
  end;
  {$EndRegion Ausgaben}
  // Belege
  {$Region Belege}
  procedure Tfrm_PCM_Main.lv_BelegeDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
  var
    qry_BelegeDelete: TFDQuery;
  begin
    qry_BelegeDelete:= TFDQuery.Create(Self);
    qry_BelegeDelete.Connection:= dmmain.con_PCM;
    qry_BelegeDelete.SQL.Text:= sSQL_UPD_DeleteBelItem;
    qry_BelegeDelete.ParamByName('ID').AsInteger:= lv_Belege.Items.Item[AIndex].Tag;
    qry_BelegeDelete.ExecSQL;
    FreeandNil(qry_BelegeDelete);
  end;
  procedure Tfrm_PCM_Main.lv_BelegeKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  var
    qry_BelegeDelete: TFDQuery;
  begin
   if Key = 46 then
    begin
      qry_BelegeDelete:= TFDQuery.Create(Self);
      qry_BelegeDelete.Connection:= dmmain.con_PCM;
      qry_BelegeDelete.SQL.Text:= sSQL_UPD_DeleteBelItem;
      qry_BelegeDelete.ParamByName('ID').AsInteger:= lv_Belege.Items.Item[iItemIndex].Tag;
      qry_BelegeDelete.ExecSQL;
      FreeandNil(qry_BelegeDelete);
    end;
  end;
  procedure Tfrm_PCM_Main.lv_BelegeItemClick(const Sender: TObject;  const AItem: TListViewItem);
  begin
    iItemIndex := AItem.Index;
    iItemTag:= AItem.Tag;
    {$IFDEF ANDROID}
    if AItem.Index >= 0 then
    begin
      iID:= AItem.Tag;
      iListviewID:= AItem.Index;
      Application.CreateForm(Tfrm_PCMAPP_BelegeDetail,frm_PCMAPP_BelegeDetail);
      frm_PCMAPP_BelegeDetail.Show;
    end;
    {$ENDIF ANDROID}
  end;
  procedure Tfrm_PCM_Main.lv_BelegeDblClick(Sender: TObject);
  begin
    {$IFDEF MSWINDOWS}
    if iItemIndex >= 0 then
    begin
      iID:= iItemTag;
      iListviewID:= iItemIndex;
      Application.CreateForm(Tfrm_PCMAPP_BelegeDetail,frm_PCMAPP_BelegeDetail);
      frm_PCMAPP_BelegeDetail.Show;
    end;
    iItemIndex:= -1;
    {$ENDIF MSWINDOWS}
  end;
  procedure Tfrm_PCM_Main.lv_BelegePullRefresh(Sender: TObject);
  begin
    dmmain.wfWaitFrame.Execute('Belege synchronisieren...', 'Belege', True);
    TTask.Run(
    Procedure()
    begin
      TThread.Synchronize(nil,
      procedure()
      begin
        SyncBelege_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
        lv_Belege.Items.Clear;
        lv_Belege.BeginUpdate;
        CreateBelegeGridConfig;
        lv_Belege.EndUpdate;
      end);
    end)
  end;
  procedure Tfrm_PCM_Main.CreateBelegeGridConfig;
  var
    lstvwitm_Belege: TListViewItem;
    qry_Belege: TFDQuery;
  begin
    qry_Belege:= TFDQuery.Create(Self);
    qry_Belege.Connection:= dmmain.con_PCM;
    qry_Belege.SQL.Text:= sSQL_SEL_ALL_Belege;
    qry_Belege.open;
    if not qry_Belege.Eof then
    begin
      while not qry_Belege.Eof do
      begin
        lstvwitm_Belege:= lv_Belege.Items.Add;
        lstvwitm_Belege.Tag:= qry_Belege.FieldByName('ID').AsInteger;
        lstvwitm_Belege.Detail:= qry_Belege.FieldByName('Datum').AsString + ', ' + FormatCurr(',0.00 €;-,0.00 €', qry_Belege.FieldByName('Betrag').AsFloat);
        lstvwitm_Belege.Text:= qry_Belege.FieldByName('Aussteller').AsString + ': ' + qry_Belege.FieldByName('Nummer').AsString;
        lstvwitm_Belege.ImageIndex:= 5;
        qry_Belege.Next;
      end;
    end;
    FreeandNil(qry_Belege);
  end;
  {$EndRegion Belege}
  // Finanzübersicht
  {$Region FinanzUebersicht}
  procedure Tfrm_PCM_Main.rec_1EinnahmenClick(Sender: TObject);
  begin
    tc_FinanzenOverview.ActiveTab:= ti_2Detail;
    tc_FinanzenDetail.ActiveTab:= ti_FinanzenEinDetail;
  end;
  procedure Tfrm_PCM_Main.rec_2AusgabenVarClick(Sender: TObject);
  begin
    tc_FinanzenOverview.ActiveTab:= ti_2Detail;
    tc_FinanzenDetail.ActiveTab:= ti_FinanzenAusVarDetail;
  end;
  procedure Tfrm_PCM_Main.rec_3AusgabenFixClick(Sender: TObject);
  begin
    tc_FinanzenOverview.ActiveTab:= ti_2Detail;
    tc_FinanzenDetail.ActiveTab:= ti_FinanzenAusFixDetail;
  end;
  procedure Tfrm_PCM_Main.btn_DetailBackClick(Sender: TObject);
  begin
    tc_FinanzenOverview.ActiveTab:= ti_1Komprimiert;
  end;
  procedure Tfrm_PCM_Main.cbx_MonatChange(Sender: TObject);
    procedure BerechneUebersicht;
    var
      fEinnamen: double;
      ffixkosten: double;
      fgesamt: double;
      fvarKosten: double;
      qry_Sum: TFDQuery;
    begin
      try
        qry_Sum:= TFDQuery.Create(Self);
        qry_Sum.Connection:= dmmain.con_PCM;
        qry_Sum.SQL.Text := sSQL_SEL_SUMBetrag_Einnahmen;
        qry_Sum.open;
        fEinnamen:= qry_Sum.FieldByName('Einnahmen').AsFloat;
        qry_Sum.close;
        qry_Sum.SQL.Text := sSQL_SEL_SUMBetrag_varKosten;
        qry_Sum.ParamByName('Monat').AsInteger:= cbx_Monat.ItemIndex + 1;
        qry_Sum.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
        qry_Sum.ParamByName('Fixkosten').AsBoolean:= false;
        qry_Sum.open;
        fvarKosten:= qry_Sum.FieldByName('varKosten').AsFloat;
        qry_Sum.close;
        qry_Sum.SQL.Text := sSQL_SEL_SUMBetrag_fixKosten;
        qry_Sum.ParamByName('Fixkosten').AsBoolean:= true;
        qry_Sum.open;
        ffixkosten:= qry_Sum.FieldByName('fixKosten').AsFloat;
        qry_Sum.close;
        lbl_EinnahmenDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fEinnamen);
        lo_FinanzenEinDetailGesamt.Text:=lbl_EinnahmenDetail.Text;
        lbl_EinnahmenGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fEinnamen);
        lbl_AusgabenVarDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fvarKosten);
        lbl_FinanzenVarGesamt.Text:= lbl_AusgabenVarDetail.text;
        lbl_AusgabenVarGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', fvarKosten);
        lbl_AusgabenFixDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', ffixkosten);
        lbl_FinanzenFixGesamt.Text:= lbl_AusgabenFixDetail.Text;
        lbl_AusgabenFixGesDetail.Text:= FormatCurr(',0.00 €;-,0.00 €', ffixkosten);
        fgesamt:= fEinnamen - fvarKosten - ffixkosten;
        lbl_GesamtKompDetail.text:= FormatCurr(',0.00 €;-,0.00 €', fgesamt);
        mem_FinanzenEinDetailBesch.Lines.Clear;
        mem_FinanzenEinDetailBetrag.Lines.Clear;
        qry_Sum.SQL.Text := 'Select Quelle, IFnull(Betrag,0) as Einnahmen From FinanzenEinnahmen WHERE (Deleted <> true or deleted is null) and Betrag > 0 Order by Quelle';
        qry_Sum.open;
        while not qry_Sum.Eof do
        begin
          mem_FinanzenEinDetailBesch.Lines.Add(qry_Sum.FieldByName('Quelle').asString);
          mem_FinanzenEinDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_Sum.FieldByName('Einnahmen').asFloat));
          qry_Sum.Next;
        end;
        qry_Sum.close;
        mem_FinanzenAusVarDetailBesch.Lines.Clear;
        mem_FinanzenAusVarDetailBetrag.Lines.Clear;
        qry_Sum.SQL.Text := 'Select Name,IFnull(Betrag,0)as varKosten From FinanzenAusgaben WHERE (Deleted <> true or deleted is null)  and fixkosten = :Fixkosten '
                                      + 'and Gueltig_Monat = :Monat and Gueltig_Jahr = :Jahr order by name';
        qry_Sum.ParamByName('Monat').AsInteger:= cbx_Monat.ItemIndex + 1;
        qry_Sum.ParamByName('Jahr').AsInteger:= StrToint(cbx_Jahr.Items[cbx_Jahr.ItemIndex]);
        qry_Sum.ParamByName('Fixkosten').AsBoolean:= false;
        qry_Sum.open;
        while not qry_Sum.Eof do
        begin
          mem_FinanzenAusVarDetailBesch.Lines.Add(qry_Sum.FieldByName('Name').asString);
          mem_FinanzenAusVarDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_Sum.FieldByName('varKosten').asFloat));
          qry_Sum.Next;
        end;
        qry_Sum.close;
        mem_FinanzenFixDetailBesch.Lines.Clear;
        mem_FinanzenfixDetailBetrag.Lines.Clear;
        qry_Sum.SQL.Text := 'Select Name,IFnull(Betrag,0)as FixKosten From FinanzenAusgaben WHERE (Deleted <> true or deleted is null) and Betrag > 0 and fixkosten = :Fixkosten '
                                      + 'order by name';
        qry_Sum.ParamByName('Fixkosten').AsBoolean:= true;
        qry_Sum.open;
        while not qry_Sum.Eof do
        begin
          mem_FinanzenFixDetailBesch.Lines.Add(qry_Sum.FieldByName('Name').asString);
          mem_FinanzenfixDetailBetrag.Lines.Add(FormatCurr(',0.00 €;-,0.00 €', qry_Sum.FieldByName('FixKosten').asFloat));
          qry_Sum.Next;
        end;
        qry_Sum.close;
      except
      end;
      FreeandNil(qry_Sum);
    end;
  begin
    BerechneUebersicht;
  end;
  {$EndRegion FinanzUebersicht}
{$EndRegion Finanzen}
////////////////////////////////////////////////////////////////////////////////
// Gutscheine                                                                 //
////////////////////////////////////////////////////////////////////////////////
{$Region Gutschein}
procedure Tfrm_PCM_Main.btn_GutscheineVisibleClick(Sender: TObject);
begin
  lv_Gutschein.Items.Clear;
  if btn_GutscheineVisible.Tag = 1 then
  begin
    btn_GutscheineVisible.Tag:=0;
    btn_GutscheineVisible.Text:= 'erledigte Gutscheine einblenden';
    CreateGridGutschein;
  end
  else begin
    btn_GutscheineVisible.Tag:=1;
    btn_GutscheineVisible.Text:= 'erledigte Gutscheine ausblenden';
    CreateGridGutschein;
  end;
end;
procedure Tfrm_PCM_Main.lv_GutscheinDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
var
  qry_GutscheinDelete: TFDQuery;
begin
  qry_GutscheinDelete:= TFDQuery.Create(Self);
  qry_GutscheinDelete.Connection:= dmmain.con_PCM;
  qry_GutscheinDelete.SQL.Text:= sSQL_UPD_Del_Gutschein;
  qry_GutscheinDelete.ParamByName('ID').AsInteger:= lv_Gutschein.Items.Item[AIndex].Tag;
  qry_GutscheinDelete.ExecSQL;
  FreeandNil(qry_GutscheinDelete);
end;
procedure Tfrm_PCM_Main.lv_GutscheinKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  qry_GutscheinDelete: TFDQuery;
begin
  if Key = 46 then
  begin
    qry_GutscheinDelete:= TFDQuery.Create(nil);
    qry_GutscheinDelete.Connection:= dmmain.con_PCM;
    qry_GutscheinDelete.SQL.Text:= sSQL_UPD_Del_Gutschein;
    qry_GutscheinDelete.ParamByName('ID').AsInteger:= lv_Gutschein.Items.Item[iItemIndex].Tag;
    qry_GutscheinDelete.ExecSQL;
    FreeandNil(qry_GutscheinDelete);
  end;
end;
procedure Tfrm_PCM_Main.lv_GutscheinItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  iItemIndex := AItem.Index;
  iItemTag:= AItem.Tag;
  {$IFDEF ANDROID}
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    Application.CreateForm(Tfrm_PCMAPP_GutscheinDetail,frm_PCMAPP_GutscheinDetail);
    frm_PCMAPP_GutscheinDetail.Show;
  end;
  {$ENDIF ANDROID}
end;
procedure Tfrm_PCM_Main.lv_GutscheinDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if iItemIndex >= 0 then
  begin
    iID:= iItemTag;
    iListviewID:= iItemIndex;
    Application.CreateForm(Tfrm_PCMAPP_GutscheinDetail,frm_PCMAPP_GutscheinDetail);
    frm_PCMAPP_GutscheinDetail.Show;
  end;
  iItemIndex:= -1;
  {$ENDIF MSWINDOWS}
end;
procedure Tfrm_PCM_Main.lv_GutscheinPullRefresh(Sender: TObject);
begin
  dmmain.wfWaitFrame.Execute('Gutscheine synchronisieren...', 'Gutscheine', True);
  TTask.Run(
  Procedure()
  begin
    TThread.Synchronize(nil,
    procedure()
    begin
      SyncGutscheine_FromServer(dmmain.iUserID,dmmain.wfWaitFrame);
      lv_Gutschein.Items.Clear;
      lv_Gutschein.BeginUpdate;
      CreateGridGutschein;
      lv_Gutschein.EndUpdate;
    end);
  end)
end;
procedure Tfrm_PCM_Main.CreateGridGutschein;
var
  lstvwitm_Gutschein: TListViewItem;
  fRestwert: Double;
  fWert: Double;
  qry_GutscheinGrid: TFDQuery;
begin
  fWert:= 0;
  fRestwert:= 0;
  qry_GutscheinGrid:= TFDQuery.Create(Self);
  qry_GutscheinGrid.Connection:= dmmain.con_PCM;
  if btn_GutscheineVisible.Tag = 1 then
    qry_GutscheinGrid.SQL.Text:= SQL_SEL_ALL_Gutscheine_Where_Deleted
  else
    qry_GutscheinGrid.SQL.Text:= SQL_SEL_ALL_Gutscheine_Where_DeletedRestWert;
  qry_GutscheinGrid.open;
  if not qry_GutscheinGrid.Eof then
  begin
    while not qry_GutscheinGrid.Eof do
    begin
      lstvwitm_Gutschein:= lv_Gutschein.Items.Add;
      lstvwitm_Gutschein.Tag:= qry_GutscheinGrid.FieldByName('ID').AsInteger;
      lstvwitm_Gutschein.Detail:= 'Wert: ' +  FormatCurr(',0.00 €;-,0.00 €', qry_GutscheinGrid.FieldByName('Wert').AsFloat) + ', Rest: ' + FormatCurr(',0.00 €;-,0.00 €',qry_GutscheinGrid.FieldByName('RestWert').AsFloat);
      lstvwitm_Gutschein.Text:= 'Bez: ' + qry_GutscheinGrid.FieldByName('Bezeichnung').AsString + ', Datum: ' + qry_GutscheinGrid.FieldByName('Datum').AsString;
      lstvwitm_Gutschein.ImageIndex := 12;
      fWert:= fWert + qry_GutscheinGrid.FieldByName('Wert').AsFloat;
      fRestwert:= fRestwert + qry_GutscheinGrid.FieldByName('Restwert').AsFloat;
      qry_GutscheinGrid.Next;
    end;
  end;
  FreeandNil(qry_GutscheinGrid);
  lbl_Gesamt.Text:= FormatCurr(',0.00 €;-,0.00 €', fWert);
  lbl_Rest.Text:= FormatCurr(',0.00 €;-,0.00 €',fRestwert);
end;
{$EndRegion Gutschein}
////////////////////////////////////////////////////////////////////////////////
// Kalenderabo                                                                //
////////////////////////////////////////////////////////////////////////////////
{$Region Kalenderabo}
procedure Tfrm_PCM_Main.lv_CalaboDeletingItem(Sender: TObject; AIndex: Integer; var ACanDelete: Boolean);
var
  qry_CalaboDelete: TFDQuery;
begin
  qry_CalaboDelete:= TFDQuery.Create(Self);
  qry_CalaboDelete.Connection:= dmmain.con_PCM;
  qry_CalaboDelete.SQL.Text:= sSQL_DEL_Calabo;
  qry_CalaboDelete.ParamByName('ID').AsInteger:= lv_Calabo.Items.Item[AIndex].Tag;
  qry_CalaboDelete.ExecSQL;
  FreeandNil(qry_CalaboDelete);
end;
procedure Tfrm_PCM_Main.lv_CalaboItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  if AItem.Index >= 0 then
  begin
    iID:= AItem.Tag;
    iListviewID:= AItem.Index;
    try
      Application.CreateForm(Tfrm_PCMAPP_Calabodetail,frm_PCMAPP_Calabodetail);
      frm_PCMAPP_CAlAboDetail.Show;
    except
    end;
  end;
end;
procedure Tfrm_PCM_Main.CreateCalAboGrid;
var
  lstvwitm_Calabo: TListViewItem;
  qry_Calabo: TFDQuery;
begin
  qry_Calabo:= TFDQuery.Create(Self);
  qry_Calabo.Connection:= dmmain.con_PCM;
  qry_Calabo.SQL.Text:= sSQL_SEL_ALL_Calabo;
  qry_Calabo.open;
  if not qry_Calabo.Eof then
  begin
    while not qry_Calabo.Eof do
    begin
      lstvwitm_Calabo:= lv_Calabo.Items.Add;
      lstvwitm_Calabo.Tag:= qry_Calabo.FieldByName('ID').AsInteger;
      lstvwitm_Calabo.Text:= qry_Calabo.FieldByName('Kalender').AsString;
      lstvwitm_Calabo.Detail:= qry_Calabo.FieldByName('Link').AsString;
      lstvwitm_Calabo.ImageIndex:= 1;
      qry_Calabo.Next;
    end;
  end;
  FreeandNil(qry_Calabo);
end;
{$EndRegion Kalenderabo}
////////////////////////////////////////////////////////////////////////////////
// More                                                                       //
////////////////////////////////////////////////////////////////////////////////
{$Region More}
procedure Tfrm_PCM_Main.btn_SynchronisationClick(Sender: TObject);
begin
  qry_Work.SQL.Text := sSQL_SEL_All_AUtologin;
  qry_Work.Open;
  try
    if qry_Work.FieldByName('Localaccount').AsBoolean then Exit;
  finally
    qry_Work.Close;
  end;
  if not dmmain.bServerAvailable then
  begin
    ShowMessage('Der Server ist nicht erreichbar.');
    Exit;
  end;
  btn_Synchronisation.Enabled := False;
  dmmain.wfWaitFrame.Execute('Synchronisierung...', 'Synchronisierung', True);
  TTask.Run(
    procedure
    begin
      try
        try
          Synchronisation(dmmain.iUserID, iServerID, dmmain.wfWaitFrame, True);
        except
          on E: Exception do ShowLoginMessage(E.Message);
        end;
      finally
        dmmain.wfWaitFrame.HideFW;
        TThread.Queue(nil, procedure begin btn_Synchronisation.Enabled := True; end);
      end;
    end);
end;
procedure Tfrm_PCM_Main.lstbxitm_1OptionenClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  btn_Multiview.visible:= false;
  tc_MainApp.ActiveTab:= ti_7More;
  iTags:= 6;
  try
    CreateFrameSystem;
  except
  end;
end;
procedure Tfrm_PCM_Main.lstbxitm_2CalaboClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  btn_CloseApp.Visible:= true;
  {$ENDIF MSWINDOWS}
  tc_MainApp.ActiveTab:= ti_7More;
  iTags:= 6;
  lv_Calabo.Items.clear;
  lv_Calabo.BeginUpdate;
  CreateCalAboGrid;
  lv_Calabo.EndUpdate;
  lbl_ModulName.Text := 'Kalenderabo';
  SetDisableToolButtons;
  tc_More.ActiveTab:= ti_4Calabo;;
  btn_Synchronisation.Visible:= false;
  btn_AddData.Visible:= True;
end;
procedure Tfrm_PCM_Main.lstbxitm_3AbmeldenClick(Sender: TObject);
begin
  TDialogServiceAsync.MessageDialog('ACHTUNG: Wenn Sie sich abmelden, muss bei der nächsten Anmeldung ' + #13 + 'ein aktive Serververbindung bestehen! Möchten Sie fortfahren?',
  TMsgDlgType.mtWarning, mbYesNo, TMsgDlgBtn.mbNo, 0,
  procedure(const AResult: TModalResult)
  begin
    if AResult = mrYes then
    begin
      try
        Logout;
        {$IFDEF MSWINDOWS}
        btn_CloseApp.Visible:= true;
        {$ENDIF MSWINDOWS}
        lo_Frame.DeleteChildren;
        lo_DetailFrame.DeleteChildren;
        tc_Main.ActiveTab := ti_1Login;
      except
      end;
    end;
  end);
end;
procedure Tfrm_PCM_Main.lstbxitm_3BeendenClick(Sender: TObject);
begin
  Application.Terminate;
end;
{$EndRegion More}
{$EndRegion Modulgrids}
end.

