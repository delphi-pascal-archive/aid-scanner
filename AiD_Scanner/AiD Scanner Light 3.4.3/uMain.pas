unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Menus, ImgList, XPMan, avKernel, avTypes, ShellAPI, ShlObj,
  AppEvnts, OneHist, langs;

  const
  WM_NOTIFYTRAYICON = WM_USER + 1;
  WM_MINERESTORE = WM_USER    + $877;

  type
  TIconType = (itSmall, itLarge);

  type
  NotifyIconData_50 = record
   cbSize: DWORD;
   Wnd: HWND;
   uID: UINT;
   uFlags: UINT;
   uCallbackMessage: UINT;
   hIcon: HICON;
   szTip: array[0..MAXCHAR] of AnsiChar;
   dwState: DWORD;
   dwStateMask: DWORD;
   szInfo: array[0..MAXBYTE] of AnsiChar;
   uTimeout: UINT; // union with uVersion: UINT;
   szInfoTitle: array[0..63] of AnsiChar;
   dwInfoFlags: DWORD;
  end;

  const
  NIF_INFO      =        $00000010;
  NIIF_NONE     =        $00000000;
  NIIF_INFO     =        $00000001;
  NIIF_WARNING  =        $00000002;
  NIIF_ERROR    =        $00000003;

  type
  TBalloonTimeout = 10..30;
  TBalloonIconType = (bitNone,
                      bitInfo,
                      bitWarning,
                      bitError);

type
  TMainForm = class(TForm)
    MainPages: TPageControl;
    ScanPathesTab: TTabSheet;
    ScanningTab: TTabSheet;
    ReportTab: TTabSheet;
    BottomPanel: TPanel;
    ScanBTN: TButton;
    SaveBTN: TButton;
    PathList: TListView;
    Bevel1: TBevel;
    ScanList: TListView;
    ReportMemo: TMemo;
    ImageList: TImageList;
    DrivesImg: TImageList;
    PathMenu: TPopupMenu;
    AddFolder: TMenuItem;
    DeletePath: TMenuItem;
    N1: TMenuItem;
    Reftesh: TMenuItem;
    SaveDialog: TSaveDialog;
    XPManifest: TXPManifest;
    Bevel4: TBevel;
    DelMenu: TPopupMenu;
    Del: TMenuItem;
    TrayMenu: TPopupMenu;
    mnuShowAiDScanner: TMenuItem;
    mnuHideAiDScanner: TMenuItem;
    N2: TMenuItem;
    mnuOptions: TMenuItem;
    N4: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    N7: TMenuItem;
    mnuExit: TMenuItem;
    Image1: TImage;
    TopPn: TPanel;
    Bevel3: TBevel;
    Image2: TImage;
    RightPanel: TPanel;
    ExitBTN: TButton;
    TopRightPanel: TPanel;
    Image3: TImage;
    VersionLabel: TLabel;
    CopyRightLabel: TLabel;
    AboutBTN: TLabel;
    HelpBTN: TLabel;
    DelAll: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    ProgressBar: TProgressBar;
    ScanTopBtn: TLabel;
    ScanMenu: TPopupMenu;
    mnuSelScanPath: TMenuItem;
    mnuShowReport: TMenuItem;
    N12: TMenuItem;
    OptionTopBtn: TLabel;
    PCTopBtn: TLabel;
    mnuAiDProcessControl: TMenuItem;
    N19: TMenuItem;
    mnuPCShow: TMenuItem;
    N21: TMenuItem;
    mnuPCRun: TMenuItem;
    mnuPCPause: TMenuItem;
    mnuPCStop: TMenuItem;
    mnuScanStart: TMenuItem;
    mnuStopScan: TMenuItem;
    N13: TMenuItem;
    mnuSaveReport: TMenuItem;
    N26: TMenuItem;
    mnuGoToTray: TMenuItem;
    SOURCESTRING: TListBox;
    LabelPanel: TPanel;
    ScanFile: TLabel;
    procedure DelAllClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ExitBTNClick(Sender: TObject);
    procedure ScanListDblClick(Sender: TObject);
    procedure ScanBTNClick(Sender: TObject);
    procedure InitScannerKernel;
    Procedure StartScan(Parametr: String);
    procedure SaveBTNClick(Sender: TObject);
    procedure DeletePathClick(Sender: TObject);
    procedure RefteshClick(Sender: TObject);
    procedure AddFolderClick(Sender: TObject);
    function CreateDrivesList(ListView: TListView): boolean;
    procedure AboutBTNClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpBTNClick(Sender: TObject);
    procedure DelMenuPopup(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure mnuHideAiDScannerClick(Sender: TObject);
    procedure mnuShowAiDScannerClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ScanListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    function BalloonTrayIcon(const Window: HWND; const IconID: Byte; const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle: String; const BalloonIconType: TBalloonIconType): Boolean;
    procedure ScanTopBtnClick(Sender: TObject);
    procedure mnuShowReportClick(Sender: TObject);
    procedure mnuSelScanPathClick(Sender: TObject);
    procedure PCTopBtnClick(Sender: TObject);
    procedure OptionTopBtnClick(Sender: TObject);
    procedure mnuGoToTrayClick(Sender: TObject);
    procedure mnuPCShowClick(Sender: TObject);
    procedure mnuPCRunClick(Sender: TObject);
    procedure mnuPCPauseClick(Sender: TObject);
    procedure mnuPCStopClick(Sender: TObject);
    procedure TrayMenuPopup(Sender: TObject);
    procedure ScanMenuPopup(Sender: TObject);
    procedure mnuScanStartClick(Sender: TObject);
    procedure mnuStopScanClick(Sender: TObject);
    procedure mnuSaveReportClick(Sender: TObject);
    procedure CopyRightLabelClick(Sender: TObject);
    Procedure CreateTray;
  protected
    procedure MineRestore(var Msg: TMessage); message WM_MINERESTORE;
    procedure SendScanning(var Msg: TMessage); message WM_COPYDATA;
  private
    Procedure WMSysCommand(var message: TWMSysCommand); message WM_SysCommand;
    procedure WMTRAYICONNOTIFY(var Msg: TMessage); message WM_NOTIFYTRAYICON;
    { Private declarations }
  public
    FileCN        : Integer;
    FileInfected  : Integer;
    FileIgnored   : Integer;
    FileDVC       : integer;

    MonFileCN        : Integer;
    MonFileInfected  : Integer;

    Path          : TStringList;
    DeActiveTray  : Boolean;

//****************************************************************************//

        AiDMonitor      : String;
        AiDInit         : String;
        LoadAPI         : String;
        LoadDB          : String;
        CreateDrvList   : String;
        OptFileNotFnd   : String;
        LoadOptFile     : String;
        InitProcedures  : String;
        initShield      : String;
        ErrorInit       : String;
        LogBevel        : String;
        DBKnowledge     : String;
        SCNOBJ          : String;
        ScanExecute     : String;
        ScanEnd         : String;
        PrepareToScan   : String;
        FileIgnor       : String;
        FileIfect       : String;
        FileScanned     : String;
        DataScanned     : String;
        IGNORED         : String;
        SKIPBYSIZE      : String;
        INFECTED        : String;
        STOPB           : String;
        RETURNB         : String;
        SCANB           : String;
        SCNFILE         : String;
        FileDel         : String;
        FileNotDel      : String;
        PATHNOSEL       : String;
        SysMenu         : String;
        NfoAiDScanner   : String;
        NfoAiDKernel    : String;
        NfoAiDBuild     : String;
        DelDialog       : String;
        DelAllDialog    : String;
        DelError        : String;
        HelpNOFound     : String;
        avShieldMes     : String;
        avError         : String;
        DelResult       : String;
        AllInfected     : String;
        DeleteInfected  : String;
        SkippedInfected : String;
        AiDCloseDlg     : String;
        AllreadyInScan  : String;
        ProcControlSt   : String;
        ErrorKillProc   : String;
        PCActive        : String;
        PCPaused        : String;
        PCStoped        : String;
        PCInit          : String;
        PCPause         : String;
        PCStop          : String;
        PCRestore       : String;
        LASTDBDATA      : String;
        DATABASEdate    : String;
        BASELOADED      : String;
        DBerrorI1       : String;
        DBerrorI2       : String;
        DBerrorI3       : String;

        MLoad           : String;
        MunLoad         : String;
        
  end;

//****************************************************************************//

resourcestring
  Return          = #13#10;
  AiDScannerCapt  = 'AiD Scanner';
  AiDScannerVS    = 'v3.4.3';
var
  MainForm      : TMainForm;
  inScan        : Boolean = False;
  NeedToReturn  : Boolean = False;
  FirstRun      : Boolean = True;
  P             : TPoint;
  MayClose      : boolean=false;
implementation

uses uSelInfo, uOptions, uAddPath, AboutFrm, Math, uMessage, uHideForm,
  uMonitor, uInfectedAction, uPluginInfo;
{$R *.dfm}

//****************************************************************************//

Procedure TMainForm.WMSysCommand(var message: TWMSysCommand);
begin
  If message.CmdType = SC_MINIMIZE then mnuHideAiDScanner.Click
  Else Inherited;
End;

//****************************************************************************//

procedure TMainForm.SendScanning;
var
  pcd: PCopyDataStruct;
begin
  pcd := PCopyDataStruct(Msg.LParam);
  if not inScan then
  begin
    StartScan(PChar(pcd.lpData));
  end
  else begin
    MessageDlg(AllreadyInScan,mtError,[mbOK],0);
  end;
end;

procedure TMainForm.MineRestore(var Msg: TMessage);
begin
  if (Msg.Msg = WM_MINERESTORE) then
  begin
    mnuShowAiDScanner.Click;
  end;
end;

//****************************************************************************//

function TMainForm.BalloonTrayIcon(const Window: HWND; const IconID: Byte; const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle: String; const BalloonIconType: TBalloonIconType): Boolean;
  const
  aBalloonIconTypes : array[TBalloonIconType] of
                      Byte = (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR);
  var
  NID_50 : NotifyIconData_50;
begin
  if Not OptionsForm.SHOWBALOONHINT.Checked then Exit;
  FillChar(NID_50, SizeOf(NotifyIconData_50), 0);
  with NID_50 do begin
    cbSize := SizeOf(NotifyIconData_50);
    Wnd := Window;
    uID := IconID;
    uFlags := NIF_INFO;
    StrPCopy(szInfo, BalloonText);
    uTimeout := Timeout * 1000;
    StrPCopy(szInfoTitle, BalloonTitle);
    dwInfoFlags := aBalloonIconTypes[BalloonIconType];
  end;
  Result := Shell_NotifyIcon(NIM_MODIFY, @NID_50);
end;

procedure TMainForm.WMTRAYICONNOTIFY(var Msg: TMessage);
begin
  case Msg.LParam of
    WM_LBUTTONUP:
      begin
      if Not DeActiveTray then
        begin
          MayClose := False;
          GetCursorPos(p);
          MayClose:= false;
          DeActiveTray := False;
          showwindow(Application.handle, SW_SHOW);
          showwindow(MainForm.handle, SW_SHOW);
          Application.Restore;
        end
        else
        begin
          SetForegroundWindow(HideForm.Handle);
        end;
      end;
    WM_RBUTTONUP:
      begin
        if Not DeActiveTray then
        begin
          GetCursorPos(p);
          TrayMenu.Popup(P.X, P.Y);
        end;
      end;
  end;
end;

Procedure TMainForm.CreateTray;
  var
  tray: TNotifyIconData;
begin
  with tray do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := MainForm.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallBackMessage := WM_NOTIFYTRAYICON;
    hIcon :=  Application.Icon.Handle;
    szTip := 'AiD Scanner';
  end;
  Shell_NotifyIcon(NIM_ADD, Addr(tray));
end;

Procedure DestroyTray;
  var
  tray: TNotifyIconData;
begin
  with tray do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := MainForm.Handle;
    uID := 1;
  end;
  Shell_NotifyIcon(NIM_DELETE, Addr(tray));
end;

//****************************************************************************//

Function GetShortPathBC(lPath:string): string;
  var
  D,F,P: String;
  i    : integer;
begin
  D := lPath[1]+':\';
  F := ExtractFileName(lPath);
  ShowMessage(D+'..'+F);
end;

Function GETParam(Str: String): String;
  var
  TMP,Str1,Str2 : String;
  PS: integer;
begin
  Result := '';
  TMP := STR;
  if TMP <> '' then
  if pos('=',TMP) <> 0 then
  begin
    ps := pos('=',TMP);
    Str1 := Copy(TMP,0,ps-1);
    Str2 := Copy(TMP,ps+1,length(Tmp));
    Result := Str2;
  end;
end;

Function GETParamName(Str: String): String;
  var
  TMP,Str1,Str2 : String;
  PS: integer;
begin
  Result := '';
  TMP := STR;
  if TMP <> '' then
  if pos('=',TMP) <> 0 then
  begin
    ps := pos('=',TMP);
    Str1 := Copy(TMP,0,ps-1);
    Str2 := Copy(TMP,ps+1,length(Tmp));
    Result := Str1;
  end;
end;

//****************************************************************************//

Procedure LoadOptions;
  var
  i: integer;
begin
  LoadConfig_;
  OptionsForm.ModulesLOAD.Checked     := OPT_MODULES_LOAD;
  OptionsForm.DBPATH.Text             := OPT_DB_DIR;
  OptionsForm.MODULESPATH.Text        := OPT_MODULE_DIR;
  OptionsForm.USESHIELD.Checked       := OPT_USE_SHIELD;
  OptionsForm.SHIELDSILENT.Checked    := OPT_SILENT_SHIELD_MODE;
  OptionsForm.SCNSUBDIR.Checked       := OPT_SCAN_SUBDIR;
  OptionsForm.SCNHEX.Checked          := OPT_USE_HEX_MODE;
  OptionsForm.SCNCRC.Checked          := OPT_USE_CRC_MODE;
  OptionsForm.SCNBIT.Checked          := OPT_USE_BYTE_MODE;

  OptionsForm.SCNHEXINPOS.Checked     := OPT_USE_HEX_INPOS;
  OptionsForm.DisplayScnFiles.Checked := OPT_SEND_SCAN_FILE;

  OptionsForm.PathList.Clear;
  OptionsForm.ExtList.Clear;
  for i := 0 to AiDConfig.Count-1 do begin

    if GETParamName(AiDConfig[i]) = 'EXT' then
      with OptionsForm.ExtList.Items.Add do begin
        Caption := GetParam(AiDConfig[i]);
        ImageIndex := 3;
      end;
      if GETParamName(AiDConfig[i]) = 'SHOWBALOONHINT' then
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.SHOWBALOONHINT.Checked := False else
      OptionsForm.SHOWBALOONHINT.Checked := True;

      if GETParamName(AiDConfig[i]) = 'PROCCONTROLAUTOMODE' then
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.PCAutoLoad.Checked := False else
      OptionsForm.PCAutoLoad.Checked := True;
      
      if GETParamName(AiDConfig[i]) = 'PROCCONTROLAUTOKILL' then
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.PCAutoKill.Checked := False else
      OptionsForm.PCAutoKill.Checked := True;

      if GETParamName(AiDConfig[i]) = 'PROCCONTROLAUTOACTION' then
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.PCAutoAction.Checked := False else
      OptionsForm.PCAutoAction.Checked := True;

      if GETParamName(AiDConfig[i]) = 'PROCCONTROLDELINFECT' then
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.PCDelInfect.Checked := False else
      OptionsForm.PCDelInfect.Checked := True;

      if GETParamName(AiDConfig[i]) = 'PROCCONTROLSKIPINFECT' then 
      if GetParam(AiDConfig[i]) = 'OFF' then OptionsForm.PCSkipInfect.Checked := False else
      OptionsForm.PCSkipInfect.Checked := True;

      if GETParamName(AiDConfig[i]) = 'HIDETIP' then begin
      if GetParam(AiDConfig[i]) = 'OFF' then HideForm.ShowHideTip.Checked := False else
      HideForm.ShowHideTip.Checked := True;
      end;

      if GETParamName(AiDConfig[i]) = 'PATH' then begin
      with OptionsForm.PathList.Items.Add do begin
        Caption := GetParam(AiDConfig[i]);
        if DirectoryExists(Caption) then ImageIndex := 4 else ImageIndex := 5;
      end;
      end;

      if GETParamName(AiDConfig[i]) = 'AUTOSAVEREPORT' then
      if GetParam(AiDConfig[i]) = 'ON' then OptionsForm.AutoSaveReport.Checked := true else
      OptionsForm.AutoSaveReport.Checked := False;

      if GETParamName(AiDConfig[i]) = 'REGISTERSYSMENU' then
      if GetParam(AiDConfig[i]) = 'ON' then OptionsForm.RegisterSysMenu.Checked := true else
      OptionsForm.RegisterSysMenu.Checked := False;

      if GETParamName(AiDConfig[i]) = 'AUTORUN' then
      if GetParam(AiDConfig[i]) = 'ON' then OptionsForm.AUTORUN.Checked := true else
      OptionsForm.AUTORUN.Checked := False;

      if GETParamName(AiDConfig[i]) = 'AUTOHIDE' then
      if GetParam(AiDConfig[i]) = 'ON' then OptionsForm.AUTOHIDE.Checked := true else
      OptionsForm.AUTOHIDE.Checked := False;

      if GETParamName(AiDConfig[i]) = 'AUTOSAVEREPORTTO' then OptionsForm.ReportSavePath.Text := GETParam(AiDConfig[i]);
  end;
end;

function GetHDDSerial(ADisk : char): dword;
  var
  SerialNum : dword;
  a, b : dword;
  VolumeName : array [0..255] of char;
begin
  Result := 0;
  if GetVolumeInformation(PChar(ADisk + ':\'), VolumeName, SizeOf(VolumeName),
  @SerialNum, a, b, nil, 0) then
    Result := SerialNum;
end;

function TMainForm.CreateDrivesList(ListView: TListView): boolean;
  var
  Bufer : array[0..1024] of char;
  RealLen, i : integer;
  S : string;
begin
  ListView.Clear;
  RealLen := GetLogicalDriveStrings(SizeOf(Bufer),Bufer);
  i := 0; S := '';
  while i < RealLen do begin
    if Bufer[i] <> #0 then begin
      S := S + Bufer[i];
      inc(i);
    end else begin
      inc(i);
      with ListView.Items.Add do begin
        Caption := S;
        if GetDriveType(PChar(S)) = DRIVE_RAMDISK then ImageIndex := 3;
        if GetDriveType(PChar(S)) = DRIVE_FIXED then ImageIndex := 3;
        if GetDriveType(PChar(S)) = DRIVE_REMOTE then ImageIndex := 0;
        if GetDriveType(PChar(S)) = DRIVE_CDROM then ImageIndex := 1;
        if GetDriveType(PChar(S)) = DRIVE_REMOVABLE then ImageIndex := 2;
      end;
      S := '';
    end;
  end;

  For i := 0 to OptionsForm.PathList.Items.Count-1  do begin
    with ListView.Items.Add do begin
      Caption := OptionsForm.PathList.Items[i].Caption;
      ImageIndex := OptionsForm.PathList.Items.Item[i].ImageIndex;
    end;
  end;
  Result := ListView.items.Count > 0;
end;

procedure OnAddToLogStr(LogString: String; ID: integer);
  var
  TMP : String;
begin
  with MainForm.ScanList.Items.Add do begin
    if ID = -1 then
      Caption := LogString
    else begin
      Caption := FormatDateTime('[hh:mm:ss]',now) + ' ' + LogString;
      MainForm.ReportMemo.Lines.Add(Caption);
      if ID = 2 then begin
        TMP := LogString;
        system.Delete(Tmp,1,pos(']',Tmp)+1);
        SubItems.Add(TMP);
      end;
      ImageIndex := ID;
    end;
    ImageIndex := ID;
  end;
  SendMessage(MainForm.ScanList.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure AddToMonLogStr(LogString: String; ID: integer);
  var
  TMP : String;
begin
{ }
end;

//****************************************************************************//

procedure OnScanComplete;
  var
  ScanEndBalloonText: String;
  i: integer;
begin
  MainForm.ProgressBar.Max := 1;
  MainForm.ProgressBar.Position := MainForm.ProgressBar.Max;
  MainForm.ScanBTN.Caption := MainForm.RETURNB;
  NeedToReturn := True;
  inScan := False;
  MainForm.Path.Clear;

  for i := 0 to MainForm.PathList.Items.Count-1 do
    MainForm.PathList.Items.Item[i].Checked := false;

  MessageBeep(MB_ICONASTERISK);
  MainForm.SaveBTN.Enabled := true;
  MainForm.ScanFile.caption  := MainForm.ScanEnd;
  OnAddToLogStr('',-1);
  OnAddToLogStr(MainForm.ScanEnd,0);
  OnAddToLogStr('',-1);
  OnAddToLogStr(MainForm.FileScanned+inttostr(MainForm.FileCN),0);
  OnAddToLogStr(MainForm.FileIgnor+inttostr(MainForm.FileIgnored),0);
  OnAddToLogStr(MainForm.FileIfect+inttostr(MainForm.FileInfected),0);
  OnAddToLogStr(MainForm.DataScanned+Format('%.2f',[ScannedDataSize / 1024 / 1024])+' Mb',0);
  MainForm.ReportMemo.Lines.Add(MainForm.LogBevel);
  if OptionsForm.AutoSaveReport.Checked then begin
    MainForm.ReportMemo.Lines.SaveToFile(OptionsForm.ReportSavePath.Text);
  end;

  ScanEndBalloonText := MainForm.ScanEnd + ':' + Return + Return
                       +' >> '+MainForm.FileScanned+inttostr(MainForm.FileCN) + Return
                       +' >> '+MainForm.FileIgnor+inttostr(MainForm.FileIgnored) + Return
                       +' >> '+MainForm.FileIfect+inttostr(MainForm.FileInfected) + Return
                       +' >> '+MainForm.DataScanned+Format('%.2f',[ScannedDataSize / 1024 / 1024])+' Mb';

  MainForm.BalloonTrayIcon(MainForm.Handle ,1,10,ScanEndBalloonText,'AiD Scanner',bitInfo);
end;

//****************************************************************************//

Procedure OnScanStart;
  var
  i: integer;
begin
  MainForm.FileDVC := 0;
  MainForm.ProgressBar.Position := 0;
  MainForm.ProgressBar.Max := 0;
  
  ClearExtList;
  for i := 0 to OptionsForm.ExtList.Items.Count-1 do begin
    AddToExtList(ExtractFileExt(OptionsForm.ExtList.Items.Item[i].Caption));
  end;

  MainForm.ScanBTN.Caption := MainForm.STOPB;
  MainForm.SaveBTN.Enabled := False;
  MainForm.ScanList.Clear;
  MainForm.ScanningTab.Show;
  MainForm.FileCN       := 0;
  MainForm.FileInfected := 0;
  MainForm.FileIgnored  := 0;
  inScan := True;
  NeedToReturn := False;
  OnAddToLogStr(MainForm.ScanExecute,0);
  if AiDScanner.AvAction = TScanDir then
  else
  OnAddToLogStr(MainForm.SCNOBJ+AiDScanner.FileName,0);
  OnAddToLogStr('',-1);
  MainForm.BalloonTrayIcon(MainForm.Handle ,1,10,MainForm.ScanExecute,'AiD Scanner',bitInfo);
  AiDScanner.Resume;
end;

//****************************************************************************//

Procedure AiDKernelMessageAPI(MES: Integer; const Pr_0: Integer = 0; Pr_1: String = ''; Pr_2: String = '');
begin

  if MES = MES_NONE then Exit;

  if mes = MES_LOCKINPUT then
  begin
    MainForm.ProgressBar.Enabled := False;
    MainForm.ScanBTN.Enabled := False;
  end;

  if mes = MES_UNLOCKINPUT then
  begin
    MainForm.ProgressBar.Position := 0;
    MainForm.ProgressBar.Enabled := True;
    MainForm.ScanBTN.Enabled := True;
  end;

  if MES = MES_SCANMAXPROGRESS then begin
    MainForm.FileDVC := mainForm.FileCN;
    MainForm.ProgressBar.Max := Pr_0-MainForm.FileDVC;
  end;

  if MES = MES_PREPARINGTOSCAN then MainForm.ScanFile.Caption := MainForm.PrepareToScan;

  if mes = MES_INITKERNEL then OnAddToLogStr(MainForm.AiDInit,0);

  if mes = MES_INITAPI then OnAddToLogStr(MainForm.LoadAPI,0);

  if mes = MES_LOADBASES then OnAddToLogStr(MainForm.LoadDB,0);

  if mes = MES_LOADCONFIG then OnAddToLogStr(MainForm.LoadOptFile,0);

  if mes = MES_INITSHIELD then OnAddToLogStr(MainForm.initShield,0);

  if mes = MES_ERRORONINIT then OnAddToLogStr(MainForm.ErrorInit,2);

  if MES = MES_LOADDBDATE then begin
    MainForm.ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+MainForm.BASELOADED+ ExtractFileName(Pr_1)+' ('+MainForm.DATABASEdate+_ConvertDate(Pr_2)+')');
  end;

  if MES = MES_ERROR then begin
    MainForm.ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+MainForm.avError);
  end;

  if MES = MES_ONSCANEXECUTE then
    OnScanStart;

  if MES = MES_ONSCANCOMPLETE then
    OnScanComplete;

  if MES = MES_ONPROGRESS then begin
    if MainForm.ProgressBar.Enabled then begin
      MainForm.FileCN := MainForm.FileCN + 1;
      if MainForm.ProgressBar.Max > 0 then
        MainForm.ProgressBar.Position := MainForm.FileCN-MainForm.FileDVC;
      MainForm.ScanFile.caption  := '['+inttostr(MainForm.FileCN)+'] '+ExtractFileName(Pr_1);
    end
    else
      MainForm.ScanFile.caption  := ExtractFileName(Pr_1);
    if OPT_SEND_SCAN_FILE then MainForm.ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+MainForm.SCNFILE + Pr_1);
  end;

  if MES = MES_ONVIRFOUND then begin
    OnAddToLogStr('['+MainForm.INFECTED+' - '+Pr_2+'] '+Pr_1,2);
    MainForm.FileInfected := MainForm.FileInfected + 1;
    MainForm.BalloonTrayIcon(MainForm.Handle ,1,10,Pr_1 ,'['+MainForm.INFECTED+' - '+Pr_2+'] ',bitError);
  end;

  if MES = MES_ONREADERROR then begin
    OnAddToLogStr('['+MainForm.IGNORED+'] '+Pr_1,1);
    MainForm.FileIgnored  := MainForm.FileIgnored + 1;
  end;

  if MES = MES_SKIPBYSIZE then begin
    OnAddToLogStr('['+MainForm.SKIPBYSIZE+'] '+Pr_1,1);
    MainForm.FileIgnored  := MainForm.FileIgnored + 1;
  end;

  if MES = MES_ADDTOLOG then begin
    OnAddToLogStr(Pr_1,Pr_0);
  end;

  if MES = MES_SHIELD_INFECT then begin
    MessageFrm.Caption := 'avShield Messsage';
    MessageFrm.InformationLabel.Caption := 'avShield Messsage';
    MessageFrm.InfoLabel.Caption := 'Warning!';
    MessageFrm.Memo1.Text := MainForm.avShieldMes;
  end;

end;

//****************************************************************************//

procedure TMainForm.InitScannerKernel;
  var
  i:integer;
begin

//****************************************************************************//
        AiDMonitor      := SOURCESTRING.Items[0];
        AiDInit         := SOURCESTRING.Items[1];
        LoadAPI         := SOURCESTRING.Items[2];
        LoadDB          := SOURCESTRING.Items[3];
        CreateDrvList   := SOURCESTRING.Items[4];
        OptFileNotFnd   := SOURCESTRING.Items[5];
        LoadOptFile     := SOURCESTRING.Items[6];
        InitProcedures  := SOURCESTRING.Items[7];
        initShield      := SOURCESTRING.Items[8];
        ErrorInit       := SOURCESTRING.Items[9];
        LogBevel        := SOURCESTRING.Items[10];
        DBKnowledge     := SOURCESTRING.Items[11];
        SCNOBJ          := SOURCESTRING.Items[12];
        ScanExecute     := SOURCESTRING.Items[13];
        ScanEnd         := SOURCESTRING.Items[14];
        PrepareToScan   := SOURCESTRING.Items[15];
        FileIgnor       := SOURCESTRING.Items[16];
        FileIfect       := SOURCESTRING.Items[17];
        FileScanned     := SOURCESTRING.Items[18];
        DataScanned     := SOURCESTRING.Items[19];
        IGNORED         := SOURCESTRING.Items[20];
        SKIPBYSIZE      := SOURCESTRING.Items[21];
        INFECTED        := SOURCESTRING.Items[22];
        STOPB           := SOURCESTRING.Items[23];
        RETURNB         := SOURCESTRING.Items[24];
        SCANB           := SOURCESTRING.Items[25];
        SCNFILE         := SOURCESTRING.Items[26];
        FileDel         := SOURCESTRING.Items[27];
        FileNotDel      := SOURCESTRING.Items[28];
        PATHNOSEL       := SOURCESTRING.Items[29];
        SysMenu         := SOURCESTRING.Items[30];
        NfoAiDScanner   := SOURCESTRING.Items[31];
        NfoAiDKernel    := SOURCESTRING.Items[32];
        NfoAiDBuild     := SOURCESTRING.Items[33];
        DelDialog       := SOURCESTRING.Items[34];
        DelAllDialog    := SOURCESTRING.Items[35];
        DelError        := SOURCESTRING.Items[36];
        HelpNOFound     := SOURCESTRING.Items[37];
        avShieldMes     := SOURCESTRING.Items[38];
        avError         := SOURCESTRING.Items[39];
        DelResult			  := SOURCESTRING.Items[40];
        AllInfected     := SOURCESTRING.Items[41];
        DeleteInfected  := SOURCESTRING.Items[42];
        SkippedInfected := SOURCESTRING.Items[43];
        AiDCloseDlg     := SOURCESTRING.Items[44];
        AllreadyInScan  := SOURCESTRING.Items[45];
        ProcControlSt   := SOURCESTRING.Items[46];
        ErrorKillProc   := SOURCESTRING.Items[47];
        PCActive        := SOURCESTRING.Items[48];
        PCPaused        := SOURCESTRING.Items[49];
        PCStoped        := SOURCESTRING.Items[50];
        PCInit          := SOURCESTRING.Items[51];
        PCPause         := SOURCESTRING.Items[52];
        PCStop          := SOURCESTRING.Items[53];
        PCRestore       := SOURCESTRING.Items[54];
        LASTDBDATA      := SOURCESTRING.Items[55];
        DATABASEdate    := SOURCESTRING.Items[56];
        BASELOADED      := SOURCESTRING.Items[57];
        DBerrorI1       := SOURCESTRING.Items[58];
        DBerrorI2       := SOURCESTRING.Items[59];
        DBerrorI3       := SOURCESTRING.Items[60];

        MLoad           := SOURCESTRING.Items[61];
        MunLoad         := SOURCESTRING.Items[62];

        InitKernel(AiDKernelMessageAPI);
        LoadOptions;

//****************************************************************************//

  CreateDrivesList(PathList);

  for i := 0 to GetPluginAPICount do
    with OptionsForm.APIList.Items.Add do
      begin
        Caption := GetPluginAPIName(i) + ' ('+ExtractFileName(GetPluginAPIPath(i))+')';
        SubItems.Add(GetPluginAPIAutor(i));
        SubItems.Add(GetPluginAPIInfo(i));
        SubItems.Add(GetPluginAPIPath(i));
      end;

  ReportMemo.Lines.Add('');
  ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+NfoAiDScanner +AiDScannerVS);
  ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+NfoAiDKernel +GetKernelVersion);
  ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+NfoAiDBuild +GetKernelBuild);
  ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+DBKnowledge+IntToStr(GetDBRecCount));

  if GetDBVersionDate = '01.01.1880' then
    ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+LASTDBDATA+'0')
  else
    ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+' '+LASTDBDATA+GetDBVersionDate);

  ReportMemo.Lines.Add(LogBevel);
  ReportMemo.Lines.Add('');

  if OptionsForm.RegisterSysMenu.Checked then begin
    OptionsForm.FileTAddAction('*','AiD.Scan',SysMenu,ParamStr(0)+' %1');
    OptionsForm.FileTAddAction('Directory','AiD.Scan',SysMenu,ParamStr(0)+' %1');
    OptionsForm.FileTAddAction('Drive','AiD.Scan',SysMenu,ParamStr(0)+' %1');
  end else
  begin
    OptionsForm.FileTDelAction('Drive','AiD.Scan');
    OptionsForm.FileTDelAction('Directory','AiD.Scan');
    OptionsForm.FileTDelAction('*','AiD.Scan');
  end;
end;

//****************************************************************************//

Procedure TMainForm.StartScan(Parametr: String);
  var
  T : String;
begin
  if GetDBRecCount = 0 then
  begin
    MessageFrm.Caption := DBerrorI1;
    MessageFrm.InformationLabel.Caption := DBerrorI1;
    MessageFrm.InfoLabel.Caption := DBerrorI2;
    MessageFrm.Memo1.Text := DBerrorI3;
    MessageFrm.ShowModal;
    Exit;
  end;

  if Parametr = 'DRV' then
  begin
    AiDScanner := TAvScanner.Create(true);
    AiDScanner.NeedForAPI := TRUE;
    AiDScanner.AvAction   := TScanDir;
    Path.Add(ExtractFileDrive(Paramstr(0))+'\');
    AiDScanner.Dirs       := Path;
    OnScanStart;
    exit;
  end;

  if DirectoryExists(Parametr+'\') then
  begin
    AiDScanner := TAvScanner.Create(true);
    AiDScanner.NeedForAPI := TRUE;
    AiDScanner.AvAction   := TScanDir;
    Path.Add(Parametr+'\');
    AiDScanner.Dirs       := Path;
    OnScanStart;
    exit;
  end;

  if FileExists(Parametr) then
  begin
    AiDScanner := TAvScanner.Create(true);
    AiDScanner.NeedForAPI := false;
    AiDScanner.AvAction := TScanFile;
    AiDScanner.FileName := Parametr;
    OnScanStart;
    exit;
  end;

end;

procedure TMainForm.ExitBTNClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ScanListDblClick(Sender: TObject);
begin
  if ScanList.ItemIndex <> -1 then
  begin
    InformationForm.InfoMemo.Text := ScanList.Selected.Caption;
    InformationForm.ShowModal;
  end;
end;

procedure TMainForm.ScanBTNClick(Sender: TObject);
  var
  i: integer;
  err: boolean;
begin
  err:= false;
  
  for i := 0 to PathList.Items.Count-1 do
  begin
    if PathList.Items.Item[i].Checked then
    begin
      Path.Add(PathList.Items.Item[i].Caption);
      if not DirectoryExists(PathList.Items.Item[i].Caption+'\') then
        begin
          MessageDlg(PATHNOSEL,mtError,[mbOk],0);
          Exit;
        end;
    end;
  end;

  if GetDBRecCount = 0 then
  begin
    MessageFrm.Caption := DBerrorI1;
    MessageFrm.InformationLabel.Caption := DBerrorI1;
    MessageFrm.InfoLabel.Caption        := DBerrorI2;
    MessageFrm.Memo1.Text               := DBerrorI3;
    MessageFrm.ShowModal;
    Exit;
  end;

  if NeedToReturn = false then
  begin
    if inScan = False then
    begin
      if PATH.Count-1 <> -1 then
      begin
        AiDScanner := TAvScanner.Create(true);
        AiDScanner.FreeOnTerminate := True;
        AiDScanner.NeedForAPI      := true;
        AiDScanner.AvAction        := TScanDir;
        AiDScanner.Dirs            := MainForm.Path;
        OnScanStart;
      end
      else begin
        MessageDlg(PATHNOSEL,mtError,[mbOk],0);
      end;
    end
    else begin
      CloseScanThread;
    end;
  end else
  begin
    ScanBTN.Caption := ScanB;
    MainForm.SaveBTN.Enabled := False;
    NeedToReturn := False;
    ScanPathesTab.Show;
  end;
end;

procedure TMainForm.SaveBTNClick(Sender: TObject);
  var
  Report: TStringList;
  i: integer;
begin
  if SaveDialog.Execute then
  begin
    Report:= TStringList.Create;
    For i := 0 to ScanList.Items.Count-1 do
      Report.Add(ScanList.Items.Item[i].Caption);
    Report.SaveToFile(SaveDialog.FileName);
    Report.Free;
  end;
end;

procedure TMainForm.DeletePathClick(Sender: TObject);
begin
  try
    if PathList.ItemIndex <> -1 then
      if PathList.Selected.ImageIndex > 3 then
      begin
        OptionsForm.PathList.Items.Delete(PathList.Selected.Index-((PathList.Items.Count-1) - (OptionsForm.PathList.items.count-1)));
        PathList.Items.Delete(PathList.Selected.Index);
      end;
    OptionsForm.SaveOptions;
  except
  end;
end;

procedure TMainForm.RefteshClick(Sender: TObject);
begin
  CreateDrivesList(PathList);
end;

procedure TMainForm.AddFolderClick(Sender: TObject);
begin
  AddUserPathForm.ShowModal;
end;

procedure TMainForm.AboutBTNClick(Sender: TObject);
begin
  AboutForm.Label1.Caption  := AiDScannerVS;
  AboutForm.Label11.Caption := NfoAiDScanner+AiDScannerVS;
  AboutForm.Label13.Caption := NfoAiDKernel+GetKernelVersion;
  AboutForm.Label14.Caption := NfoAiDBuild+GetKernelBuild;
  AboutForm.Label15.Caption := DBKnowledge+IntToStr(GetDBRecCount);

  if GetDBVersionDate = '01.01.1880' then
    AboutForm.Label4.Caption  := LASTDBDATA+'0' else
    AboutForm.Label4.Caption  := LASTDBDATA+GetDBVersionDate;

  AboutForm.ShowModal;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  VersionLabel.Caption := AiDScannerVS;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageDlg(AiDCloseDlg,mtInformation,[mbYes]+[mbNo],0) = 6 then begin
    if OptionsForm.AutoSaveReport.Checked then begin
      MainForm.ReportMemo.Lines.SaveToFile(OptionsForm.ReportSavePath.Text);
    end;
  end else Action := caNone;
end;

procedure TMainForm.HelpBTNClick(Sender: TObject);
begin
  if FileExists(ExtractFilePath(paramstr(0))+'\Help.chm') then
    ShellExecute(0,'',PChar(ExtractFilePath(paramstr(0))+'\Help.chm'),nil,nil,1)
  else
    MessageDlg(HelpNOFound,mtError,[mbOk],0);
end;

procedure TMainForm.DelMenuPopup(Sender: TObject);
begin
  if (ScanList.ItemIndex <> -1) and (ScanList.Selected.ImageIndex = 2) and (inScan = False) then
  begin
    Del.Visible := true;
  end
  else
    Del.Visible := False;

  if (ScanList.ItemIndex <> -1) and (inScan = False) then
    DelAll.Visible := true
  else
    DelAll.Visible := false;
end;

procedure TMainForm.DelAllClick(Sender: TObject);
  var
	i,d,e,c: integer;
begin
  d:=0;
  e:=0;
  c:=0;
  if MessageDlg(DelAllDialog,mtInformation,[mbCancel]+[mbYes],0) = 6 then
  begin
	  for i := 0 to ScanList.Items.Count - 1 do
   	  if ScanList.Items.Item[i].ImageIndex = 2 then
      begin
      	c:=c+1;
			  try
			  	if DeleteFileBC(ScanList.Items.Item[i].SubItems[0]) then
          begin
            d:=d+1;
     				ScanList.Items.Item[i].ImageIndex := 4;
     				ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+FileDel+ScanList.Items.Item[i].SubItems[0]);
          end
  				else begin
     				ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+FileNotDel+ScanList.Items.Item[i].SubItems[0]);
            e:=e+1;
  				end;
			  except
			  end;
   end;

  MessageDlg(DelResult + Return
			                 + Return
		                   + AllInfected + IntToStr(c) + Return
                       + DeleteInfected + IntToStr(d) + Return
                       + SkippedInfected + IntToStr(e),mtInformation,[mbOK],0);
  end;
end;

procedure TMainForm.DelClick(Sender: TObject);
begin
  if MessageDlg(DelDialog,mtInformation,[mbCancel]+[mbYes],0) = 6 then
  begin
  try
    if DeleteFileBC(ScanList.Selected.SubItems[0]) then
    begin
      ScanList.Selected.ImageIndex := 4;
      ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+FileDel+ScanList.Selected.SubItems[0]);
    end
    else begin
      ReportMemo.Lines.Add(FormatDateTime('[hh:mm:ss]',now)+FileNotDel+ScanList.Selected.SubItems[0]);
      MessageDlg(DelError,mtWarning,[mbOk],0);
    end;
  except
  end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Path := TStringList.Create;
  TopPn.ControlStyle            := ControlStyle + [csOpaque];
  TopRightPanel.ControlStyle    := ControlStyle + [csOpaque];
  Caption                       := AiDScannerCapt;
  TopPn.DoubleBuffered 			    := true;
  TopRightPanel.DoubleBuffered 	:= true;
  PathList.DoubleBuffered 		  := true;
  ScanList.DoubleBuffered 		  := true;
  BottomPanel.DoubleBuffered 	  := true;
  MonFileCN                     := 0;
  MonFileInfected               := 0;
end;

procedure TMainForm.AppMinimize(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyTray;
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  showwindow(Application.handle, SW_HIDE);
  showwindow(MainForm.handle, SW_HIDE);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  PathList.Columns.Items[0].Width := PathList.Width - 25;
  ScanList.Columns.Items[0].Width := ScanList.Width - 25;
end;

procedure TMainForm.mnuHideAiDScannerClick(Sender: TObject);
begin
  DeActiveTray := True;
  MayClose := True;
  showwindow(Application.handle, SW_HIDE);
  showwindow(MainForm.handle, SW_HIDE);
  if not HideForm.ShowHideTip.Checked then
  begin
    HideForm.Show;
    SetForegroundWindow(HideForm.Handle);
    Application.BringToFront;
  end else DeActiveTray := False;
end;

procedure TMainForm.mnuShowAiDScannerClick(Sender: TObject);
begin
  DeActiveTray := False;
  showwindow(Application.handle, SW_SHOW);
  showwindow(MainForm.handle, SW_SHOW);
  Application.Restore;
  MayClose := False;
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.mnuOptionsClick(Sender: TObject);
begin
  if not inScan then begin
    LoadOptions;
    OptionsForm.Show;
  end;
end;

procedure TMainForm.mnuHelpClick(Sender: TObject);
begin
  if FileExists(ExtractFilePath(paramstr(0))+'\Help.chm') then
    ShellExecute(0,'',PChar(ExtractFilePath(paramstr(0))+'\Help.chm'),nil,nil,1)
  else
    MessageDlg(HelpNOFound,mtError,[mbOk],0);
end;

procedure TMainForm.mnuAboutClick(Sender: TObject);
begin
  AboutForm.Label1.Caption  := AiDScannerVS;
  AboutForm.Label11.Caption := NfoAiDScanner+AiDScannerVS;
  AboutForm.Label13.Caption := NfoAiDKernel+GetKernelVersion;
  AboutForm.Label14.Caption := NfoAiDBuild+GetKernelBuild;
  AboutForm.Label15.Caption := DBKnowledge+IntToStr(GetDBRecCount);
  if GetDBVersionDate = '01.01.1880' then
    AboutForm.Label4.Caption  := LASTDBDATA+'0' else
    AboutForm.Label4.Caption  := LASTDBDATA+GetDBVersionDate;
  try
    AboutForm.ShowModal;
  except
  end;
end;

procedure TMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  mnuHideAiDScanner.Click;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if FirstRun then
    if OptionsForm.AUTOHIDE.Checked then
    begin
      mnuHideAiDScanner.Click;
    end;
  FirstRun := false;
end;

procedure TMainForm.ScanListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with ScanList.Canvas.Brush do
  begin
    case Item.ImageIndex of
      0: Color := $00FFF1EC;
      2: Color := $00ECECFF;
      1: Color := $00ECFBFF;
      4: Color := $00EDFFEC;
    end;
  end;
end;

procedure TMainForm.ScanTopBtnClick(Sender: TObject);
begin
  ScanMenu.Popup(MainForm.Left+ScanTopBtn.Left+3,MainForm.Top+ScanTopBtn.Top+38);
end;

procedure TMainForm.mnuShowReportClick(Sender: TObject);
begin
  if not inScan then
    ReportTab.Show;
end;

procedure TMainForm.mnuSelScanPathClick(Sender: TObject);
begin
  if not inScan then
    ScanPathesTab.Show;
end;

procedure TMainForm.PCTopBtnClick(Sender: TObject);
begin
  MonitorForm.Show;
end;

procedure TMainForm.OptionTopBtnClick(Sender: TObject);
begin
  if not inScan then begin
    LoadOptions;
    OptionsForm.ShowModal;
  end;
end;

procedure TMainForm.mnuGoToTrayClick(Sender: TObject);
begin
  mnuHideAiDScanner.Click;
end;

procedure TMainForm.mnuPCShowClick(Sender: TObject);
begin
  MonitorForm.Show;
end;

procedure TMainForm.mnuPCRunClick(Sender: TObject);
begin
  MonitorForm.StartPC.Click;
end;

procedure TMainForm.mnuPCPauseClick(Sender: TObject);
begin
  MonitorForm.PausePC.Click;
end;

procedure TMainForm.mnuPCStopClick(Sender: TObject);
begin
  MonitorForm.StopPC.Click;
end;

procedure TMainForm.TrayMenuPopup(Sender: TObject);
begin
  mnuPCRun.Enabled := MonitorForm.StartPC.Enabled;
  mnuPCPause.Enabled := MonitorForm.PausePC.Enabled;
  mnuPCStop.Enabled := MonitorForm.StopPC.Enabled;
  if inScan then mnuOptions.Enabled := False else mnuOptions.Enabled := True;
end;

procedure TMainForm.ScanMenuPopup(Sender: TObject);
begin
  mnuPCRun.Enabled := MonitorForm.StartPC.Enabled;
  mnuPCPause.Enabled := MonitorForm.PausePC.Enabled;
  mnuPCStop.Enabled := MonitorForm.StopPC.Enabled;
  mnuSaveReport.Enabled := SaveBTN.Enabled;
  if inScan then mnuScanStart.Enabled := False else mnuScanStart.Enabled := True;
  if inScan then mnuStopScan.Enabled := True else mnuStopScan.Enabled := False;
end;

procedure TMainForm.mnuScanStartClick(Sender: TObject);
begin
  ScanBTN.Click;
end;

procedure TMainForm.mnuStopScanClick(Sender: TObject);
begin
  ScanBTN.Click;
end;

procedure TMainForm.mnuSaveReportClick(Sender: TObject);
begin
  SaveBTN.Click;
end;

procedure TMainForm.CopyRightLabelClick(Sender: TObject);
  Const 
  URL : String = 'http://www.bit-lab.info';
begin
  ShellExecute(0,'',pChar(''+URL),NIL,NIL,SW_SHOWNORMAL);
end;

end.
