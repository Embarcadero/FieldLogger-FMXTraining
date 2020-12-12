unit uNewProjectFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, FMX.Effects, FMX.Filter.Effects;

type
  TNewProjectFrame = class(TFrame)
    Image10: TImage;
    Layout2: TLayout;
    Layout4: TLayout;
    edtNewProjTitle: TEdit;
    mmoNewProjDescription: TMemo;
    Layout5: TLayout;
    Label15: TLabel;
    Label4: TLabel;
    ToolBar4: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label23: TLabel;
    spedCancelNewProject: TSpeedButton;
    CreateButton: TButton;
    Layout1: TLayout;
    procedure spedCancelNewProjectClick(Sender: TObject);
    procedure CreateButtonClick(Sender: TObject);
    procedure edtNewProjTitleKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearFields;
  end;

implementation

{$R *.fmx}

uses
  formMain;

procedure TNewProjectFrame.ClearFields;
begin
  edtNewProjTitle.Text := '';
  mmoNewProjDescription.Text := '';
end;

procedure TNewProjectFrame.CreateButtonClick(Sender: TObject);
begin
  frmMain.NewProject(edtNewProjTitle.Text, mmoNewProjDescription.Lines.Text);
end;

procedure TNewProjectFrame.edtNewProjTitleKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    mmoNewProjDescription.SetFocus;
  end;
end;

procedure TNewProjectFrame.spedCancelNewProjectClick(Sender: TObject);
begin
  frmMain.SetBackToProjectScreen;
end;

end.
