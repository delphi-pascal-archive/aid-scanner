library ModuleSDK;
/////////////////////////////////////
// API Module SDK for AiD Scanner  //
/////////////////////////////////////
uses
  ShareMem, SysUtils, Classes, windows;

  const
  MES_NONE         = 0;
  API_OTHER        = 1000;
  API_SCAN         = 1001;
  API_SCANATRUN    = 1002;
  API_SCANFILE     = 1003;
  MES_SCANDIR      = 1101;
  MES_SCANFILE     = 1102;
  MES_PLUGINWAIT   = 1103;
  MES_PLUGINEXIT   = 1104;
  MES_EXITFROMWAIT = 1121;

  type

  OnVirFound          = Procedure(FileName,VirName: PChar);
  OnReadError         = Procedure(FileName: String; ID: Integer);
  OnAddToLogString    = Procedure(LogString: PChar; ID: integer);
  ApiScanFileInThread = Procedure(FileName: PChar);
  ApiScanDirInThread  = Procedure(DirName: PChar);
  ApiScanFile         = Procedure(FileName: PChar);
  ApiScanDir          = Procedure(DirName: PChar);
  ApiAddToExtList     = Procedure(Ext: PChar);
  ApiOnScanStart      = Procedure;
  ApiScanFileInPlugin = Function(FileName: PChar; var VirName: PChar): Boolean;
  ExitWaitForPlugin   = Procedure;

  var
  OwnerHDC : integer;

Procedure InitApiPlug(Owner: integer);
begin
OwnerHDC := Owner;
end;

Procedure APIPlugInitOnScan;
begin
  //
end;

Function ApiPluginGetType: integer;
begin
{Get plugin Type}
end;

Function ApiPluginGetName: PChar;
begin
{Plugin name}
end;

Function ApiPluginGetInfo: PChar;
begin
{Plugin info}
end;

Function ApiPluginGetAutor: PChar;
begin
{Plugin autor}
end;

Function ApiPlugScanFile(FileName: PChar): integer;
begin
  //
end;

Function ApiPlugScanDir(DirName: PChar): integer;
begin
  //
end;

Function ApiPlugReturnMes: integer;
begin
  //
end;

Function ApiPlugGetScanFile: PChar;
begin
  //
end;

Function ApiPlugGetScanDir: PChar;
begin
  //
end;

Procedure ApiPlugSendInfected(FileName: PChar);
begin
  //
end;

//---------------------------------------------------//
{Export plugin functions}
exports InitApiPlug;
exports APIPlugInitOnScan;
exports ApiPlugSendInfected;
exports ApiPluginGetAutor;
exports ApiPluginGetName;
exports ApiPluginGetType;
exports ApiPluginGetInfo;
exports ApiPlugScanFile;
exports ApiPlugScanDir;
exports ApiPlugReturnMes;
exports ApiPlugGetScanFile;
exports ApiPlugGetScanDir;

begin
end.
 