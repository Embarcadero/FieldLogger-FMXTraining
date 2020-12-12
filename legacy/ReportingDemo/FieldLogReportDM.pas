unit FieldLogReportDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IBLiteDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Types;

type
  TdmFieldLogger = class(TDataModule)
    conn: TFDConnection;
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

function ResizeJpegField(const field: TBlobField; const maxWidth: integer): TByteDynArray;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  IOUtils, FMX.Graphics;

function ResizeJpegField(const field: TBlobField; const maxWidth: integer): TByteDynArray;
var
  blob: TStream;
  jpeg: TBitmap;
begin
  Assert(Assigned(field));

  blob := nil;
  jpeg := nil;
  try
    blob := field.DataSet.CreateBlobStream(field, TBlobStreamMode.bmRead);
    jpeg := TBitmap.Create;
    jpeg.LoadFromStream(blob);
    blob.DisposeOf;
    if jpeg.Width > maxWidth then
      jpeg.Resize(maxWidth, Trunc(jpeg.Height / jpeg.Width * maxWidth));
    blob := TMemoryStream.Create;
    jpeg.SaveToStream(blob);
    blob.Position := 0;
    SetLength(result, blob.Size);
    blob.Read(result[0], blob.Size);
  finally
    jpeg.DisposeOf;
    blob.DisposeOf;
  end;
end;

procedure TdmFieldLogger.LoadRandomImage;
var
  imgs: TArray<System.string>;
  jpeg: TBitmap;
  idx: Integer;
begin
  imgs := TDirectory.GetFiles('C:\Users\Jim\Documents\GitHub\FieldLogger-FMXTraining\ReportingDemo\RandomImages');
  idx := Random(Length(imgs));
  jpeg := TBitmap.CreateFromFile(imgs[idx]);
  try
    // resize the images to 512 on the largest size
    if jpeg.Height > jpeg.Width then
      jpeg.Resize(Trunc(jpeg.Width / jpeg.Height * 512), 512)
    else
      jpeg.Resize(512, Trunc(jpeg.Height / jpeg.Width * 512));
    dmFieldLogger.qLogEntriesPicture.Assign(jpeg);
  finally
    jpeg.DisposeOf;
  end;
end;

procedure TdmFieldLogger.DataModuleCreate(Sender: TObject);
begin
  {$ifdef ANDROID}
  conn.Params.Clear;
  conn.Params.DriverID := 'IBLite';
  conn.Params.Database := TPath.Combine(TPath.GetDocumentsPath, 'EMBEDDEDIBLITE.IB');
  {$ENDIF}
  conn.Params.UserName := 'sysdba';
  conn.Params.Password := 'masterkey';
  conn.Params.Values['CharacterSet'] := 'UTF8';
  qProjects.Open();
  qLogEntries.Open();
end;

procedure TdmFieldLogger.qLogEntriesAfterInsert(DataSet: TDataSet);
begin
  qLogEntriesLOG_ID.Value := Random(MaxInt);
  qLogEntriesTIMEDATESTAMP.AsDateTime := Now + (random(31) * (0.5-random));
  qLogEntriesLONGITUDE.Value := Random + (179 - Random(360));
  qLogEntriesLATITUDE.Value := Random + (89 - Random(180));
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
