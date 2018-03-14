program POP3sync;

{
  0.1b1:
  * initial release

  0.1b2:
  * Imap accounts are scanned for UIDLs as well
}

uses
  Forms,
  MainF in '..\Pas\MainF.pas' {MainForm},
  StatusF in '..\Pas\StatusF.pas' {StatusForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'POP3sync | Thunderbird';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TStatusForm, StatusForm);
  Application.Run;
end.
