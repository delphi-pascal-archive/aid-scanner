////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//            Data Base Unit v0.5             //
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
unit avDataBase;

Interface

uses Windows, SysUtils, classes, Messages, avTypes;
//****************************************************************************//

type
  TDataRecord = record
    VirName   : String[50];
    SignType  : LongWord;
    Signature : String[255];
  end;

  TDBFile     = file of TDataRecord;

type
  TStreamDB   = record
    BASECopyR : String[150];
    DBDate    : String[8];
    Dovesok   : array [1..152] of byte;
    DBCount   : integer;
    DBViruses : array of TDataRecord;
  end;

//****************************************************************************//

Var
  StreamDB    : TStreamDB;
  DBCount     : Integer = 0;
  DBFile      : TDBFile;
  LastDate    : String = '01011880';

  arSizes     : array of Integer;
  Hstar       : Integer;

//****************************************************************************//

  procedure CreateDBFile(const sFileName: String;var DBFile: TDBFile);
  procedure LoadDBFile(const sFileName: String;var DBFile: TDBFile);
  Procedure AddRecToDBFile(var DBFile: TDBFile; Rec: TDataRecord);
  Procedure RecounDBStream;
  Procedure FindDataBases(Dir:String);

  Procedure getSpeedesProcOfDataBase;
  
  function ConvertToDate(Str: String): String;
  function CompareTooDates(D1,D2: String): integer; // 1 = D1 > 2 = D2 > 0 = error
  
implementation

//****************************************************************************//

function ConvertToDate(Str: String): String;
begin
  Result := Str;
  Insert('.',Result,3);
  Insert('.',Result,6);
end;

function CompareTooDates(D1,D2: String): integer;
  var
  Dt1,Dt2: TDateTime;
Begin
  try
    DT1 := StrToDate(ConvertToDate(D1));
    DT2 := StrToDate(ConvertToDate(D2));
    if DT1 > DT2 then
      Result := 1
    else
      Result := 2;
  except
    Result := 0;
  end;
end;

//****************************************************************************//

Function GetSizeFromSign(Sign : ShortString): Integer;
begin
  try
    if Pos(':',sign) <> 0 then
      Result := strtoint(Copy(Sign,Pos(':',sign)+1,Length(Sign)))
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

Procedure getSpeedesProcOfDataBase;
  var
  i: Integer;
begin
  try
    SetLength(arSizes,DBCount+1);
    Hstar := 0;
    for i := 0 to DBCount do begin
      arSizes[i] := GetSizeFromSign(StreamDB.dbviruses[i].Signature);
      if Hstar = 0 then
        if arSizes[i] = 0 then
          Hstar := i;
    end;
  except
  end;
end;

//****************************************************************************//

Procedure RecounDBStream;
begin
  DBCount := 0;
end;

Procedure AddRecToDBFile(var DBFile: TDBFile; Rec: TDataRecord);
begin
  Seek(DBFile, FileSize(DBFile));
  Write(DBFile, rec);
end;

Procedure AddToDBStream(DBRec: TDataRecord);
begin
  StreamDB.DBCount := DBCount;
  SetLength(StreamDB.DBViruses, DBCount+1);
  StreamDB.DBViruses[DBCount] := DBRec;
end;

Procedure LoadDBFile(const sFileName: String;var DBFile: TDBFile);
  var
  DBRec : TDataRecord;
  M     : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.LoadFromFile(sFileName);
  M.Read(StreamDB.BASECopyR,sizeof(StreamDB.BASECopyR));
  M.Read(StreamDB.DBDate,sizeof(StreamDB.DBDate));
  M.Free;
  
  if CompareTooDates(LastDate, StreamDB.DBDate) = 2
    then LastDate := StreamDB.DBDate;

  if CompareTooDates(LastDate, StreamDB.DBDate) = 0
    then Exit;

  KernelMessageAPI(MES_LOADDBDATE,0,sFileName, StreamDB.DBDate);

  AssignFile(DBFile, sFileName);
  Reset(DBFile);

  Seek(DBFile,1);

  while not EOF(DBFile) do
    begin
      Read(DBFile, DBRec);
      AddToDBStream(DBRec);
      inc(DBCount);
    end;
end;

//****************************************************************************//

Procedure CreateDBFile(const sFileName: String;var DBFile: TDBFile);
begin
  AssignFile(DBFile, sFileName);
  Reset(DBFile);
  Seek(DBFile,FileSize(DBFile));
end;

//****************************************************************************//

Procedure FindDataBases(Dir:String);
  var
  SR      : TSearchRec;
  FindRes : Integer;
  EX,tmp  : String;
  MDHash  : String;
  c       : cardinal;
  Four    : integer;
begin
  Four := 0;
  FindRes:=FindFirst(Dir+'*.*',faAnyFile,SR);
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
        FindDataBases(Dir+SR.Name+'\');
        FindRes:=FindNext(SR);
        Continue;
      end;
    Ex := ExtractFileExt(Dir+SR.Name);
    if  LowerCase(Ex) = LowerCase('.av') then
      begin
        LoadDBFile(Dir+Sr.Name,DBFile);
      end;
    FindRes:=FindNext(SR);
  end;
  FindClose(SR);
end;

//****************************************************************************//

end.
