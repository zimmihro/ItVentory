unit classesPersonen;

interface

uses System.SysUtils, System.StrUtils, Vcl.Dialogs, System.UITypes, System.Generics.Collections, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TMitarbeiter = class
  private
    MitarbeiterQuery: TFDQuery;
    FId             : Variant;
    FName           : string;
    FVorname        : string;
    procedure IdErmitteln();
  public
    property Id     : Variant read FId write FId;
    property Name   : string read FName write FName;
    property Vorname: string read FVorname write FVorname;
    constructor Create(name, Vorname: string; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Aktualisieren();
    procedure Loeschen();
  end;

type
  TBenutzer = class
  private
    BenutzerQuery: TFDQuery;
    FId          : Variant;
    FLogin       : string;
    FMd5Passwort : string;
    FMd5Salt     : string;
    FName        : string;
    FVorname     : string;
    procedure setMd5Passwort(hash: string);
    procedure setMd5Salt(salt: string);
  public
    property Id         : Variant read FId write FId;
    property Login      : string read FLogin write FLogin;
    property Md5Passwort: string read FMd5Passwort write setMd5Passwort;
    property Md5Salt    : string read FMd5Salt write setMd5Salt;
    property Name       : string read FName write FName;
    property Vorname    : string read FVorname write FVorname;
    constructor Create(Login, Md5Passwort, Md5Salt, name, Vorname: string; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure IdErmitteln();
    procedure Aktualisieren();
    procedure Loeschen();
  end;

type
  TBenutzerVerwaltung = class
  private
    BenutzerListeQuery: TFDQuery;
    FBenutzerListe    : TList<TBenutzer>;
  public
    property BenutzerListe: TList<TBenutzer> read FBenutzerListe write FBenutzerListe;
    constructor Create(Connection: TFDConnection);
    procedure BenutzerSuchen(Suchbegriff: string; Connection: TFDConnection);
  end;

implementation


{ TMitarbeiter }

procedure TMitarbeiter.Aktualisieren;
begin
  with self.MitarbeiterQuery, SQL do
  begin
    Clear;
    Add('UPDATE Mitarbeiter SET');
    Add('Name = :name, ');
    Add('Vorname = :vorname,');
    Add('WHERE Id = :id');
    ParamByName('name').Value := self.name;
    ParamByName('vorname').Value := self.Vorname;
    ParamByName('id').Value := self.Id;
  end;
  self.MitarbeiterQuery.ExecSQL;
end;

constructor TMitarbeiter.Create(name, Vorname: string; Connection: TFDConnection);
begin
  self.name := name;
  self.Vorname := Vorname;
  self.MitarbeiterQuery := TFDQuery.Create(nil);
  self.MitarbeiterQuery.Connection := Connection;
end;

constructor TMitarbeiter.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.MitarbeiterQuery := TFDQuery.Create(nil);
  self.MitarbeiterQuery.Connection := Connection;
  with self.MitarbeiterQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM Mitarbeiter WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.MitarbeiterQuery.Open;
  if self.MitarbeiterQuery.RecordCount = 1 then
  begin
    self.Id := self.MitarbeiterQuery.FieldByName('Id').AsInteger;
    self.name := self.MitarbeiterQuery.FieldByName('Name').AsString;
    self.Vorname := self.MitarbeiterQuery.FieldByName('Vorname').AsString;
  end;
  self.MitarbeiterQuery.Close;
end;

procedure TMitarbeiter.IdErmitteln;
begin
  with self.MitarbeiterQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Mitarbeiter ORDER BY Id DESC LIMIT 1');
  end;
  self.MitarbeiterQuery.Open;
  if self.MitarbeiterQuery.RecordCount = 1 then
    self.Id := self.MitarbeiterQuery.FieldByName('Id').AsInteger;
  self.MitarbeiterQuery.Close
end;

procedure TMitarbeiter.Loeschen;
begin
  with self.MitarbeiterQuery, SQL do
  begin
    Clear;
    Add('DELETE FROM Mitarbeiter WHERE Id = :id');
    ParamByName('id').Value := self.Id;
  end;
  self.MitarbeiterQuery.ExecSQL;
end;

procedure TMitarbeiter.Speichern;
begin
  with self.MitarbeiterQuery, SQL do
  begin
    Clear;
    Add('INSERT INTO Mitarbeiter (Name, Vorname)');
    Add('VALUES (:name,:vorname'')');
    ParamByName('name').Value := self.name;
    ParamByName('vorname').Value := self.Vorname;
  end;
  self.MitarbeiterQuery.ExecSQL;
  self.IdErmitteln;
end;

{ TBenutzer }

procedure TBenutzer.Aktualisieren;
begin
  with self.BenutzerQuery, SQL do
  begin
    Clear;
    Add('UPDATE Benutzer SET');
    Add('Login = :login');
    Add('Md5Passwort = :pw');
    Add('Md5Salt = :salt');
    Add('Name = :name, ');
    Add('Vorname = :vorname,');
    Add('WHERE Id = :id');
    ParamByName('login').Value := self.Login;
    ParamByName('pw').Value := self.Md5Passwort;
    ParamByName('salt').Value := self.Md5Salt;
    ParamByName('name').Value := self.name;
    ParamByName('vorname').Value := self.Vorname;
    ParamByName('id').Value := self.Id;
  end;
  self.BenutzerQuery.ExecSQL;
end;

constructor TBenutzer.Create(Login, Md5Passwort, Md5Salt, name, Vorname: string; Connection: TFDConnection);
begin
  self.Login := Login;
  self.Md5Passwort := Md5Passwort;
  self.Md5Salt := Md5Salt;
  self.name := name;
  self.Vorname := Vorname;
  self.BenutzerQuery := TFDQuery.Create(nil);
  self.BenutzerQuery.Connection := Connection;
end;

constructor TBenutzer.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.BenutzerQuery := TFDQuery.Create(nil);
  self.BenutzerQuery.Connection := Connection;
  with self.BenutzerQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM Benutzer WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.BenutzerQuery.Open;
  if self.BenutzerQuery.RecordCount = 1 then
  begin
    self.Id := self.BenutzerQuery.FieldByName('Id').AsInteger;
    self.Login := self.BenutzerQuery.FieldByName('Login').AsString;
    self.Md5Passwort := self.BenutzerQuery.FieldByName('Md5Passwort').AsString;
    self.Md5Salt := self.BenutzerQuery.FieldByName('Md5Salt').AsString;
    self.name := self.BenutzerQuery.FieldByName('Name').AsString;
    self.Vorname := self.BenutzerQuery.FieldByName('Vorname').AsString;
  end;
  self.BenutzerQuery.Close;
end;

procedure TBenutzer.IdErmitteln;
begin
  with self.BenutzerQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Benutzer ORDER BY Id DESC LIMIT 1');
  end;
  self.BenutzerQuery.Open;
  if self.BenutzerQuery.RecordCount = 1 then
    self.Id := self.BenutzerQuery.FieldByName('Id').AsInteger;
  self.BenutzerQuery.Close
end;

procedure TBenutzer.Loeschen;
begin
  with self.BenutzerQuery, SQL do
  begin
    Clear;
    Add('DELETE FROM Benutzer WHERE Id = :id');
    ParamByName('id').Value := self.Id;
  end;
  self.BenutzerQuery.ExecSQL;
end;

procedure TBenutzer.setMd5Passwort(hash: string);
begin
  if Length(hash) = 32 then
    self.FMd5Passwort := hash
  else
    MessageDlg('Beim setzen des Passworts ist ein Fehler aufgetreten', mtError, [mbOk], 0);
end;

procedure TBenutzer.setMd5Salt(salt: string);
begin
  if Length(salt) = 32 then
    self.FMd5Salt := salt
  else
    MessageDlg('Beim setzen des Passworts ist ein Fehler aufgetreten', mtError, [mbOk], 0);
end;

procedure TBenutzer.Speichern;
begin
  with self.BenutzerQuery, SQL do
  begin
    Clear;
    Add('INSERT INTO Benutzer (Login, Md5Passwort, Md5Salt, Name, Vorname)');
    Add('VALUES (:login, :pw, :salt, :name, :vorname)');
    ParamByName('login').Value := self.Login;
    ParamByName('pw').Value := self.Md5Passwort;
    ParamByName('salt').Value := self.Md5Salt;
    ParamByName('name').Value := self.name;
    ParamByName('vorname').Value := self.Vorname
  end;
  self.BenutzerQuery.ExecSQL;
  self.IdErmitteln;
end;

{ TBenutzerVerwaltung }

procedure TBenutzerVerwaltung.BenutzerSuchen(Suchbegriff: string; Connection: TFDConnection);
var
  I         : integer;
  BenutzerId: integer;
  Benutzer  : TBenutzer;
begin
  with self.BenutzerListeQuery, SQL do
  begin
    Close;
    Clear;
    Add('SELECT Id FROM Benutzer');
    Add('WHERE Name = :input');
    Add('  OR Vorname = : input');
    Add('  OR Vorname + '' '' + Name = :input');
    ParamByName('input').Value := Suchbegriff;
    Open;
  end;
  for I := 0 to self.BenutzerListeQuery.RecordCount do
  begin
    BenutzerId := self.BenutzerListeQuery.FieldByName('Id').AsInteger;
    Benutzer := TBenutzer.CreateFromId(BenutzerId, Connection);
    self.BenutzerListe.Add(Benutzer);
    Benutzer.Free;
  end;
end;

constructor TBenutzerVerwaltung.Create(Connection: TFDConnection);
begin
  self.BenutzerListe := TList<TBenutzer>.Create;
end;

end.
