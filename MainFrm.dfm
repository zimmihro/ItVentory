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
  object MainConnection: TFDConnection
    Params.Strings = (
      'Database=D:\Projekte\ItVentory\Database\ItVentory.db'
      'DriverID=SQLite'
      'LockingMode=Normal')
    Connected = True
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
    end
  end
end
