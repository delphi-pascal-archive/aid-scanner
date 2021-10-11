program debug;

uses
  Forms,
  avDataBase in '..\AiD Scanner Modues\avDataBase.pas',
  avHash in '..\AiD Scanner Modues\avHash.pas',
  uMain in 'uMain.pas' {MainForm},
  uAddRec in 'uAddRec.pas' {AddForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AiD DataBase Creator';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddForm, AddForm);

  Application.Run;
end.
