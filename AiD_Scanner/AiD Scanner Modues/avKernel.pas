////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//               avKernel  Unit               //
////////////////////////////////////////////////
//                                            //
//   bit-lab © 2008. All Right reserved       //
//                                            //
////////////////////////////////////////////////
//                                            //
//   Autor: DoGeR                             //
//   email: BlackCash2006@Yandex.ru           //
//          DoGeR@bit-lab.info                //
//                                            //
////////////////////////////////////////////////
unit avKernel;

Interface

uses Windows, SysUtils, Classes, avTypes, avScanner, avDataBase, avExt, avAPI,
     avConfig, avShield, avMonitor;

type
  TAvScanner = class(TThread)
  private
  protected
    procedure Execute; override;
    Procedure AvScanFile;
    Procedure AvScanDir;
  public
    FileName, DirName  : String;
    Dirs               : TStringList;
    NeedForAPI         : Boolean;
    AvAction           : TAvAction;
  end;

  Function InitApiPlugin(ApiPlugIn: String): Boolean;
  Function GetDBRecCount: integer;
  Function GetPluginAPICount: integer;
  Function GetPluginAPIAutor(ID: integer): String;
  Function GetPluginAPIName(ID: integer): String;
  Function GetPluginAPIInfo(ID: integer): String;
  Function GetPluginAPIPath(ID: integer): String;
  Function GetKernelBuild: String;
  Function GetKernelVersion: String;
  Function GetDBVersionDate: String;
  function DeleteFileBC(FileName: String): boolean;
  Function _LoadModule(ModuleName: string): boolean;
  Function _UnLoadModule(ModuleName: string): boolean;
  Function _ScanFileEx(FileName: String): integer;
  function GetVirusName(ID: integer): String;
  function _ConvertDate(D: String): String;

  Procedure LoadApiPlugins(ApiPath: String);
  Procedure ClearExtList;
  Procedure InitExtList;
  Procedure FreeExtList;
  Procedure AddToExtList(Ext: String);
  Procedure LoadDataBases(DirName: String);
  Procedure InitApi;
  Procedure FreeApi;
  Procedure AddOtherParamString(Param: String);
  Procedure ClearOtherParamList;
  procedure SaveConfig_;
  procedure LoadConfig_;

  procedure CloseScanThread;
  
  Procedure InitKernel(AvKernelMessageAPI: TKernelMessageAPI);

  Procedure ScanDirForProgress; stdcall;

var
  AiDScanner : TAvScanner;

//****************************************************************************//

implementation

uses Math;

Procedure TAvScanner.AvScanFile;
begin
  ScanFile(FileName);
end;

Procedure ScanDirForProgress;
  var
  i : integer;
begin
  for i := 0 to AiDScanner.Dirs.Count-1 do
  begin
    ScanDirFor_Progress(AiDScanner.Dirs[i]);
    if ExitScn then Break;
  end;
  KernelMessageAPI(MES_SCANMAXPROGRESS,MaxProgress);
  ExitThread(0);
end;

Procedure TAvScanner.AvScanDir;
  var
  i,t,t1 : integer;
  h1     : Cardinal;
begin
  MaxProgress := 0;
  createthread(nil,128,@ScanDirForProgress,self,0,h1);
  for i := 0 to Dirs.Count-1 do
  begin
    ScanDir(Dirs[i]);
    if ExitScn then Break;
  end;
end;

Procedure TAvScanner.Execute;
var
  i : integer;
begin
  FreeOnTerminate := True;
  ExitScn := False;
  ScannedDataSize := 0;
  KernelMessageAPI(MES_PREPARINGTOSCAN);
  if NeedForAPI then
  if OPT_USE_MODULE_ATRUN then begin
    KernelMessageAPI(MES_LOCKINPUT);
    for i := 0 to ApiPlugins.Count-1 do begin
      ApiPlugin := ApiPlugins.Items[i];
      if ApiPlugin.ApiPlugType = API_SCANATRUN then ApiPlugin.APIPlugInitOnScan;
    end;
    KernelMessageAPI(MES_UNLOCKINPUT);
  end;
  if AvAction = TScanFile then AvScanFile;
  if AvAction = TScanDir  then AvScanDir;
  KernelMessageAPI(MES_ONSCANCOMPLETE);
  ExitScn := True;
end;

//****************************************************************************//

procedure CloseScanThread;
begin
  ExitFromScan;
end;

//****************************************************************************//

function GetVirusName(ID: integer): String;
begin
try
  Result := StreamDB.DBViruses[id].VirName;
except
end;
end;

//****************************************************************************//

Function GetKernelVersion: String;
begin
  Result := 'v1.2';
end;

Function GetKernelBuild: String;
begin
  Result := '20.04.2008';
end;

//****************************************************************************//

Procedure InitKernel(AvKernelMessageAPI: TKernelMessageAPI);
begin
	try
    KernelMessageAPI := AvKernelMessageAPI;
    KernelMessageAPI(MES_INITKERNEL);
    KernelMessageAPI(MES_INITEXTLIST);
    InitExtList;
    LoadConfig;
  	if OPT_DB_LOAD then
    begin
    	KernelMessageAPI(MES_LOADBASES);
    	LoadDataBases(OPT_DB_DIR);
  		if GetDBRecCount = 0 then KernelMessageAPI(MES_DBNIL);
        getSpeedesProcOfDataBase;
 		end
      else KernelMessageAPI(MES_DB_DONTLOAD);
    KernelMessageAPI(MES_INITAPI);
    InitApi;
  	if OPT_MODULES_LOAD then begin
    	KernelMessageAPI(MES_LOADMODULES);
    	LoadApi(OPT_MODULE_DIR);
  	end;
  	if OPT_USE_SHIELD then begin
    	KernelMessageAPI(MES_INITSHIELD);
    	StartShield(ParamStr(0));
  	end;
	except
   	if OPT_SEND_ERR_INIT then
   	KernelMessageAPI(MES_ERRORONINIT);
	end;
end;

//****************************************************************************//

Function _ScanFileEx(FileName: String): integer;
begin
  Result := ScanFileEx(FileName);
end;

//****************************************************************************//

Function _LoadModule(ModuleName: string): boolean;
begin
  Result := LoadPlugin(ModuleName);
end;

Function _UnLoadModule(ModuleName: string): boolean;
begin
  Result := UnLoadPlugin(ModuleName);
end;

Function InitApiPlugin(ApiPlugIn: String): Boolean;
begin
  try
  	LoadApiPlugin(ApiPlugIn);
  	Result := True;
  except
  	Result := False;
  end;
end;

Procedure LoadApiPlugins(ApiPath: String);
begin
  try
    LoadApi(ApiPath);
  except
  end;
end;

Procedure InitApi;
begin
  InitializeApiPlugin;
end;

Procedure FreeApi;
begin
  FreeApiPluginList;
end;

//****************************************************************************//

Function GetPluginAPICount: integer;
begin
  Result := ApiPlugins.Count-1;
end;

Function GetPluginAPIAutor(ID: integer): String;
begin
  ApiPlugin := ApiPlugins[ID];
  Result    := ApiPlugin.ApiPlugAutor;
end;

Function GetPluginAPIName(ID: integer): String;
begin
  ApiPlugin := ApiPlugins[ID];
  Result    := ApiPlugin.ApiPlugName;
end;

Function GetPluginAPIInfo(ID: integer): String;
begin
  ApiPlugin := ApiPlugins[ID];
  Result    := ApiPlugin.ApiPluginfo;
end;

Function GetPluginAPIPath(ID: integer): String;
begin
  ApiPlugin := ApiPlugins[ID];
  Result    := ApiPlugin.ApiPlugPath;
end;

function _ConvertDate(D: String): String;
begin
  Result := ConvertToDate(D);
end;

//****************************************************************************//

Procedure InitExtList;
begin
  InitExestensionList;
end;

Procedure FreeExtList;
begin
  FreeExestensionList;
end;

Procedure AddToExtList(Ext: String);
begin
  ExestensionList.Add(Ext);
end;

Procedure ClearExtList;
begin
  ExestensionList.Clear;
end;

Procedure LoadDataBases(DirName: String);
begin
  FindDataBases(DirName);
end;

Function GetDBRecCount: integer;
begin
  Result := DBCount;
end;

Function GetDBVersionDate: String;
begin
  Result := ConvertToDate(LastDate);
end;

Procedure AddOtherParamString(Param: String);
begin
  AddOtherParam(Param);
end;

Procedure ClearOtherParamList;
begin
  ClearOtherParam;
end;

procedure SaveConfig_;
begin
  SaveConfigParams;
end;

procedure LoadConfig_;
begin
  LoadConfigParams;
end;

//****************************************************************************//

function DeleteFileBC(FileName: String): boolean;
begin
	SetFileAttributes(PChar(FileName),faSysFile-faReadOnly-faHidden+faAnyFile);
	Result := DeleteFile(FileName);
end;

//****************************************************************************//

end.

