unit AboutFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ShellAPI, ComCtrls;

type
  TAboutForm = class(TForm)
    Bevel2: TBevel;
    TopPanel: TPanel;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    OkBTN: TBitBtn;
    Bevel1: TBevel;
    NameToLabel: TLabel;
    Label3: TLabel;
    InfoBox: TGroupBox;
    inWebLabel: TLabel;
    CopyRightLabel: TLabel;
    LinkLabel: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    smallLicenseLabel: TLabel;
    Label4: TLabel;
    procedure OkBTNClick(Sender: TObject);
    procedure LinkLabelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses uMain;

{$R *.dfm}

procedure TAboutForm.OkBTNClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.LinkLabelClick(Sender: TObject);
  Const
  URL : String = 'http://www.bit-lab.info';
begin
  ShellExecute(0,'',pChar(''+URL),NIL,NIL,SW_SHOWNORMAL);
end;
end.
