object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 452
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 136
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object MainConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'LockingMode=Normal')
    LoginPrompt = False
    Left = 560
    Top = 272
  end
  object MainMenu: TMainMenu
    Left = 536
    Top = 368
    object Datei1: TMenuItem
      Caption = 'Datei'
    end
    object Stammdaten1: TMenuItem
      Caption = 'Stammdaten'
      object Mitarbeiter1: TMenuItem
        Caption = 'Mitarbeiter'
        OnClick = Mitarbeiter1Click
      end
      object Benutzer1: TMenuItem
        Caption = 'Benutzer'
        OnClick = Benutzer1Click
      end
      object Arbeitsmittelklassen: TMenuItem
        Caption = 'Arbeitsmittelklassen'
        OnClick = ArbeitsmittelklassenClick
      end
    end
  end
  object FDQuery1: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'SELECT * FROM Benutzer ')
    Left = 376
    Top = 336
  end
end
