unit StamBenutzerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, classesPersonen, MainFrm, Helpers, SuchenFrm, PwAendernFrm, XStammdatenFrm;

type
  TStamBenutzerForm = class(TXStammdatenForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BenutzerGrid: TDBGrid;
    PasswortAendernButton: TButton;
    VornameEdit: TEdit;
    NameEdit: TEdit;
    BenutzerSource: TDataSource;
    BenutzerTable: TFDTable;
    Label4: TLabel;
    BenutzernameEdit: TEdit;
    procedure AnzeigeFuellen;
    procedure AnzeigeUmschalten(Status: TFormStatus); reintroduce;
    procedure NeuButtonClick(Sender: TObject);
    procedure SpeichernButtonClick(Sender: TObject);
    procedure AbbrechenButtonClick(Sender: TObject);
    procedure LoeschenButtonClick(Sender: TObject);
    procedure PasswortAendernButtonClick(Sender: TObject);
  private
    Benutzer: TBenutzer;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  StamBenutzerForm: TStamBenutzerForm;

implementation

{$R *.dfm}

{ TStamBenutzerForm }

procedure TStamBenutzerForm.AbbrechenButtonClick(Sender: TObject);
begin
  self.AnzeigeFuellen;
  if Assigned(self.Benutzer) then
    self.AnzeigeUmschalten(fsGesperrt)
  else
    self.AnzeigeUmschalten(fsLeer)
end;

procedure TStamBenutzerForm.AnzeigeFuellen;
begin
  if Assigned(Benutzer) then
  begin
    self.NameEdit.Text := Benutzer.Name;
    self.VornameEdit.Text := Benutzer.Vorname;
  end
  else
  begin
    self.NameEdit.Clear;
    self.VornameEdit.Clear
  end;
end;

procedure TStamBenutzerForm.AnzeigeUmschalten(Status: TFormStatus);
begin
  inherited;
  self.NameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.VornameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.BenutzernameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.PasswortAendernButton.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.AnzeigeFuellen;
end;

procedure TStamBenutzerForm.LoeschenButtonClick(Sender: TObject);
begin
  inherited;
  if Assigned(self.Benutzer) then
    self.Benutzer.Loeschen;
  self.AnzeigeUmschalten(fsLeer);
end;

procedure TStamBenutzerForm.NeuButtonClick(Sender: TObject);
begin
  if Assigned(self.Benutzer) then
    FreeAndNil(self.Benutzer);
  self.AnzeigeUmschalten(fsNeu);
end;

procedure TStamBenutzerForm.PasswortAendernButtonClick(Sender: TObject);
var
  PasswortForm :
begin
  inherited;

end;

procedure TStamBenutzerForm.SpeichernButtonClick(Sender: TObject);
begin
  begin
    if Assigned(self.Benutzer) then
      self.Benutzer.Speichern
    else
    begin
//      self.Benutzer := TBenutzer.Create(BenutzernameEdit.Text, NameEdit.Text, VornameEdit.Text,
//          MainForm.MainConnection);
      self.Benutzer.Speichern;
    end;
    self.AnzeigeUmschalten(fsGesperrt);
  end;
end;

end.
