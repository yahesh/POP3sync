unit StatusF;

interface

uses
  SysUtils, Controls, Forms, Classes, StdCtrls, ExtCtrls, Dialogs;

type
  TStatusForm = class(TForm)
    AccountBevel : TBevel;
    AccountLabel : TLabel;
    CancelBevel : TBevel;
    CancelButton : TButton;
    CurrentChangesLabel : TLabel;
    CurrentCommandsLabel : TLabel;
    CurrentIDsLabel : TLabel;
    CurrentLinesLabel : TLabel;
    CurrentMailsLabel : TLabel;
    FileLabel : TLabel;
    ProfileBevel : TBevel;
    ProfileNameLabel : TLabel;
    ProfilePathLabel : TLabel;
    TotalChangesLabel : TLabel;
    TotalCommandsLabel : TLabel;
    TotalIDsLabel : TLabel;
    TotalLinesLabel : TLabel;
    TotalMailsLabel : TLabel;

    procedure CancelButtonClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    FCanceled : Boolean;
  public
    { Public-Deklarationen }
    function IsCanceled : Boolean;

    procedure DataInit(const AScan : Boolean; const AProfileName : String; const AProfilePath : String; const AAccount : String; const AFile : String);
    procedure DataUpdateGen(const ATotalCommands : LongInt; const ACurrentCommands : LongInt; const ATotalChanges : LongInt; const ACurrentChanges : LongInt);
    procedure DataUpdateScan(const ATotalIDs : LongInt; const ACurrentIDs : LongInt; const ATotalLines : LongInt; const ACurrentLines : LongInt; const ATotalMails : LongInt; const ACurrentMails : LongInt);
  published
    { Published-Deklarationen }
  end;

var
  StatusForm : TStatusForm;

implementation

{$R *.dfm}

{ TStatusForm }

procedure TStatusForm.DataInit(const AScan : Boolean; const AProfileName : String; const AProfilePath : String; const AAccount : String; const AFile : String);
begin
  FCanceled := false;

  ProfileNameLabel.Caption := 'Profile Name: ' + AProfileName;
  ProfilePathLabel.Caption := 'Profile Path: ' + AProfilePath;

  AccountLabel.Caption := 'Account: ' + AAccount;
  FileLabel.Caption    := 'File   : ' + AFile;

  CurrentChangesLabel.Visible  := not(AScan);
  CurrentCommandsLabel.Visible := not(AScan);
  TotalChangesLabel.Visible    := not(AScan);
  TotalCommandsLabel.Visible   := not(AScan);

  CurrentIDsLabel.Visible   := AScan;
  CurrentLinesLabel.Visible := AScan;
  CurrentMailsLabel.Visible := AScan;
  TotalIDsLabel.Visible     := AScan;
  TotalLinesLabel.Visible   := AScan;
  TotalMailsLabel.Visible   := AScan;

  Application.ProcessMessages;
end;

function TStatusForm.IsCanceled: Boolean;
begin
  Result := FCanceled;
end;

procedure TStatusForm.DataUpdateScan(const ATotalIDs : LongInt; const ACurrentIDs : LongInt; const ATotalLines : LongInt; const ACurrentLines : LongInt; const ATotalMails : LongInt; const ACurrentMails : LongInt);
begin
  CurrentIDsLabel.Caption := 'Current IDs: ' + IntToStr(ACurrentIDs);
  TotalIDsLabel.Caption   := 'Total IDs  : ' + IntToStr(ATotalIDs);

  CurrentLinesLabel.Caption := 'Current LNs: ' + IntToStr(ACurrentLines);
  TotalLinesLabel.Caption   := 'Total LNs  : ' + IntToStr(ATotalLines);

  CurrentMailsLabel.Caption := 'Current MLs: ' + IntToStr(ACurrentMails);
  TotalMailsLabel.Caption   := 'Total MLs  : ' + IntToStr(ATotalMails);

  Application.ProcessMessages;
end;

procedure TStatusForm.CancelButtonClick(Sender : TObject);
begin
  FCanceled := (MessageDlg('Do you really want to cancel the process?', mtConfirmation,
                           [mbYes, mbNo], 0) = mrYes);
  if FCanceled then
    Close;
end;

procedure TStatusForm.FormCreate(Sender : TObject);
begin
  FCanceled := false;
end;

procedure TStatusForm.DataUpdateGen(const ATotalCommands : LongInt; const ACurrentCommands : LongInt; const ATotalChanges : LongInt; const ACurrentChanges : LongInt);
begin
  CurrentChangesLabel.Caption := 'Current CHs: ' + IntToStr(ACurrentChanges);
  TotalChangesLabel.Caption   := 'Total CHs: ' + IntToStr(ATotalChanges);

  CurrentCommandsLabel.Caption := 'Current CMs: ' + IntToStr(ACurrentCommands);
  TotalCommandsLabel.Caption   := 'Total CMs: ' + IntToStr(ATotalCommands);

  Application.ProcessMessages;
end;

end.
