unit XStammdatenFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MainFrm, Helpers, SuchenFrm;

type
  TXStammdatenForm = class(TForm)
    NeuButton: TButton;
    BearbeitenButton: TButton;
    SpeichernButton: TButton;
    AbbrechenButton: TButton;
    LoeschenButton: TButton;
    SuchenButton: TButton;
    procedure AnzeigeUmschalten(Status: TFormStatus);
    procedure FormShow(Sender: TObject);
    procedure BearbeitenButtonClick(Sender: TObject);
  private

    { Private-Deklarationen }
  public
    FormStatus : TFormstatus;
    { Public-Deklarationen }
  end;

var
  XStammdatenForm: TXStammdatenForm;

implementation

{$R *.dfm}

{ TXStammdatenForm }

procedure TXStammdatenForm.AnzeigeUmschalten(Status: TFormStatus);
begin
  self.FormStatus := Status;
  self.NeuButton.Enabled := self.FormStatus in [fsGesperrt, fsLeer];
  self.BearbeitenButton.Enabled := self.FormStatus = fsGesperrt;
  self.SpeichernButton.Enabled := not(self.FormStatus in [fsGesperrt, fsLeer]);
  self.AbbrechenButton.Enabled := self.FormStatus in [fsBearbeiten, fsNeu];
  self.LoeschenButton.Enabled := self.FormStatus = fsGesperrt;
  self.SuchenButton.Enabled := self.FormStatus in [fsGesperrt, fsLeer];
end;

procedure TXStammdatenForm.BearbeitenButtonClick(Sender: TObject);
begin
  self.AnzeigeUmschalten(fsBearbeiten);
end;

procedure TXStammdatenForm.FormShow(Sender: TObject);
begin
  self.AnzeigeUmschalten(fsLeer);
end;

end.
