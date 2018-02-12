object StamBenutzerForm: TStamBenutzerForm
  Left = 0
  Top = 0
  Caption = 'StamBenutzerForm'
  ClientHeight = 267
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 308
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Vorname:'
  end
  object Label2: TLabel
    Left = 308
    Top = 49
    Width = 54
    Height = 13
    Caption = 'Nachname:'
  end
  object Label3: TLabel
    Left = 308
    Top = 90
    Width = 48
    Height = 13
    Caption = 'Passwort:'
  end
  object BenutzerGrid: TDBGrid
    Left = 8
    Top = 8
    Width = 279
    Height = 252
    DataSource = BenutzerSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Vorname'
        Width = 111
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Width = 151
        Visible = True
      end>
  end
  object NeuButton: TButton
    Left = 447
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Neu'
    TabOrder = 1
    OnClick = NeuButtonClick
  end
  object BearbeitenButton: TButton
    Left = 447
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Bearbeiten'
    TabOrder = 2
    OnClick = BearbeitenButtonClick
  end
  object SpeichernButton: TButton
    Left = 447
    Top = 71
    Width = 75
    Height = 25
    Caption = 'Speichern'
    TabOrder = 3
  end
  object AbbrechenButton: TButton
    Left = 447
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 4
  end
  object LoeschenButton: TButton
    Left = 447
    Top = 133
    Width = 75
    Height = 25
    Caption = 'L'#246'schen'
    TabOrder = 5
  end
  object PasswortAendernButton: TButton
    Left = 312
    Top = 109
    Width = 75
    Height = 25
    Caption = #196'ndern'
    TabOrder = 6
    OnClick = PasswortAendernButtonClick
  end
  object SuchenButton: TButton
    Left = 447
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Suchen'
    TabOrder = 7
  end
  object VornameEdit: TEdit
    Left = 308
    Top = 22
    Width = 121
    Height = 21
    TabOrder = 8
  end
  object NameEdit: TEdit
    Left = 308
    Top = 63
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object BenutzerSource: TDataSource
    DataSet = BenutzerTable
    Left = 488
    Top = 163
  end
  object BenutzerTable: TFDTable
    Active = True
    IndexFieldNames = 'Id'
    Connection = MainForm.MainConnection
    UpdateOptions.UpdateTableName = 'Benutzer'
    TableName = 'Benutzer'
    Left = 448
    Top = 163
  end
end
