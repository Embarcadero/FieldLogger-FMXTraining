unit uProjectDetailsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Effects, FMX.Filter.Effects,
  FMX.TabControl, FMX.Platform, System.Threading, FMX.DialogService, fieldlogger.data,
  System.ImageList, FMX.ImgList;

type
  TProjectDetailsFrame = class(TFrame)
    Layout9: TLayout;
    Label3: TLabel;
    edtProjTitle: TEdit;
    mmoProjDesc: TMemo;
    Layout6: TLayout;
    Label5: TLabel;
    ToolBar7: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label13: TLabel;
    spedProjBack: TSpeedButton;
    spedProjDelete: TSpeedButton;
    TabControl1: TTabControl;
    DetailsTab: TTabItem;
    EntriesTab: TTabItem;
    GenReportButton: TButton;
    Layout1: TLayout;
    Layout3: TLayout;
    AddLogEntryCircleBTN: TCircle;
    AddButton: TSpeedButton;
    VertScrollBox1: TVertScrollBox;
    BackgroundImage: TImage;
    procedure spedProjBackClick(Sender: TObject);
    procedure spedProjDeleteClick(Sender: TObject);
    procedure edtProjTitleExit(Sender: TObject);
    procedure mmoProjDescExit(Sender: TObject);
    procedure lstEntriesItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure GenReportButtonClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure edtProjTitleKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure AddLogEntryCircleBTNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearProjectDetail;
    procedure LoadProjectDetail(AProject: TProject);
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule;

procedure TProjectDetailsFrame.GenReportButtonClick(Sender: TObject);
begin
  frmMain.SetReportScreen;
end;

procedure TProjectDetailsFrame.AddLogEntryCircleBTNClick(Sender: TObject);
begin
  frmMain.NewProjectEntry;
end;

procedure TProjectDetailsFrame.ClearProjectDetail;
begin
  // - Clear data
  edtProjTitle.Text := '';
  edtProjTitle.Enabled := False;
  mmoProjDesc.Lines.Text := '';
  mmoProjDesc.Enabled := False;
end;

procedure TProjectDetailsFrame.LoadProjectDetail(AProject: TProject);
begin
  if TabControl1.ActiveTab=DetailsTab then
    begin
      TabControl1Change(Self);
    end
  else
    TabControl1.ActiveTab := DetailsTab;

  ClearProjectDetail;

  edtProjTitle.Enabled := TRUE;
  mmoProjDesc.Enabled := TRUE;
  edtProjTitle.Text := AProject.Title;
  mmoProjDesc.Lines.Text := AProject.Description;
end;

procedure TProjectDetailsFrame.edtProjTitleExit(Sender: TObject);
begin
  frmMain.UpdateProject(edtProjTitle.Text,mmoProjDesc.Lines.Text);
end;

procedure TProjectDetailsFrame.edtProjTitleKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    mmoProjDesc.SetFocus;
  end;
end;

procedure TProjectDetailsFrame.lstEntriesItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  frmMain.SetEntryDetailScreen;
end;

procedure TProjectDetailsFrame.mmoProjDescExit(Sender: TObject);
begin
  frmMain.UpdateProject(edtProjTitle.Text,mmoProjDesc.Lines.Text);
end;

procedure TProjectDetailsFrame.spedProjBackClick(Sender: TObject);
begin
  frmMain.SetBackToProjectScreen;
end;

procedure TProjectDetailsFrame.spedProjDeleteClick(Sender: TObject);
begin
  frmMain.DeleteCurrentProject;
end;

procedure TProjectDetailsFrame.TabControl1Change(Sender: TObject);
begin
  if TabControl1.ActiveTab = DetailsTab then
    begin
      spedProjDelete.Visible := True;
    end;
  if TabControl1.ActiveTab = EntriesTab then
    begin
      spedProjDelete.Visible := False;
    end;
end;

end.
