unit FieldLogReportDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IBLiteDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmFieldLogger = class(TDataModule)
    FDConnection1: TFDConnection;
    qProjects: TFDQuery;
    qLogEntries: TFDQuery;
    dsProjects: TDataSource;
    qProjectsPROJ_ID: TIntegerField;
    qProjectsPROJ_TITLE: TWideStringField;
    qProjectsPROJ_DESC: TWideMemoField;
    qLogEntriesLOG_ID: TIntegerField;
    qLogEntriesPROJ_ID: TIntegerField;
    qLogEntriesPICTURE: TBlobField;
    qLogEntriesLONGITUDE: TSingleField;
    qLogEntriesLATITUDE: TSingleField;
    qLogEntriesTIMEDATESTAMP: TSQLTimeStampField;
    qLogEntriesOR_X: TSingleField;
    qLogEntriesOR_Y: TSingleField;
    qLogEntriesOR_Z: TSingleField;
    qLogEntriesOR_DISTANCE: TSingleField;
    qLogEntriesHEADING_X: TSingleField;
    qLogEntriesHEADING_Y: TSingleField;
    qLogEntriesHEADING_Z: TSingleField;
    qLogEntriesV_X: TSingleField;
    qLogEntriesV_Y: TSingleField;
    qLogEntriesV_Z: TSingleField;
    qLogEntriesANGLE_X: TSingleField;
    qLogEntriesANGLE_Y: TSingleField;
    qLogEntriesANGLE_Z: TSingleField;
    qLogEntriesMOTION: TSingleField;
    qLogEntriesSPEED: TSingleField;
    qLogEntriesNOTE: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qLogEntriesAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadRandomImage;
  end;

var
  dmFieldLogger: TdmFieldLogger;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  IOUtils;

procedure TdmFieldLogger.LoadRandomImage;
var
  imgs: TArray<System.string>;
  idx: Integer;
begin
  imgs := TDirectory.GetFiles('C:\Users\Jim\Documents\GitHub\FieldLogger-FMXTraining\ReportingDemo\RandomImages');
  idx := Random(Length(imgs));
  dmFieldLogger.qLogEntriesPicture.LoadFromFile(imgs[idx]);
end;

procedure TdmFieldLogger.DataModuleCreate(Sender: TObject);
begin
  qProjects.Open();
  qLogEntries.Open();
end;

procedure TdmFieldLogger.qLogEntriesAfterInsert(DataSet: TDataSet);
begin
  qLogEntriesLOG_ID.Value := Random(MaxInt);
  qLogEntriesTIMEDATESTAMP.AsDateTime := Now;
  qLogEntriesLONGITUDE.Value := 720 * Random - 360;
  qLogEntriesLATITUDE.Value := 720 * Random - 360;
  qLogEntriesOR_X.Value := Random - Random(2);
  qLogEntriesOR_Y.Value := Random - Random(2);
  qLogEntriesOR_Z.Value := Random - Random(2);
  qLogEntriesOR_DISTANCE.Value := Random;
  qLogEntriesHEADING_X.Value := 720 * Random - 360;
  qLogEntriesHEADING_Y.Value := 720 * Random - 360;
  qLogEntriesHEADING_Z.Value := 720 * Random - 360;
  qLogEntriesV_X.Value := 10 * Random;
  qLogEntriesV_Y.Value := 10 * Random;
  qLogEntriesV_Z.Value := 10 * Random;
  qLogEntriesANGLE_X.Value := 360 * Random;
  qLogEntriesANGLE_Y.Value := 360 * Random;
  qLogEntriesANGLE_Z.Value := 360 * Random;
  qLogEntriesMOTION.Value := 1000 * Random;
  qLogEntriesSPEED.Value := 100 * Random;
  LoadRandomImage;
end;

end.
