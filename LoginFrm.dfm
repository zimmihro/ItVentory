object AnmeldeForm: TAnmeldeForm
  Left = 305
  Top = 467
  HelpContext = 4010
  ActiveControl = PasswortEdit
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Benutzer-Anmeldung'
  ClientHeight = 139
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 278
    Height = 13
    Caption = 'Bitte geben Sie Ihren Benutzernamen und Ihr Passwort ein.'
  end
  object Label2: TLabel
    Left = 16
    Top = 41
    Width = 68
    Height = 13
    Caption = 'Benutzername'
  end
  object Label3: TLabel
    Left = 16
    Top = 73
    Width = 43
    Height = 13
    Caption = 'Passwort'
  end
  object UserEdit: TEdit
    Left = 96
    Top = 37
    Width = 194
    Height = 21
    HelpContext = 4012
    TabOrder = 0
    Text = 'Tobias Zimmermann'
  end
  object PasswortEdit: TEdit
    Left = 96
    Top = 69
    Width = 194
    Height = 21
    HelpContext = 4013
    PasswordChar = '*'
    TabOrder = 1
  end
  object AnmeldenButton: TButton
    Left = 56
    Top = 108
    Width = 73
    Height = 23
    HelpContext = 4014
    Caption = '&Ok'
    Default = True
    TabOrder = 2
    OnClick = AnmeldenButtonClick
  end
  object AbbrechenButton: TButton
    Left = 176
    Top = 109
    Width = 73
    Height = 23
    HelpContext = 4015
    Cancel = True
    Caption = '&Abbrechen'
    ModalResult = 2
    TabOrder = 3
  end
  object LoginQuery: TFDQuery
    Connection = MainForm.MainConnection
    SQL.Strings = (
      'SELECT * FROM Benutzer'
      'WHERE Login = :user'
      '   AND Md5Passwort = :pw')
    Left = 8
    Top = 72
    ParamData = <
      item
        Name = 'USER'
        ParamType = ptInput
      end
      item
        Name = 'PW'
        ParamType = ptInput
      end>
  end
  object SaltQuery: TFDQuery
    Connection = MainForm.MainConnection
    SQL.Strings = (
      'SELECT Md5Salt FROM Benutzer'
      'WHERE Login = :user')
    Left = 8
    Top = 96
    ParamData = <
      item
        Name = 'USER'
        ParamType = ptInput
      end>
  end
end
