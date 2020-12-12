unit uProjectDetailsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Effects, FMX.Filter.Effects,
  FMX.TabControl, FMX.Platform, System.Threading, FMX.DialogService,
  System.ImageList, FMX.ImgList;

type
  TProjectDetailsFrame = class(TFrame)
    ToolBar7: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label13: TLabel;
    spedProjBack: TSpeedButton;
    procedure spedProjBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule;

procedure TProjectDetailsFrame.spedProjBackClick(Sender: TObject);
begin
  frmMain.SetBackToProjectScreen;
end;

end.
