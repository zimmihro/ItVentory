object XStammdatenForm: TXStammdatenForm
  Left = 0
  Top = 0
  Caption = 'XStammdatenForm'
  ClientHeight = 336
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NeuButton: TButton
    Left = 552
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Neu'
    TabOrder = 0
  end
  object BearbeitenButton: TButton
    Left = 552
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Bearbeiten'
    TabOrder = 1
    OnClick = BearbeitenButtonClick
  end
  object SpeichernButton: TButton
    Left = 552
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Speichern'
    TabOrder = 2
  end
  object AbbrechenButton: TButton
    Left = 552
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 3
  end
  object LoeschenButton: TButton
    Left = 552
    Top = 132
    Width = 75
    Height = 25
    Caption = 'L'#246'schen'
    TabOrder = 4
  end
  object SuchenButton: TButton
    Left = 552
    Top = 162
    Width = 75
    Height = 25
    Caption = 'Suchen'
    TabOrder = 5
  end
end
