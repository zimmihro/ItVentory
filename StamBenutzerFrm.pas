unit StamBenutzerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.StdCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,
  classesPersonen;

type
  TStamBenutzerForm = class(TForm)
    BenutzerGrid: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    NeuButton: TButton;
    BearbeitenButton: TButton;
    SpeichernButton: TButton;
    AbbrechenButton: TButton;
    LoeschenButton: TButton;
    BenutzerSource: TDataSource;
    BenutzerTable: TFDTable;
    PasswortAendernButton: TButton;
    Label3: TLabel;
    SuchenButton: TButton;
    VornameEdit: TEdit;
    NameEdit: TEdit;
    procedure NeuButtonClick(Sender: TObject);
    procedure SchaltflaechenUmschalten;
    procedure BearbeitenButtonClick(Sender: TObject);
    procedure PasswortAendernButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    Benutzer : TBenutzer;
    BenutzerVerwaltung : TBenutzerVerwaltung;
  end;

var
  StamBenutzerForm: TStamBenutzerForm;

implementation

uses MainFrm, Helpers, PwAendernFrm;
{$R *.dfm}


procedure TStamBenutzerForm.BearbeitenButtonClick(Sender: TObject);
begin
  BenutzerTable.Edit;
  SchaltflaechenUmschalten;
  PasswortAendernButton.Caption := 'Ändern';
end;

procedure TStamBenutzerForm.FormCreate(Sender: TObject);
begin
  BenutzerVerwaltung := TBenutzerVerwaltung.Create(MainForm.MainConnection);
end;

procedure TStamBenutzerForm.NeuButtonClick(Sender: TObject);
begin
  BenutzerTable.Insert;
  PasswortAendernButton.Caption := 'Festlegen';
  SchaltflaechenUmschalten;
end;

procedure TStamBenutzerForm.PasswortAendernButtonClick(Sender: TObject);
var
  PwAendernForm: TPwAendernForm;
begin
  PwAendernForm := TPwAendernForm.create(application);
  PwAendernForm.ShowModal;
end;

procedure TStamBenutzerForm.SchaltflaechenUmschalten;
begin
  BenutzerGrid.Enabled := not(BenutzerTable.State in [dsEdit, dsInsert]);
  SpeichernButton.Enabled := BenutzerTable.State in [dsEdit, dsInsert];
  AbbrechenButton.Enabled := BenutzerTable.State in [dsEdit, dsInsert];
  BearbeitenButton.Enabled := not(BenutzerTable.State in [dsEdit, dsInsert]);
  NeuButton.Enabled := not(BenutzerTable.State in [dsEdit, dsInsert]);
  NameEdit.Enabled := BenutzerTable.State in [dsEdit, dsInsert];
  VornameEdit.Enabled := BenutzerTable.State in [dsEdit, dsInsert];
  PasswortAendernButton.Enabled := BenutzerTable.State in [dsEdit, dsInsert];
end;

end.
