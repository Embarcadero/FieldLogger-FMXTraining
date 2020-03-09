unit formMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TabControl, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBLiteDef,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.MultiView, FMX.Effects,
  FMX.Filter.Effects, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, FMX.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FireDAC.Comp.DataSet, FMX.ActnList,
  FMX.ScrollBox, FMX.Memo, FMX.ListView, FMX.ListBox, System.Actions, FMX.Gestures,
  FMX.StdActns, FMX.Media, FMX.Ani, System.Sensors, System.Sensors.Components,
  FMX.WebBrowser, System.Devices, System.Threading, Math,
  uReportingFrame, uNewProjectFrame, uNewEntryFrame, uEntryDetailsFrame,
  uProjectDetailsFrame, uProjectsFrame, uSigninFrame, uProgressFrame,
  fieldlogger.Data, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, FMX.Platform, FMX.VirtualKeyboard;

type
  EConnectFailed = class(Exception)
  public
    constructor Create; reintroduce;
  end;
  TfrmMain = class(TForm)
    mmoCreateDatabase: TMemo;
    tbcMain: TTabControl;
    tabSignin: TTabItem;
    tabProjects: TTabItem;
    tabProjectDetail: TTabItem;
    tabEntryDetail: TTabItem;
    tabNewEntry: TTabItem;
    tabNewProject: TTabItem;
    LocationSensor1: TLocationSensor;
    tabReport: TTabItem;
    ReportingFrame1: TReportingFrame;
    ProgressFrame: TProgressFrame;
    VSB: TVertScrollBox;
    NetHTTPClient: TNetHTTPClient;
    DefaultImage: TImage;
    IdTCPClient1: TIdTCPClient;
    ProjectsFrame1: TProjectsFrame;
    ProjectDetailsFrame1: TProjectDetailsFrame;
    EntryDetailsFrame1: TEntryDetailsFrame;
    NewEntryFrame1: TNewEntryFrame;
    NewProjectFrame1: TNewProjectFrame;
    SigninFrame1: TSigninFrame;
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure tbcMainChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FGeocoder: TGeocoder;
    FCurrentLocation: TLocationCoord2D;
    FRunOnce: Boolean;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    FCurrentStyleId: Integer;
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure LoadEntryDetail(LogID: Integer);
    procedure OnGeocodeReverseEvent(const AAddress: TCivicAddress);
  public
    { Public declarations }
    CurrentProject: TProject;
    CurrentLogEntry: Integer;
    InternetConnectivity: IFuture <Boolean>;
    procedure ShowActivity;
    procedure HideActivity;
    procedure ReverseLocation(Lat, Long: double);
    procedure SignInComplete;
    procedure SignOut;
    procedure SetWelcomeScreen;
    procedure SetNewProjectScreen;
    procedure SetProjectScreen;
    procedure SetBackToProjectScreen;
    procedure SetProjectDetailScreen;
    procedure SetBackToProjectDetailScreen;
    procedure SetNewEntryDetailScreen;
    procedure SetEntryDetailScreen;
    procedure SetReportScreen;
    procedure UpdateProject(const ATitle, ADesc: String);
    procedure DeleteLogEntry;
    procedure SaveNewEntry(const ANote: String; ABitmap: TBitmap);
    procedure NewProject(const ATitle, ADesc: String);
    procedure LoadCurrentProject(AId: Integer);
    procedure LoadProjectDetail(AId: Integer);
    procedure NewProjectEntry;
    procedure DeleteCurrentProject;
    procedure ClearCurrentProject;
    procedure UpdateLogEntries;
    procedure DownloadStaticMap(const ALocation:String; AHeight, AWidth: Single; AImage: TImage);
    function DetectInternet: Boolean;
    function DetectInternetAsync: Boolean;
    function GetCurrentStyleId: Integer;
  end;
  const
    BUSY = 1;
    NOT_BUSY = 0;
    NO_CONNECTIVITY = 'No connectivity to the server detected.';
    // Get an API key from here: https://developers.google.com/maps/documentation/static-maps/get-api-key
    GOOGLE_MAPS_STATIC_API_KEY = '';

var
  frmMain: TfrmMain;

implementation

uses
  uDataModule,
  IOUtils,
  strutils,
  System.NetEncoding,
  System.Permissions,
  FMX.DialogService,
{$IFDEF ANDROID}
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  System.Android.Sensors;
{$ENDIF ANDROID}
{$IFDEF IOS}
System.iOS.Sensors;
{$ELSE}
{$IFDEF MACOS}
System.Mac.Sensors;
{$ENDIF MACOS}
{$ENDIF IOS}
{$IFDEF MSWINDOWS}
System.Win.Sensors;
{$ENDIF}



constructor EConnectFailed.Create;
begin
  inherited Create('Failed to connect to database.');
end;

{$R *.fmx}

function DataFilename: string;
const
  cDatafileName = 'EMBEDDEDIBLITE.IB';
begin
  Result := TPath.GetDocumentsPath + TPath.DirectorySeparatorChar +
    cDatafileName;
end;

function TfrmMain.GetCurrentStyleId;
begin
  Result := FCurrentStyleId;
end;

procedure TfrmMain.SignInComplete;
begin
  SetProjectScreen;
end;

procedure TfrmMain.SetWelcomeScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabSignin, TTabTransition.Slide,
    TTabTransitionDirection.Normal,nil);
end;

procedure TfrmMain.SetNewProjectScreen;
begin
  NewProjectFrame1.ClearFields;
  tbcMain.SetActiveTabWithTransitionAsync(tabNewProject, TTabTransition.Slide,
    TTabTransitionDirection.Normal,nil);
end;

procedure TfrmMain.SetProjectDetailScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabProjectDetail,
    TTabTransition.Slide, TTabTransitionDirection.Normal,procedure begin

    end);
end;

procedure TfrmMain.SetBackToProjectDetailScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabProjectDetail, TTabTransition.Slide,
    TTabTransitionDirection.Reversed,nil);

  {$IF NOT DEFINED(ANDROID)}
  if LocationSensor1.Active then
    LocationSensor1.Active := False;
  {$ENDIF}
end;

procedure TfrmMain.SetProjectScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabProjects, TTabTransition.Slide,
    TTabTransitionDirection.Normal,nil);
end;

procedure TfrmMain.SetBackToProjectScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabProjects, TTabTransition.Slide,
    TTabTransitionDirection.Reversed,nil);
end;

procedure TfrmMain.SetEntryDetailScreen;
begin
  tbcMain.SetActiveTabWithTransitionAsync(tabEntryDetail, TTabTransition.Slide,
    TTabTransitionDirection.Normal,nil);
end;

procedure TfrmMain.ShowActivity;
begin
  ProgressFrame.ShowActivity;
end;

procedure TfrmMain.HideActivity;
begin
  ProgressFrame.HideActivity;
end;

procedure TfrmMain.SetReportScreen;
begin

end;

procedure TfrmMain.SetNewEntryDetailScreen;
begin
  // - Switch tab
  tbcMain.SetActiveTabWithTransition(tabNewEntry, TTabTransition.Slide,
    TTabTransitionDirection.Normal);
end;

procedure TfrmMain.NewProjectEntry;
begin
  NewEntryFrame1.ClearFields;

  // - Set sensors active.
{$IFDEF ANDROID}
  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION),JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION)],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 2) and
        (AGrantResults[0] = TPermissionStatus.Granted) and
        (AGrantResults[1] = TPermissionStatus.Granted) then
      begin
        { activate or deactivate the location sensor }
        LocationSensor1.Active := True;
      end
      else
      begin
        LocationSensor1.Active := False;
      end;
    end);
{$ELSE}
  LocationSensor1.Active := True;
{$ENDIF}
  SetNewEntryDetailScreen;
end;

procedure TfrmMain.DeleteCurrentProject;
begin
  mainDM.DeleteProject(CurrentProject.ID);
  SetBackToProjectScreen;
end;

procedure TfrmMain.ClearCurrentProject;
begin
  CurrentProject.ID := 0;
  CurrentProject.Title := '';
  CurrentProject.Description := '';
end;

procedure TfrmMain.LoadCurrentProject(AId: Integer);
var
  Projects: TArrayOfProject;
begin
  CurrentProject.ID := AId;

  CurrentProject := Projects[0];
end;

procedure TfrmMain.DeleteLogEntry;
begin
  mainDM.DeleteLogEntry(CurrentLogEntry, CurrentProject);
  ProjectDetailsFrame1.UpdateLogEntries(CurrentProject);
  SetBackToProjectDetailScreen;
end;

procedure TfrmMain.UpdateLogEntries;
begin
  ProjectDetailsFrame1.UpdateLogEntries(CurrentProject)
end;

procedure TfrmMain.SaveNewEntry(const ANote: String; ABitmap: TBitmap);
var
  LID: Integer;
begin
  LID := mainDM.CreateNewLogEntry(ANote, ABitmap, CurrentProject, FCurrentLocation);
  LoadEntryDetail(LID);
  UpdateLogEntries;
  tbcMain.SetActiveTabWithTransitionAsync(tabEntryDetail, TTabTransition.Slide,
    TTabTransitionDirection.Reversed,nil);
  NewEntryFrame1.ClearFields;
end;

procedure TfrmMain.NewProject(const ATitle, ADesc: String);
var
  Project: TProject;
  ID: Integer;
begin

  CurrentProject.ID := ID;
  CurrentProject.Title := Project.Title;
  CurrentProject.Description := Project.Description;

  ProjectDetailsFrame1.LoadProjectDetail(CurrentProject);

  SetProjectDetailScreen;
end;

procedure TfrmMain.LoadProjectDetail(AId: Integer);
begin
    ClearCurrentProject;
    LoadCurrentProject(AId);
    ProjectDetailsFrame1.LoadProjectDetail(CurrentProject);

    SetProjectDetailScreen;
end;


procedure TfrmMain.UpdateProject(const ATitle, ADesc: String);
var
  Project: TProject;
begin
  if CurrentProject.ID = 0 then
  begin
    exit;
  end;
  // - Only update if something actually changed.
  if (Trim(CurrentProject.Title) = Trim(ATitle)) and
    (Trim(CurrentProject.Description) = Trim(ADesc)) then
  begin
    exit;
  end;

  ProjectsFrame1.LoadProjects;
end;

procedure TfrmMain.CalcContentBoundsProc(Sender: TObject;
                                       var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfrmMain.RestorePosition;
begin
  VSB.ViewportPosition := PointF(VSB.ViewportPosition.X, 0);
  tbcMain.Align := TAlignLayout.Client;
  VSB.RealignContent;
end;

procedure TfrmMain.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VSB.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      tbcMain.Align := TAlignLayout.Horizontal;
      VSB.RealignContent;
      Application.ProcessMessages;
      VSB.ViewportPosition :=
        PointF(VSB.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // - Ensure we're on the welcome tab
  tbcMain.TabPosition := TTabPosition.None;
  tbcMain.ActiveTab := tabSignIn;

  Application.OnIdle := ApplicationIdle;

  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  VKAutoShowMode := TVKAutoShowMode.Always;
  VSB.OnCalcContentBounds := CalcContentBoundsProc;
  {$ENDIF}
end;

procedure TfrmMain.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if Key = vkHardwareBack then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
      begin
        // do nothing
      end
    else
      begin
        if tbcMain.ActiveTab = tabProjects then
          begin
            SignOut;
            Key := 0;
          end;
        if tbcMain.ActiveTab = tabProjectDetail then
          begin
            SetBackToProjectScreen;
            Key := 0;
          end;
        if tbcMain.ActiveTab = tabEntryDetail then
          begin
            SetBackToProjectDetailScreen;
            Key := 0;
          end;
        if tbcMain.ActiveTab = tabNewProject then
          begin
            SetBackToProjectScreen;
            Key := 0;
          end;
        if tbcMain.ActiveTab = tabNewEntry then
          begin
            SetBackToProjectDetailScreen;
            Key := 0;
          end;
        if tbcMain.ActiveTab = tabReport then
          begin
            SetBackToProjectDetailScreen;
            Key := 0;
          end;
      end;
  end

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

function TfrmMain.DetectInternet: Boolean;
begin
  Result := False;
  //offline test
  //Exit;
  try
    IdTCPClient1.ReadTimeout := 6000;
    IdTCPClient1.ConnectTimeout := 6000;
    IdTCPClient1.Port := 80;
    IdTCPClient1.Host := 'www.embarcadero.com';
    IdTCPClient1.Connect;
    IdTCPClient1.Disconnect;
    Result := True;
  except
    Result := False;
  end;
end;

function TfrmMain.DetectInternetAsync: Boolean;
begin
  InternetConnectivity := TTask.Future<Boolean>(
    function:Boolean
    begin
      Result := DetectInternet;
  end);
  Result := InternetConnectivity.Value;
end;


procedure TfrmMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
var
  SL: TStringList;
begin
  if FRunOnce=False then
    begin
      FRunOnce := True;

      DetectInternetAsync;

      ShowActivity;

      SL := TStringList.Create;
      SL.Text := mmoCreateDatabase.Lines.Text;
      TTask.Run(procedure begin
        try
          mainDM.InitializeDatabase(DataFilename, SL);
        finally
          SL.Free;

          TThread.Synchronize(nil,procedure begin
            HideActivity;
          end);
        end;
      end);
    end;
end;

procedure TfrmMain.LocationSensor1LocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
begin
  FCurrentLocation := NewLocation;
end;

procedure TfrmMain.SignOut;
begin
  CurrentProject.ID := 0;
  tbcMain.SetActiveTabWithTransition(tabSignIn, TTabTransition.Slide,
    TTabTransitionDirection.Reversed);
end;


procedure TfrmMain.OnGeocodeReverseEvent(const AAddress: TCivicAddress);
begin
  EntryDetailsFrame1.UpdateDetails(AAddress);
end;

procedure TfrmMain.ReverseLocation(Lat, Long: double);
var
  NewLocation: TLocationCoord2D;
begin
{$IFNDEF ANDROID}
  // Setup an instance of TGeocoder
  if not assigned(FGeocoder) then
  begin
    if assigned(TGeocoder.Current) AND TGeoCoder.Current.Supported=True then
      FGeocoder := TGeocoder.Current.Create;
    if assigned(FGeocoder) then
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
  end;

  // Translate location to address
  NewLocation.Latitude := Lat;
  NewLocation.Longitude := Long;
  if assigned(FGeocoder) and not FGeocoder.Geocoding then
    begin
      FGeocoder.GeocodeReverse(NewLocation);
    end;
{$ENDIF}
end;

procedure TfrmMain.LoadEntryDetail(LogID: Integer);
begin
  EntryDetailsFrame1.LoadEntryDetail(LogID, CurrentProject);
end;

procedure TfrmMain.tbcMainChange(Sender: TObject);
begin
  if tbcMain.ActiveTab = tabProjects then
  begin
    ProjectsFrame1.LoadProjects;
  end
  else if tbcMain.ActiveTab = tabProjectDetail then
  begin

  end
  else if tbcMain.ActiveTab = tabNewProject then
  begin
    NewProjectFrame1.ClearFields;
  end
  else if tbcMain.ActiveTab = tabEntryDetail then
  begin
    if ProjectDetailsFrame1.lstEntries.ItemIndex >= 0 then
    begin
      CurrentLogEntry := ProjectDetailsFrame1.lstEntries.Items[ProjectDetailsFrame1.lstEntries.ItemIndex].Tag;
      LoadEntryDetail(CurrentLogEntry);
    end;
  end;
end;

procedure TfrmMain.DownloadStaticMap(const ALocation: String; AHeight, AWidth: Single; AImage: TImage);
begin
  AImage.WrapMode := TImageWrapMode.Fit;
  AImage.Bitmap.Assign(DefaultImage.Bitmap);

  if GOOGLE_MAPS_STATIC_API_KEY='' then Exit;

  if NetHTTPClient.Tag=NOT_BUSY then
    begin
      if InternetConnectivity.Value=True then
       begin
          NetHTTPClient.Tag := BUSY;
          ITask(TTask.Create(
            procedure
            var
            MS: TMemoryStream;
            begin
              try
                MS := TMemoryStream.Create;
                try
                  NetHTTPClient.Get('https://maps.googleapis.com/maps/api/staticmap?center='+ALocation+'&zoom=15&scale=2&size='+AWidth.ToString+'x'+AHeight.ToString+'&key='+GOOGLE_MAPS_STATIC_API_KEY,MS);
                  TThread.Synchronize(nil,
                    procedure
                    begin
                      AImage.Bitmap.LoadFromStream(MS);
                      AImage.WrapMode := TImageWrapMode.Stretch;
                    end);
                  MS.Clear;
                finally
                  MS.DisposeOf;
                  MS := nil;
                end;
              finally

                TThread.Synchronize(nil,
                  procedure
                  begin
                    NetHTTPClient.Tag := NOT_BUSY;
                  end);
              end;
            end)).Start;
       end;
    end;
end;

end.
