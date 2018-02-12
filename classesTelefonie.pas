unit classesTelefonie;

interface

uses System.SysUtils, System.StrUtils, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.UITypes;

type
  TTarif = class
  private
    TarifQuery          : TFDQuery;
    FId                 : integer;
    FBezeichnung        : string;
    FTelefonieMoeglich  : boolean;
    FIstSubventionierbar: boolean;
    procedure IdErmitteln();
  public
    property Id                 : integer read FId write FId;
    property Bezeichnung        : string read FBezeichnung write FBezeichnung;
    property TelefonieMoeglich  : boolean read FTelefonieMoeglich write FTelefonieMoeglich;
    property IstSubventionierbar: boolean read FIstSubventionierbar write FIstSubventionierbar;
    constructor Create(Bezeichnung: string; telefonie, subvention: boolean; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure Aktualisieren();
    procedure Loeschen();
  end;

type
  TRufnummer = class
  private
    RufnummerQuery     : TFDQuery;
    FId                : integer;
    FNummer            : string;
    FInterneKennung    : string;
    FTarif             : TTarif;
    FVertragsBegin     : Variant;
    FVertragsEnde      : Variant;
    FNaechsteSubvention: Variant;
  public
    property Id                : integer read FId write FId;
    property Nummer            : string read FNummer write FNummer;
    property InterneKennung    : string read FInterneKennung write FInterneKennung;
    property Tarif             : TTarif read FTarif write FTarif;
    property VertragsBegin     : Variant read FVertragsBegin write FVertragsBegin;
    property VertragsEnde      : Variant read FVertragsEnde write FVertragsEnde;
    property NaechsteSubvention: Variant read FNaechsteSubvention write FNaechsteSubvention;
    constructor Create(Nummer, kennung: string; Tarif: TTarif;
        vertBegin, vertEnde, nextSubvention: Variant; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure IdErmitteln();
    procedure Aktualisieren();
    procedure Loeschen();
  end;

type
  TSimKarte = class
  private
    SimKarteQuery: TFDQuery;
    FId          : integer;
    FSerienNummer: string;
    FPin         : string;
    FSuperPin    : string;
    FRufnummer   : TRufnummer;
    procedure setPin(Value: string);
    procedure setSuperPin(Value: string);
  public
    property Id          : integer read FId write FId;
    property SerienNummer: string read FSerienNummer write FSerienNummer;
    property Pin         : string read FPin write setPin;
    property SuperPin    : string read FSuperPin write setSuperPin;
    property Rufnummer   : TRufnummer read FRufnummer write FRufnummer;
    constructor Create(SerienNummer, Pin, SuperPin: string; Rufnummer: TRufnummer;
        Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
    procedure Speichern();
    procedure IdErmitteln();
    procedure Aktualisieren();
    procedure Loeschen();
  end;

implementation

{ TTarif }

procedure TTarif.Aktualisieren;
begin
  with self.TarifQuery, SQL do
  begin
    Clear;
    Add('UPDATE Tarif SET Bezeichnung = :bezeichnung,');
    Add('istTelefonieMoeglich = :telefonie,');
    Add('istSubventionierbar = :subvention');
    Add('WHERE Id = :id');
    ParamByName('bezeichnung').Value := self.Bezeichnung;
    ParamByName('telefonie').Value := self.TelefonieMoeglich;
    ParamByName('subvention').Value := self.IstSubventionierbar;
    ParamByName('id').Value := self.Id;
  end;
  self.TarifQuery.ExecSQL;
end;

constructor TTarif.Create(Bezeichnung: string; telefonie, subvention: boolean; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Bezeichnung := Bezeichnung;
  self.TelefonieMoeglich := telefonie;
  self.IstSubventionierbar := subvention;
  self.TarifQuery := TFDQuery.Create(nil);
  self.TarifQuery.Connection := Connection;
end;

constructor TTarif.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.TarifQuery := TFDQuery.Create(nil);
  self.TarifQuery.Connection := Connection;
  with self.TarifQuery, SQL do
  begin
    Add('SELECT * FROM Tarif WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.TarifQuery.Open;
  if self.TarifQuery.RecordCount = 1 then
  begin
    self.Id := self.TarifQuery.FieldByName('Id').AsInteger;
    self.Bezeichnung := self.TarifQuery.FieldByName('Bezeichnung').AsString;
    self.TelefonieMoeglich := self.TarifQuery.FieldByName('istTelefonieMoeglich').AsBoolean;
    self.IstSubventionierbar := self.TarifQuery.FieldByName('istSubventionierbar').AsBoolean;
  end;
  self.TarifQuery.Close;
end;

procedure TTarif.IdErmitteln;
begin
  with self.TarifQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Tarif ORDER BY Id DESC LIMIT 1');
  end;
  self.TarifQuery.Open;
  self.Id := self.TarifQuery.FieldByName('Id').AsInteger;
  self.TarifQuery.Close;
end;

procedure TTarif.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.TarifQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM Tarif WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.TarifQuery.ExecSQL;
  end;
end;

procedure TTarif.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.TarifQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO Tarif (Bezeichnung, istTelefonieMoeglich, istSubventionierbar)');
      Add('VALUES (:bezeichnung,:telefonie,:subvention)');
      ParamByName('bezeichnung').Value := self.Bezeichnung;
      ParamByName('telefonie').Value := self.TelefonieMoeglich;
      ParamByName('subvention').Value := self.IstSubventionierbar;
    end;
    self.TarifQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

{ TRufnummer }

procedure TRufnummer.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.RufnummerQuery, SQL do
    begin
      Clear;
      Add('UPDATE Rufnummer SET ');
      Add('Nummer = :nr, ');
      Add('InterneKennung = :kennung,');
      Add('Tarif_Id = :tarif,');
      Add('VertragsBeginn = :begin,');
      Add('VertragsEnde = :ende,');
      Add('NaechsteSubvention = :subvention');
      Add('WHERE Id = :id');
      ParamByName('nr').Value := self.Nummer;
      ParamByName('kennung').Value := self.InterneKennung;
      ParamByName('tarif').Value := self.Tarif.Id;
      ParamByName('begin').Value := self.VertragsBegin;
      ParamByName('ende').Value := self.VertragsEnde;
      ParamByName('subvention').Value := self.NaechsteSubvention;
      ParamByName('id').Value := self.Id;
    end;
    self.RufnummerQuery.ExecSQL;
  end;
end;

constructor TRufnummer.Create(Nummer, kennung: string; Tarif: TTarif; vertBegin, vertEnde,
    nextSubvention: Variant; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Nummer := Nummer;
  self.InterneKennung := kennung;
  self.Tarif := Tarif;
  self.VertragsBegin := vertBegin;
  self.VertragsEnde := vertEnde;
  self.NaechsteSubvention := nextSubvention;
  self.RufnummerQuery := TFDQuery.Create(nil);
  self.RufnummerQuery.Connection := Connection;
end;

constructor TRufnummer.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.RufnummerQuery := TFDQuery.Create(nil);
  self.RufnummerQuery.Connection := Connection;
  with self.RufnummerQuery, SQL do
  begin
    Add('SELECT * FROM Rufnummer WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.RufnummerQuery.Open;
  if self.RufnummerQuery.RecordCount = 1 then
  begin
    self.Id := self.RufnummerQuery.FieldByName('Id').AsInteger;
    self.Nummer := self.RufnummerQuery.FieldByName('Nummer').AsString;
    self.InterneKennung := self.RufnummerQuery.FieldByName('InterneKennung').AsString;
    self.Tarif := TTarif.CreateFromId(self.RufnummerQuery.FieldByName('Tarif_Id').AsInteger, Connection);
    self.VertragsBegin := self.RufnummerQuery.FieldByName('VertragsBeginn').AsDateTime;
    self.VertragsEnde := self.RufnummerQuery.FieldByName('VertragsEnde').AsVariant;
    self.NaechsteSubvention := self.RufnummerQuery.FieldByName('NaechsteSubvention').AsVariant;
  end;

end;

procedure TRufnummer.IdErmitteln;
begin
  with self.RufnummerQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM Rufnummer ORDER BY Id DESC LIMIT 1');
  end;
  self.RufnummerQuery.Open;
  self.Id := self.RufnummerQuery.FieldByName('Id').AsInteger;
  self.RufnummerQuery.Close;
end;

procedure TRufnummer.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.RufnummerQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM Rufnummer WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.RufnummerQuery.ExecSQL;
  end;
end;

procedure TRufnummer.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.RufnummerQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO Rufnummer (Nummer, InterneKennung, Tarif_Id, ');
      Add('VertragsBeginn, VertragsEnde, NaechsteSubvention)');
      Add('VALUES (:nr,:kennung,:tarif,:begin,:ende,:subvention)');
      ParamByName('nr').Value := self.Nummer;
      ParamByName('kennung').Value := self.InterneKennung;
      ParamByName('tarif').Value := self.Tarif.Id;
      ParamByName('begin').Value := self.VertragsBegin;
      ParamByName('ende').Value := self.VertragsEnde;
      ParamByName('subvention').Value := self.NaechsteSubvention;
    end;
    self.RufnummerQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

{ TSimKarte }

procedure TSimKarte.Aktualisieren;
begin
  if self.Id <> 0 then
  begin
    with self.SimKarteQuery, SQL do
    begin
      Clear;
      Add('UPDATE SimKarte SET');
      Add('SerienNummer = :seriennr, ');
      Add('Pin = :pin,');
      Add('SuperPin = :superpin,');
      Add('Rufnummer_Id = :rufnummer');
      Add('WHERE Id = :id');
      ParamByName('seriennr').Value := self.SerienNummer;
      ParamByName('pin').Value := self.Pin;
      ParamByName('superpin').Value := self.SuperPin;
      ParamByName('rufnummer').Value := self.Rufnummer.Id;
      ParamByName('id').Value := self.Id;
    end;
    self.SimKarteQuery.ExecSQL;
  end;
end;

constructor TSimKarte.Create(SerienNummer, Pin, SuperPin: string; Rufnummer: TRufnummer;
    Connection: TFDConnection);
begin
  self.Id := 0;
  self.SerienNummer := SerienNummer;
  self.Pin := Pin;
  self.SuperPin := SuperPin;
  self.Rufnummer := Rufnummer;
  self.SimKarteQuery := TFDQuery.Create(nil);
  self.SimKarteQuery.Connection := Connection;
end;

constructor TSimKarte.CreateFromId(Id: integer; Connection: TFDConnection);
begin
  self.SimKarteQuery := TFDQuery.Create(nil);
  self.SimKarteQuery.Connection := Connection;
  with self.SimKarteQuery, SQL do
  begin
    Add('SELECT * FROM SimKarte WHERE Id = :id');
    ParamByName('id').Value := Id;
  end;
  self.SimKarteQuery.Open;
  if self.SimKarteQuery.RecordCount = 1 then
  begin
    self.Id := self.SimKarteQuery.FieldByName('Id').AsInteger;
    self.SerienNummer := self.SimKarteQuery.FieldByName('Seriennummer').AsString;
    self.Pin := self.SimKarteQuery.FieldByName('Pin').AsString;
    self.SuperPin := self.SimKarteQuery.FieldByName('SuperPin').AsString;
    self.Rufnummer := TRufnummer.CreateFromId(self.SimKarteQuery.FieldByName('Rufnummer_id').AsInteger, Connection);
  end;
end;

procedure TSimKarte.IdErmitteln;
begin
  with self.SimKarteQuery, SQL do
  begin
    Clear;
    Add('SELECT Id FROM SimKarte ORDER BY Id DESC LIMIT 1');
  end;
  self.SimKarteQuery.Open;
  self.Id := self.SimKarteQuery.FieldByName('Id').AsInteger;
  self.SimKarteQuery.Close;
end;

procedure TSimKarte.Loeschen;
begin
  if self.Id <> 0 then
  begin
    with self.SimKarteQuery, SQL do
    begin
      Clear;
      Add('DELETE FROM SimKarte WHERE Id = :id');
      ParamByName('id').Value := self.Id;
    end;
    self.SimKarteQuery.ExecSQL;
  end;
end;

procedure TSimKarte.setPin(Value: string);
var
  pinAsInt: integer;
begin
  if Length(Value) in [4 .. 8] then
    if tryStrToInt(Value, pinAsInt) then
      FPin := Value
    else
      MessageDlg('Die Pin darf nur Zahlen enthalten!', mtError, [mbOk], 0)
  else
    MessageDlg('Die Pin muss zwischen 4 und 8 Zeichen lang sein!', mtError, [mbOk], 0);
end;

procedure TSimKarte.setSuperPin(Value: string);
var
  superPinAsInt: integer;
begin
  if Length(Value) = 8 then
    if tryStrToInt(Value, superPinAsInt) then
      FSuperPin := Value
    else
      MessageDlg('Die Superpin darf nur Zahlen enthalten!', mtError, [mbOk], 0)
  else
    MessageDlg('Die Superpin muss 8 Zeichen lang sein!', mtError, [mbOk], 0);
end;

procedure TSimKarte.Speichern;
begin
  if self.Id = 0 then
  begin
    with self.SimKarteQuery, SQL do
    begin
      Clear;
      Add('INSERT INTO SimKarte (SerienNummer, Pin, SuperPin, Rufnummer_Id)');
      Add('VALUES (:seriennr,:pin,:superpin,:rufnummer'')');
      ParamByName('seriennr').Value := self.SerienNummer;
      ParamByName('pin').Value := self.Pin;
      ParamByName('superpin').Value := self.SuperPin;
      ParamByName('rufnummer').Value := self.Rufnummer.Id;
    end;
    self.SimKarteQuery.ExecSQL;
    self.IdErmitteln;
  end;
end;

end.
