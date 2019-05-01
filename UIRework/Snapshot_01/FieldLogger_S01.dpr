program FieldLogger_S01;

uses
  System.StartUpCopy,
  FMX.Forms,
  uformMain in 'forms\uformMain.pas' {frmMain},
  fieldlogger.authentication in '..\Common\units\fieldlogger.authentication.pas',
  fieldlogger.data in '..\Common\units\fieldlogger.data.pas',
  fieldlogger.logdata.standard in '..\Common\units\fieldlogger.logdata.standard.pas',
  fieldlogger.projectdata.standard in '..\Common\units\fieldlogger.projectdata.standard.pas',
  uframeSignIn in 'frames\uframeSignIn.pas' {frameSignIn: TFrame},
  uframeProjects in 'frames\uframeProjects.pas' {frameProjects: TFrame},
  dmConnection in '..\Common\dmConnection.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
