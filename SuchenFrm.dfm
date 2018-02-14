object SuchenForm: TSuchenForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'SuchenForm'
  ClientHeight = 115
  ClientWidth = 208
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
  object SuchbegriffEdit: TEdit
    Left = 16
    Top = 16
    Width = 169
    Height = 21
    TabOrder = 0
    Text = 'SuchbegriffEdit'
    OnKeyPress = SuchbegriffEditKeyPress
  end
  object AuswahlFelderBox: TComboBox
    Left = 16
    Top = 43
    Width = 169
    Height = 21
    TabOrder = 1
    Text = 'AuswahlFelderBox'
  end
  object SuchenButton: TButton
    Left = 16
    Top = 70
    Width = 81
    Height = 25
    Caption = 'SuchenButton'
    TabOrder = 2
    OnClick = SuchenButtonClick
  end
  object AbbrechenButton: TButton
    Left = 103
    Top = 70
    Width = 81
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
  end
end
