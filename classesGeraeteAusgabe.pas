unit classesGeraeteAusgabe;

interface

uses System.SysUtils, System.StrUtils, Vcl.Dialogs, System.UITypes, classesPersonen, classesTelefonie,
  classesArbeitsmittel, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TGeraeteAusgabe = class
  private
    AusgabeQuery   : TFDQuery;
    FId            : integer;
    FMitarbeiter   : TMitarbeiter;
    FArbeitsmittel : TArbeitsmittel;
    FDatumAusgabe  : TDateTime;
    FDatumRueckgabe: variant;
    FAusgabeDurch  : TBenutzer;
  public
    property Id            : integer read FId write FId;
    property Mitarbeiter   : TMitarbeiter read FMitarbeiter write FMitarbeiter;
    property Arbeitsmittel : TArbeitsmittel read FArbeitsmittel write FArbeitsmittel;
    property DatumAusgabe  : TDateTime read FDatumAusgabe write FDatumAusgabe;
    property DatumRueckgabe: variant read FDatumRueckgabe write FDatumRueckgabe;
    property AusgabeDurch  : TBenutzer read FAusgabeDurch write FAusgabeDurch;
    constructor Create(Mitarbeiter: TMitarbeiter; Arbeitsmittel: TArbeitsmittel; DatumAusgabe: TDateTime;
        DatumRueckgabe: variant; AusgabeDurch: TBenutzer; Connection: TFDConnection);
    constructor CreateFromId(Id: integer; Connection: TFDConnection);
  end;

implementation

{ TGeraetAusgaben }

constructor TGeraeteAusgabe.Create(Mitarbeiter: TMitarbeiter; Arbeitsmittel: TArbeitsmittel;
    DatumAusgabe: TDateTime; DatumRueckgabe: variant; AusgabeDurch: TBenutzer; Connection: TFDConnection);
begin
  self.Id := 0;
  self.Mitarbeiter := Mitarbeiter;
  self.Arbeitsmittel := Arbeitsmittel;
  self.DatumAusgabe := DatumAusgabe;
  self.DatumRueckgabe := DatumRueckgabe;
  self.AusgabeDurch := AusgabeDurch;
  self.AusgabeQuery := TFDQuery.Create(nil);
  self.AusgabeQuery.Connection := Connection;
end;

constructor TGeraeteAusgabe.CreateFromId(Id: integer; Connection: TFDConnection);
var
  Geraete_Id    : integer;
  Mitarbeiter_Id: integer;
  Benutzer_Id   : integer;
begin
  self.AusgabeQuery := TFDQuery.Create(nil);
  self.AusgabeQuery.Connection := Connection;
  with self.AusgabeQuery, SQL do
  begin
    Clear;
    Add('SELECT * FROM Mitarbeiter_Arbeitsmittel WHERE Id = :id');
    ParamByName('id').Value := Id;
    Open;
  end;
  if self.AusgabeQuery.RecordCount = 1 then
  begin
    Geraete_Id := self.AusgabeQuery.FieldByName('Arbeitsmittel_Id').AsInteger;
    Mitarbeiter_Id := self.AusgabeQuery.FieldByName('Mitarbeiter_Id').AsInteger;
    Benutzer_Id := self.AusgabeQuery.FieldByName('UebergabeDurchBenutzer_Id').AsInteger;
    self.Id := self.AusgabeQuery.FieldByName('Id').AsInteger;
    self.Mitarbeiter := TMitarbeiter.CreateFromId(Mitarbeiter_Id, Connection);
    self.Arbeitsmittel := TArbeitsmittel.CreateFromId(Geraete_Id, Connection);
    self.DatumAusgabe := self.AusgabeQuery.FieldByName('DatumAusgabe').AsDateTime;
    self.DatumRueckgabe := self.AusgabeQuery.FieldByName('DatumRueckgabe').AsVariant;
    self.AusgabeDurch := TBenutzer.CreateFromId(Benutzer_Id, Connection);
  end;
  self.AusgabeQuery.Close;
end;

end.
