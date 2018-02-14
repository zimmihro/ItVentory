inherited StamMitarbeiterForm: TStamMitarbeiterForm
  Caption = 'StamMitarbeiterForm'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 12
    Top = 49
    Width = 54
    Height = 13
    Caption = 'Nachname:'
  end
  object Label1: TLabel [1]
    Left = 12
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Vorname:'
  end
  inherited NeuButton: TButton
    OnClick = NeuButtonClick
  end
  inherited BearbeitenButton: TButton
    OnClick = BearbeitenButtonClick
  end
  inherited SpeichernButton: TButton
    OnClick = SpeichernButtonClick
  end
  inherited AbbrechenButton: TButton
    OnClick = AbbrechenButtonClick
  end
  inherited LoeschenButton: TButton
    OnClick = LoeschenButtonClick
  end
  inherited SuchenButton: TButton
    OnClick = SuchenButtonClick
  end
  object Button1: TButton
    Left = 255
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 6
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 154
    Top = 26
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Vorname'
        Visible = True
      end>
  end
  object NameEdit: TEdit
    Left = 16
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'NameEdit'
  end
  object VornameEdit: TEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'VornameEdit'
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 200
    Top = 152
  end
  object FDTable1: TFDTable
    Active = True
    IndexFieldNames = 'Id'
    Connection = MainForm.MainConnection
    UpdateOptions.UpdateTableName = 'Mitarbeiter'
    TableName = 'Mitarbeiter'
    Left = 160
    Top = 152
  end
end
