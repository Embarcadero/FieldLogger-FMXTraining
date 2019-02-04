program FieldLogger;

uses
  System.StartUpCopy,
  FMX.Forms,
  formMain in 'forms\formMain.pas' {frmMain},
  fieldlogger.authentication in 'units\fieldlogger.authentication.pas',
  modMain in 'modules\modMain.pas' {dmMain: TDataModule},
  fieldlogger.data in 'units\fieldlogger.data.pas',
  fieldlogger.projectdata.standard in 'units\fieldlogger.projectdata.standard.pas',
  fieldlogger.logdata.standard in 'units\fieldlogger.logdata.standard.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
