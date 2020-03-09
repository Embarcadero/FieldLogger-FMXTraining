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
    procedure AddReportLine(const S: String; AStrings: TStrings);
    procedure AddReportHeaderLine(const S: String; AStrings: TStrings);
    procedure AddReportSubHeaderLine(const S: String; AStrings: TStrings);
    procedure AddReportHorzRow(const AName, AValue: String; AStrings: TStrings);
    procedure AddReportVertRow(const AName, AValue: String; AStrings: TStrings);
    procedure InitializeDatabase(const AFileName: String; AStrings: TStrings);
    procedure LoadProjects(AListView: TListView; AImageIndex: Integer);
    function DeleteProject(AId: Integer): Boolean;
    function DeleteLogEntry(AId: Integer; AProject: TProject): Boolean;
    procedure LoadLogEntries(AId: Integer; AListView: TListView; AImageIndex: Integer; ABackgroundImage: TImage);
    function CreateNewLogEntry(const ANote: String; ABitmap: TBitmap; AProject: TProject; ALocation: TLocationCoord2D): Integer;
    function GenerateReport(const AStyle: String; AProject: TProject): String;
  end;
  const
    TableTRStart = '<tr class="row"><td><b>';
    TableTDMid = '</b></td><td>';
    TableTREnd = '</td></tr>';
    TableTR2Start = '<tr class="row"><td colspan="2"><b>';
    TableTR2End = '</b></td></tr>';

var
  mainDM: TmainDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
{$IFDEF ANDROID}
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.Helpers, Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
{$ENDIF}
  formMain;


procedure TmainDM.AddReportLine(const S: String; AStrings: TStrings);
begin
  AStrings.Append(S);
end;

procedure TmainDM.AddReportHeaderLine(const S: String; AStrings: TStrings);
begin
  AStrings.Append('<tr class="row header blue"><td colspan="2"><h2><p class="bg-primary">' + S + '</p></h2></td></tr>');
end;

procedure TmainDM.AddReportSubHeaderLine(const S: String; AStrings: TStrings);
begin
  AStrings.Append('<tr class="row header ltblue"><td colspan="2"><h3><p class="bg-info">' + S + '</p></h3></td></tr>');
end;

procedure TmainDM.AddReportHorzRow(const AName, AValue: String; AStrings: TStrings);
begin
  AddReportLine(TableTRStart + AName + TableTDMid + AValue + TableTREnd, AStrings);
end;

procedure TmainDM.AddReportVertRow(const AName, AValue: String; AStrings: TStrings);
begin
  if AName<>'' then AddReportLine(TableTR2Start + AName + TableTR2End, AStrings);
  AddReportLine(TableTR2Start + AValue + TableTR2End, AStrings);
end;

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
var
  ProjectData: IProjectData;
  Projects: TArrayOfProject;
begin
  Result := False;

  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then
  begin
    raise EConnectFailed.Create;
  end;
  ProjectData.Read(Projects);
  if Length(Projects) = 0 then
  begin
    exit;
  end;
  ProjectData.Delete([AId]);

  Result := True;
end;

procedure TmainDM.LoadProjects(AListView: TListView; AImageIndex: Integer);
var
  ProjectData: IProjectData;
  Projects: TArrayOfProject;
  Item: TListViewItem;
  idx: integer;
begin
  TThread.Synchronize(nil,procedure begin
    AListView.Items.Clear;
  end);

  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then
  begin
    raise EConnectFailed.Create;
  end;
  ProjectData.Read(Projects);
  if Length(Projects) = 0 then
  begin
    exit;
  end;
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

function TmainDM.CreateNewLogEntry(const ANote: String; ABitmap: TBitmap; AProject: TProject; ALocation: TLocationCoord2D): Integer;
var
  LogData: ILogData;
  LogEntry: TLogEntry;
  LID: Integer;
  MS: TMemoryStream;
begin
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then
  begin
    raise EConnectFailed.Create;
  end;
  LogEntry.ProjectID := AProject.ID;
  LogEntry.Latitude := ALocation.Latitude;
  LogEntry.Longitude := ALocation.Longitude;
  LogEntry.TimeDateStamp := Now;
  LogEntry.Note := ANote;
  MS := TMemoryStream.Create;
  try
    ABitmap.SaveToStream(MS);
    MS.Position := 0;
    LogEntry.LoadPictureFromStream(MS);
  finally
   MS.Free;
  end;

  LID := LogData.CreateEntry(LogEntry);

  Result := LID;
end;

function TmainDM.DeleteLogEntry(AId: Integer; AProject: TProject): Boolean;
var
  LogData: ILogData;
  LogEntries: TArrayOfLogEntry;
begin
  Result := False;

  // - Get log data for project
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then
  begin
    raise EConnectFailed.Create;
  end;
  LogData.Read(LogEntries, AProject.ID);
  if Length(LogEntries) = 0 then
  begin
    exit;
  end;
  LogData.Delete([AId]);

  Result := True;
end;

procedure TmainDM.LoadLogEntries(AId: Integer; AListView: TListView; AImageIndex: Integer; ABackgroundImage: TImage);
var
  LogData: ILogData;
  LogEntries: TArrayOfLogEntry;
  idx: integer;
  Item: TListViewItem;
  MS: TMemoryStream;
begin
  AListView.Items.Clear;

  // - Get log data for project
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then
  begin
    raise EConnectFailed.Create;
  end;
  LogData.Read(LogEntries, AId);
  if Length(LogEntries) = 0 then
  begin
    exit;
  end;
  AListView.BeginUpdate;
  for idx := 0 to pred(Length(LogEntries)) do
  begin
      Item := AListView.Items.AddItem;
      Item.Tag := LogEntries[idx].ID;
      Item.Text := DateTimeToStr(LogEntries[idx].TimeDateStamp);
      Item.Detail := LogEntries[idx].Note.Replace(#13#10,' ',[rfReplaceAll]);
      Item.ImageIndex := AImageIndex;

      if idx=0 then
       begin
         MS := TMemoryStream.Create;
         try
           LogEntries[idx].SavePictureToStream(MS);
           MS.Position := 0;
           ABackgroundImage.Bitmap.LoadFromStream(MS);
         finally
           MS.DisposeOf;
         end;
       end;
  end;
  AListView.EndUpdate;
end;

function TmainDM.GenerateReport(const AStyle: String; AProject: TProject): String;
var
  report: TStringList;
  LogData: ILogData;
  LogEntries: TArrayOfLogEntry;
  ImageAsBase64: String;
  idx: Integer;
  MS: TMemoryStream;
begin
  report := TStringList.Create;
  try

     AddReportLine('<!DOCTYPE html>',report);
     AddReportLine('<html lang="en"><head>',report);
     AddReportLine('<meta name="viewport" content="width=device-width; initial-scale=1" />',report);
     AddReportLine(AStyle,report);
     AddReportLine('</head><body><table width="100%" align="center" cellspacing="0" cellpadding="10" border="0">',report);
     AddReportHeaderLine(TNetEncoding.HTML.Encode(AProject.Title),report);
     AddReportSubHeaderLine(TNetEncoding.HTML.Encode(AProject.Description),report);


      // - Get log data for project
      LogData := TLogData.Create(conn);
      if not assigned(LogData) then
      begin
        raise EConnectFailed.Create;
      end;
      LogData.Read(LogEntries, AProject.ID);
      if Length(LogEntries) = 0 then
      begin
        exit;
      end;
      MS := TMemoryStream.Create;
      for idx := 0 to pred(Length(LogEntries)) do
      begin
        MS.Clear;
        LogEntries[idx].SavePictureToStream(MS);
        ImageAsBase64 := TNetEncoding.Base64.EncodeBytesToString(MS.Memory, MS.Size);

        AddReportHorzRow('Time Stamp',DateTimeToStr(LogEntries[idx].TimeDateStamp),report);
        AddReportHorzRow('ID',TNetEncoding.HTML.Encode(LogEntries[idx].ID.ToString),report);
        AddReportHorzRow('Latitude',TNetEncoding.HTML.Encode(LogEntries[idx].Latitude.ToString),report);
        AddReportHorzRow('Longitude',TNetEncoding.HTML.Encode(LogEntries[idx].Longitude.ToString),report);
        AddReportHorzRow('Note',TNetEncoding.HTML.Encode(LogEntries[idx].Note),report);
        AddReportVertRow('Image','<img src="data:image/jpg;base64,'+ImageAsBase64+'" width="100%" alt="'+DateTimeToStr(LogEntries[idx].TimeDateStamp)+'" />',report);


      end;
      MS.DisposeOf;

      AddReportHeaderLine('&nbsp;',report);

      report.Append('</table></body></html>');

      Result := Report.Text;

  finally
    report.Free;
  end;
end;



end.
