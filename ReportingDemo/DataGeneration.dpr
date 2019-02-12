program FieldLoggerReporting;

uses
  System.StartUpCopy,
  FMX.Forms,
  FieldLogReportMain in 'FieldLogReportMain.pas' {Form53},
  FieldLogReportDM in 'FieldLogReportDM.pas' {dmFieldLogger: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm53, Form53);
  Application.CreateForm(TdmFieldLogger, dmFieldLogger);
  Application.Run;
end.
