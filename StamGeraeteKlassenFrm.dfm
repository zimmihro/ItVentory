inherited StamGeraeteKlassenForm: TStamGeraeteKlassenForm
  Caption = 'StamGeraeteKlassenForm'
  ClientHeight = 160
  ClientWidth = 176
  ExplicitWidth = 192
  ExplicitHeight = 199
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Bezeichnung'
  end
  inherited NeuButton: TButton
    Left = 8
    Top = 54
    OnClick = NeuButtonClick
    ExplicitLeft = 8
    ExplicitTop = 54
  end
  inherited BearbeitenButton: TButton
    Left = 87
    Top = 54
    ExplicitLeft = 87
    ExplicitTop = 54
  end
  inherited SpeichernButton: TButton
    Left = 8
    Top = 85
    OnClick = SpeichernButtonClick
    ExplicitLeft = 8
    ExplicitTop = 85
  end
  inherited AbbrechenButton: TButton
    Left = 87
    Top = 85
    OnClick = AbbrechenButtonClick
    ExplicitLeft = 87
    ExplicitTop = 85
  end
  inherited LoeschenButton: TButton
    Left = 8
    Top = 116
    OnClick = LoeschenButtonClick
    ExplicitLeft = 8
    ExplicitTop = 116
  end
  inherited SuchenButton: TButton
    Left = 89
    Top = 116
    OnClick = SuchenButtonClick
    ExplicitLeft = 89
    ExplicitTop = 116
  end
  object BezeichnungEdit: TEdit
    Left = 8
    Top = 27
    Width = 154
    Height = 21
    TabOrder = 6
    Text = 'BezeichnungEdit'
  end
end
