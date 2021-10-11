unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, XPMan, avDataBase;

type
  TMainForm = class(TForm)
    TopPanel: TPanel;
    LogoImage: TImage;
    BackImage: TImage;
    NameLabel1: TLabel;
    NameLabel2: TLabel;
    NameLabel3: TLabel;
    CopyRightLabel: TLabel;
    VersionLabel: TLabel;
    Bevel: TBevel;
    DBListView: TListView;
    Panel1: TPanel;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    XPManifest1: TXPManifest;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses uAddRec;

{$R *.dfm}
procedure AddRecToList(Rec: TDataRecord);
begin
  with MainForm.DBListView.Items.Add, Rec do
    begin
      if rec.SignType = 0 then  Caption := 'MD5';
      if rec.SignType = 1 then  Caption := 'HEX';
      if rec.SignType = 2 then  Caption := 'HEX2';
      SubItems.Add(VirName);
      SubItems.Add(Signature);
    end;
end;

procedure OpenDBFile(const sFileName: String;var DBFile: TDBFile);
var
  DBRec: TDataRecord;
begin
  AssignFile(DBFile, sFileName);
  Reset(DBFile);

  while not EOF(DBFile) do
    begin
      Read(DBFile, DBRec);
      AddRecToList(DBRec);
    end;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
AddForm.showmodal;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
DBListView.DeleteSelected;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
if OpenDialog1.Execute then begin
  OpenDBFile(OpenDialog1.FileName,DBFile);
end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
i: integer;
Rec: TDataRecord;
begin
if SaveDialog1.Execute then begin
CreateDBFile(SaveDialog1.FileName,DBFile);
  for i := 0 to DBListView.Items.Count-1 do begin
    //
    Rec.VirName := DBListView.Items.Item[i].SubItems[0];
    Rec.Signature := DBListView.Items.Item[i].SubItems[1];
    if DBListView.Items.Item[i].Caption = 'MD5' then
    Rec.SignType := 0;
    if DBListView.Items.Item[i].Caption = 'HEX' then
    Rec.SignType := 1;

    AddRecToDBFile(DBFile,Rec);

  end;
end;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  DBListView.Clear;
end;

end.
