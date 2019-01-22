unit uProjectsForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Actions, FMX.ActnList, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.Bind.GenData, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.Edit, FMX.ScrollBox, FMX.Memo, dmIBLite,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.DBScope;

type
  TfrmProjectList = class(TForm)
    TabControl1: TTabControl;
    tabProjectsList: TTabItem;
    tabProjectsEdit: TTabItem;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ActionList1: TActionList;
    changeTabActionList: TChangeTabAction;
    changeTabActionEdit: TChangeTabAction;
    speedButtonAdd: TSpeedButton;
    Label1: TLabel;
    listViewProjects: TListView;
    speedButtonBack: TSpeedButton;
    speedButtonSave: TSpeedButton;
    speedButtonDelete: TSpeedButton;
    Label2: TLabel;
    labelProjectsID: TLabel;
    editProjectsID: TEdit;
    labelProjectsTitle: TLabel;
    editProjectsTitle: TEdit;
    labelProjectsDescription: TLabel;
    Memo2: TMemo;
    qryProjects: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    procedure speedButtonAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProjectList: TfrmProjectList;

implementation

{$R *.fmx}

procedure TfrmProjectList.FormShow(Sender: TObject);
begin
  qryProjects.Active := True;
end;

procedure TfrmProjectList.speedButtonAddClick(Sender: TObject);
begin
 TabControl1.ActiveTab := tabProjectsEdit;
end;

end.
