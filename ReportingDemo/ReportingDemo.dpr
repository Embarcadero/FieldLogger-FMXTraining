program ReportingDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  ReportingDemoMain in 'ReportingDemoMain.pas' {Form56},
  FieldLogReportDM in 'FieldLogReportDM.pas' {dmFieldLogger: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm56, Form56);
  Application.CreateForm(TdmFieldLogger, dmFieldLogger);
  Application.Run;
end.
