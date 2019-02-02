unit modMain;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.Phys.IBDef;

type
  TdmMain = class(TDataModule)
    qryProjects: TFDQuery;
    qryEntries: TFDQuery;
    conn: TFDConnection;
    dsProjects: TDataSource;
    qryProjectsPROJ_ID: TIntegerField;
    qryProjectsPROJ_TITLE: TWideStringField;
    qryProjectsPROJ_DESC: TWideMemoField;
    qryEntriesLOG_ID: TIntegerField;
    qryEntriesPROJ_ID: TIntegerField;
    qryEntriesPICTURE: TBlobField;
    qryEntriesLONGITUDE: TSingleField;
    qryEntriesLATITUDE: TSingleField;
    qryEntriesTIMEDATESTAMP: TSQLTimeStampField;
    qryEntriesOR_X: TSingleField;
    qryEntriesOR_Y: TSingleField;
    qryEntriesOR_Z: TSingleField;
    qryEntriesOR_DISTANCE: TSingleField;
    qryEntriesHEADING_X: TSingleField;
    qryEntriesHEADING_Y: TSingleField;
    qryEntriesHEADING_Z: TSingleField;
    qryEntriesV_X: TSingleField;
    qryEntriesV_Y: TSingleField;
    qryEntriesV_Z: TSingleField;
    qryEntriesANGLE_X: TSingleField;
    qryEntriesANGLE_Y: TSingleField;
    qryEntriesANGLE_Z: TSingleField;
    qryEntriesMOTION: TSingleField;
    qryEntriesSPEED: TSingleField;
    qryEntriesNOTE: TWideMemoField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
