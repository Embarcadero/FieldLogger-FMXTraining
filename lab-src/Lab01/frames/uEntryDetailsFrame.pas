unit uEntryDetailsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Sensors,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, FMX.Platform, System.Permissions, FMX.Edit;

type
  TEntryDetailsFrame = class(TFrame)
    ToolBar3: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label6: TLabel;
    btnEntriesBack: TButton;
    procedure btnEntriesBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule;


procedure TEntryDetailsFrame.btnEntriesBackClick(Sender: TObject);
begin
  frmMain.SetBackToProjectDetailScreen;
end;

end.
