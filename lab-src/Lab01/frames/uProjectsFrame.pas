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
    btnSignOut: TButton;
    Layout1: TLayout;
    procedure btnSignOutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadProjects;
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule;


procedure TProjectsFrame.btnSignOutClick(Sender: TObject);
begin
  frmMain.SignOut;
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
