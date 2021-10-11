unit uSelDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, ExtCtrls;

type
  TSelDirFrm = class(TForm)
    Bevel: TBevel;
    TopPanel: TPanel;
    Image13: TImage;
    InformationLabel: TLabel;
    ApplyBTN: TButton;
    CanselBTN: TButton;
    ShellTreeView: TShellTreeView;
    Image1: TImage;
    procedure CanselBTNClick(Sender: TObject);
    procedure ApplyBTNClick(Sender: TObject);
    procedure ShellTreeViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelDirFrm: TSelDirFrm;

implementation

{$R *.dfm}

procedure TSelDirFrm.CanselBTNClick(Sender: TObject);
begin
  ModalResult := mrNone;
  Close;
end;

procedure TSelDirFrm.ApplyBTNClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSelDirFrm.ShellTreeViewClick(Sender: TObject);
begin
  if DirectoryExists(ShellTreeView.Path+'\') then
    ApplyBTN.Enabled := True else
    ApplyBTN.Enabled := False;
end;

procedure TSelDirFrm.FormCreate(Sender: TObject);
begin
  ModalResult := mrNone;
end;

end.
