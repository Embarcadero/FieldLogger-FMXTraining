unit uNewEntryFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.MediaLibrary, FMX.Platform, FMX.Edit,
  System.Permissions, FMX.DialogService, FMX.Ani, System.IOUtils
{$IFDEF ANDROID}
  , Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  System.Android.Sensors
{$ENDIF ANDROID}
  ;

type
  TNewEntryFrame = class(TFrame)
    ToolBar2: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label17: TLabel;
    btnNewEntryCancel: TButton;
    procedure btnNewEntryCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearFields;
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule;

procedure TNewEntryFrame.ClearFields;
begin

end;

procedure TNewEntryFrame.btnNewEntryCancelClick(Sender: TObject);
begin
  frmMain.SetBackToProjectDetailScreen;
end;

end.
