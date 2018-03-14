object StatusForm: TStatusForm
  Left = 250
  Top = 180
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'POP3sync Status | Thunderbird'
  ClientHeight = 225
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProfileNameLabel: TLabel
    Left = 8
    Top = 8
    Width = 105
    Height = 14
    Caption = 'Profile Name: x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object ProfilePathLabel: TLabel
    Left = 8
    Top = 24
    Width = 105
    Height = 14
    Caption = 'Profile Path: x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object AccountLabel: TLabel
    Left = 8
    Top = 64
    Width = 70
    Height = 14
    Caption = 'Account: y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object FileLabel: TLabel
    Left = 8
    Top = 80
    Width = 70
    Height = 14
    Caption = 'File   : y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object CurrentIDsLabel: TLabel
    Left = 8
    Top = 120
    Width = 98
    Height = 14
    Caption = 'Current IDs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object CurrentLinesLabel: TLabel
    Left = 8
    Top = 136
    Width = 98
    Height = 14
    Caption = 'Current LNs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object TotalIDsLabel: TLabel
    Left = 216
    Top = 120
    Width = 84
    Height = 14
    Caption = 'Total IDs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object TotalLinesLabel: TLabel
    Left = 216
    Top = 136
    Width = 84
    Height = 14
    Caption = 'Total LNs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object ProfileBevel: TBevel
    Left = 0
    Top = 48
    Width = 425
    Height = 9
    Shape = bsTopLine
  end
  object AccountBevel: TBevel
    Left = 0
    Top = 104
    Width = 425
    Height = 9
    Shape = bsTopLine
  end
  object CancelBevel: TBevel
    Left = 0
    Top = 176
    Width = 425
    Height = 9
    Shape = bsTopLine
  end
  object CurrentMailsLabel: TLabel
    Left = 8
    Top = 152
    Width = 98
    Height = 14
    Caption = 'Current MLs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object TotalMailsLabel: TLabel
    Left = 216
    Top = 152
    Width = 84
    Height = 14
    Caption = 'Total MLs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object CurrentChangesLabel: TLabel
    Left = 8
    Top = 128
    Width = 98
    Height = 14
    Caption = 'Current CHs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object TotalChangesLabel: TLabel
    Left = 216
    Top = 128
    Width = 84
    Height = 14
    Caption = 'Total CHs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object CurrentCommandsLabel: TLabel
    Left = 8
    Top = 144
    Width = 98
    Height = 14
    Caption = 'Current CMs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object TotalCommandsLabel: TLabel
    Left = 216
    Top = 144
    Width = 84
    Height = 14
    Caption = 'Total CMs: z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object CancelButton: TButton
    Left = 344
    Top = 192
    Width = 75
    Height = 25
    Caption = 'CANCEL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = CancelButtonClick
  end
end
