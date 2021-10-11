////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//              av API Modules                //
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
unit avAPI;

Interface

uses Windows, Classes, SysUtils, avTypes, avExt;

type

  TApiPluginGetType         = Function: Integer;
  TApiPluginGetName         = Function: PChar;
  TApiPluginGetAutor        = Function: PChar;
  TApiPluginGetInfo         = Function: PChar;
  TApiPluginInit            = Procedure(Owner: integer);
  TApiPluginInitOnScan      = Procedure;
  TApiPluginScanFile        = Function(FileName: PChar): integer;
  TApiPluginScanDir         = Function(DirName: PChar): integer;
  TApiSendInfectedFile      = Procedure(FileName: PChar);
  TApiPluginReturnMes       = Function: integer;
  TApiPluginGetFileForScan  = Function: PChar;
  TApiPluginGetDirForScan   = Function: PChar;

  TApiPlugin       = record

  ApiPlugPath      : String;
  ApiHandle        : integer;
  ApiPlugName      : ShortString;
  ApiPlugAutor     : ShortString;
  ApiPluginfo      : PChar;
  ApiPlugType      : Integer;
  ApiPlugHandle    : integer;

  ApiPlugInit         : TApiPluginInit;
  APIPlugInitOnScan   : TApiPluginInitOnScan;
  ApiPlugMessage      : TApiPluginReturnMes;
  ApiPlugScanDir      : TApiPluginScanDir;
  ApiPlugScanFile     : TApiPluginScanFile;
  ApiPlugGetScanFile  : TApiPluginGetFileForScan;
  ApiPlugGetScanDir   : TApiPluginGetDirForScan;
  ApiPlugSendInfected : TApiSendInfectedFile;
end;

  PApiPlugin=^TApiPlugin;
  TApiPlugins=class(TList);
var
  ApiPlugins  :TApiPlugins;
  lib         :integer;
  ApiPlugin   :PApiPlugin;

//****************************************************************************//

  Procedure InitializeApiPlugin;
  Procedure FreeApiPluginList;
  Procedure LoadApiPlugin(PluginName: String);
  Procedure LoadApi(ApiDir: String);
  Function LoadPlugin(PluginName: String): boolean;
  Function UnLoadPlugin(PluginName: String): boolean;
implementation
  uses avScanner, avKernel;

//****************************************************************************//

Function LoadPlugin(PluginName: String): boolean;
  var
  i: integer;
begin
  Result := False;
  For i := 0 to OPT_MODULES_UNLOAD.Count-1 do begin
    if OPT_MODULES_UNLOAD[i] = PluginName then
    begin
      OPT_MODULES_UNLOAD.Delete(i);
      Result := True;
      exit;
    end;
  end;
end;

Function UnLoadPlugin(PluginName: String): boolean;
  var
  i,j: integer;
begin
  Result := False;
  j:=0;
  for i := 0 to OPT_MODULES_UNLOAD.Count-1 do begin
    if OPT_MODULES_UNLOAD[i] = PluginName then j:=j+1;
  end;
  if j = 0 then begin
    OPT_MODULES_UNLOAD.Add(PluginName);
    Result := True;
  end;
end;

Procedure ApiOnVirFound(FileName, VirName: PChar); far;
begin
  KernelMessageAPI(MES_ONVIRFOUND,0,FileName,VirName);
end;

Procedure ApiOnReadError(FileName: String; ID: Integer); far;
begin
  KernelMessageAPI(MES_ONREADERROR,0,FileName);
end;

Procedure ApiOnAddToLogString(LogString: PChar; ID: integer); far;
begin
  KernelMessageAPI(MES_ADDTOLOG,ID,LogString);
end;

Procedure ApiAddToExtList(Ext: PChar); far;
begin
  APIExestensionList.Add(Ext);
end;

Procedure ApiOnScanStart; far;
begin
  KernelMessageAPI(MES_ONSCANEXECUTE);
end;

Procedure ApiScanFile(FileName: PChar); far;
begin
  if FileName <> '' then begin
    AiDScanner := TAvScanner.Create(True);
    AiDScanner.NeedForAPI := true;
    AiDScanner.AvAction := TScanFile;
    AiDScanner.FileName := FileName;
    ApiOnScanStart;
  end;
end;

Procedure ApiScanDir(DirName: PChar); far;
begin
  if DirName <> '' then begin
    AiDScanner := TAvScanner.Create(True);
    AiDScanner.NeedForAPI := true;
    AiDScanner.AvAction := TScanDir;
    AiDScanner.DirName := DirName;
    ApiOnScanStart;
  end;
end;

Procedure ApiScanFileInThread(FileName: PChar); far;
Begin
  ExitScn := False;
  ScanFile(FileName);
end;

Procedure ApiScanDirInThread(DirName: PChar); far;
begin
  ExitScn := False;
  ScanDir(DirName);
end;

Function ApiScanFileInPlugin(FileName: PChar; var VirName: PChar): Boolean; far;
  var
  VName: String;
begin

  if ExitScn then begin
  Result := False;
  VName := 'NONE';
  Exit;
  end;

  VName := PChar(ScanFileWithoutPlugin(FileName));

  if CompareStr(VName,'NONE') = 0 then begin
    Result := False;
  end else begin
    Result := True;
    VirName := PChar(VName);
  end;
end;

Procedure ExitWaitForPlugin; far;
begin
  Wait := False;
end;

Procedure ApiSendScanFile(FileName : PChar); far;
begin
  KernelMessageAPI(MES_ONPROGRESS,0,FileName);

  if OPT_SEND_SCAN_FILE then
  KernelMessageAPI(MES_SENDSCNFILE,0,FileName);
end;

//----------------------------------------------------------------------------//

Procedure InitializeApiPlugin;
begin
  ApiPlugins:=TApiPlugins.Create;
end;

Procedure FreeApiPluginList;
begin
  ApiPlugins.Free;
end;

Procedure LoadApi(ApiDir: String);
  var
  SR       : TSearchRec;
  FindRes  : Integer;
  EX,tmp   : String;
  MDHash   : String;
  c        : cardinal;
  Four     : integer;
begin
  Four := 0;
  FindRes:=FindFirst(ApiDir+'*.*',faAnyFile,SR);
  While FindRes=0 do
   begin
    if ((SR.Attr and faDirectory)=faDirectory) and
    ((SR.Name='.')or(SR.Name='..')) then
      begin
      FindRes:=FindNext(SR);
      Continue;
      end;
    if ((SR.Attr and faDirectory)=faDirectory) then
      begin
      LoadApi(ApiDir+SR.Name+'\');
      FindRes:=FindNext(SR);
      Continue;
      end;
    Ex := ExtractFileExt(ApiDir+SR.Name);
    if  LowerCase(Ex) = LowerCase('.dll') then
      begin
      LoadApiPlugin(ApiDir+sr.Name);
      end;
    FindRes:=FindNext(SR);
  end;
  FindClose(SR);
end;

Procedure LoadApiPlugin(PluginName: String);
  var
  PlugHnd,i  : integer;
  PlugType   : TApiPluginGetType;
  PlugName   : TAPiPluginGetName;
  PlugAutor  : TApiPluginGetAutor;
  PlugInfo   : TAPiPluginGetInfo;
  PlugInit   : TApiPluginInit;
begin
  for i := 0 to OPT_MODULES_UNLOAD.Count - 1 do begin
    if LowerCase(ExtractFileName(PluginName)) = LowerCase(OPT_MODULES_UNLOAD[i]) then exit;
  end;

  PlugHnd := LoadLibrary(PChar(PluginName));
  @PlugInfo := GetProcAddress(PlugHnd,'ApiPluginGetInfo');
  if @PlugInfo = nil then FreeLibrary(PlugHnd)
  else
  begin
    try
    New(ApiPlugin);

    @PlugName         := GetProcAddress(PlugHnd,'ApiPluginGetName');
    @PlugAutor        := GetProcAddress(PlugHnd,'ApiPluginGetAutor');
    @PlugType         := GetProcAddress(PlugHnd,'ApiPluginGetType');

    ApiPlugin.ApiPlugName   := PlugName;
    ApiPlugin.ApiPlugAutor  := PlugAutor;
    ApiPlugin.ApiPluginfo   := PlugInfo;
    ApiPlugin.ApiPlugHandle := PlugHnd;
    ApiPlugin.ApiPlugType   := PlugType;

    ApiPlugin.ApiPlugMessage     := GetProcAddress(PlugHnd,'ApiPlugMessage');
    ApiPlugin.APIPlugInitOnScan  := GetProcAddress(PlugHnd,'APIPlugInitOnScan');
    ApiPlugin.ApiPlugScanDir     := GetProcAddress(PlugHnd,'ApiPlugScanDir');
    ApiPlugin.ApiPlugScanFile    := GetProcAddress(PlugHnd,'ApiPlugScanFile');
    ApiPlugin.ApiPlugGetScanFile := GetProcAddress(PlugHnd,'ApiPlugGetScanFile');
    ApiPlugin.ApiPlugGetScanDir  := GetProcAddress(PlugHnd,'ApiPlugGetScanDir');
    ApiPlugin.ApiPlugSendInfected:= GetProcAddress(PlugHnd,'ApiPlugSendInfected');

    ApiPlugin.ApiPlugPath := PluginName;

    TApiPluginInit(GetProcAddress(PlugHnd, 'InitApiPlug'))(HInstance);

    ApiPlugins.Add(Apiplugin);

except
end;
end;
end;

//****************************************************************************//

exports ApiOnVirFound;
exports ApiOnAddToLogString;
exports ApiAddToExtList;
exports ApiScanFile;
exports ApiScanDir;
exports ApiOnScanStart;
exports ApiScanFileInPlugin;
exports ExitWaitForPlugin;
exports ApiScanDirInThread;
exports ApiScanFileInThread;
exports ApiOnReadError;
exports ApiSendScanFile;

//****************************************************************************//

end.
