////////////////////////////////////////////////
//                AiD Scanner                 //
////////////////////////////////////////////////
//                av Ext unit                 //
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
unit avExt;

Interface

uses Classes;

var
  ExestensionList     : TStringList;
  APIExestensionList  : TStringList;

Procedure InitExestensionList;
Procedure FreeExestensionList;

implementation

//****************************************************************************//

Procedure InitExestensionList;
begin
  APIExestensionList  := TStringList.Create;
  ExestensionList     := TStringList.Create;
end;

Procedure FreeExestensionList;
begin
  ExestensionList.Free;
  APIExestensionList.Free;
end;

//****************************************************************************//

end.
