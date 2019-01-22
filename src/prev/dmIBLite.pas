unit dmIBLite;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.IBBase, FireDAC.Comp.UI;

type
  TdmMain = class(TDataModule)
    FDConnectionIBLite: TFDConnection;
    qryPICTURE: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    qryPICTUREPICTURE: TBlobField;
    qryLOGENTRIES: TFDQuery;
    qryInsertLogEntries: TFDQuery;
    qryProjectsMaxId: TFDQuery;
  private
    //function GetNewId: integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

    (*
    function TDataModule1.GetNewId: integer;
        var
         fld: TField;
        begin
            qryProjectsMaxId.Open;
            try
                fld := qryProjectsMaxId.FieldByName('Proj_Id');
                if fld.IsNull then
                    Result := 1
                else
                    Result := fld.AsInteger + 1;
                finally
                qryProjectsMaxId.Close;
            end;
    end
  *)

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


end.
