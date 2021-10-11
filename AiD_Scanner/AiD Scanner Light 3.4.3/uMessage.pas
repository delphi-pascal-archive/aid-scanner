unit uMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMessageFrm = class(TForm)
    TopPanel: TPanel;
    Image13: TImage;
    InformationLabel: TLabel;
    Bevel: TBevel;
    Memo1: TMemo;
    Ok: TButton;
    InfoLabel: TLabel;
    Image1: TImage;
    procedure OkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MessageFrm: TMessageFrm;

implementation

{$R *.dfm}

procedure TMessageFrm.OkClick(Sender: TObject);
begin
  Close;
end;

end.
