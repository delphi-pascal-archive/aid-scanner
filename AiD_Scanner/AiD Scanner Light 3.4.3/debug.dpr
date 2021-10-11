program debug;

uses
  Forms,
  SysUtils,
  avKernel in '..\AiD Scanner Modues\avKernel.pas',
  avTypes in '..\AiD Scanner Modues\avTypes.pas',
  avMonitor in '..\AiD Scanner Modues\avMonitor.pas',
  avScanner in '..\AiD Scanner Modues\avScanner.pas',
  avHex in '..\AiD Scanner Modues\avHex.pas',
  avDataBase in '..\AiD Scanner Modues\avDataBase.pas',
  avHash in '..\AiD Scanner Modues\avHash.pas',
  avExt in '..\AiD Scanner Modues\avExt.pas',
  avAPI in '..\AiD Scanner Modues\avAPI.pas',
  avConfig in '..\AiD Scanner Modues\avConfig.pas',
  avShield in '..\AiD Scanner Modues\avShield.pas',
  langs in 'langs.pas',
  uMain in 'uMain.pas' {MainForm},
  uSelInfo in 'uSelInfo.pas' {InformationForm},
  uOptions in 'uOptions.pas' {OptionsForm},
  uPluginInfo in 'uPluginInfo.pas' {PluginAPIForm},
  uAddPath in 'uAddPath.pas' {AddUserPathForm},
  AboutFrm in 'AboutFrm.pas' {AboutForm},
  uSelDir in 'uSelDir.pas' {SelDirFrm},
  uMessage in 'uMessage.pas' {MessageFrm},
  uHideForm in 'uHideForm.pas' {HideForm},
  uMonitor in 'uMonitor.pas' {MonitorForm},
  uInfectedAction in 'uInfectedAction.pas' {ActionForm},
  uSplash in 'uSplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AiD Scanner';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInformationForm, InformationForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TPluginAPIForm, PluginAPIForm);
  Application.CreateForm(TAddUserPathForm, AddUserPathForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TSelDirFrm, SelDirFrm);
  Application.CreateForm(TMessageFrm, MessageFrm);
  Application.CreateForm(THideForm, HideForm);
  Application.CreateForm(TMonitorForm, MonitorForm);
  Application.CreateForm(TActionForm, ActionForm);
  Application.CreateForm(TSplashForm, SplashForm);
  {Show Splash form}
  SplashForm.CRLabel.Caption   := 'AiD Kernel '+GetKernelVersion;
  SplashForm.CRLabel00.Caption := 'AiD Build ' +GetKernelBuild;
  SplashForm.Show;
  {}
  Init;
  //Load default Language:
  langs.SwitchAllFormsToLng(01,01,ExtractFilePath(Paramstr(0))+'default.lng');
  {init kernel}
  MainForm.InitScannerKernel;
  {Hide Splash Form}
  SplashForm.Hide;
  Sleep(200);
  {Create Tray Icon}
  MainForm.CreateTray;
  {}
  if OptionsForm.AUTORUN.Checked then begin
    OptionsForm.ChangeReg('AiDScanner',False);
  end else begin
    OptionsForm.ChangeReg('AiDScanner',True);
  end;
  {}
  if ParamStr(1) <> '' then
  MainForm.StartScan(ParamStr(1));
  {}
  if OptionsForm.PCAutoLoad.Checked then begin
    MonitorForm.StartMonitor;
  end;
  {}
  Application.Run;
end.
