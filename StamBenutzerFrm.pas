unit StamBenutzerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, classesPersonen, MainFrm, Helpers, SuchenFrm, PwAendernFrm,
  XStammdatenFrm;

type
  TStamBenutzerForm = class(TXStammdatenForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BenutzerGrid: TDBGrid;
    PasswortButton: TButton;
    VornameEdit: TEdit;
    NameEdit: TEdit;
    BenutzerSource: TDataSource;
    BenutzerTable: TFDTable;
    Label4: TLabel;
    BenutzernameEdit: TEdit;
    Button1: TButton;
    procedure AnzeigeFuellen;
    procedure AnzeigeUmschalten(Status: TFormStatus); reintroduce;
    procedure NeuButtonClick(Sender: TObject);
    procedure SpeichernButtonClick(Sender: TObject);
    procedure AbbrechenButtonClick(Sender: TObject);
    procedure LoeschenButtonClick(Sender: TObject);
    procedure PasswortButtonClick(Sender: TObject);
    procedure SuchenButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BearbeitenButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    Benutzer        : TBenutzer;
    BenutzerPasswort: TPasswort;
    function istPwValide(): boolean;
  public
    property PasswortValide: boolean read istPwValide;
  end;

var
  StamBenutzerForm: TStamBenutzerForm;

implementation

{$R *.dfm}

{ TStamBenutzerForm }

procedure TStamBenutzerForm.AbbrechenButtonClick(Sender: TObject);
begin
  if Assigned(self.Benutzer) and (self.FormStatus <> fsNeu) then
    self.AnzeigeUmschalten(fsGesperrt)
  else
    self.AnzeigeUmschalten(fsLeer)
end;

procedure TStamBenutzerForm.AnzeigeFuellen;
begin
  if Assigned(Benutzer) and (self.FormStatus <> fsNeu) then
  begin
    self.NameEdit.Text := Benutzer.Name;
    self.VornameEdit.Text := Benutzer.Vorname;
    self.BenutzernameEdit.Text := Benutzer.Login;
    self.PasswortButton.Caption := 'ändern';
  end
  else
  begin
    self.NameEdit.Clear;
    self.VornameEdit.Clear;
    self.BenutzernameEdit.Clear;
    self.PasswortButton.Caption := 'festlegen';
  end;
end;

procedure TStamBenutzerForm.AnzeigeUmschalten(Status: TFormStatus);
begin
  inherited;
  self.NameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.VornameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.BenutzernameEdit.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.PasswortButton.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.AnzeigeFuellen;
end;

procedure TStamBenutzerForm.BearbeitenButtonClick(Sender: TObject);
begin
  inherited;
  self.AnzeigeUmschalten(fsBearbeiten);
end;

procedure TStamBenutzerForm.Button1Click(Sender: TObject);
begin
  inherited;
  self.BenutzerTable.Refresh;
end;

procedure TStamBenutzerForm.FormShow(Sender: TObject);
begin
  inherited;
  self.AnzeigeUmschalten(fsLeer);
  self.BenutzerTable.Active := true;
end;

function TStamBenutzerForm.istPwValide: boolean;
begin
  result := (self.BenutzerPasswort.md5Hash.Length = 32) and (self.BenutzerPasswort.md5salt.Length = 32);
end;

procedure TStamBenutzerForm.LoeschenButtonClick(Sender: TObject);
begin
  if messagedlg('Möchten Sie den Benutzer ' + Benutzer.VollName + ' wirklich löschen?', mtConfirmation,
      [mbYes, mbCancel], 0) = mrYes THEN
    if Benutzer.Loeschen then
    begin
      FreeAndNil(Benutzer);
      self.AnzeigeUmschalten(fsLeer);
    end
    else
      messagedlg('Beim Löschen trat ein Fehler auf. Bitte wenden Sie sich an den Administrator', mtInformation,
          [mbOk], 0);
end;

procedure TStamBenutzerForm.NeuButtonClick(Sender: TObject);
begin
  if Assigned(self.Benutzer) then
    FreeAndNil(self.Benutzer);
  self.AnzeigeUmschalten(fsNeu);
end;

procedure TStamBenutzerForm.PasswortButtonClick(Sender: TObject);
var
  PasswortForm: TPwAendernForm;
begin
  inherited;
  PasswortForm := TPwAendernForm.Create(application);
  if PasswortForm.ShowModal = mrOk then
  begin
    self.BenutzerPasswort := PasswortForm.Passwort;
    self.PasswortButton.Caption := 'ändern';
  end;
end;

procedure TStamBenutzerForm.SpeichernButtonClick(Sender: TObject);
begin
  try
    if not Assigned(self.Benutzer) then
      if self.PasswortValide then
      begin
        self.Benutzer := TBenutzer.Create(BenutzernameEdit.Text, self.BenutzerPasswort.md5Hash,
            self.BenutzerPasswort.md5salt, NameEdit.Text, VornameEdit.Text,
            MainForm.MainConnection);
        self.BenutzerPasswort.md5Hash := '';
        self.BenutzerPasswort.md5salt := '';
      end
      else
      begin
        messagedlg('Bitte legen sie vor dem Speichern ein Passwort fest!', mtInformation, [mbOk], 0);
        PasswortButtonClick(self);
        exit;
      end;
    if self.Benutzer.Speichern then
      self.AnzeigeUmschalten(fsGesperrt)
    else
      messagedlg('Beim speichern trat ein Fehler auf. Bitte wenden Sie sich an Ihren Administrator!', mtInformation,
          [mbOk], 0);
  except
    on E: Exception do
    begin
      messagedlg(E.ToString, mtInformation,
          [mbOk], 0);
      FreeAndNil(self.Benutzer);
    end;
  end;
end;

procedure TStamBenutzerForm.SuchenButtonClick(Sender: TObject);
var
  SuchenForm   : TSuchenForm;
  SuchEintraege: TList<TSucheintrag>;
begin
  SuchEintraege := TList<TSucheintrag>.Create;
  SuchEintraege.Add(TSucheintrag.Create('Name', 'Nachname'));
  SuchEintraege.Add(TSucheintrag.Create('Vorname', 'Vorname'));
  SuchEintraege.Add(TSucheintrag.Create('Vorname + '' '' + Name', 'voller Name'));
  SuchEintraege.Add(TSucheintrag.Create('Login', 'Anmeldename'));
  SuchenForm := TSuchenForm.Create(application, 'Benutzer', SuchEintraege, MainForm.MainConnection);
  if SuchenForm.ShowModal = mrOk then
  begin
    if Assigned(self.Benutzer) then
      FreeAndNil(self.Benutzer);
    self.Benutzer := TBenutzer.CreateFromId(SuchenForm.Ergebnis, MainForm.MainConnection);
    self.AnzeigeUmschalten(fsGesperrt);
  end;
end;

end.
