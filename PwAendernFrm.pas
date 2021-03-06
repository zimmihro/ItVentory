unit PwAendernFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Helpers;

type
  TPasswort = record
    md5Hash: string;
    md5Salt: string;
  end;

type
  TPwAendernForm = class(TForm)
    Passwort1Edit: TEdit;
    Passwort2Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OkButton: TButton;
    AbbrechenButton: TButton;
    procedure OkButtonClick(Sender: TObject);
    procedure AbbrechenButtonClick(Sender: TObject);
    procedure Passwort2EditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    Passwort: TPasswort;
  end;

var
  PwAendernForm: TPwAendernForm;

implementation

{$R *.dfm}

{ TPwAendernForm }

procedure TPwAendernForm.AbbrechenButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  self.CloseModal;
end;

procedure TPwAendernForm.OkButtonClick(Sender: TObject);
var
  md5Salt    : string;
  validierung: boolean;
begin
  validierung := (Passwort1Edit.Text <> '') and (Passwort2Edit.Text <> '') and
      (Passwort1Edit.Text = Passwort2Edit.Text);
  if validierung then
  begin
    md5Salt := Helpers.getRandomString(32);
    self.Passwort.md5Hash := Helpers.getMD5Hash(Passwort1Edit.Text + md5Salt);
    self.Passwort.md5Salt := md5Salt;
    ModalResult := mrOk;
    self.CloseModal;
  end
  else
    messageDlg('Die gew�hlten Passw�rter stimmen nicht �berein. Bitte wiederholen Sie die Eingabe!', mtError,
        [mbOK], 0);
end;

procedure TPwAendernForm.Passwort2EditKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
    begin
      OkButton.Click;
      Key := #0;
    end;
end;

end.
