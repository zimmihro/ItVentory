unit StamMitarbeiterFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TStamMitarbeiterForm = class(TForm)
    NameEdit: TDBEdit;
    MitarbeiterSource: TDataSource;
    VornameEdit: TDBEdit;
    NeuButton: TButton;
    BearbeitenButton: TButton;
    SpeichernButton: TButton;
    AbbrechenButton: TButton;
    LoeschenButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    MitarbeiterTable: TFDTable;
    MitarbeiterGrid: TDBGrid;
    procedure SchaltflaechenUmschalten();
    procedure FormShow(Sender: TObject);
    procedure NeuButtonClick(Sender: TObject);
    procedure BearbeitenButtonClick(Sender: TObject);
    procedure SpeichernButtonClick(Sender: TObject);
    procedure AbbrechenButtonClick(Sender: TObject);
    procedure LoeschenButtonClick(Sender: TObject);
    function EingabeValidieren(): boolean;
    procedure MitarbeiterGridCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);

  private

  public
    { Public-Deklarationen }
  end;

var
  StamMitarbeiterForm     : TStamMitarbeiterForm;
  NeuerMitarbeiter: boolean;
  PasswortAendern : boolean;

implementation

uses MainFrm, Helpers;

{$R *.dfm}

{ TNewUserForm }

procedure TStamMitarbeiterForm.AbbrechenButtonClick(Sender: TObject);
begin
  MitarbeiterTable.Cancel;
  NeuerMitarbeiter := false;
  SchaltflaechenUmschalten;
end;

procedure TStamMitarbeiterForm.BearbeitenButtonClick(Sender: TObject);
begin
  MitarbeiterTable.Edit;
  SchaltflaechenUmschalten;
  if MitarbeiterTable.State = dsInsert then
    exit;
end;

function TStamMitarbeiterForm.EingabeValidieren: boolean;
begin
  result := false;

  if (MitarbeiterTable.FieldByName('Name').IsNull) or (MitarbeiterTable.FieldByName('Name').AsString = '') then
  begin
    MessageDlg('Bitte ergänzen Sie den Namen bevor Sie den Datensatz speichern!', mtError, [mbOk], 0);
    exit;
  end;

  if (MitarbeiterTable.FieldByName('Vorname').IsNull) or (MitarbeiterTable.FieldByName('Vorname').AsString = '') then
  begin
    MessageDlg('Bitte ergänzen Sie den Vornamen bevor Sie den Datensatz speichern!', mtError, [mbOk], 0);
    exit;
  end;

  result := true;
end;

procedure TStamMitarbeiterForm.FormCreate(Sender: TObject);
begin
  MitarbeiterTable.Open();
  NeuerMitarbeiter := false;
end;

procedure TStamMitarbeiterForm.FormShow(Sender: TObject);
begin
  SchaltflaechenUmschalten;
end;

procedure TStamMitarbeiterForm.LoeschenButtonClick(Sender: TObject);
var
  mitarbeiterName: string;
begin
  mitarbeiterName := MitarbeiterTable.FieldByName('Vorname').AsString + ' ' +
      MitarbeiterTable.FieldByName('Name').AsString;
  if MessageDlg('Wollen sie den Mitarbeiter ' + mitarbeiterName + ' wirklich löschen?', mtConfirmation, [mbYes, mbNo],
      0) = IDYES then
  begin
    MitarbeiterTable.Delete;
    SchaltflaechenUmschalten;
  end;
end;

procedure TStamMitarbeiterForm.MitarbeiterGridCellClick(Column: TColumn);
begin
  SchaltflaechenUmschalten;
end;

procedure TStamMitarbeiterForm.NeuButtonClick(Sender: TObject);
begin
  MitarbeiterTable.Insert;
  SchaltflaechenUmschalten;
end;

procedure TStamMitarbeiterForm.SchaltflaechenUmschalten;
begin
  MitarbeiterGrid.Enabled := not(MitarbeiterTable.State in [dsEdit, dsInsert]);
  SpeichernButton.Enabled := MitarbeiterTable.State in [dsEdit, dsInsert];
  AbbrechenButton.Enabled := MitarbeiterTable.State in [dsEdit, dsInsert];
  BearbeitenButton.Enabled := not(MitarbeiterTable.State in [dsEdit, dsInsert]);
  NeuButton.Enabled := not(MitarbeiterTable.State in [dsEdit, dsInsert]);
  NameEdit.Enabled := MitarbeiterTable.State in [dsEdit, dsInsert];
  VornameEdit.Enabled := MitarbeiterTable.State in [dsEdit, dsInsert];
end;

procedure TStamMitarbeiterForm.SpeichernButtonClick(Sender: TObject);
begin
  if EingabeValidieren then
  begin
    MitarbeiterTable.Post;
    SchaltflaechenUmschalten;
  end;
end;

end.
