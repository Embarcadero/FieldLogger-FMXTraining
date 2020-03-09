unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FMX.Graphics, System.NetEncoding, FMX.ListView, FMX.ListView.Appearances,
  FireDAC.Comp.UI, System.Threading, System.Sensors, FMX.Objects,
  FMX.VirtualKeyboard, FMX.Platform, fieldlogger.data;

type
  TmainDM = class(TDataModule)
    conn: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeDatabase(const AFileName: String; AStrings: TStrings);
    procedure LoadProjects(AListView: TListView; AImageIndex: Integer);
    function DeleteProject(AId: Integer): Boolean;
  end;

var
  mainDM: TmainDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  formMain;

procedure TmainDM.InitializeDatabase(const AFileName: String; AStrings: TStrings);
var
idx: Integer;
begin
  // - Configure our connection to the database.
  conn.LoginPrompt := False;
  conn.Params.Database := AFileName;
  // - Ensure the database file already exists, if not, create it.
  if not FileExists(AFileName) then
  begin
    conn.Params.Values['CreateDatabase'] := BoolToStr(TRUE, TRUE);
    conn.Connected := TRUE;
    for idx := 0 to pred(AStrings.Count) do
    begin
      if AStrings[idx].Trim <> '' then
      begin
        conn.ExecSQL(AStrings[idx].Trim);
      end;
    end;
    conn.Params.Values['CreateDatabase'] := BoolToStr(False, TRUE);
    conn.Connected := False;
  end;
  // - Connect to the database.
  conn.Connected := TRUE;

  if not conn.Connected then
  begin
    raise EConnectFailed.Create;
  end;
end;

function TmainDM.DeleteProject(AId: Integer): Boolean;
begin
  Result := False;
end;

procedure TmainDM.LoadProjects(AListView: TListView; AImageIndex: Integer);
var
  Projects: TArrayOfProject;
  Item: TListViewItem;
  idx: integer;
begin
  TThread.Synchronize(nil,procedure begin
    AListView.Items.Clear;
  end);

  AListView.BeginUpdate;
  for idx := 0 to pred(Length(Projects)) do
  begin
    TThread.Synchronize(nil,procedure begin
      Item := AListView.Items.AddItem;
      Item.Tag := Projects[idx].ID;
      Item.Text := Projects[idx].Title;
      Item.Detail := Projects[idx].Description.Replace(#13#10,' ',[rfReplaceAll]).Replace(#13,' ',[rfReplaceAll]).Replace(#10,' ',[rfReplaceAll]);
      Item.ImageIndex := AImageIndex;
    end);
  end;
  TThread.Synchronize(nil,procedure begin
    AListView.EndUpdate;
  end);
end;

end.
