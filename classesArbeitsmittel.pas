unit classesArbeitsmittel;

interface

uses System.SysUtils, System.StrUtils, Vcl.Dialogs, System.UITypes, classesPersonen, classesTelefonie,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.StdCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  THersteller = class
  private
    HerstellerQuery: TFDQuery;
    FId            : integer;
    FBezeichnung   : string;
    procedure IdErmitteln();
  public
    property Id         : integer read FId write FId;
    property Bezeichnung: string read FBezeichnung write FBezeichnung;
    constructor Create(Bezeichnung: string; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Loeschen();
    procedure Aktualisieren();
  end;

type
  TArbeitsmittelKlasse = class
  private
    KlassenQuery: TFDQuery;
    FId         : integer;
    FBezeichnung: String;
    procedure IdErmitteln();
  public
    property Id         : integer read FId write FId;
    property Bezeichnung: string read FBezeichnung write FBezeichnung;
    constructor Create(Bezeichnung: string; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Loeschen();
    procedure Aktualisieren();
  end;

type
  TArbeitsmittelTyp = class
  private
    TypenQuery          : TFDQuery;
    FId                 : integer;
    FBezeichnung        : string;
    FHersteller         : THersteller;
    FArbeistmittelKlasse: TArbeitsmittelKlasse;
    FHatSim             : boolean;
    procedure IdErmitteln();
  public
    property Id                 : integer read FId write FId;
    property Bezeichnung        : string read FBezeichnung write FBezeichnung;
    property Hersteller         : THersteller read FHersteller write FHersteller;
    property ArbeitsmittelKlasse: TArbeitsmittelKlasse read FArbeistmittelKlasse write FArbeistmittelKlasse;
    property HatSim             : boolean read FHatSim write FHatSim;
    constructor Create(Bezeichnung: string; Hersteller: THersteller; klasse: TArbeitsmittelKlasse;
        HatSim: boolean; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Loeschen();
    procedure Aktualisieren();
  end;

type
  TArbeitsmittel = class
  private
    ArbeitsmittelQuery: TFDQuery;
    FId               : integer;
    FBezeichnung      : string;
    FArbeitsmittelTyp : TArbeitsmittelTyp;
    FImei             : Variant;
    FSerienNummer     : Variant;
    FSimKarte         : TSimKarte;
    procedure setImei(Value: Variant);
    procedure IdErmitteln();
  public
    property Id              : integer read FId write FId;
    property Bezeichnung     : string read FBezeichnung write FBezeichnung;
    property ArbeitsmittelTyp: TArbeitsmittelTyp read FArbeitsmittelTyp write FArbeitsmittelTyp;
    property Imei            : Variant read FImei write setImei;
    property SerienNummer    : Variant read FSerienNummer write FSerienNummer;
    property SimKarte        : TSimKarte read FSimKarte write FSimKarte;
    constructor Create(Bezeichnung: string; typ: TArbeitsmittelTyp; Imei, serienNr: Variant;
        Connection: TFDConnection; sim: TSimKarte = nil);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Loeschen();
    procedure Aktualisieren();
  end;

implementation

{ THersteller }

procedure THersteller.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.HerstellerQuery, SQL do
    begin
      Clear;
      Add('UPDATE Hersteller');
      Add('SET Bezeichnung = :name');
      Add('WHERE Id = :id');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('id').Value := self.Id;
    end;
    self.HerstellerQuery.ExecSQL;
  end;
end;

constructor THersteller.Create(Bezeichnung: string; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Bezeichnung := Bezeichnung;
  self.HerstellerQuery := TFDQuery.Create(nil);
  self.HerstellerQuery.Connection := Connection;
end;

constructor THersteller.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.HerstellerQuery := TFDQuery.Create(nil);
  self.HerstellerQuery.Connection := Connection;
  with self.HerstellerQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM Hersteller WHERE Id = :id');
    ParamByName('id').Value := Id;
    Open;
  end;
  if self.HerstellerQuery.RecordCount = 1 then
  begin
    self.Id := self.HerstellerQuery.FieldByName('Id').AsInteger;
    self.Bezeichnung := self.HerstellerQuery.FieldByName('Bezeichnung').AsString;
  end;
  self.HerstellerQuery.Close;
end;

procedure THersteller.IdErmitteln;
begin
  with self.HerstellerQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Hersteller ORDER BY Id DESC LIMIT 1');
  end;
  self.HerstellerQuery.Open;
  if self.HerstellerQuery.RecordCount = 1 then
    self.Id := self.HerstellerQuery.FieldByName('Id').AsInteger;
  self.HerstellerQuery.Close
end;

procedure THersteller.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.HerstellerQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM Hersteller WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.HerstellerQuery.ExecSQL;
  end;
end;

procedure THersteller.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.HerstellerQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO Hersteller (Bezeichnung)');
      Add('VALUES (:name)');
      ParamByName('name').Value := self.Bezeichnung;
    end;
    self.HerstellerQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

{ TArbeitsmittelKlasse }

procedure TArbeitsmittelKlasse.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.KlassenQuery, SQL do
    begin
      Clear;
      Add('UPDATE ArbeitsmittelKlasse');
      Add('SET Bezeichnung = :name');
      Add('WHERE Id = :id');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('id').Value := self.Id;
    end;
    self.KlassenQuery.ExecSQL;
  end;
end;

constructor TArbeitsmittelKlasse.Create(Bezeichnung: string; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Bezeichnung := Bezeichnung;
  self.KlassenQuery := TFDQuery.Create(nil);
  self.KlassenQuery.Connection := Connection
end;

constructor TArbeitsmittelKlasse.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.KlassenQuery := TFDQuery.Create(nil);
  self.KlassenQuery.Connection := Connection;
  with self.KlassenQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM ArbteitsmittelKlasse WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.KlassenQuery.Open();
  if self.KlassenQuery.RecordCount = 1 then
  begin
    self.Id := self.KlassenQuery.FieldByName('Id').AsInteger;
    self.Bezeichnung := self.KlassenQuery.FieldByName('Bezeichnung').AsString;
  end;
  self.KlassenQuery.Close;
end;

procedure TArbeitsmittelKlasse.IdErmitteln;
begin
  with self.KlassenQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM ArbeitsmittelKlasse ORDER BY Id DESC LIMIT 1');
  end;
  self.KlassenQuery.Open;
  if self.KlassenQuery.RecordCount = 1 then
    self.Id := self.KlassenQuery.FieldByName('Id').AsInteger;
  self.KlassenQuery.Close
end;

procedure TArbeitsmittelKlasse.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.KlassenQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM ArbeitsmittelKlasse WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.KlassenQuery.ExecSQL;
  end;
end;

procedure TArbeitsmittelKlasse.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.KlassenQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO ArbeitsmittelKlasse (Bezeichnung)');
      Add('VALUES (:name)');
      ParamByName('name').Value := self.Bezeichnung;
    end;
    self.KlassenQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

{ TArbeitsmittelTyp }

procedure TArbeitsmittelTyp.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.TypenQuery, SQL do
    begin
      Clear;
      Add('UPDATE ArbeitsmittelTyp');
      Add('SET Bezeichnung = :name,');
      Add('Hersteller = :hersteller,');
      Add('ArbeitsmittelKlasse = :klasse,');
      Add('HatSim = :sim');
      Add('WHERE Id = :id');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('hersteller').Value := self.Hersteller.Id;
      ParamByName('klasse').Value := self.ArbeitsmittelKlasse.Id;
      ParamByName('sim').Value := self.HatSim;
      ParamByName('id').Value := self.Id;
    end;
    self.TypenQuery.ExecSQL;
  end;
end;

constructor TArbeitsmittelTyp.Create(Bezeichnung: string; Hersteller: THersteller;
    klasse: TArbeitsmittelKlasse; HatSim: boolean; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Bezeichnung := Bezeichnung;
  self.Hersteller := Hersteller;
  self.ArbeitsmittelKlasse := klasse;
  self.HatSim := HatSim;
  self.TypenQuery := TFDQuery.Create(nil);
  self.TypenQuery.Connection := Connection;
end;

constructor TArbeitsmittelTyp.CreateFromId(Id: integer; Connection: TFDConnection);
var
  Hersteller_Id: integer;
  Klassen_Id   : integer;
begin
  self.TypenQuery := TFDQuery.Create(nil);
  self.TypenQuery.Connection := Connection;
  with self.TypenQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM ArbeitsmittelTyp WHERE Id = :id');
    ParamByName('id').Value := Id;
    Open;
  end;
  if self.TypenQuery.RecordCount = 1 then
  begin
    Hersteller_Id := self.TypenQuery.FieldByName('Hersteller_Id').AsInteger;
    Klassen_Id := self.TypenQuery.FieldByName('ArbeitsmittelKlasse_Id').AsInteger;
    self.Id := self.TypenQuery.FieldByName('Id').AsInteger;
    self.Bezeichnung := self.TypenQuery.FieldByName('Bezeichnung').AsString;
    self.Hersteller := THersteller.CreateFromId(Hersteller_Id, Connection);
    self.ArbeitsmittelKlasse := TArbeitsmittelKlasse.CreateFromId(Klassen_Id, Connection);
    self.HatSim := self.TypenQuery.FieldByName('HatSim').AsBoolean;
  end;
  self.TypenQuery.Close;
end;

procedure TArbeitsmittelTyp.IdErmitteln;
begin
  with self.TypenQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM ArbeitsmittelTyp ORDER BY Id DESC LIMIT 1');
  end;
  self.TypenQuery.Open;
  if self.TypenQuery.RecordCount = 1 then
    self.Id := self.TypenQuery.FieldByName('Id').AsInteger;
  self.TypenQuery.Close
end;

procedure TArbeitsmittelTyp.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.TypenQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM Arbeitsmitteltyp WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.TypenQuery.ExecSQL;
  end;
end;

procedure TArbeitsmittelTyp.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.TypenQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO ArbeitsmittelTyp (Bezeichnung, Hersteller_id, ArbeitsmittelKlasse_Id, HatSim)');
      Add('VALUES(:name, :hersteller, :klasse, :sim)');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('hersteller').Value := self.Hersteller.Id;
      ParamByName('klasse').Value := self.ArbeitsmittelKlasse.Id;
      ParamByName('sim').Value := self.HatSim;
    end;
    self.TypenQuery.ExecSQL;
    self.IdErmitteln;
  end;

end;

{ TArbeitsmittel }

procedure TArbeitsmittel.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.ArbeitsmittelQuery, SQL do
    begin
      Clear;
      Add('UPDATE Arbeitsmittel');
      Add('SET Bezeichnung = :name,');
      Add('ArbeitsmittelTyp_id = :typ,');
      Add('IMEI = :imei,');
      Add('Seriennummer = :serial,');
      Add('Sim_Id = :sim');
      Add('WHERE Id = :id');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('typ').Value := self.ArbeitsmittelTyp.Id;
      ParamByName('imei').Value := self.Imei;
      ParamByName('serial').Value := self.SerienNummer;
      if self.ArbeitsmittelTyp.HatSim then
        ParamByName('sim').Value := self.SimKarte.Id
      else
        ParamByName('sim').Clear;
      ParamByName('id').Value := self.Id;
    end;
    self.ArbeitsmittelQuery.ExecSQL;
  end;
end;

constructor TArbeitsmittel.Create(Bezeichnung: string; typ: TArbeitsmittelTyp; Imei, serienNr: Variant;
    Connection: TFDConnection; sim: TSimKarte = nil);
begin
  self.Id := 0;
  self.Bezeichnung := Bezeichnung;
  self.ArbeitsmittelTyp := typ;
  self.Imei := Imei;
  self.SerienNummer := serienNr;
  self.SimKarte := sim;
  self.ArbeitsmittelQuery := TFDQuery.Create(nil);
  self.ArbeitsmittelQuery.Connection := Connection;
end;

constructor TArbeitsmittel.CreateFromId(Id: integer; Connection: TFDConnection);
var
  Typen_Id: integer;
  Sim_Id  : integer;
begin
  self.ArbeitsmittelQuery := TFDQuery.Create(nil);
  self.ArbeitsmittelQuery.Connection := Connection;
  with self.ArbeitsmittelQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM Arbeitsmittel WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.ArbeitsmittelQuery.Open();
  if self.ArbeitsmittelQuery.RecordCount = 1 then
  begin
    self.Id := self.ArbeitsmittelQuery.FieldByName('Id').AsInteger;
    self.Bezeichnung := self.ArbeitsmittelQuery.FieldByName('Bezeichnung').AsString;
    Typen_Id := self.ArbeitsmittelQuery.FieldByName('ArbeitsmittelTyp_Id').AsInteger;
    self.ArbeitsmittelTyp := TArbeitsmittelTyp.CreateFromId(Typen_Id, Connection);
    self.Imei := self.ArbeitsmittelQuery.FieldByName('IMEI').AsVariant;
    self.SerienNummer := self.ArbeitsmittelQuery.FieldByName('Seriennummer').AsVariant;
    if self.ArbeitsmittelTyp.HatSim then
    begin
      Sim_Id := self.ArbeitsmittelQuery.FieldByName('Sim_Id').AsVariant;
      self.SimKarte := TSimKarte.CreateFromId(Sim_Id, Connection);
    end;
  end;
  self.ArbeitsmittelQuery.Close;
end;

procedure TArbeitsmittel.IdErmitteln;
begin
  with self.ArbeitsmittelQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Arbeitsmittel ORDER BY Id DESC LIMIT 1');
  end;
  self.ArbeitsmittelQuery.Open();
  if self.ArbeitsmittelQuery.RecordCount = 1 then
    self.Id := self.ArbeitsmittelQuery.FieldByName('Id').AsInteger;
  self.ArbeitsmittelQuery.Close;
end;

procedure TArbeitsmittel.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.ArbeitsmittelQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM Arbeitsmittel WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.ArbeitsmittelQuery.ExecSQL
  end;
end;

procedure TArbeitsmittel.setImei(Value: Variant);
var
  imeiAsInt: integer;
begin
  if Length(Value) = 15 then
    if tryStrToInt(Value, imeiAsInt) then
      self.FImei := Value
    else
      MessageDlg('Die IMEI darf nur Zahlen enthalten!', mtError, [mbOk], 0)
  else
    MessageDlg('Die IMEI muss 15 Zeichen lang sein!', mtError, [mbOk], 0);
end;

procedure TArbeitsmittel.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.ArbeitsmittelQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO Arbeitsmittel (Bezeichnung, ArbeitsmittelTyp_Id, IMEI, Seriennummer, Sim_Id)');
      Add('VALUES (:name, :typ, :imei, :serial, :sim)');
      ParamByName('name').Value := self.Bezeichnung;
      ParamByName('typ').Value := self.ArbeitsmittelTyp.Id;
      ParamByName('imei').Value := self.Imei;
      ParamByName('serial').Value := self.SerienNummer;
      if self.ArbeitsmittelTyp.HatSim then
        ParamByName('sim').Value := self.SimKarte.Id
      else
        ParamByName('sim').Clear;
    end;
    self.ArbeitsmittelQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

end.
