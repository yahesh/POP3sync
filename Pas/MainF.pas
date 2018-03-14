unit MainF;

interface

uses
  Windows, SysUtils, Forms, Dialogs, Registry, IniFiles, StdCtrls, ExtCtrls,
  CheckLst, TlHelp32, Classes, Controls, FileCtrl, Graphics;

type
  TThunderbirdAccounts     = array of String;
  TThunderbirdAccountFiles = array of String;

  TThunderbirdLocalIDs = array of String;

  TThunderbirdPopstateStatus = (tpsDeleteFromServer, tpsDoNothing,
                                tpsFetchFromServer, tpsKeepOnServer);
  TThunderbirdPopstate = record
    LocalID  : String;
    RemoteID : String;
    Status   : String;
  end;

  TThunderbirdProfile = record
    Default : Boolean;
    Name    : String;
    Path    : String;
  end;
  TThunderbirdProfiles = array of TThunderbirdProfile;

  TMainForm = class(TForm)
    AccountsBevel : TBevel;
    AccountsCheckListBox : TCheckListBox;
    AccountsLabel : TLabel;
    ActionBevel : TBevel;
    ActionLabel : TLabel;
    AllButton : TButton;
    CopyrightLabel : TLabel;
    DeleteCheckBox : TCheckBox;
    DeleteRadioButton : TRadioButton;
    FetchCheckBox : TCheckBox;
    FetchRadioButton : TRadioButton;
    InvertButton : TButton;
    NoneButton : TButton;
    OptionsBevel : TBevel;
    ProfileBevel : TBevel;
    ProfileComboBox : TComboBox;
    ProfileLabel : TLabel;
    SelectButton : TButton;
    SelectEdit : TEdit;
    StatusBevel : TBevel;
    StatusLabel : TLabel;
    StatusListBox : TListBox;
    SynchronizeButton : TButton;
    VersionLabel : TLabel;

    procedure AllButtonClick(Sender : TObject);
    procedure DeleteRadioButtonClick(Sender : TObject);
    procedure FetchRadioButtonClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure InvertButtonClick(Sender : TObject);
    procedure NoneButtonClick(Sender : TObject);
    procedure ProfileComboBoxChange(Sender : TObject);
    procedure SelectButtonClick(Sender : TObject);
    procedure SelectEditChange(Sender: TObject);
    procedure SynchronizeButtonClick(Sender : TObject);
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    FAccounts       : TThunderbirdAccounts;
    FIgnoreFromMail : Boolean;
    FProfiles       : TThunderbirdProfiles;
  public
    { Public-Deklarationen }
    function CheckSeparate(const APath : String) : String;
    function GetMailPath(const APath : String; const AImap : Boolean; const AAppend : String = '') : String;
    function GetProfileName : String;
    function GetProfilePath : String;
    function IsProcessRunning(const AFileName : String) : Boolean;
    function PopstateToString(const APopstate : TThunderbirdPopstate) : String;
    function RetrieveAccounts(AProfilePath : String; const AImap : Boolean;
                              const AFilter : Boolean) : TThunderbirdAccounts;
    function RetrieveFiles(AAccountPath : String) : TThunderbirdAccountFiles;
    function RetrieveProfiles : TThunderbirdProfiles;
    function StatusToString(const AStatus : TThunderbirdPopstateStatus) : String;
    function StringToPopstate(AString : String) : TThunderbirdPopstate;
    function StringToStatus(const AString : String) : TThunderbirdPopstateStatus;
    function WordToStr2(const AWord : Word) : String;

    procedure AddStatus(const AStatusText : String);
    procedure SwitchEnabled(const AEnabled : Boolean);
  published
    { Published-Deklarationen }
  end;

var
  MainForm : TMainForm;

implementation

uses
  StatusF;

const
  CAllFiles         = '*';
  CLocalPath        = '.';
  CDeleteFromServer = 'd';
  CDoNothing        = 'b';
  CFetchFromServer  = 'f';
  CUpdateLimit      = 5120;
  CImapMailPath     = 'ImapMail\';
  CKeepOnServer     = 'k';
  CMailPath         = 'Mail\';
  CPathSeparator    = '\';
  CPopstateDat      = 'popstate.dat';
  CSeparator        = ' ';
  CSlash            = '/';
  CSyncPath         = 'Sync\';

{$R *.dfm}

{ TMainForm }

procedure TMainForm.AddStatus(const AStatusText : String);
var
  LHour    : Word;
  LMinute  : Word;
  LMSecond : Word;
  LSecond  : Word;
  LTime    : String;
  LWidth   : LongInt;
begin
  DecodeTime(Now, LHour, LMinute, LSecond, LMSecond);
  LTime := WordToStr2(LHour) + ':' + WordToStr2(LMinute) + ':' + WordToStr2(LSecond);

  LWidth := Trunc(StatusListBox.Canvas.TextWidth('[' + LTime + '] ' + AStatusText) * 1.5);
  if (StatusListBox.ScrollWidth < LWidth) then
    StatusListBox.ScrollWidth := LWidth;

  StatusListBox.Items.Add('[' + LTime + '] ' + AStatusText);
  StatusListBox.ItemIndex := Pred(StatusListBox.Items.Count);
end;

function TMainForm.RetrieveProfiles : TThunderbirdProfiles;
  function ReplaceSlash(const APath : String) : String;
  var
    LPos : LongInt;
  begin
    Result := APath;
    repeat
      LPos := Pos(CSlash, Result);
      if (LPos > 0) then
        Result[LPos] := CPathSeparator;
    until (LPos <= 0);
  end;

const
  CDefaultValue    = 'Default';
  CIsRelativeValue = 'IsRelative';
  CKey             = 'Volatile Environment';
  CNameValue       = 'Name';
  CPathValue       = 'Path';
  CProfilesIni     = 'profiles.ini';
  CProfilesIniPath = 'Thunderbird\';
  CProfileSection  = 'Profile';
  CRootKey         = HKEY_CURRENT_USER;
  CValue           = 'APPDATA';
var
  LCount           : LongInt;
  LIniFile         : TIniFile;
  LPath            : String;
  LProfilesIniPath : String;
  LRegistry        : TRegistry;
begin
  SetLength(Result, 0);

  SetLength(LProfilesIniPath, 0);
  LRegistry := TRegistry.Create(KEY_READ);
  try
    LRegistry.RootKey := CRootKey;

    if LRegistry.OpenKey(CKey, false) then
    begin
      try
        if LRegistry.ValueExists(CValue) then
          LProfilesIniPath := CheckSeparate(LRegistry.ReadString(CValue)) + CProfilesIniPath;
      finally
        LRegistry.CloseKey;
      end;
    end;
  finally
    LRegistry.Free;
  end;

  if (Length(LProfilesIniPath) > 0) then
  begin
    if FileExists(LProfilesIniPath + CProfilesIni) then
    begin
      LIniFile := TIniFile.Create(LProfilesIniPath + CProfilesIni);
      try
        LCount := 0;
        while LIniFile.SectionExists(CProfileSection + IntToStr(LCount)) do
        begin
          if (LIniFile.ValueExists(CProfileSection + IntToStr(LCount), CNameValue) and
              LIniFile.ValueExists(CProfileSection + IntToStr(LCount), CPathValue)) then
          begin
            LPath := CheckSeparate(LIniFile.ReadString(CProfileSection + IntToStr(LCount), CPathValue, ''));
            if LIniFile.ReadBool(CProfileSection + IntToStr(LCount), CIsRelativeValue, false) then
              LPath := LProfilesIniPath + ReplaceSlash(LPath);
            if DirectoryExists(LPath) then
            begin
              SetLength(Result, Succ(Length(Result)));
              Result[High(Result)].Default := LIniFile.ReadBool(CProfileSection + IntToStr(LCount),
                                                                CDefaultValue, false);
              Result[High(Result)].Name    := LIniFile.ReadString(CProfileSection + IntToStr(LCount),
                                                                  CNameValue, 'Unknown');
              Result[High(Result)].Path    := LPath;
            end;
          end;

          Inc(LCount);
        end;
      finally
        LIniFile.Free;
      end;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender : TObject);
const
  CParamA  = '-ignore-from';
  CParamB  = '-if';
  CProcess = 'thunderbird.exe';
var
  LDefault : LongInt;
  LIndex   : LongInt;
begin
  FIgnoreFromMail := false;
  for LIndex := 1 to ParamCount do
  begin
    if ((AnsiLowerCase(Trim(ParamStr(LIndex))) = CParamA) or
        (AnsiLowerCase(Trim(ParamStr(LIndex))) = CParamB)) then
      FIgnoreFromMail := true;
  end;

  AccountsCheckListBox.Items.Clear;
  ProfileComboBox.Items.Clear;
  StatusListBox.Items.Clear;
  StatusListBox.ScrollWidth := 0;

  AddStatus('Application started');

  AddStatus('Retrieving Thunderbird profiles');
  FProfiles := RetrieveProfiles;
  for LIndex := 0 to Pred(Length(FProfiles)) do
  begin
    ProfileComboBox.Items.Add(FProfiles[LIndex].Name);

    AddStatus('  ' + FProfiles[LIndex].Name + ' retrieved');
  end;
  ProfileComboBox.Items.Add('...Custom Location...');
  AddStatus(IntToStr(Length(FProfiles)) + ' Thunderbird profiles retrieved');

  ProfileComboBox.ItemIndex := -1;
  if (Length(FProfiles) > 0) then
  begin
    LDefault := 0;
    for LIndex := 1 to Pred(Length(FProfiles)) do
    begin
      if FProfiles[LIndex].Default then
      begin
        LDefault := LIndex;

        Break;
      end;
    end;

    ProfileComboBox.ItemIndex := LDefault;
  end
  else
    ProfileComboBox.ItemIndex := Pred(ProfileComboBox.Items.Count);
  DeleteRadioButtonClick(nil);
  ProfileComboBoxChange(nil);
//  SelectEditChange(nil);

  if IsProcessRunning(CProcess) then
    MessageDlg('"' + CProcess + '" is found to be running.' + #13#10 +
               'It is recommended to close Thunderbird before proceeding with the synchronization.',
               mtWarning, [mbOK], 0);
end;

function TMainForm.RetrieveAccounts(AProfilePath : String; const AImap : Boolean;
                                    const AFilter : Boolean) : TThunderbirdAccounts;
var
  LEntry     : String;
  LSearchRec : TSearchRec;
begin
  SetLength(Result, 0);

  AProfilePath := GetMailPath(AProfilePath, AImap);
  if DirectoryExists(AProfilePath) then
  begin
    if (FindFirst(AProfilePath + CAllFiles, faAnyFile, LSearchRec) = 0) then
    begin
      try
        repeat
          if ((LSearchRec.Attr and faDirectory) <> 0) then
          begin
            LEntry := LSearchRec.Name;
            if ((LEntry <> CLocalPath) and
                (LEntry <> '..')) then
            begin
              if (FileExists(CheckSeparate(AProfilePath + LEntry) + CPopstateDat) or
                  not(AFilter) or AImap) then
              begin
                SetLength(Result, Succ(Length(Result)));
                Result[High(Result)] := LEntry;
              end;
            end;
          end;
        until (FindNext(LSearchRec) <> 0);
      finally
        FindClose(LSearchRec);
      end;
    end;
  end;
end;

function TMainForm.CheckSeparate(const APath : String) : String;
begin
  Result := APath;
  if (Result[Length(Result)] <> CPathSeparator) then
    Result := Result + CPathSeparator;
end;

procedure TMainForm.ProfileComboBoxChange(Sender : TObject);
begin
  SelectButton.Enabled := (ProfileComboBox.ItemIndex = Pred(ProfileComboBox.Items.Count));
  SelectEdit.ReadOnly  := (ProfileComboBox.ItemIndex <> Pred(ProfileComboBox.Items.Count));
  SelectEdit.TabStop   := (ProfileComboBox.ItemIndex = Pred(ProfileComboBox.Items.Count));
  if (ProfileComboBox.ItemIndex <> Pred(ProfileComboBox.Items.Count)) then
    SelectEdit.Font.Color := clInactiveCaptionText
  else
    SelectEdit.Font.Color := clWindowText;

  SelectEdit.Text := GetProfilePath;
//  SelectEditChange(nil);
end;

procedure TMainForm.AllButtonClick(Sender : TObject);
var
  LIndex : LongInt;
begin
  for LIndex := 0 to Pred(AccountsCheckListBox.Items.Count) do
    AccountsCheckListBox.Checked[LIndex] := true;
end;

procedure TMainForm.NoneButtonClick(Sender: TObject);
var
  LIndex : LongInt;
begin
  for LIndex := 0 to Pred(AccountsCheckListBox.Items.Count) do
    AccountsCheckListBox.Checked[LIndex] := false;
end;

procedure TMainForm.InvertButtonClick(Sender: TObject);
var
  LIndex : LongInt;
begin
  for LIndex := 0 to Pred(AccountsCheckListBox.Items.Count) do
    AccountsCheckListBox.Checked[LIndex] := not(AccountsCheckListBox.Checked[LIndex]);
end;

procedure TMainForm.SwitchEnabled(const AEnabled : Boolean);
begin
  AccountsCheckListBox.Enabled := AEnabled;
  AllButton.Enabled            := AEnabled;
  DeleteCheckBox.Enabled       := (DeleteRadioButton.Checked and AEnabled);
  DeleteRadioButton.Enabled    := AEnabled;
  FetchCheckBox.Enabled        := (FetchRadioButton.Checked and AEnabled);
  FetchRadioButton.Enabled     := AEnabled;
  InvertButton.Enabled         := AEnabled;
//  MainForm.Enabled             := AEnabled;
  NoneButton.Enabled           := AEnabled;
  ProfileComboBox.Enabled      := AEnabled;
  SelectButton.Enabled         := AEnabled;
  SelectEdit.Enabled           := AEnabled;
  SynchronizeButton.Enabled    := AEnabled;
end;

function TMainForm.IsProcessRunning(const AFileName : String) : Boolean;
var
  LHandle         : THandle;
  LProcessEntry32 : TProcessEntry32;
begin
  Result := false;

  LHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    LProcessEntry32.dwSize := SizeOf(LProcessEntry32);

    if Process32First(LHandle, LProcessEntry32) then
    begin
      repeat
        Result := ((AnsiLowerCase(LProcessEntry32.szExeFile) = AnsiLowerCase(AFileName)) or
                   (AnsiLowerCase(ExtractFileName(LProcessEntry32.szExeFile)) = AnsiLowerCase(AFileName)));
        if Result then
          Break;
      until not(Process32Next(LHandle, LProcessEntry32));
    end;
  finally
    CloseHandle(LHandle);
  end;
end;

procedure TMainForm.SynchronizeButtonClick(Sender : TObject);
  procedure AddValue(var AList : TThunderbirdLocalIDs; var ACount : LongInt;
                     const AValue : String; const AGrowthFactor : LongInt);
  begin
    while (ACount >= Length(AList)) do
      SetLength(AList, Length(AList) + AGrowthFactor);

    AList[ACount] := AValue;
    Inc(ACount);
  end;

  function FindEntryInList(const AList : TThunderbirdLocalIDs; const AEntry : String) : LongInt;
  var
    LIndex : LongInt;
  begin
    Result := -1;

    for LIndex := 0 to Pred(Length(AList)) do
    begin
      if (AList[LIndex] = AEntry) then
      begin
        Result := LIndex;

        Break;
      end;
    end;
  end;

  function GenerateAccountPopstate(const AProfile : String; const AAccount : String;
                                   const ADelete : Boolean; const ALocalIDs : TThunderbirdLocalIDs;
                                   var ATotalCommands : LongInt; var ATotalChanges : LongInt;
                                   var AFileCount : LongInt) : Boolean;
  const
    CCopyCount = 4;
  var
    LAccount         : String;
    LCurrentChanges  : LongInt;
    LCurrentCommands : LongInt;
    LNextLine        : String;
    LPopstate        : TThunderbirdPopstate;
    LProfile         : String;
    LReadFile        : TextFile;
    LUpdateCount     : Word;
    LWriteFile       : TextFile;
    LWriteLine       : Boolean;
  begin
    Result := false;

    LProfile := CheckSeparate(AProfile);
    if DirectoryExists(GetMailPath(LProfile, false, AAccount)) then
    begin
      LCurrentChanges  := 0;
      LCurrentCommands := 0;

      StatusForm.DataInit(false, GetProfileName, LProfile, GetMailPath(CLocalPath, false, AAccount), CPopstateDat);
      StatusForm.DataUpdateGen(ATotalCommands, LCurrentCommands, ATotalChanges, LCurrentChanges);

      LAccount := CheckSeparate(GetMailPath(LProfile, false, AAccount)) + CPopstateDat;
      if FileExists(LAccount) then
      begin
        AddStatus('    Generating ' + GetMailPath(CLocalPath, false, AAccount));
        AssignFile(LReadFile, LAccount);
        Reset(LReadFile);
        try
          if ForceDirectories(LProfile + CSyncPath) then
          begin
            AssignFile(LWriteFile, LProfile + CSyncPath + AAccount + '_' + CPopstateDat);
            Rewrite(LWriteFile);
            try
              LUpdateCount := 0;
              while not(EoF(LReadFile)) do
              begin
                ReadLn(LReadFile, LNextLine);
                LNextLine := Trim(LNextLine);

                if (LCurrentCommands < CCopyCount) then
                begin
                  WriteLn(LWriteFile, LNextLine);
                  Inc(LCurrentCommands);
                  Inc(ATotalCommands);
                end
                else
                begin
                  if (Length(LNextLine) > 0) then
                  begin
                    LWriteLine := false;

                    LPopstate := StringToPopstate(LNextLine);
                    try
                      if ADelete then
                      begin
                        if (FindEntryInList(ALocalIDs, LPopstate.LocalID) < 0) then
                        begin
                          LPopstate.Status := StatusToString(tpsDeleteFromServer);
                          Inc(LCurrentChanges);
                          Inc(ATotalChanges);
                        end;

                        LWriteLine := true;
                      end
                      else
                      begin
                        LWriteLine := (FindEntryInList(ALocalIDs, LPopstate.LocalID) >= 0);
                        if not(LWriteLine) then
                        begin
                          Inc(LCurrentChanges);
                          Inc(ATotalChanges);
                        end;
                      end;
                    finally
                      if LWriteLine then
                      begin
                        WriteLn(LWriteFile, PopstateToString(LPopstate));
                        Inc(LCurrentCommands);
                        Inc(ATotalCommands);
                      end;
                    end;
                  end;
                end;

                Inc(LUpdateCount);
                if (LUpdateCount > CUpdateLimit) then
                begin
                  StatusForm.DataUpdateGen(ATotalCommands, LCurrentCommands,
                                           ATotalChanges, LCurrentChanges);
                  Result := StatusForm.IsCanceled;
                  if Result then
                    Break;

                  LUpdateCount := 0;
                end;
              end;
            finally
              CloseFile(LWriteFile);
            end;
          end;
        finally
          CloseFile(LReadFile);
        end;
        AddStatus('      ' + IntToStr(LCurrentChanges) + ' changes in ' + GetMailPath(CLocalPath, false, AAccount));
        AddStatus('      ' + IntToStr(LCurrentCommands) + ' commands in ' + GetMailPath(CLocalPath, false, AAccount));

        if not(Result) then
        begin
          if FileExists(LProfile + CSyncPath + AAccount + '_' + CPopstateDat) then
          begin
            AddStatus('    ' + GetMailPath(CLocalPath, false, AAccount) + ' generated');
            Inc(AFileCount);
          end;
        end;
      end;
    end;
  end;

  function GetCurrentTime : String;
  var
    LDay     : Word;
    LHour    : Word;
    LMinute  : Word;
    LMonth   : Word;
    LMSecond : Word;
    LSecond  : Word;
    LYear    : Word;
  begin
    DecodeDate(Now, LYear, LMonth, LDay);
    DecodeTime(Now, LHour, LMinute, LSecond, LMSecond);

    Result := WordToStr2(LYear) + WordToStr2(LMonth) + WordToStr2(LDay) + '_' +
              WordToStr2(LHour) + WordToStr2(LMinute) + WordToStr2(LSecond);
  end;

  function GetMailPath2(const AImap : Boolean) : String;
  begin
    if AImap then
      Result := CImapMailPath
    else
      Result := CMailPath;
  end;

  function GetRelativeFile(const AAbsoluteAccount : String; const AAbsoluteFile : String) : String;
  begin
    Result := Copy(AAbsoluteFile, Succ(Length(AAbsoluteAccount)), Length(AAbsoluteFile) - Length(AAbsoluteAccount));
  end;

  function GetUIDLCancel(const ADelete : Boolean; const ATotalIDs : LongInt; const ATotalMails : LongInt) : Boolean;
  begin
    if ADelete then
      Result := (MessageDlg('The number of local IDs does not match the number of mails.' + #13#10 +
                            'Up to ' + IntToStr(ATotalMails - ATotalIDs) + ' mails could be deleted from the server even though they are still in use.' + #13#10 +
                            'Do you really want to proceed?', mtWarning, [mbYes, mbNo], 0) = mrNo)
    else
      Result := (MessageDlg('The number of local IDs does not match the number of mails.' + #13#10 +
                            'Up to ' + IntToStr(ATotalMails - ATotalIDs) + ' mails could be fetched from the server even though they are still available.' + #13#10 +
                            'Do you really want to proceed?', mtWarning, [mbYes, mbNo], 0) = mrNo);
  end;

  function ScanAccountForUIDLs(const AProfile : String; const AAccount : String; const AImap : Boolean;
                               const ADelete : Boolean; var ALocalIDs : TThunderbirdLocalIDs;
                               var ATotalIDs : LongInt; var ATotalLines : LongInt; var ATotalMails : LongInt) : Boolean;
  const
    CFromText     = 'From ';
    CFromMailText = 'From:';
    CGrowthFactor = 1024;
    CUIDLText     = 'X-UIDL:';
  var
    LAccountFiles  : TThunderbirdAccountFiles;
    LCurrentIDs    : LongInt;
    LCurrentLines  : LongInt;
    LCurrentMails  : LongInt;
    LIndex         : LongInt;
    LNextLine      : String;
    LPos           : LongInt;
    LProfile       : String;
    LReadFile      : TextFile;
    LUpdateCount   : Word;
    LWaitForMail   : Boolean;
  begin
    Result := false;

    LProfile := CheckSeparate(AProfile);
    if DirectoryExists(GetMailPath(LProfile, AImap, AAccount)) then
    begin
      LAccountFiles := RetrieveFiles(CheckSeparate(GetMailPath(LProfile, AImap, AAccount)));
      AddStatus('    Scanning ' + GetMailPath(CLocalPath, AImap, AAccount));
      for LIndex := 0 to Pred(Length(LAccountFiles)) do
      begin
        LCurrentIDs   := 0;
        LCurrentLines := 0;
        LCurrentMails := 0;

        StatusForm.DataInit(true, GetProfileName, LProfile, GetMailPath(CLocalPath, AImap, AAccount),
                            GetRelativeFile(CheckSeparate(GetMailPath(LProfile, AImap, AAccount)), LAccountFiles[LIndex]));
        StatusForm.DataUpdateScan(ATotalIDs, LCurrentIDs, ATotalLines, LCurrentLines, ATotalMails, LCurrentMails);

        AssignFile(LReadFile, LAccountFiles[LIndex]);
        Reset(LReadFile);
        try
          LUpdateCount := 0;
          LWaitForMail := not(ADelete);
          while not(EoF(LReadFile)) do
          begin
            ReadLn(LReadFile, LNextLine);
            LNextLine := Trim(LNextLine);
            Inc(LCurrentLines);
            Inc(ATotalLines);

            if not(FIgnoreFromMail) then
            begin
              if (Pos(AnsiLowerCase(CFromMailText), AnsiLowerCase(LNextLine)) = 1) then
                LWaitForMail := not(ADelete);
            end;
            if not(LWaitForMail) then
            begin
              LPos := Pos(AnsiLowerCase(CUIDLText), AnsiLowerCase(LNextLine));
              if (LPos = 1) then
              begin
                LNextLine := Trim(Copy(LNextLine, Succ(Length(CUIDLText)), Length(LNextLine) - Length(CUIDLText)));
                AddValue(ALocalIDs, ATotalIDs, LNextLine, CGrowthFactor);
                Inc(LCurrentIDs);

                if not(ADelete) then
                  LWaitForMail := true;
              end;
            end;
            if (Pos(AnsiLowerCase(CFromText), AnsiLowerCase(LNextLine)) = 1) then
            begin
              Inc(LCurrentMails);
              Inc(ATotalMails);

              LWaitForMail := false;
            end;

            Inc(LUpdateCount);
            if (LUpdateCount > CUpdateLimit) then
            begin
              StatusForm.DataUpdateScan(ATotalIDs, LCurrentIDs, ATotalLines,
                                        LCurrentLines, ATotalMails, LCurrentMails);
              Result := StatusForm.IsCanceled;
              if Result then
                Break;

              LUpdateCount := 0;
            end;
          end;
        finally
          CloseFile(LReadFile);
        end;
        AddStatus('      ' + IntToStr(LCurrentIDs) + ' IDs in ' + GetRelativeFile(CheckSeparate(GetMailPath(LProfile, AImap, AAccount)), LAccountFiles[LIndex]));
        AddStatus('      ' + IntToStr(LCurrentMails) + ' mails in ' + GetRelativeFile(CheckSeparate(GetMailPath(LProfile, AImap, AAccount)), LAccountFiles[LIndex]));

        if Result then
          Break;
      end;
      AddStatus('    ' + GetMailPath(CLocalPath, AImap, AAccount) + ' scanned');
    end;
  end;

  function ScanProfileForUIDLs(const AProfile : String; const AImap : Boolean; const ADelete : Boolean;
                               var ALocalIDs : TThunderbirdLocalIDs; var ATotalIDs : LongInt;
                               var ATotalLines : LongInt; var ATotalMails : LongInt) : Boolean;
  var
    LAccountFolders : TThunderbirdAccounts;
    LIndex          : LongInt;
    LProfile        : String;
  begin
    Result := false;

    LProfile := CheckSeparate(AProfile);
    if DirectoryExists(LProfile) then
    begin
      LAccountFolders := RetrieveAccounts(LProfile, AImap, false);
      for LIndex := 0 to Pred(Length(LAccountFolders)) do
      begin
        Result := ScanAccountForUIDLs(LProfile, LAccountFolders[LIndex], AImap, ADelete, ALocalIDs,
                                      ATotalIDs, ATotalLines, ATotalMails);
        if Result then
          Break;
      end;
    end;
  end;

const
  CBackupPath = 'backup\';
  CLockFile   = 'parent.lock';
var
  LAccount         : String;
  LCanceled        : Boolean;
  LCheckAll        : Boolean;
  LCurrentIDs      : LongInt;
  LCurrentMails    : LongInt;
  LDelete          : Boolean;
  LFileCount       : LongInt;
  LIndex           : LongInt;
  LLocalIDs        : TThunderbirdLocalIDs;
  LProfile         : String;
  LSyncCount       : LongInt;
  LTotalChanges    : LongInt;
  LTotalCommands   : LongInt;
  LTotalIDs        : LongInt;
  LTotalLines      : LongInt;
  LTotalMails      : LongInt;
begin
  LCanceled  := false;
  LFileCount := 0;
  SetLength(LLocalIDs, 0);
  LSyncCount     := 0;
  LTotalChanges  := 0;
  LTotalCommands := 0;
  LTotalIDs      := 0;
  LTotalLines    := 0;
  LTotalMails    := 0;

  SwitchEnabled(false);
  try
    AddStatus('Synchronizing accounts');
    LProfile := GetProfilePath;
    if DirectoryExists(LProfile) then
    begin
      if FileExists(LProfile + CLockFile) then
        LCanceled := (MessageDlg('The selected profile is currently in use.' + #13#10 +
                                 'It is recommended to close Thunderbird before proceeding with the synchronization.' + #13#10 +
                                 'Do you really want to proceed?', mtWarning, [mbYes, mbNo], 0) = mrNo);

      if not(LCanceled) then
      begin
        LDelete   := DeleteRadioButton.Checked;
        LCheckAll := ((LDelete and DeleteCheckBox.Checked) or
                      (not(LDelete) and FetchCheckBox.Checked));
        if LCheckAll then
        begin
          AddStatus('  Retrieving local IDs');
          StatusForm.Show;
          try
            LCanceled := ScanProfileForUIDLs(LProfile, true, LDelete, LLocalIDs, LTotalIDs,
                                             LTotalLines, LTotalMails);
            if not(LCanceled) then
              LCanceled := ScanProfileForUIDLs(LProfile, false, LDelete, LLocalIDs, LTotalIDs,
                                               LTotalLines, LTotalMails);
          finally
            StatusForm.Close;
          end;
          SetLength(LLocalIDs, LTotalIDs);
          AddStatus('  ' + IntToStr(LTotalIDs) + ' local IDs retrieved');
          AddStatus('  ' + IntToStr(LTotalMails) + ' mails found');

          if not(LCanceled) then
          begin
            AddStatus('  Generating popstate files');
            StatusForm.Show;
            try
              for LIndex := 0 to Pred(Length(FAccounts)) do
              begin
                if AccountsCheckListBox.Checked[LIndex] then
                begin
                  LCanceled := GenerateAccountPopstate(LProfile, FAccounts[LIndex], LDelete,
                                                       LLocalIDs, LTotalCommands, LTotalChanges,
                                                       LFileCount);
                  if (LCanceled) then
                    Break;
                end;
              end;
            finally
              StatusForm.Close;
            end;
            AddStatus('  ' + IntToStr(LFileCount) + ' popstate files generated');
            AddStatus('  ' + IntToStr(LTotalChanges) + ' changes written');
            AddStatus('  ' + IntToStr(LTotalCommands) + ' commands written');
          end;
        end
        else
        begin
          for LIndex := 0 to Pred(Length(FAccounts)) do
          begin
            if AccountsCheckListBox.Checked[LIndex] then
            begin
              LCurrentIDs   := 0;
              LCurrentMails := 0;
              SetLength(LLocalIDs, 0);
              LTotalLines := 0;

              AddStatus('  Retrieving local IDs');
              StatusForm.Show;
              try
                LCanceled := ScanAccountForUIDLs(LProfile, FAccounts[LIndex], false,
                                                 LDelete, LLocalIDs, LCurrentIDs,
                                                 LTotalLines, LCurrentMails);
              finally
                StatusForm.Close;
              end;
              SetLength(LLocalIDs, LCurrentIDs);
              LTotalIDs   := LTotalIDs + LCurrentIDs;
              LTotalMails := LTotalMails + LCurrentMails;
              AddStatus('  ' + IntToStr(LCurrentIDs) + ' local IDs retrieved');
              AddStatus('  ' + IntToStr(LCurrentMails) + ' mails found');

              if not(LCanceled) then
              begin
                AddStatus('  Generating popstate file');
                StatusForm.Show;
                try
                  LCanceled := GenerateAccountPopstate(LProfile, FAccounts[LIndex], LDelete,
                                                       LLocalIDs, LTotalCommands, LTotalChanges,
                                                       LFileCount);
                finally
                  StatusForm.Close;
                end;
                AddStatus('  ' + IntToStr(LFileCount) + ' popstate files generated');
                AddStatus('  ' + IntToStr(LTotalChanges) + ' changes written');
                AddStatus('  ' + IntToStr(LTotalCommands) + ' commands written');

                if LCanceled then
                  Break;
              end
              else
                Break;
            end;
          end;
        end;

        if not(LCanceled) then
        begin
          if (LTotalMails <> LTotalIDs) then
          begin
            AddStatus('  Number of local IDs and number of mails do not match');
            LCanceled := GetUIDLCancel(LDelete, LTotalIDs, LTotalMails);
          end;

          if not(LCanceled) then
          begin
            LCanceled := (MessageDlg(IntToStr(LFileCount) + ' popstate files have been generated.' + #13#10 +
                                     'They and are now ready to be deployed.' + #13#10 +
                                     'Backup files will be created for security reasons.' + #13#10 +
                                     'Do you really want to proceed?', mtInformation, [mbYes, mbNo], 0) = mrNo);
            if not(LCanceled) then
            begin
              AddStatus('  Deploying popstate files');
              for LIndex := 0 to Pred(Length(FAccounts)) do
              begin
                if AccountsCheckListBox.Checked[LIndex] then
                begin
                  LAccount := CheckSeparate(LProfile + CMailPath + FAccounts[LIndex]) + CPopstateDat;
                  if (FileExists(LAccount) and
                      FileExists(LProfile + CSyncPath + FAccounts[LIndex] + '_' + CPopstateDat)) then
                  begin
                    AddStatus('    Deploying ' + CheckSeparate(FAccounts[LIndex]) + CPopstateDat);

                    if ForceDirectories(LProfile + CBackupPath) then
                    begin
                      RenameFile(LAccount, LProfile + CBackupPath + FAccounts[LIndex] + '_' + GetCurrentTime + '_' + CPopstateDat);
                      RenameFile(LProfile + CSyncPath + FAccounts[LIndex] + '_' + CPopstateDat, LAccount);
                      Inc(LSyncCount);
                    end;

                    AddStatus('    ' + CheckSeparate(FAccounts[LIndex]) + CPopstateDat + ' deployed');
                  end;
                end;
              end;
              AddStatus('  ' + IntToStr(LSyncCount) + ' popstate files deployed');
            end;
          end;
        end;
      end;
    end
    else
      AddStatus('The selected profile does not exist.');
    AddStatus(IntToStr(LSyncCount) + ' accounts synchronized');

    if LCanceled then
    begin
      AddStatus('SYNCHRONIZATION HAS BEEN ABORTED');
      MessageDlg('The synchronization has been aborted.', mtWarning, [mbOK], 0);
    end
    else
    begin
      AddStatus('SYNCHRONIZATION HAS BEEN SUCCESSFUL');
      MessageDlg('The synchronization has been successful.' + #13#10 + 'Please execute the "Get Mail" function immediately.', mtInformation, [mbOK], 0);
    end;
  finally
    SwitchEnabled(true);
  end;
end;

function TMainForm.StatusToString(const AStatus : TThunderbirdPopstateStatus) : String;
begin
  Result := CKeepOnServer;

  case AStatus of
    tpsDeleteFromServer : Result := CDeleteFromServer;
    tpsDoNothing        : Result := CDoNothing;
    tpsFetchFromServer  : Result := CFetchFromServer;
    tpsKeepOnServer     : Result := CKeepOnServer;
  end;
end;

function TMainForm.StringToStatus(const AString : String) : TThunderbirdPopstateStatus;
begin
  Result := tpsKeepOnServer;

  if (AnsiLowerCase(AString) = AnsiLowerCase(CDeleteFromServer)) then
    Result := tpsDeleteFromServer;
  if (AnsiLowerCase(AString) = AnsiLowerCase(CDoNothing)) then
    Result := tpsDoNothing;
  if (AnsiLowerCase(AString) = AnsiLowerCase(CFetchFromServer)) then
    Result := tpsFetchFromServer;
  if (AnsiLowerCase(AString) = AnsiLowerCase(CKeepOnServer)) then
    Result := tpsKeepOnServer;
end;

function TMainForm.WordToStr2(const AWord : Word) : String;
begin
  Result := IntToStr(AWord);
  if (Length(Result) < 2) then
    Result := '0' + Result;
end;

function TMainForm.RetrieveFiles(AAccountPath : String) : TThunderbirdAccountFiles;
const
  CFileCheckExt   = '.msf';
  CFolderCheckExt = '.sbd';
var
  LEntry     : String;
  LIndex     : LongInt;
  LPos       : LongInt;
  LSearchRec : TSearchRec;
  LTemp      : TThunderbirdAccountFiles;
begin
  SetLength(Result, 0);

  AAccountPath := CheckSeparate(AAccountPath);
  if DirectoryExists(AAccountPath) then
  begin
    if (FindFirst(AAccountPath + CAllFiles, faAnyFile, LSearchRec) = 0) then
    begin
      try
        repeat
          LEntry := LSearchRec.Name;
          if ((LSearchRec.Attr and faDirectory) <> 0) then
          begin
            if ((LEntry <> CLocalPath) and
                (LEntry <> '..')) then
            begin
              LPos := Pos(AnsiLowerCase(CFolderCheckExt), AnsiLowerCase(LEntry));
              if ((LPos > 0) and
                  (Pred(LPos + Length(CFolderCheckExt)) = Length(LEntry))) then
              begin
                LTemp := RetrieveFiles(CheckSeparate(AAccountPath + LEntry));
                if (Length(LTemp) > 0) then
                begin
                  for LIndex := 0 to Pred(Length(LTemp)) do
                  begin
                    SetLength(Result, Succ(Length(Result)));
                    Result[High(Result)] := LTemp[LIndex];
                  end;
                end;
              end;
            end;
          end
          else
          begin
            if FileExists(AAccountPath + LEntry + CFileCheckExt) then
            begin
              SetLength(Result, Succ(Length(Result)));
              Result[High(Result)] := AAccountPath + LEntry;
            end;
          end;
        until (FindNext(LSearchRec) <> 0);
      finally
        FindClose(LSearchRec);
      end;
    end;
  end;
end;

function TMainForm.PopstateToString(const APopstate : TThunderbirdPopstate) : String;
begin
  Result := APopstate.Status + CSeparator + APopstate.LocalID + CSeparator + APopstate.RemoteID;
end;

function TMainForm.StringToPopstate(AString : String) : TThunderbirdPopstate;
var
  LPos : LongInt;
begin
  Result.LocalID  := '';
  Result.RemoteID := '';
  Result.Status   := '';

  AString := Trim(AString);

  LPos := Pos(CSeparator, AString);
  if (LPos > 0) then
  begin
    Result.Status := Trim(Copy(AString, 1, Pred(LPos)));
    Delete(AString, 1, LPos);
    AString := Trim(AString);
  end
  else
  begin
    Result.Status := AString;
    SetLength(AString, 0);
  end;

  LPos := Pos(CSeparator, AString);
  if (LPos > 0) then
  begin
    Result.LocalID := Trim(Copy(AString, 1, Pred(LPos)));
    Delete(AString, 1, LPos);
    AString := Trim(AString);
  end
  else
  begin
    Result.LocalID := AString;
    SetLength(AString, 0);
  end;

  LPos := Pos(CSeparator, AString);
  if (LPos > 0) then
  begin
    Result.RemoteID := Trim(Copy(AString, 1, Pred(LPos)));
    Delete(AString, 1, LPos);
    AString := Trim(AString);
  end
  else
  begin
    Result.RemoteID := AString;
    SetLength(AString, 0);
  end;
end;

procedure TMainForm.SelectButtonClick(Sender : TObject);
var
  LDirectory : String;
begin
  LDirectory := SelectEdit.Text;
  if SelectDirectory(LDirectory, [], 0) then
    SelectEdit.Text := LDirectory;
end;

procedure TMainForm.SelectEditChange(Sender : TObject);
var
  LIndex : LongInt;
begin
  AccountsCheckListBox.Items.Clear;

  if DirectoryExists(SelectEdit.Text) then
  begin
    SelectEdit.Color := $C6FFC6;

    AddStatus('Retrieving POP3 accounts');
    FAccounts := RetrieveAccounts(SelectEdit.Text, false, true);
    for LIndex := 0 to Pred(Length(FAccounts)) do
    begin
      AccountsCheckListBox.Items.Add(FAccounts[LIndex]);
      AccountsCheckListBox.Checked[Pred(AccountsCheckListBox.Items.Count)] := true;

      AddStatus('  ' + GetMailPath(CLocalPath, false, FAccounts[LIndex]) + ' retrieved');
    end;
    AddStatus(IntToStr(Length(FAccounts)) + ' POP3 accounts retrieved');
  end
  else
    SelectEdit.Color := $C6C6FF;
end;

function TMainForm.GetProfilePath : String;
begin
  Result := '';

  if (ProfileComboBox.ItemIndex = Pred(ProfileComboBox.Items.Count)) then
    Result := SelectEdit.Text
  else
  begin
    if ((ProfileComboBox.ItemIndex >= 0) and
        (ProfileComboBox.ItemIndex < Length(FProfiles))) then
      Result := FProfiles[ProfileComboBox.ItemIndex].Path;
  end;

  if (Length(Result) > 0) then
    Result := CheckSeparate(Result);
end;

function TMainForm.GetMailPath(const APath : String; const AImap : Boolean; const AAppend : String = '') : String;
begin
  Result := CheckSeparate(APath);
  if (Result = CLocalPath + CPathSeparator) then
    Result := '';
    
  if AImap then
    Result := Result + CImapMailPath
  else
    Result := Result + CMailPath;

  Result := Result + AAppend;
end;

function TMainForm.GetProfileName : String;
begin
  Result := 'Custom';

  if (ProfileComboBox.ItemIndex <> Pred(ProfileComboBox.Items.Count)) then
  begin
    if ((ProfileComboBox.ItemIndex >= 0) and
        (ProfileComboBox.ItemIndex < Length(FProfiles))) then
      Result := FProfiles[ProfileComboBox.ItemIndex].Name;
  end;
end;

procedure TMainForm.DeleteRadioButtonClick(Sender : TObject);
begin
  DeleteCheckBox.Enabled := DeleteRadioButton.Checked;
  FetchCheckBox.Enabled  := not(DeleteRadioButton.Checked);
end;

procedure TMainForm.FetchRadioButtonClick(Sender : TObject);
begin
  DeleteCheckBox.Enabled := not(FetchRadioButton.Checked);
  FetchCheckBox.Enabled  := FetchRadioButton.Checked;
end;

end.
