unit OneHist;

interface

implementation
uses Windows, Messages, SysUtils, Forms, uMain;

const
     WM_MINERESTORE = WM_USER + $877;
var
  Mutex : THandle;
  hwnd  : THandle;
  cd    : TCopyDataStruct;

function StopLoading() : boolean;
begin
   Mutex := CreateMutex(nil,false,'AIDSCANNER$SUPERMUTEX');
   Result := (Mutex = 0) or
   (GetLastError = ERROR_ALREADY_EXISTS);
end;


initialization
  if StopLoading() then
  begin
       hwnd := FindWindow(nil, PChar(uMain.AiDScannerCapt));
       if (hwnd <> 0) then
       begin
            if ParamStr(1) <> '' then begin
            cd.cbData := Length(ParamStr(1)) + 1;
            cd.lpData := PChar(ParamStr(1));
            SendMessage(hWnd, WM_COPYDATA, 0, LParam(@cd));
            end
            else begin
            PostMessage(hWnd, WM_MINERESTORE,0 , 0);
            SetForegroundWindow(hwnd);
            end
       end;
       halt;
  end;
finalization
  if Mutex <> 0 then
    CloseHandle(Mutex);
end.

