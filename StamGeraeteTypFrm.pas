unit StamGeraeteTypFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, classesArbeitsmittel, MainFrm, Helpers, SuchenFrm, XStammdatenFrm;

type
  TStamGeraeteTypForm = class(TXStammdatenForm)
    BezeichnungEdit: TEdit;
    HerstellerComboBox: TComboBox;
    ArbeitsmittelKlasseComboBox: TComboBox;
    HatSimRadioGroup: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    ArbeitsmittelTyp   : TArbeitsmittelTyp;
    ArbeitsmittelHelper: TArbeitsmittelHelper;
    procedure AnzeigeFuellen;
    procedure AnzeigeUmschalten(Status: TFormStatus);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  StamGeraeteTypForm: TStamGeraeteTypForm;

implementation

{$R *.dfm}

{ TStamGeraeteTypForm }

procedure TStamGeraeteTypForm.AnzeigeFuellen;
begin
  inherited
end;

procedure TStamGeraeteTypForm.AnzeigeUmschalten(Status: TFormStatus);
begin

end;

procedure TStamGeraeteTypForm.FormCreate(Sender: TObject);
begin
  inherited;
  self.ArbeitsmittelHelper := TArbeitsmittelHelper.create(MainForm.MainConnection);
end;

end.
