unit LoginFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ExtCtrls, System.UITypes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TAnmeldeForm = class(TForm)
    UserEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PasswortEdit: TEdit;
    AnmeldenButton: TButton;
    AbbrechenButton: TButton;
    LoginQuery: TFDQuery;
    SaltQuery: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure AnmeldenButtonClick(Sender: TObject);
    function getSalt(input: string): string;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    Versuche: Integer;
  public
    { Public-Deklarationen }
  end;

var
  AnmeldeForm: TAnmeldeForm;

implementation

uses MainFrm, Helpers;

{$R *.DFM}


procedure TAnmeldeForm.FormCreate(Sender: TObject);
begin
  Versuche := 0;
end;

procedure TAnmeldeForm.FormShow(Sender: TObject);
begin
  UserEdit.SetFocus;
end;


function TAnmeldeForm.getSalt(input: string): string;
begin
  result := '';
  SaltQuery.Close;
  SaltQuery.ParamByName('user').Value := UserEdit.Text;
  SaltQuery.Open;
  if (SaltQuery.RecordCount = 1) then
    result := SaltQuery.FieldByName('Md5Salt').AsString;
end;

procedure TAnmeldeForm.AnmeldenButtonClick(Sender: TObject);
var
  pwmd5: string;
  salt : string;
begin
  try
    MainForm.MainConnection.Open;
  except
    MessageDlg('Beim Verbinden mit der Datenbank trat ein Fehler auf!' + #13 +
        'Bitte überprüfen Sie die Netzwerk-Verbindung und versuchen Sie es erneut.', mtError, [mbOk], 0);
    exit;
  end;

  salt := getSalt(UserEdit.Text);
  pwmd5 := getMD5Hash(PasswortEdit.Text + salt);
  LoginQuery.ParamByName('user').Value := UserEdit.Text;
  LoginQuery.ParamByName('pw').Value := pwmd5;

  try
    LoginQuery.Open;
  except
    MessageDlg('Beim Verbinden mit der Datenbank trat ein Fehler auf!' + #13 +
        'Die angegebene Datenbank ist ungültig oder beschädigt!', mtError, [mbOk], 0);
    Application.Terminate;
    exit;
  end;

  if (LoginQuery.RecordCount = 1) then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    inc(Versuche);
    if Versuche = 3 then
      ModalResult := mrCancel
    else
    begin
      MessageDlg('Falscher Benutzername oder falsches Kennwort!' + #13 + #10
          + 'Bitte versuchen Sie es nocheinmal.', mtError, [mbOk], 0);
      PasswortEdit.Text := '';
      PasswortEdit.SetFocus;
    end;
  end;
end;

end.
