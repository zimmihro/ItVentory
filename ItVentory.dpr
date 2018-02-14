program ItVentory;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  Helpers in 'Helpers.pas',
  LoginFrm in 'LoginFrm.pas' {AnmeldeForm},
  StamBenutzerFrm in 'StamBenutzerFrm.pas' {StamBenutzerForm},
  PwAendernFrm in 'PwAendernFrm.pas' {PwAendernForm},
  classesArbeitsmittel in 'classesArbeitsmittel.pas',
  classesPersonen in 'classesPersonen.pas',
  classesTelefonie in 'classesTelefonie.pas',
  classesGeraeteAusgabe in 'classesGeraeteAusgabe.pas',
  SuchenFrm in 'SuchenFrm.pas' {SuchenForm},
  XStammdatenFrm in 'XStammdatenFrm.pas' {XStammdatenForm},
  StamMitarbeiterFrm in 'StamMitarbeiterFrm.pas' {StamMitarbeiterForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAnmeldeForm, AnmeldeForm);
  Application.CreateForm(TStamBenutzerForm, StamBenutzerForm);
  Application.CreateForm(TPwAendernForm, PwAendernForm);
  Application.CreateForm(TSuchenForm, SuchenForm);
  Application.CreateForm(TXStammdatenForm, XStammdatenForm);
  Application.CreateForm(TStamMitarbeiterForm, StamMitarbeiterForm);
  Application.Run;
end.
