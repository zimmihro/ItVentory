unit classesPersonen;

interface

uses System.SysUtils, System.StrUtils, Vcl.Dialogs, System.UITypes, System.Generics.Collections,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TMitarbeiter = class
  private
    SqlQuery: TFDQuery;
    FId     : Variant;
    FName   : string;
    FVorname: string;
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

  const
    TABLE_NAME = 'Mitarbeiter';
  end;

type
  TBenutzer = class(TMitarbeiter)
  private
    FLogin      : string;
    FMd5Passwort: string;
    FMd5Salt    : string;
    procedure setMd5Passwort(hash: string);
    procedure setMd5Salt(salt: string);
  public
    property Login      : string read FLogin write FLogin;
    property Md5Passwort: string read FMd5Passwort write setMd5Passwort;
    property Md5Salt    : string read FMd5Salt write setMd5Salt;
    constructor Create(Login, Md5Passwort, Md5Salt, name, Vorname: string;
      Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Aktualisieren();

  const
    TABLE_NAME = 'Benutzer';
  end;

type
  TBenutzerVerwaltung = class
  private
    SqlQuery      : TFDQuery;
    FBenutzerListe: TList<TBenutzer>;
  public
    property BenutzerListe: TList<TBenutzer> read FBenutzerListe write FBenutzerListe;
    constructor Create(Connection: TFDConnection);
    procedure BenutzerSuchen(Suchbegriff: string; Connection: TFDConnection);
  end;

implementation

{ TMitarbeiter }

procedure TMitarbeiter.Aktualisieren;
begin
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('UPDATE :table SET');
    Add('Name = :name, ');
    Add('Vorname = :vorname,');
    Add('WHERE Id = :id');
    ParamByName('table').Value   := self.TABLE_NAME;
    ParamByName('name').Value    := self.name;
    ParamByName('vorname').Value := self.Vorname;
    ParamByName('id').Value      := self.Id;
  end;
  self.SqlQuery.ExecSQL;
end;

constructor TMitarbeiter.Create(name, Vorname: string; Connection: TFDConnection);
begin
  self.name                := name;
  self.Vorname             := Vorname;
  self.SqlQuery            := TFDQuery.Create(nil);
  self.SqlQuery.Connection := Connection;
end;

constructor TMitarbeiter.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.SqlQuery            := TFDQuery.Create(nil);
  self.SqlQuery.Connection := Connection;
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM :table WHERE Id = :id');
    ParamByName('table').Value := self.TABLE_NAME;
    ParamByName('id').Value    := Id;
  end;
  self.SqlQuery.Open;
  if self.SqlQuery.RecordCount = 1 then
  begin
    self.Id      := self.SqlQuery.FieldByName('Id').AsInteger;
    self.name    := self.SqlQuery.FieldByName('Name').AsString;
    self.Vorname := self.SqlQuery.FieldByName('Vorname').AsString;
  end;
  self.SqlQuery.Close;
end;

procedure TMitarbeiter.IdErmitteln;
begin
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM :table ORDER BY Id DESC LIMIT 1');
    ParamByName('table').Value := self.TABLE_NAME;
  end;
  self.SqlQuery.Open;
  if self.SqlQuery.RecordCount = 1 then
    self.Id := self.SqlQuery.FieldByName('Id').AsInteger;
  self.SqlQuery.Close
end;

procedure TMitarbeiter.Loeschen;
begin
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('DELETE FROM :table WHERE Id = :id');
    ParamByName('table').Value := self.TABLE_NAME;
    ParamByName('id').Value    := self.Id;
  end;
  self.SqlQuery.ExecSQL;
end;

procedure TMitarbeiter.Speichern;
begin
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('INSERT INTO :table (Name, Vorname)');
    Add('VALUES (:name,:vorname'')');
    ParamByName('table').Value   := self.TABLE_NAME;
    ParamByName('name').Value    := self.name;
    ParamByName('vorname').Value := self.Vorname;
  end;
  self.SqlQuery.ExecSQL;
  self.IdErmitteln;
end;

{ TBenutzer }

procedure TBenutzer.Aktualisieren;
begin
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('UPDATE :table SET');
    Add('Login = :login,');
    Add('Md5Passwort = :pw,');
    Add('Md5Salt = :salt,');
    Add('Name = :name, ');
    Add('Vorname = :vorname');
    Add('WHERE Id = :id');
    ParamByName('table').Value   := self.TABLE_NAME;
    ParamByName('login').Value   := self.Login;
    ParamByName('pw').Value      := self.Md5Passwort;
    ParamByName('salt').Value    := self.Md5Salt;
    ParamByName('name').Value    := self.name;
    ParamByName('vorname').Value := self.Vorname;
    ParamByName('id').Value      := self.Id;
  end;
  self.SqlQuery.ExecSQL;
end;

constructor TBenutzer.Create(Login, Md5Passwort, Md5Salt, name, Vorname: string;
  Connection: TFDConnection);
begin
  self.Login               := Login;
  self.Md5Passwort         := Md5Passwort;
  self.Md5Salt             := Md5Salt;
  self.name                := name;
  self.Vorname             := Vorname;
  self.SqlQuery            := TFDQuery.Create(nil);
  self.SqlQuery.Connection := Connection;
end;

constructor TBenutzer.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.SqlQuery            := TFDQuery.Create(nil);
  self.SqlQuery.Connection := Connection;
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM :table WHERE Id = :id');
    ParamByName('table').Value := self.TABLE_NAME;
    ParamByName('id').Value    := Id;
  end;
  self.SqlQuery.Open;
  if self.SqlQuery.RecordCount = 1 then
  begin
    self.Id          := self.SqlQuery.FieldByName('Id').AsInteger;
    self.Login       := self.SqlQuery.FieldByName('Login').AsString;
    self.Md5Passwort := self.SqlQuery.FieldByName('Md5Passwort').AsString;
    self.Md5Salt     := self.SqlQuery.FieldByName('Md5Salt').AsString;
    self.name        := self.SqlQuery.FieldByName('Name').AsString;
    self.Vorname     := self.SqlQuery.FieldByName('Vorname').AsString;
  end;
  self.SqlQuery.Close;
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
  with self.SqlQuery, SQL do
  begin
    Clear;
    Add('INSERT INTO :table (Login, Md5Passwort, Md5Salt, Name, Vorname)');
    Add('VALUES (:login, :pw, :salt, :name, :vorname)');
    ParamByName('table').Value   := self.TABLE_NAME;
    ParamByName('login').Value   := self.Login;
    ParamByName('pw').Value      := self.Md5Passwort;
    ParamByName('salt').Value    := self.Md5Salt;
    ParamByName('name').Value    := self.name;
    ParamByName('vorname').Value := self.Vorname
  end;
  self.SqlQuery.ExecSQL;
  self.IdErmitteln;
end;

{ TBenutzerVerwaltung }

procedure TBenutzerVerwaltung.BenutzerSuchen(Suchbegriff: string; Connection: TFDConnection);
var
  I         : integer;
  BenutzerId: integer;
  Benutzer  : TBenutzer;
begin
  with self.SqlQuery, SQL do
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
  for I := 0 to self.SqlQuery.RecordCount do
  begin
    BenutzerId := self.SqlQuery.FieldByName('Id').AsInteger;
    Benutzer   := TBenutzer.CreateFromId(BenutzerId, Connection);
    self.BenutzerListe.Add(Benutzer);
    Benutzer.Free;
  end;
end;

constructor TBenutzerVerwaltung.Create(Connection: TFDConnection);
begin
  self.BenutzerListe := TList<TBenutzer>.Create;
end;

end.
