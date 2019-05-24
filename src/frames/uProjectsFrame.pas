unit uProjectsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.ListView, FMX.Objects, FMX.Layouts,
  FMX.Effects, FMX.Filter.Effects, FMX.Platform, System.Threading,
  System.ImageList, FMX.ImgList;

type
  TProjectsFrame = class(TFrame)
    listViewProjects: TListView;
    ToolBar1: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label1: TLabel;
    AddButton: TSpeedButton;
    btnSignOut: TButton;
    Layout1: TLayout;
    BackgroundImage: TImage;
    AddProjectCircleBTN: TCircle;
    Layout2: TLayout;
    ShadowEffect1: TShadowEffect;
    Layout3: TLayout;
    ImageList1: TImageList;
    procedure listViewProjectsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnSignOutClick(Sender: TObject);
    procedure listViewProjectsDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure AddProjectCircleBTNClick(Sender: TObject);
    procedure AddProjectCircleBTNMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadProjects;
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule, fieldlogger.data;


procedure TProjectsFrame.AddProjectCircleBTNClick(Sender: TObject);
begin
  frmMain.SetNewProjectScreen;
end;

procedure TProjectsFrame.AddProjectCircleBTNMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  frmMain.MaterialDesignMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TProjectsFrame.btnSignOutClick(Sender: TObject);
begin
  frmMain.SignOut;
end;

procedure TProjectsFrame.listViewProjectsDeletingItem(Sender: TObject;
  AIndex: Integer; var ACanDelete: Boolean);
begin
  ACanDelete := mainDM.DeleteProject(listViewProjects.Items[AIndex].Tag);
end;

procedure TProjectsFrame.listViewProjectsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  frmMain.LoadProjectDetail(AItem.Tag);
end;

procedure TProjectsFrame.LoadProjects;
begin
  frmMain.ShowActivity;
  TTask.Run(procedure begin
    try
      mainDM.LoadProjects(listViewProjects, frmMain.GetCurrentStyleId);
    finally
      TThread.Synchronize(nil, procedure begin
        frmMain.HideActivity;
      end);
    end;
  end);
end;

end.
