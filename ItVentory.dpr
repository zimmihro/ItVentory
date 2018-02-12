program ItVentory;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  Helpers in 'Helpers.pas',
  LoginFrm in 'LoginFrm.pas' {AnmeldeForm},
  StamMitarbeiterFrm in 'StamMitarbeiterFrm.pas' {StamMitarbeiterForm},
  StamBenutzerFrm in 'StamBenutzerFrm.pas' {StamBenutzerForm},
  PwAendernFrm in 'PwAendernFrm.pas' {PwAendernForm},
  classesArbeitsmittel in 'classesArbeitsmittel.pas',
  classesPersonen in 'classesPersonen.pas',
  classesTelefonie in 'classesTelefonie.pas',
  classesGeraeteAusgabe in 'classesGeraeteAusgabe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAnmeldeForm, AnmeldeForm);
  Application.CreateForm(TStamMitarbeiterForm, StamMitarbeiterForm);
  Application.CreateForm(TStamBenutzerForm, StamBenutzerForm);
  Application.CreateForm(TPwAendernForm, PwAendernForm);
  Application.Run;
end.
