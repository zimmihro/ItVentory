unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Vcl.Menus;

type
  TMainForm = class(TForm)
    MainConnection: TFDConnection;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Stammdaten1: TMenuItem;
    Mitarbeiter1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Mitarbeiter1Click(Sender: TObject);
  private
    procedure BenutzerAnmelden;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

uses helpers, LoginFrm, StamMitarbeiterfrm, classesTelefonie;

{$R *.dfm}

{ TMainForm }

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
var
  sim : TSimKarte;
begin
  BenutzerAnmelden;
  sim := TSimKarte.CreateFromId(1, MainConnection);
  sim.Free;
end;

procedure TMainForm.Mitarbeiter1Click(Sender: TObject);
var
  MitarbeiterForm : TStamMitarbeiterForm;
begin
  MitarbeiterForm := TStammitarbeiterForm.Create(application);
  MitarbeiterForm.ShowModal;
end;

end.
