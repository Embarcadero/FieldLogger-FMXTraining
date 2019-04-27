program FieldLogger;

uses
  System.StartUpCopy,
  FMX.Forms,
  formMain in 'forms\formMain.pas' {frmMain},
  fieldlogger.authentication in '..\Common\units\fieldlogger.authentication.pas',
  fieldlogger.data in '..\Common\units\fieldlogger.data.pas',
  fieldlogger.logdata.standard in '..\Common\units\fieldlogger.logdata.standard.pas',
  fieldlogger.projectdata.standard in '..\Common\units\fieldlogger.projectdata.standard.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
