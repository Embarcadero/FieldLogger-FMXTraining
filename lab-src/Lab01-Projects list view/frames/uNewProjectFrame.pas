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
    ToolBar4: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label23: TLabel;
    spedCancelNewProject: TSpeedButton;
    procedure spedCancelNewProjectClick(Sender: TObject);
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

end;

procedure TNewProjectFrame.spedCancelNewProjectClick(Sender: TObject);
begin
  frmMain.SetBackToProjectScreen;
end;

end.
