unit uReportingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Controls.Presentation, FMX.Objects;

type
  TReportingFrame = class(TFrame)
    ToolBar8: TToolBar;
    WebBrowser1: TWebBrowser;
    ToolBarBackgroundRect: TRectangle;
    spedProjBack: TSpeedButton;
    Label6: TLabel;
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

procedure TReportingFrame.spedProjBackClick(Sender: TObject);
begin
  WebBrowser1.Visible := False;
  frmMain.SetBackToProjectDetailScreen;
end;


end.
