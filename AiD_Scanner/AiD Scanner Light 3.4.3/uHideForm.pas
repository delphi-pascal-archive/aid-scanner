unit uHideForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  THideForm = class(TForm)
    ShowHideTip: TCheckBox;
    Button1: TButton;
    TopPanel: TPanel;
    BackImage: TImage;
    InformationLabel: TLabel;
    Image1: TImage;
    Bevel: TBevel;
    HideTipLabel: TLabel;
    Image2: TImage;
    InfoLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HideForm: THideForm;

implementation

uses uOptions, uMain;

{$R *.dfm}

procedure THideForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure THideForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.DeActiveTray := False;
  OptionsForm.SaveOptions;
end;

end.
