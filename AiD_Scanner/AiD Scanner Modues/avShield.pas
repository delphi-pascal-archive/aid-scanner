////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//               avShield  Unit               //
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
unit avShield;

Interface

uses Windows, Classes, avHash, avTypes;

type
  TAvShield = Class(TThread)
  private
    StartHash: String;
    NewHash  : String;
    Temp     : String;
    Restore  : TMemoryStream;
    FileName : String;
    Procedure Defence;
  protected
    procedure Execute; override;
  public
  end;

var
  Shield: TAvShield;
  
  Procedure StartShield(FileName: String);
  Procedure StopShield;
implementation

//****************************************************************************//

Procedure TAvShield.Defence;
begin
  repeat
  try
    Temp := NewHash;
    NewHash := MD5File(FileName);
  except
    NewHash := Temp;
  end;
  if NewHash <> StartHash then begin
    if not OPT_SILENT_SHIELD_MODE then
      KernelMessageAPI(MES_SHIELD_INFECT);
    try
      Restore.SaveToFile(FileName);
      if not OPT_SILENT_SHIELD_MODE then
        KernelMessageAPI(MES_SHIELD_RESTORE);
    except
      if not OPT_SILENT_SHIELD_MODE then
        KernelMessageAPI(MES_SHIELD_ERR_RESTORE);
    end;
  end;
  Sleep(1000);
  until 2 = 1;
end;

Procedure TAvShield.Execute;
begin
  try
    Restore := TMemoryStream.Create;
    Restore.LoadFromFile(FileName);
    StartHash := MD5File(FileName);
    Defence;
    Restore.Free;
  except
    KernelMessageAPI(MES_ERROR,1024);
  end;
end;

Procedure StartShield(FileName: String);
begin
  Shield := TAvShield.Create(true);
  Shield.FileName := FileName;
  Shield.Resume;
end;

Procedure StopShield;
begin
  Shield.Suspend;
end;

//****************************************************************************//

end.
