unit formMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TabControl, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBLiteDef,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.MultiView, FMX.Effects,
  FMX.Filter.Effects, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FireDAC.Comp.DataSet, System.Actions, FMX.ActnList,
  FMX.ScrollBox, FMX.Memo, FMX.ListView, FMX.ListBox, FMX.MediaLibrary.Actions,
  FMX.StdActns, FMX.Media, FMX.Ani, System.Sensors, System.Sensors.Components,
  fieldlogger.data;

type
  TfrmMain = class(TForm)
    CameraComponent1: TCameraComponent;
    mmoCreateDatabase: TMemo;
    tbcMain: TTabControl;
    tabWelcome: TTabItem;
    sbSterling: TStyleBook;
    BackgroundRect: TRectangle;
    BackgroundImage: TImage;
    BackgroundGaussianBlurEffect: TGaussianBlurEffect;
    MenuLayout: TLayout;
    LogoLayout: TLayout;
    LogoImage: TImage;
    MenuGridPanelLayout: TGridPanelLayout;
    LearnLayout: TLayout;
    LoginBackgroundRect: TRectangle;
    LearnCenterLayout: TLayout;
    LearnCircle: TCircle;
    LearnImage: TImage;
    LoginLabel: TLabel;
    SupportLayout: TLayout;
    SupportBackgroundRect: TRectangle;
    SupportCenterLayout: TLayout;
    SupportCircle: TCircle;
    SupportImage: TImage;
    SupportLabel: TLabel;
    AdvocateLayout: TLayout;
    AdvocateBackgroundRect: TRectangle;
    AdvocateCenterLayout: TLayout;
    AdvocateCircle: TCircle;
    AdvocateImage: TImage;
    AdvocateLabel: TLabel;
    EventsLayout: TLayout;
    EventsBackgroundRect: TRectangle;
    EventsCenterLayout: TLayout;
    EventsCircle: TCircle;
    EventsImage: TImage;
    EventsLabel: TLabel;
    HeaderToolBar: TToolBar;
    HeaderBackgroundRect: TRectangle;
    HeaderLabel: TLabel;
    MenuButton: TButton;
    DrawerMultiView: TMultiView;
    DrawerBackgroundRect: TRectangle;
    TopImage: TImage;
    tabSignin: TTabItem;
    Image1: TImage;
    GaussianBlurEffect1: TGaussianBlurEffect;
    VertScrollBox1: TVertScrollBox;
    SignUpLayout: TLayout;
    SignupTextBTN: TText;
    SignInBackgroundRect: TRectangle;
    FormLayout: TLayout;
    UsernameEdit: TEdit;
    UserImage: TImage;
    PasswordEdit: TEdit;
    LockImage: TImage;
    SignInRectBTN: TRectangle;
    SignInText: TText;
    FormSpacerLayout: TLayout;
    HeaderLayout: TLayout;
    CenterLayout: TLayout;
    LogoCircle: TCircle;
    Image2: TImage;
    Layout1: TLayout;
    WelcomeLabel: TLabel;
    tabProjects: TTabItem;
    tabProjectDetail: TTabItem;
    Splitter1: TSplitter;
    tabEntryDetail: TTabItem;
    imgPicture: TImage;
    ScrollBox1: TScrollBox;
    Rectangle1: TRectangle;
    GradientAnimation1: TGradientAnimation;
    Label2: TLabel;
    Rectangle2: TRectangle;
    GradientAnimation2: TGradientAnimation;
    Label7: TLabel;
    lblLongitude: TLabel;
    Rectangle3: TRectangle;
    GradientAnimation3: TGradientAnimation;
    Label9: TLabel;
    lblLatitude: TLabel;
    Rectangle4: TRectangle;
    GradientAnimation4: TGradientAnimation;
    Label11: TLabel;
    Rectangle5: TRectangle;
    GradientAnimation5: TGradientAnimation;
    Label12: TLabel;
    lblSubThoroughfare: TLabel;
    Rectangle6: TRectangle;
    GradientAnimation6: TGradientAnimation;
    Label14: TLabel;
    lblThoroughfare: TLabel;
    Rectangle7: TRectangle;
    GradientAnimation7: TGradientAnimation;
    Label16: TLabel;
    lblSubLocality: TLabel;
    Rectangle8: TRectangle;
    GradientAnimation8: TGradientAnimation;
    Label18: TLabel;
    lblSubAdminArea: TLabel;
    Rectangle9: TRectangle;
    GradientAnimation9: TGradientAnimation;
    Label20: TLabel;
    lblZipCode: TLabel;
    Rectangle10: TRectangle;
    GradientAnimation10: TGradientAnimation;
    Label22: TLabel;
    lblLocality: TLabel;
    Rectangle11: TRectangle;
    GradientAnimation11: TGradientAnimation;
    Label24: TLabel;
    lblFeature: TLabel;
    Rectangle12: TRectangle;
    GradientAnimation12: TGradientAnimation;
    Label26: TLabel;
    lblCountry: TLabel;
    Rectangle13: TRectangle;
    GradientAnimation13: TGradientAnimation;
    Label28: TLabel;
    lblCountryCode: TLabel;
    Rectangle14: TRectangle;
    GradientAnimation14: TGradientAnimation;
    Label30: TLabel;
    lblAdminArea: TLabel;
    tabNewEntry: TTabItem;
    tabNewProject: TTabItem;
    Layout4: TLayout;
    mmoNewProjDescription: TMemo;
    edtNewProjTitle: TEdit;
    LocationSensor1: TLocationSensor;
    ToolBar6: TToolBar;
    Rectangle15: TRectangle;
    Label10: TLabel;
    Button1: TButton;
    ToolBar1: TToolBar;
    Rectangle16: TRectangle;
    Label1: TLabel;
    Button2: TButton;
    speedButtonAdd: TSpeedButton;
    ToolBar7: TToolBar;
    Rectangle17: TRectangle;
    Label13: TLabel;
    Button3: TButton;
    spedProjBack: TSpeedButton;
    spedProjDelete: TSpeedButton;
    ToolBar3: TToolBar;
    Rectangle18: TRectangle;
    Label6: TLabel;
    Button4: TButton;
    btnEntriesBack: TButton;
    Image3: TImage;
    GaussianBlurEffect2: TGaussianBlurEffect;
    Image4: TImage;
    GaussianBlurEffect3: TGaussianBlurEffect;
    Image5: TImage;
    GaussianBlurEffect4: TGaussianBlurEffect;
    Layout7: TLayout;
    Layout9: TLayout;
    Rectangle22: TRectangle;
    Circle2: TCircle;
    Image7: TImage;
    Layout8: TLayout;
    Rectangle21: TRectangle;
    Circle1: TCircle;
    Image6: TImage;
    mmoProjDesc: TMemo;
    Label3: TLabel;
    edtProjTitle: TEdit;
    Label5: TLabel;
    Rectangle23: TRectangle;
    lstEntries: TListView;
    Rectangle24: TRectangle;
    listViewProjects: TListView;
    Label8: TLabel;
    Image8: TImage;
    GaussianBlurEffect5: TGaussianBlurEffect;
    ToolBar2: TToolBar;
    Rectangle19: TRectangle;
    Label17: TLabel;
    Button5: TButton;
    btnNewEntryCancel: TButton;
    Layout3: TLayout;
    imgTakePicture: TImage;
    Rectangle25: TRectangle;
    btnTakePicture: TButton;
    Image10: TImage;
    GaussianBlurEffect6: TGaussianBlurEffect;
    Layout2: TLayout;
    Rectangle20: TRectangle;
    Circle3: TCircle;
    Image9: TImage;
    Layout5: TLayout;
    Rectangle26: TRectangle;
    Label21: TLabel;
    ToolBar4: TToolBar;
    Rectangle27: TRectangle;
    Label23: TLabel;
    Button7: TButton;
    spedCancelNewProject: TSpeedButton;
    ToolBar5: TToolBar;
    Rectangle28: TRectangle;
    Label19: TLabel;
    Button6: TButton;
    Label15: TLabel;
    Label4: TLabel;
    btnDeleteEntry: TSpeedButton;
    tabReport: TTabItem;
    conn: TFDConnection;
    procedure LoginBackgroundRectClick(Sender: TObject);
    procedure SignInRectBTNClick(Sender: TObject);
    procedure listViewProjectsItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure spedProjBackClick(Sender: TObject);
    procedure PasswordEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure lstEntriesItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure FormShow(Sender: TObject);
    procedure spedNewEntryClick(Sender: TObject);
    procedure btnEntriesBackClick(Sender: TObject);
    procedure CameraComponent1SampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    procedure btnTakePictureClick(Sender: TObject);
    procedure speedButtonAddClick(Sender: TObject);
    procedure spedCancelNewProjectClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure btnNewEntryCancelClick(Sender: TObject);
    procedure spedProjDeleteClick(Sender: TObject);
    procedure btnDeleteEntryClick(Sender: TObject);
    procedure tbcMainChange(Sender: TObject);
    procedure LoadProjectsTab;
    procedure UpdateProject(Sender: TObject);
  private
    FGeocoder: TGeocoder;
    CurrentLocation: TLocationCoord2D;
    CurrentProject: TProject;
    CurrentLogEntry: uint32;
    procedure LoadProjectDetailTab( ID: uint32 );
    procedure LoadEntryDetail(LogID: uint32);
    procedure ReverseLocation(Lat, Long: double);
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  IOUtils,
  strutils,
  fieldlogger.authentication,
{$IFDEF ANDROID}
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

type
 EConnectFailed = class(Exception)
 public
   constructor Create; reintroduce;
 end;

constructor EConnectFailed.Create;
begin
  inherited Create('Failed to connect to database.');
end;


{$R *.fmx}

function DataFilename: string;
const
  cDatafileName = 'EMBEDDEDIBLITE.IB';
begin
  Result := TPath.GetDocumentsPath + TPath.DirectorySeparatorChar + cDatafileName;
end;


procedure TfrmMain.btnDeleteEntryClick(Sender: TObject);
var
  LogData: ILogData;
begin
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then begin
    raise EConnectFailed.Create();
  end;
  if not LogData.Delete([CurrentLogEntry]) then begin
    raise
      Exception.Create('Failed to delete log entry: '+CurrentLogEntry.ToString);
  end;
  tbcMain.SetActiveTabWithTransition(tabProjectDetail,TTabTransition.Slide,TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.btnDoneClick(Sender: TObject);
var
  ProjectData: IProjectData;
  Project: TProject;
  ID: uint32;
begin
  //- Insert new project
  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then begin
    raise EConnectFailed.Create;
  end;
  Project.Title := edtNewProjTitle.Text;
  Project.Description := mmoNewProjDescription.Lines.Text;
  ID := ProjectData.CreateProject(Project);
  //- Switch tabs back to tabProjectDetail
  tbcMain.SetActiveTabWithTransition(tabProjectDetail,TTabTransition.Slide,TTabTransitionDirection.Normal);
  LoadProjectDetailTab(ID);
end;

procedure TfrmMain.btnEntriesBackClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabProjectDetail,TTabTransition.Slide,TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.btnNewEntryCancelClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabProjectDetail,TTabTransition.Slide,TTabTransitionDirection.Reversed);
  CameraComponent1.Active := False;
  LocationSensor1.Active := False;
end;

procedure TfrmMain.btnTakePictureClick(Sender: TObject);
var
  LogData: ILogData;
  LogEntry: TLogEntry;
  ID: uint32;
begin
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then begin
    raise EConnectFailed.Create;
  end; 
  LogEntry.ProjectID := CurrentProject.ID;
  LogEntry.Latitude := CurrentLocation.Latitude;
  LogEntry.Longitude := CurrentLocation.Longitude;
  LogEntry.TimeDateStamp := Now;
  LogEntry.setPicture(imgTakePicture.Bitmap);
  ID := LogData.CreateEntry(LogEntry);
  //-
  tbcMain.SetActiveTabWithTransition(tabEntryDetail,TTabTransition.Slide,TTabTransitionDirection.Reversed);
  LoadEntryDetail(ID);
end;

procedure TfrmMain.CameraComponent1SampleBufferReady(Sender: TObject; const ATime: TMediaTime);
begin
  CameraComponent1.SampleBufferToBitmap(imgTakePicture.Bitmap,TRUE);
end;

procedure TfrmMain.UpdateProject(Sender: TObject);
var
  ProjectData: IProjectData;
  Project: TProject;
begin
  if CurrentProject.ID=0 then begin
    exit;
  end;
  //- Only update if something actually changed.
  if (Trim(CurrentProject.Title)=Trim(edtProjTitle.Text)) and
     (Trim(CurrentProject.Description)=Trim(mmoProjDesc.Lines.Text)) then begin
       exit;
   end;
  //- Current project changed, we better update it!
  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then begin
    raise EConnectFailed.Create();
  end;
  Project.ID := CurrentProject.ID;
  Project.Title := edtProjTitle.Text;
  Project.Description := mmoProjDesc.Lines.Text;
  if not ProjectData.Update([Project]) then begin
    raise Exception.Create('Failed to update project data.');
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  idx: uint32;
begin
  //- Ensure we're on the welcome tab
  tbcMain.TabPosition := TTabPosition.None;
  tbcMain.ActiveTab := tabWelcome;
  //- Configure our connection to the database.
  conn.LoginPrompt := False;
  conn.Params.Database := DataFilename;
  //- Ensure the database file already exists, if not, create it.
  if not FileExists(DataFilename) then begin
    conn.Params.Values['CreateDatabase'] := BoolToStr(True,True);
    conn.Connected := True;
    for idx := 0 to pred(mmoCreateDatabase.Lines.Count) do begin
      if mmoCreateDatabase.Lines[idx].Trim<>'' then begin
        conn.ExecSQL(mmoCreateDatabase.Lines[idx].Trim);
      end;
    end;
    conn.Params.Values['CreateDatabase'] := BoolToStr(False,True);
    conn.Connected := False;
  end;
  //- Connect to the database.
  conn.Connected := True;
  if not conn.Connected then begin
    raise EConnectFailed.Create;
  end;
end;

procedure TfrmMain.listViewProjectsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcMain.SetActiveTabWithTransition(tabProjectDetail,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D );
begin
  CurrentLocation := NewLocation;
end;

procedure TfrmMain.LoginBackgroundRectClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabSignin,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.lstEntriesItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcMain.SetActiveTabWithTransition(tabEntryDetail,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.PasswordEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then begin
    SignInRectBTNClick(Sender);
  end else if Key=vkTab then begin
    PasswordEdit.SetFocus;
  end;
end;

procedure TfrmMain.SignInRectBTNClick(Sender: TObject);
begin
  SignInText.Text := 'Autenticating...';
  if TAuthentication.Authenticate(conn,UsernameEdit.Text,PasswordEdit.Text) then begin
    tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Normal);
  end else begin
    SignInText.Text := 'SIGN IN';
    ShowMessage('Invalid UserName/Password or Connection to IBLite database');
  end;
end;

procedure TfrmMain.spedCancelNewProjectClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.spedNewEntryClick(Sender: TObject);
begin
  //- Set sensors active.
  CameraComponent1.Active := True;
  LocationSensor1.Active := True;
  //- Switch tab
  tbcMain.SetActiveTabWithTransition(tabNewEntry,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.spedProjBackClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.spedProjDeleteClick(Sender: TObject);
var
  ProjectData: IProjectData;
begin
  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then begin
    raise EConnectFailed.Create();
  end;
  if not ProjectData.Delete([CurrentProject.ID]) then begin
    raise Exception.Create('Failed to delete project with ID '+CurrentProject.ID.ToString);
  end;
  tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.speedButtonAddClick(Sender: TObject);
begin
  edtNewProjTitle.Text := '';
  mmoNewProjDescription.Text := '';
  tbcMain.SetActiveTabWithTransition(tabNewProject,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

procedure TfrmMain.LoadProjectsTab;
var
  ProjectData: IProjectData;
  Projects: TArrayOfProject;
  Item: TListViewItem;
  idx: integer;
begin
  listViewProjects.Items.Clear;
  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then begin
    raise EConnectFailed.Create;
  end;
  ProjectData.Read(Projects);
  if Length(Projects)=0 then begin
    exit;
  end;
  for idx := 0 to pred(Length(Projects)) do begin
    Item := listViewProjects.Items.AddItem;
    Item.Tag := Projects[idx].ID;
    Item.Text := Projects[idx].Title;
  end;
end;

procedure TfrmMain.LoadProjectDetailTab( ID: uint32 );
var
  ProjectData: IProjectData;
  Projects: TArrayOfProject;
  LogData: ILogData;
  LogEntries: TArrayOfLogEntry;
  idx: integer;
  Item: TListViewItem;
begin
  //- Clear data
  edtProjTitle.Text := '';
  edtProjTitle.Enabled := False;
  mmoProjDesc.Lines.Text := '';
  mmoProjDesc.Enabled := False;
  lstEntries.Items.Clear;
  CurrentProject.ID := 0;
  CurrentProject.Title := '';
  CurrentProject.Description := '';
  if ID=0 then begin
    //- Check that there is a project selected.
    if listViewProjects.ItemIndex<0 then begin
      exit;
    end;
    CurrentProject.ID := listViewProjects.Items[listViewProjects.ItemIndex].Tag;
  end else begin
    CurrentProject.ID := ID;
  end;
  //- Get Project data
  ProjectData := TProjectData.Create(conn);
  if not assigned(ProjectData) then begin
    raise EConnectFailed.Create;
  end;
  if ProjectData.Read(Projects,CurrentProject.ID) <> 1 then begin
    exit;
  end;
  edtProjTitle.Enabled := True;
  mmoProjDesc.Enabled := True;
  CurrentProject := Projects[0];
  edtProjTitle.Text := CurrentProject.Title;
  mmoProjDesc.Lines.Text := CurrentProject.Description;
  //- Get log data for project
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then begin
    raise EConnectFailed.Create;
  end;
  LogData.Read(LogEntries,CurrentProject.ID);
  if Length(LogEntries)=0 then begin
    exit;
  end;
  for idx := 0 to pred(Length(LogEntries)) do begin
    Item := lstEntries.Items.AddItem;
    Item.Tag := LogEntries[idx].ID;
    Item.Text := DateTimeToStr( LogEntries[idx].TimeDateStamp );
  end;
end;

procedure TfrmMain.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  lblSubThoroughfare.Text := Address.SubThoroughfare;
  lblThoroughfare.Text := Address.Thoroughfare;
  lblSubLocality.Text := Address.SubLocality;
  lblSubAdminArea.Text := Address.SubAdminArea;
  lblZipCode.Text := Address.PostalCode;
  lblLocality.Text := Address.Locality;
  lblFeature.Text := Address.FeatureName;
  lblCountry.Text := Address.CountryName;
  lblCountryCode.Text := Address.CountryCode;
  lblAdminArea.Text := Address.AdminArea;
end;

procedure TfrmMain.ReverseLocation( Lat, Long: double );
var
  NewLocation: TLocationCoord2D;
begin
  // Setup an instance of TGeocoder
  if not Assigned(FGeocoder) then
  begin
    if Assigned(TGeocoder.Current) then
      FGeocoder := TGeocoder.Current.Create;
    if Assigned(FGeocoder) then
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
  end;

  // Translate location to address
  NewLocation.Latitude := Lat;
  NewLocation.Longitude := Long;
  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
    FGeocoder.GeocodeReverse(NewLocation);
end;

procedure TfrmMain.LoadEntryDetail( LogID: uint32 );
var
  LogData: ILogData;
  LogEntries: TArrayOfLogEntry;
  Found: integer;
  idx: integer;
  Bitmap: TBitmap;
begin
  //- Init the tab
  imgPicture.Bitmap.Clear(TAlphaColorRec.Null);
  lblLongitude.Text := '???';
  lblLatitude.Text := '???';
  lblSubThoroughfare.Text := '???';
  lblThoroughfare.Text := '???';
  lblSubLocality.Text := '???';
  lblSubAdminArea.Text := '???';
  lblZipCode.Text := '???';
  lblLocality.Text := '???';
  lblFeature.Text := '???';
  lblCountry.Text := '???';
  lblCountryCode.Text := '???';
  lblAdminArea.Text := '???';
  //- Get data
  LogData := TLogData.Create(conn);
  if not assigned(LogData) then begin
    raise EConnectFailed.Create;
  end;
  LogData.Read(LogEntries,CurrentProject.ID);
  if Length(LogEntries)=0 then begin
    exit;
  end;
  //- Loop through and find the log entry we want
  CurrentLogEntry := 0;
  Found := 0;
  for idx := 0 to pred(length(LogEntries)) do begin
    if LogEntries[idx].ID=LogID then begin
      CurrentLogEntry := LogEntries[idx].ID;
      Found := idx;
      break;
    end;
  end;
  if CurrentLogEntry=0 then begin
    exit;
  end;
  //- Load the entry to the form.
  Bitmap := LogEntries[Found].getPicture;
  try
    imgPicture.Bitmap.Assign(Bitmap);    
  finally
    Bitmap.DisposeOf;
  end;
  lblLongitude.Text := LogEntries[Found].Longitude.ToString;
  lblLatitude.Text := LogEntries[Found].Latitude.ToString;
  ReverseLocation( LogEntries[Found].Latitude, LogEntries[Found].Longitude );
end;

procedure TfrmMain.tbcMainChange(Sender: TObject);
begin
  if tbcMain.ActiveTab=tabProjects then begin
    LoadProjectsTab;
  end else if tbcMain.ActiveTab=tabProjectDetail then begin
    LoadProjectDetailTab(0);
  end else if tbcMain.ActiveTab=tabNewProject then begin
    edtNewProjTitle.Text := '';
    mmoNewProjDescription.Lines.Text := '';
  end else if tbcMain.ActiveTab=tabEntryDetail then begin
    if lstEntries.ItemIndex>=0 then begin
      CurrentLogEntry := lstEntries.Items[lstEntries.ItemIndex].Tag;
      LoadEntryDetail(CurrentLogEntry);
    end;
  end;
end;


end.
