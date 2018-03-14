object MainForm: TMainForm
  Left = 298
  Top = 58
  Cursor = crArrow
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'POP3sync | Thunderbird'
  ClientHeight = 593
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    999999999999999999999999999994444F00F40F444444444444444444499C44
    4F00F40F444444444444444444499CC44F0F0F0F444444440000004444499CCC
    4F0F0F0F444440008888880044499CCCCF04F00F444008888888888804499CCC
    CF00000F4008F8F8F8F8888804499CCCCF04F00F0F8F88888888800004499CCC
    CF0F0040F8F8F8F8F800078804499CCCCCF0040F8F888F880077787804499CCC
    CCCFC0F8F8F8F8F00787878044499CCCCCCC0F8F8F8F80070878788044499CCC
    CCC0F8F8F8F807770787880444499CCCCCC0FFFF8F8077780878780444499CCC
    CC08F8F8F80F77870787804444499CCCCC0FFF8F80F0F7780878044444499CCC
    C0F8F8F8078F0F870787044444499CCCC0FF8FF07777F0F80880444444499CCC
    C0F8F8F077878F0F0804444444499CCC0FFFFF07777878F00044444444499CCC
    0FF8F000000000000F4F444444499CCC0FFFF07778787880F0F0F44444499CCC
    0FF807878787870CCF00F44444499CCC0FFF0778787870CCF000F44444499CCC
    0FF8078787800CCCCFFF0F4444499CCC0FF07878780CCCCCCCCCFF4444499CCC
    C0F0777700CCCCCCCCCCCC4444499CCCC0F07700CCCCCCCCCCCCCCC444499CCC
    CC0000CCCCCCCCCCCCCCCCCC44499CCCCCCCCCCCCCCCCCCCCCCCCCCCC4499CCC
    CCCCCCCCCCCCCCCCCCCCCCCCCC49999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProfileLabel: TLabel
    Left = 8
    Top = 8
    Width = 224
    Height = 14
    Caption = 'Select your Thunderbird profile:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object ProfileBevel: TBevel
    Left = 0
    Top = 88
    Width = 401
    Height = 9
    Shape = bsTopLine
  end
  object AccountsLabel: TLabel
    Left = 8
    Top = 104
    Width = 273
    Height = 14
    Caption = 'Select the accounts to be synchronized:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object StatusLabel: TLabel
    Left = 8
    Top = 456
    Width = 49
    Height = 14
    Caption = 'Status:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object StatusBevel: TBevel
    Left = 0
    Top = 432
    Width = 401
    Height = 10
    Shape = bsBottomLine
  end
  object AccountsBevel: TBevel
    Left = 0
    Top = 248
    Width = 401
    Height = 9
    Shape = bsTopLine
  end
  object CopyrightLabel: TLabel
    Left = 8
    Top = 576
    Width = 140
    Height = 14
    Caption = '(C) 2009 coltishWARE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object VersionLabel: TLabel
    Left = 296
    Top = 576
    Width = 98
    Height = 14
    Caption = 'POP3sync 0.2b3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object OptionsBevel: TBevel
    Left = 0
    Top = 368
    Width = 401
    Height = 9
    Shape = bsTopLine
  end
  object ActionBevel: TBevel
    Left = 8
    Top = 280
    Width = 385
    Height = 73
    Shape = bsFrame
  end
  object ActionLabel: TLabel
    Left = 8
    Top = 264
    Width = 49
    Height = 14
    Caption = 'Action:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object StatusListBox: TListBox
    Left = 8
    Top = 472
    Width = 385
    Height = 97
    Hint = 'Status log'
    TabStop = False
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
  end
  object ProfileComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 385
    Height = 22
    Hint = 'Thunderbird profile selection'
    AutoDropDown = True
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = ProfileComboBoxChange
  end
  object AccountsCheckListBox: TCheckListBox
    Left = 8
    Top = 120
    Width = 353
    Height = 113
    Hint = 'POP3 account selection'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object AllButton: TButton
    Left = 368
    Top = 120
    Width = 25
    Height = 25
    Hint = 'Select all accounts'
    Caption = '++'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = AllButtonClick
  end
  object NoneButton: TButton
    Left = 368
    Top = 144
    Width = 25
    Height = 25
    Hint = 'Deselect all accounts'
    Caption = '--'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = NoneButtonClick
  end
  object InvertButton: TButton
    Left = 368
    Top = 168
    Width = 25
    Height = 25
    Hint = 'Invert account selection'
    Caption = '+-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = InvertButtonClick
  end
  object SynchronizeButton: TButton
    Left = 8
    Top = 384
    Width = 385
    Height = 41
    Caption = 'START SYNCHRONIZATION'
    TabOrder = 11
    OnClick = SynchronizeButtonClick
  end
  object SelectEdit: TEdit
    Left = 8
    Top = 56
    Width = 353
    Height = 22
    Cursor = crIBeam
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = SelectEditChange
  end
  object SelectButton: TButton
    Left = 368
    Top = 56
    Width = 25
    Height = 25
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object DeleteRadioButton: TRadioButton
    Left = 24
    Top = 296
    Width = 169
    Height = 17
    Caption = 'DELETE missing mails:'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    TabStop = True
    OnClick = DeleteRadioButtonClick
  end
  object FetchRadioButton: TRadioButton
    Left = 24
    Top = 320
    Width = 169
    Height = 17
    Caption = 'FETCH missing mails:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = FetchRadioButtonClick
  end
  object DeleteCheckBox: TCheckBox
    Left = 200
    Top = 296
    Width = 177
    Height = 17
    Caption = 'Search in all accounts'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 8
  end
  object FetchCheckBox: TCheckBox
    Left = 200
    Top = 320
    Width = 177
    Height = 17
    Caption = 'Search in all accounts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
end
