program FieldLogger10;

uses
  System.StartUpCopy,
  FMX.Forms,
  formMain in 'forms\formMain.pas' {frmMain},
  fieldlogger.authentication in 'units\fieldlogger.authentication.pas',
  fieldlogger.data in 'units\fieldlogger.data.pas',
  fieldlogger.projectdata.standard in 'units\fieldlogger.projectdata.standard.pas',
  fieldlogger.logdata.standard in 'units\fieldlogger.logdata.standard.pas',
  uSigninFrame in 'frames\uSigninFrame.pas' {SigninFrame: TFrame},
  uProjectsFrame in 'frames\uProjectsFrame.pas' {ProjectsFrame: TFrame},
  uProjectDetailsFrame in 'frames\uProjectDetailsFrame.pas' {ProjectDetailsFrame: TFrame},
  uEntryDetailsFrame in 'frames\uEntryDetailsFrame.pas' {EntryDetailsFrame: TFrame},
  uNewEntryFrame in 'frames\uNewEntryFrame.pas' {NewEntryFrame: TFrame},
  uNewProjectFrame in 'frames\uNewProjectFrame.pas' {NewProjectFrame: TFrame},
  uReportingFrame in 'frames\uReportingFrame.pas' {ReportingFrame: TFrame},
  uDataModule in 'forms\uDataModule.pas' {mainDM: TDataModule},
  uProgressFrame in 'frames\uProgressFrame.pas' {ProgressFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TmainDM, mainDM);
  Application.Run;

end.
