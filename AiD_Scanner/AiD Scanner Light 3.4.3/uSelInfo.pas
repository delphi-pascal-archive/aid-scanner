unit uSelInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TInformationForm = class(TForm)
    TopPanel: TPanel;
    BackImage: TImage;
    Bevel: TBevel;
    OkBTN: TButton;
    InfoMemo: TMemo;
    InformationLabel: TLabel;
    InfoLabel: TLabel;
    Image1: TImage;
    procedure OkBTNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InformationForm: TInformationForm;

implementation

{$R *.dfm}

procedure TInformationForm.OkBTNClick(Sender: TObject);
begin
  Close;
end;

end.
