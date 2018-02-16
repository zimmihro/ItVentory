unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.UItypes,
  System.Generics.Collections, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Vcl.Menus, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    MainConnection: TFDConnection;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Stammdaten1: TMenuItem;
    Mitarbeiter1: TMenuItem;
    FDQuery1: TFDQuery;
    Label1: TLabel;
    Benutzer1: TMenuItem;
    Arbeitsmittelklassen: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Mitarbeiter1Click(Sender: TObject);
    procedure Benutzer1Click(Sender: TObject);
    procedure ArbeitsmittelklassenClick(Sender: TObject);
  private
    procedure BenutzerAnmelden;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

uses helpers, LoginFrm, SuchenFrm, StamMitarbeiterfrm, StamBenutzerFrm, StamGeraeteKlassenFrm, classesTelefonie, classesPersonen;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.ArbeitsmittelklassenClick(Sender: TObject);
var
  KlassenForm:TStamGeraeteKlassenForm;
begin
  KlassenForm:=TStamGeraeteKlassenForm.Create(application);
  KlassenForm.Show;
end;

procedure TMainForm.Benutzer1Click(Sender: TObject);
var
  BenutzerForm: TStamBenutzerForm;
begin
  BenutzerForm := TStamBenutzerForm.Create(Application);
  BenutzerForm.ShowModal;
end;

procedure TMainForm.BenutzerAnmelden;
begin
  AnmeldeForm := TAnmeldeForm.Create(Application);
  if AnmeldeForm.ShowModal <> mrOk then
  begin
    AnmeldeForm.Free;
    Application.Terminate;
    abort;
  end;
  Caption := Caption + ' - [' + AnmeldeForm.LoginQuery.FieldByName('Vorname')
      .AsString + AnmeldeForm.LoginQuery.FieldByName('Name')
      .AsString + ']';
  // AnmeldeForm freigegeben
  AnmeldeForm.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
//var
//  Eintrag   : TSucheintrag;
//  Suche     : TList<TSucheintrag>;
//  SuchenForm: TSuchenForm;
//  Benutzer  : TBenutzer;
// mitarbeiter : TMitarbeiter;
begin
  self.MainConnection.Params.Database := ExtractFilePath(ParamStr(0)) + 'Database\ItVentory.db';
  self.MainConnection.Connected := true;
  BenutzerAnmelden;
//  try
//      mitarbeiter := TMitarbeiter.CreateFromId(145, MainConnection);
//  except on E: Exception do
//    MessageDlg(E.ToString, mtError, [mbOk],0);
//  end;

//  Eintrag.SpaltenName := 'Id';
//  Eintrag.AnzeigeName := 'Identifikationsnummer';
//  Suche := TList<TSucheintrag>.Create;
//  Suche.Add(Eintrag);
//  SuchenForm := TSuchenForm.Create(Application, 'Benutzer', Suche, MainConnection);
//  if SuchenForm.ShowModal = mrOk then
//  begin
//    Benutzer := TBenutzer.CreateFromId(SuchenForm.Ergebnis, MainConnection);
//    self.Label1.Caption := Benutzer.Md5Passwort;
//  end;

end;

procedure TMainForm.Mitarbeiter1Click(Sender: TObject);
var
  MitarbeiterForm: TStamMitarbeiterForm;
begin
  MitarbeiterForm := TStamMitarbeiterForm.Create(Application);
  MitarbeiterForm.ShowModal;
end;

end.
