////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//               avConfig  Unit               //
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
unit avConfig;

Interface

uses Windows, Classes, SysUtils, avTypes, avEXT;

  procedure LoadConfig;
  procedure LoadConfigParams;
  procedure SaveConfigParams;
  procedure ClearOtherParam;
  procedure AddOtherParam(Param :string);
implementation

//****************************************************************************//

Function GetParametrValue(Str: String): String;
  var
  TMP,Str1,Str2 : String;
  PS            : integer;
begin
    Result := '';
    TMP := STR;
    if TMP <> '' then
      if pos('=',TMP) <> 0 then begin
        ps := pos('=',TMP);
        Str1 := Copy(TMP,0,ps-1);
        Str2 := Copy(TMP,ps+1,length(Tmp));
        Result := Str2;
      end;
end;

Function GetParametrNAME(Str: String): String;
  var
  TMP,Str1,Str2 : String;
  PS            : integer;
begin
    Result := '';
    TMP := STR;
    if TMP <> '' then
      if pos('=',TMP) <> 0 then begin
        ps := pos('=',TMP);
        Str1 := Copy(TMP,0,ps-1);
        Str2 := Copy(TMP,ps+1,length(Tmp));
        Result := Str1;
      end;
end;

//****************************************************************************//

procedure ClearOtherParam;
begin
  OtherParams.Clear;
end;

procedure AddOtherParam(Param :string);
begin
  OtherParams.Add(Param);
end;

procedure InitConfigure;
begin
  AiDConfig := TStringList.Create;
  OtherParams := TStringList.Create;
end;

Procedure GenerateDefaultExtList;
begin
  ExestensionList.Add('.exe');
  ExestensionList.Add('.dll');
  ExestensionList.Add('.com');
  ExestensionList.Add('.bat');
  ExestensionList.Add('.scr');
end;

function CreateNewConfig: boolean;
begin
  try
    Result := true;
    AiDConfig.Clear;
    {Create Default Params}
    OPT_DB_DIR              := ExtractFilePath(ParamStr(0))+'DataBases\';
    OPT_DB_LOAD             := true;
    OPT_MODULE_DIR          := ExtractFilePath(ParamStr(0))+'ModulesAPI\';
    OPT_MODULES_LOAD        := true;
    OPT_SCAN_SUBDIR         := true;
    OPT_USE_MODULES         := true;
    OPT_USE_MODULE_ATRUN    := true;
    OPT_USE_MODULE_ATSCAN   := true;
    OPT_USE_HEX_MODE        := true;
    OPT_USE_HEX_INPOS		  := true;
    OPT_USE_BYTE_MODE       := true;
    OPT_USE_CRC_MODE        := true;
    OPT_USE_OTHER_MODE      := true;
    OPT_SEND_ERR_MES        := true;
    OPT_SEND_ERR_SCAN       := true;
    OPT_SEND_ERR_READ       := true;
    OPT_SEND_ERR_INIT       := true;
    OPT_SEND_SCAN_FILE      := false;
    OPT_USE_SHIELD          := true;
    OPT_SILENT_SHIELD_MODE  := false;
    OPT_USE_SIZE_LIMIT      := True;
    OPT_SIZELIMIT           := 6000000; {Size limit}
    {}
    AiDConfig.SaveToFile(ExtractFilePath(ParamStr(0))+'AiDConfig.cfg');
  except
    Result := false;
  end;
end;

function SaveConfig: boolean;
begin
  try
    Result := true;
    AiDConfig.SaveToFile(ExtractFilePath(ParamStr(0))+'AiDConfig.cfg');
  except
    Result := false;
  end;
end;

procedure SaveConfigParams;
  var
  i: integer;
begin
  {Clear config}
  AiDConfig.Clear;
  {Write info}
  AiDConfig.Add('#################################################################');
  AiDConfig.Add('#                    AiD Configuration file                     #');
  AiDConfig.Add('#################################################################');
  AiDConfig.Add('');
  {Write information}
  AiDConfig.Add('#  DataBases');
  AiDConfig.Add('DB_DIR='+OPT_DB_DIR);
  AiDConfig.Add('DB_LOAD='+BoolToStr(OPT_DB_LOAD,false));
  AiDConfig.Add('');
  AiDConfig.Add('#  Modules');
  AiDConfig.Add('MODULES_DIR='+OPT_MODULE_DIR);
  AiDConfig.Add('MODULES_LOAD='+BoolToStr(OPT_MODULES_LOAD,false));
  AiDConfig.Add('MODULES_USE='+BoolToStr(OPT_USE_MODULES,false));
  AiDConfig.Add('MODULES_USE_ATRUN='+BoolToStr(OPT_USE_MODULE_ATRUN,false));
  AiDConfig.Add('MODULES_USE_ATSCAN='+BoolToStr(OPT_USE_MODULE_ATSCAN,false));

  if OPT_MODULES_UNLOAD.Count-1 <> -1 then
    for i := 0 to OPT_MODULES_UNLOAD.Count-1 do
      AiDConfig.Add('MODULE_UNLOAD='+OPT_MODULES_UNLOAD[i]);

  AiDConfig.Add('');
  AiDConfig.Add('#  Scanner');
  AiDConfig.Add('SCAN_SUBDIR='+BoolToStr(OPT_SCAN_SUBDIR,false));
  AiDConfig.Add('SCAN_USE_HEX='+BoolToStr(OPT_USE_HEX_MODE,false));
  AiDConfig.Add('SCAN_USE_CRC='+BoolToStr(OPT_USE_CRC_MODE,false));
  AiDConfig.Add('SCAN_USE_BYTE='+BoolToStr(OPT_USE_BYTE_MODE,false));
  AiDConfig.Add('SCAN_USE_HEX_INPOS='+BoolToStr(OPT_USE_HEX_INPOS,false));
  AiDConfig.Add('SCAN_USE_OTHER='+BoolToStr(OPT_USE_OTHER_MODE,false));
  AiDConfig.Add('SCAN_USE_SIZE_LIMIT='+BoolToStr(OPT_USE_SIZE_LIMIT,false));
  AiDConfig.Add('SCAN_SIZELIMIT='+IntToStr(OPT_SIZELIMIT));

  AiDConfig.Add('');
  AiDConfig.Add('#  Scanner Exestensions');
  if ExestensionList.Count-1 = -1 then GenerateDefaultExtList;
    for i := 0 to ExestensionList.Count-1 do
      AiDConfig.Add('EXT='+ExestensionList[i]);

  AiDConfig.Add('');
  AiDConfig.Add('#  Scanner Messages');
  AiDConfig.Add('SEND_ERR='+BoolToStr(OPT_SEND_ERR_MES,false));
  AiDConfig.Add('SEND_ERR_SCAN='+BoolToStr(OPT_SEND_ERR_SCAN,false));
  AiDConfig.Add('SEND_ERR_READ='+BoolToStr(OPT_SEND_ERR_READ,false));
  AiDConfig.Add('SEND_ERR_INIT='+BoolToStr(OPT_SEND_ERR_INIT,false));
  AiDConfig.Add('SEND_SCAN_FILE='+BoolToStr(OPT_SEND_SCAN_FILE,false));

  AiDConfig.Add('');
  AiDConfig.Add('#  Scanner Shield Mode');
  AiDConfig.Add('SHIELD_USE='+BoolToStr(OPT_USE_SHIELD,false));
  AiDConfig.Add('SHIELD_SILENT_MODE='+BoolToStr(OPT_SILENT_SHIELD_MODE,false));
  AiDConfig.Add('');
  AiDConfig.Add('#  Scanner Other');

  if OtherParams.Count-1 <> -1 then
    for i := 0 to OtherParams.Count-1 do
      AiDConfig.Add(OtherParams[i]);

  if not SaveConfig then KernelMessageAPI(MES_ERRORSAVECFG);
end;

//****************************************************************************//

procedure LoadConfigParams;
  var
  i: integer;
begin
  {Open}
  AiDConfig.LoadFromFile(ExtractFilePath(ParamStr(0))+'AiDConfig.cfg');
  OPT_MODULES_UNLOAD.Clear;
  {Read config}
  for i := 0 to AiDConfig.Count-1 do begin

    if GetParametrNAME(AiDConfig[i]) = 'DB_DIR' then
      OPT_DB_DIR := GetParametrValue(AiDConfig[i]);

    if GetParametrNAME(AiDConfig[i]) = 'DB_LOAD' then
      OPT_DB_LOAD := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'MODULES_DIR' then
      OPT_MODULE_DIR := GetParametrValue(AiDConfig[i]);

    if GetParametrNAME(AiDConfig[i]) = 'MODULES_LOAD' then
      OPT_MODULES_LOAD := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'MODULES_USE' then
      OPT_USE_MODULES := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'MODULES_USE_ATRUN' then
      OPT_USE_MODULE_ATRUN := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'MODULES_USE_ATSCAN' then
      OPT_USE_MODULE_ATSCAN := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'MODULE_UNLOAD' then
      OPT_MODULES_UNLOAD.Add(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_SUBDIR' then
      OPT_SCAN_SUBDIR := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_HEX' then
      OPT_USE_HEX_MODE := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_HEX_INPOS' then
      OPT_USE_HEX_INPOS := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_BYTE' then
      OPT_USE_BYTE_MODE := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_CRC' then
      OPT_USE_CRC_MODE := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_OTHER' then
      OPT_USE_OTHER_MODE := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_USE_SIZE_LIMIT' then
      OPT_USE_SIZE_LIMIT := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SCAN_SIZELIMIT' then
      OPT_SIZELIMIT := StrToInt(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'EXT' then
      ExestensionList.Add(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SEND_ERR' then
      OPT_SEND_ERR_MES := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SEND_ERR_SCAN' then
      OPT_SEND_ERR_SCAN := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SEND_ERR_READ' then
      OPT_SEND_ERR_READ := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SEND_ERR_INIT' then
      OPT_SEND_ERR_INIT := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SEND_SCAN_FILE' then
      OPT_SEND_SCAN_FILE := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SHIELD_USE' then
      OPT_USE_SHIELD := StrToBool(GetParametrValue(AiDConfig[i]));

    if GetParametrNAME(AiDConfig[i]) = 'SHIELD_SILENT_MODE' then
      OPT_SILENT_SHIELD_MODE := StrToBool(GetParametrValue(AiDConfig[i]));

    KernelMessageAPI(MES_OPTIONSPARAM,0,GetParametrNAME(AiDConfig[i]),GetParametrValue(AiDConfig[i]));
  end;
end;

//****************************************************************************//

procedure LoadConfig;
begin
  InitConfigure;
  OPT_MODULES_UNLOAD := TStringList.Create;
  if FileExists(ExtractFilePath(ParamStr(0))+'AiDConfig.cfg') then begin
    KernelMessageAPI(MES_LOADCONFIG);
    LoadConfigParams;
  end
  else
  begin
    if OPT_SEND_ERR_INIT then
    KernelMessageAPI(MES_ERRORLOADCFG);
    
    KernelMessageAPI(MES_CREATENEWCFG);
    if CreateNewConfig then SaveConfigParams;
  end;
end;

//****************************************************************************//
end.
