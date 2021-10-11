////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//                 avScanner                  //
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
unit avScanner;

Interface

uses Windows, SysUtils, avHex, avDatabase, avTypes, avHash, avExt, avApi;

var
  Wait      : Boolean = False;
  ExitScn   : Boolean = False;

  procedure ExitFromScan;

  Procedure ScanFile(FileName: String);
  Function ScanFileEx(FileName: String): integer;
  function ScanDir(Dir:String) : Boolean;
  Function ScanDirFor_Progress(Dir:String) : Boolean;
  function ScanFileWithoutPlugin(FileName: String): String;
implementation

//****************************************************************************//

function includeSizeInBase(stP,fsSize: Integer): integer;
  var
  i: Integer;
begin
  Result := -1;
  for i := stP to DBCount do
    if fsSize = arSizes[i] then
    begin
      Result := i;
      Exit;
    end;
end;

//****************************************************************************//

function memcmp(const X, Y: ShortString; Size: DWord): Integer;
asm
  mov esi,X
  mov edi,Y
  mov ecx,Size
  mov dl,cl
  and dl,3
  shr ecx,2
  xor eax,eax
  rep cmpsd
  jb @@less
  ja @@great
  mov cl,dl
  rep cmpsb
  jz @@end
  ja @@great
  @@less:
  dec eax
  jmp @@end
  @@great:
  inc eax
  @@end:
end;

//****************************************************************************//

procedure ExitFromScan;
begin
  ExitScn := true;
end;

Procedure WaitForPlugin;
begin
  While Wait = True do begin
    Sleep(100);
  end;
end;

Function ScanFileWithoutPlugin(FileName: String): String;
  var
	i,r     : integer;
	HASH    : ShortString;
	EPoint  : integer;
begin
  if ExitScn then Exit;
  KernelMessageAPI(MES_ONPROGRESS,-1);
  Result := 'NONE';
  i:=0;
  if OPT_USE_SIZE_LIMIT then
    if GetSize(FileName) > OPT_SIZELIMIT then begin
      Exit;
  end;
  if Not OpenFileForScan(FileName) then begin
    exit;
  end;
  EPoint  := HexToInt(GetEPoffset(FileName));
  HASH    := MD5FileStream;
  While i < DBCount do begin
    if OPT_USE_CRC_MODE then
    if StreamDB.DBViruses[i].SignType = DB_CRC then
    if memcmp(StreamDB.DBViruses[i].Signature , HASH, length(HASH)) = 0 then begin
        Result := StreamDB.DBViruses[i].VirName;
        CloseFileAfterScan;
        exit;
      end;
    if OPT_USE_HEX_MODE then
    if StreamDB.DBViruses[i].SignType = DB_HEX then begin
      if FindHexSign(StreamDB.DBViruses[i].Signature) then begin
        Result := StreamDB.DBViruses[i].VirName;
        CloseFileAfterScan;
        exit;
      end;
    end;
    if OPT_USE_BYTE_MODE then
    if StreamDB.DBViruses[i].SignType = DB_BYTE then begin
      if FindByteSign(StreamDB.DBViruses[i].Signature) then begin
        Result := StreamDB.DBViruses[i].VirName;
        CloseFileAfterScan;
        exit;
      end;
    end;
    if OPT_USE_HEX_INPOS then
    if StreamDB.DBViruses[i].SignType = DB_HEX_POS then begin
      if FindHEXInPosition(StreamDB.DBViruses[i].Signature,EPoint) then begin
        Result := StreamDB.DBViruses[i].VirName;
        CloseFileAfterScan;
        exit;
      end;
    end;
    inc(i);
    if ExitScn then begin
    CloseFileAfterScan;
    Exit;
    end;
  end;
  CloseFileAfterScan;
end;

//****************************************************************************//

Function ScanFileEx(FileName: String): integer;
  var
	i       : integer;
  p       : integer;
	HASH    : ShortString;
	ApiPlug : PApiPlugin;
	Resul   : integer;
  EPoint  : integer;
begin
  ScanFileEx := -1;
  i:=0;
  if OPT_USE_SIZE_LIMIT then
    if GetSizeEX(FileName) > OPT_SIZELIMIT then begin
      Exit;
    end;
  if Not OpenFileForScanEx(FileName) then begin
    exit;
  end;
  try
    EPoint  := HexToInt(GetEPoffset(FileName));
  except
  end;
  HASH    := MD5FileStreamEx;
  While i < DBCount do begin
    if StreamDB.DBViruses[i].SignType = DB_CRC then begin
    if OPT_USE_CRC_MODE then
    if (StreamDB.DBViruses[i].Signature[1]  = HASH[1])  and
       (StreamDB.DBViruses[i].Signature[9]  = HASH[9]) then
      if memcmp(StreamDB.DBViruses[i].Signature , HASH, length(HASH)) = 0 then
      begin
        Result := i;
        try
        For p := 0 to ApiPlugins.Count-1 do begin
          ApiPlug := ApiPlugins.items[i];
          ApiPlug.ApiPlugSendInfected(PChar(FileName));
        end;
        except
        end;
          CloseFileAfterScanEx;
          exit;
      end;
    end
    else
    if StreamDB.DBViruses[i].SignType = DB_HEX then begin
    if OPT_USE_HEX_MODE then
      if FindHexSignEX(StreamDB.DBViruses[i].Signature) then
      begin
        Result := i;
        try
        For p := 0 to ApiPlugins.Count-1 do begin
          ApiPlug := ApiPlugins.items[i];
          ApiPlug.ApiPlugSendInfected(PChar(FileName));
        end;
        except
        end;
          CloseFileAfterScanEx;
          exit;
      end
    end
    else
    if StreamDB.DBViruses[i].SignType = DB_BYTE then begin
    if OPT_USE_BYTE_MODE then
      if FindByteSignEX(StreamDB.DBViruses[i].Signature) then begin

        Result := i;
        try
        For p := 0 to ApiPlugins.Count-1 do begin
          ApiPlug := ApiPlugins.items[i];
          ApiPlug.ApiPlugSendInfected(PChar(FileName));
        end;
        except
        end;
          CloseFileAfterScanEx;
          exit;
    end
    else
    if StreamDB.DBViruses[i].SignType = DB_HEX_POS then
    if OPT_USE_HEX_INPOS then
      if FindHEXInPositionEX(StreamDB.DBViruses[i].Signature,EPoint) then begin
        Result := i;
        try
        For p := 0 to ApiPlugins.Count-1 do begin
          ApiPlug := ApiPlugins.items[i];
          ApiPlug.ApiPlugSendInfected(PChar(FileName));
        end;
        except
        end;
          CloseFileAfterScanEx;
          exit;
      end
      end;
    inc(i);
  end;
  CloseFileAfterScanEx;
end;

//****************************************************************************//

Procedure ScanFile(FileName: String);
  var
	i       : integer;
  p       : integer;
	HASH    : ShortString;
	ApiPlug : PApiPlugin;
	Result  : integer;
  EPoint  : integer;
  ApType  : integer;
  LhS     : byte;
  NotinSz : boolean;
  SizeInd : integer;
begin
  KernelMessageAPI(MES_ONPROGRESS,0,FileName);
  if OPT_SEND_SCAN_FILE then
	   KernelMessageAPI(MES_SENDSCNFILE,0,FileName);
	if ExitScn then Exit;
  if OPT_USE_SIZE_LIMIT then
    if GetSize(FileName) > OPT_SIZELIMIT then begin
      if OPT_SEND_SCAN_FILE then begin
          KernelMessageAPI(MES_SKIPBYSIZE,0,FileName);
      end;
      Exit;
  end;

  i := 0;

  if Not OpenFileForScan(FileName) then begin
    if OPT_SEND_ERR_READ then begin
        KernelMessageAPI(MES_ONREADERROR,0,FileName);
      end;
    exit;
  end;

  try
    EPoint  := HexToInt(GetEPoffset(FileName));
  except
  end;

  SizeInd := includeSizeInBase(0,FStream.Size);
  if SizeInd > -1 then
  begin
    HASH    := MD5FileStream;
    LhS     := Length(HASH);
    NotinSz := False;
  end
  else
    NotinSz := True;

  if OPT_USE_MODULE_ATSCAN then begin
  try
    Result := MES_NONE;
    For p := 0 to ApiPlugins.Count-1 do
    begin
      if ExitScn then Exit;
      ApiPlug := ApiPlugins.items[p];
      if (ApiPlug.ApiPlugType = API_SCAN) or (ApiPlug.ApiPlugType = API_SCANFILE) then
      begin
        Result := ApiPlug.ApiPlugScanFile(PChar(FileName));
        if ( result <> MES_NONE ) then
        begin
          case result of
            MES_SCANDIR    : ScanDir(ApiPlug.ApiPlugGetScanDir);
            MES_SCANFILE   : ScanFile(ApiPlug.ApiPlugGetScanFile);
            MES_PLUGINWAIT : WaitForPlugin;
            MES_PLUGINEXIT : WaitForPlugin;
          end;
        end;
      end;
    end;
    if Result = MES_PLUGINEXIT then Exit;
  except
  end;
  end;

  if HStar > SizeInd then I := SizeInd; 
  if NotinSz then I := HStar;

  While i < DBCount do begin
    if StreamDB.DBViruses[i].SignType = DB_CRC then begin
    if SizeInd > -1 then
    if OPT_USE_CRC_MODE then
    if i = SizeInd then
      if memcmp(StreamDB.DBViruses[i].Signature,HASH,LhS) = 0 then
      begin
        KernelMessageAPI(MES_ONVIRFOUND,0,FileName,StreamDB.DBViruses[i].VirName);
        try
          For p := 0 to ApiPlugins.Count-1 do begin
            ApiPlug := ApiPlugins.items[i];
            ApiPlug.ApiPlugSendInfected(PChar(FileName));
          end;
        except
        end;
          CloseFileAfterScan;
          exit;
      end else SizeInd := includeSizeInBase(i+1,FStream.Size);
      end
    else
    if StreamDB.DBViruses[i].SignType = DB_HEX then begin
    if OPT_USE_HEX_MODE then
      if FindHexSign(StreamDB.DBViruses[i].Signature) then
      begin
        KernelMessageAPI(MES_ONVIRFOUND,0,FileName,StreamDB.DBViruses[i].VirName);
        try
          For p := 0 to ApiPlugins.Count-1 do begin
            ApiPlug := ApiPlugins.items[i];
            ApiPlug.ApiPlugSendInfected(PChar(FileName));
          end;
        except
        end;
          CloseFileAfterScan;
          exit;
      end
    end
    else
    if StreamDB.DBViruses[i].SignType = DB_BYTE then begin
    if OPT_USE_BYTE_MODE then
      if FindByteSign(StreamDB.DBViruses[i].Signature) then
      begin
        KernelMessageAPI(MES_ONVIRFOUND,0,FileName,StreamDB.DBViruses[i].VirName);
        try
          For p := 0 to ApiPlugins.Count-1 do begin
            ApiPlug := ApiPlugins.items[i];
            ApiPlug.ApiPlugSendInfected(PChar(FileName));
          end;
          except
        end;
          CloseFileAfterScan;
          exit;
      end
    end
    else
    if StreamDB.DBViruses[i].SignType = DB_HEX_POS then
    if OPT_USE_HEX_INPOS then
      if FindHEXInPosition(StreamDB.DBViruses[i].Signature,EPoint) then
      begin
        KernelMessageAPI(MES_ONVIRFOUND,0,FileName,StreamDB.DBViruses[i].VirName);
        try
        For p := 0 to ApiPlugins.Count-1 do begin
          ApiPlug := ApiPlugins.items[i];
          ApiPlug.ApiPlugSendInfected(PChar(FileName));
        end;
        except
        end;
          CloseFileAfterScan;
          exit;
      end;
    if ExitScn then begin
    CloseFileAfterScan;
    Exit;
    end;
    inc(i);
  end;
  CloseFileAfterScan;
end;

//****************************************************************************//

Function ScanDir(Dir:String) : Boolean;
  Var
  SR        :TSearchRec;
  FindRes,i :Integer;
  EX        : String;
  EX1       : String;
  t,t1      : integer;
begin
  ExitScn:= False;
  Result := false;
  FindRes:=FindFirst(Dir+'*.*',faAnyFile,SR);
  While FindRes=0 do
    begin
      if ExitScn then Exit;
    
    if ((SR.Attr and faDirectory)=faDirectory) and
    ((SR.Name='.')or(SR.Name='..')) then
      begin
        FindRes:=FindNext(SR);
        Continue;
      end;

    if OPT_SCAN_SUBDIR then
    if ((SR.Attr and faDirectory)=faDirectory) then
      begin
        ScanDir(Dir+SR.Name+'\');
        FindRes:=FindNext(SR);
        Continue;
      end;

    if FileExists(Dir+Sr.Name) then begin
      Ex := ExtractFileExt(Dir+SR.Name);
      try
        for i := 0 to ExestensionList.Count-1 do
          if (CompareStr(LowerCase(Ex), ExestensionList[i]) =0) or (CompareStr(ExestensionList[i], '.*') =0) then
          begin
            t := GetTickCount;
            ScanFile(Dir+Sr.Name);
            t1:= GetTickCount;
            KernelMessageAPI(MES_ONPROGRESSEX,t1-t,Dir+Sr.Name);
            Break;
          end;
        for i := 0 to APIExestensionList.Count-1 do
          if CompareStr(LowerCase(Ex), APIExestensionList[i]) =0 then
          begin
            t := GetTickCount;
            ScanFile(Dir+Sr.Name);
            t1:= GetTickCount;
            KernelMessageAPI(MES_ONPROGRESSEX,t1-t,Dir+Sr.Name);
            Break;
          end;
      except
      end;
    end;
    FindRes:=FindNext(SR);
  end;
  FindClose(SR);
  Result := true;
end;

Function ScanDirFor_Progress(Dir:String) : Boolean;
  Var
  SR        :TSearchRec;
  FindRes,i :Integer;
  EX        : String;
  EX1       : String;
begin
  ExitScn:= False;
  Result := false;
  FindRes:=FindFirst(Dir+'*.*',faAnyFile,SR);
  While FindRes=0 do
   begin
    if ExitScn then Exit;

    if ((SR.Attr and faDirectory)=faDirectory) and
    ((SR.Name='.')or(SR.Name='..')) then
      begin
        FindRes:=FindNext(SR);
        Continue;
      end;

    if OPT_SCAN_SUBDIR then
    if ((SR.Attr and faDirectory)=faDirectory) then
      begin
        ScanDirFor_Progress(Dir+SR.Name+'\');
        FindRes:=FindNext(SR);
        Continue;
      end;
    if FileExists(Dir+Sr.Name) then begin
      Ex := ExtractFileExt(Dir+SR.Name);
      try
        for i := 0 to ExestensionList.Count-1 do
        if (CompareStr(LowerCase(Ex), ExestensionList[i]) =0) or (CompareStr(ExestensionList[i], '.*') =0) then
        begin
          MaxProgress := MaxProgress + 1;
          Break;
        end;

      for i := 0 to APIExestensionList.Count-1 do
        if CompareStr(LowerCase(Ex), APIExestensionList[i]) =0 then
        begin
          MaxProgress := MaxProgress + 1;
          Break;
        end;
    except
    end;
  end;
    FindRes:=FindNext(SR);
  end;
  FindClose(SR);
  Result := true;
end;

//****************************************************************************//

end.

