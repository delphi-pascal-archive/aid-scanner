unit uPluginInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, avKernel;

type
  TPluginAPIForm = class(TForm)
    Bevel: TBevel;
    TopPanel: TPanel;
    BackImage: TImage;
    InformationLabel: TLabel;
    InfoLabel: TLabel;
    OkBTN: TButton;
    NameLabel: TLabel;
    AutorLabel: TLabel;
    OtherInfoLabel: TLabel;
    PathLabel: TLabel;
    PathEdit: TEdit;
    NameEdit: TEdit;
    AutorEdit: TEdit;
    OtherMemo: TMemo;
    LoadUploadBTN: TButton;
    Image1: TImage;
    procedure OkBTNClick(Sender: TObject);
    procedure LoadUploadBTNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PluginAPIForm: TPluginAPIForm;

implementation

uses uMain;

{$R *.dfm}

procedure TPluginAPIForm.OkBTNClick(Sender: TObject);
begin
  Close;
end;

procedure TPluginAPIForm.LoadUploadBTNClick(Sender: TObject);
begin
  if _LoadModule(ExtractFileName(PathEdit.Text)) then ShowMessage(mainForm.MLoad)
  else
  if _UnLoadModule(ExtractFileName(PathEdit.Text)) then ShowMessage(mainForm.MunLoad)
end;

end.
