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
  FMX.ScrollBox, FMX.Memo, FMX.ListView;

type
  TfrmMain = class(TForm)
    tbcMain: TTabControl;
    tabWelcome: TTabItem;
    tabSignin: TTabItem;
    tabProjects: TTabItem;
    tabDetail: TTabItem;
    sbSterling: TStyleBook;
    conn: TFDConnection;
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
    qryProjectsDetail: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    edtProjID: TEdit;
    edtProjTitle: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mmoProjDesc: TMemo;
    ToolBar3: TToolBar;
    spedProjBack: TSpeedButton;
    spedProjEdit: TSpeedButton;
    spedProjDelete: TSpeedButton;
    Label6: TLabel;
    listViewProjects: TListView;
    ToolBar1: TToolBar;
    speedButtonAdd: TSpeedButton;
    Label1: TLabel;
    qryProjectsDetailPROJ_ID: TIntegerField;
    qryProjectsDetailPROJ_TITLE: TStringField;
    qryProjectsDetailPROJ_DESC: TMemoField;
    qryProjectsDetailPICTURE: TBlobField;
    qryProjectsDetailTIMEDATESTAMP: TSQLTimeStampField;
    LinkFillControlToField: TLinkFillControlToField;
    qryProjects: TFDQuery;
    BindSourceDB2: TBindSourceDB;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    qryProjectsPROJ_ID: TIntegerField;
    qryProjectsPROJ_TITLE: TStringField;
    qryProjectsPROJ_DESC: TMemoField;
    procedure FormCreate(Sender: TObject);
    procedure LoginBackgroundRectClick(Sender: TObject);
    procedure SignInRectBTNClick(Sender: TObject);
    procedure listViewProjectsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure spedProjBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses
  fieldlogger.databaseutil,
  fieldlogger.authentication;

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //- Ensure we're on the welcome tab
  tbcMain.ActiveTab := tabWelcome;
  //- Configure our connection to the database.
  TDatabaseUtils.ConfigureConnection(conn);
  //- Ensure the database file already exists, if not, create it.
  if not FileExists(TDatabaseUtils.DataFilename) then begin
    TDatabaseUtils.CreateDatabase(conn);
  end;
  //- Connect to the database.
  conn.Connected := True;
  if not conn.Connected then begin
    raise
      Exception.Create('Unable to connect to database: '+TDatabaseUtils.DataFilename);
  end;
end;

procedure TfrmMain.listViewProjectsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcMain.SetActiveTabWithTransition(tabDetail,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.LoginBackgroundRectClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabSignin,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

procedure TfrmMain.SignInRectBTNClick(Sender: TObject);
begin
  SignInText.Text := 'Autenticating...';
  if TAuthentication.Authenticate(conn,UsernameEdit.Text,PasswordEdit.Text,[qryProjectsDetail,qryProjects]) then begin
    tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Normal);
  end else begin
    SignInText.Text := 'SIGN IN';
    ShowMessage('Invalid UserName/Password or Connection to IBLite database');
  end;
end;

procedure TfrmMain.spedProjBackClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(tabProjects,TTabTransition.Slide,TTabTransitionDirection.Normal);
end;

end.
