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
  System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, FMX.Platform, FMX.VirtualKeyboard, FMX.Memo.Types;

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
    tabReport: TTabItem;
    ReportingFrame1: TReportingFrame;
    ProgressFrame: TProgressFrame;
    VSB: TVertScrollBox;
    DefaultImage: TImage;
    ProjectsFrame1: TProjectsFrame;
    NewProjectFrame1: TNewProjectFrame;
    SigninFrame1: TSigninFrame;
    NewEntryFrame1: TNewEntryFrame;
    EntryDetailsFrame1: TEntryDetailsFrame;
    ProjectDetailsFrame1: TProjectDetailsFrame;
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
		FRunOnce: Boolean;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    FCurrentStyleId: Integer;
    procedure RestorePosition;
    procedure UpdateKBBounds;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
    procedure ShowActivity;
    procedure HideActivity;
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
    procedure NewProject(const ATitle, ADesc: String);
    procedure LoadCurrentProject(AId: Integer);
    procedure LoadProjectDetail(AId: Integer);
    procedure NewProjectEntry;
    procedure ClearCurrentProject;
    function GetCurrentStyleId: Integer;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uDataModule,
  IOUtils,
  strutils,
  System.NetEncoding,
  System.Permissions,
  FMX.DialogService;


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

  SetNewEntryDetailScreen;
end;

procedure TfrmMain.ClearCurrentProject;
begin

end;

procedure TfrmMain.LoadCurrentProject(AId: Integer);
begin

end;

procedure TfrmMain.NewProject(const ATitle, ADesc: String);
begin

  SetProjectDetailScreen;
end;

procedure TfrmMain.LoadProjectDetail(AId: Integer);
begin
    ClearCurrentProject;
    LoadCurrentProject(AId);

    SetProjectDetailScreen;
end;


procedure TfrmMain.UpdateProject(const ATitle, ADesc: String);
begin
  ProjectsFrame1.LoadProjects;
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

procedure TfrmMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
var
  SL: TStringList;
begin
  if FRunOnce=False then
    begin
      FRunOnce := True;

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

procedure TfrmMain.SignOut;
begin
  tbcMain.SetActiveTabWithTransition(tabSignIn, TTabTransition.Slide,
    TTabTransitionDirection.Reversed);
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

  end;
end;

end.
