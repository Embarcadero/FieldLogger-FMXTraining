unit uReportingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Controls.Presentation, FMX.Objects, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, System.IOUtils;

type
  TReportingFrame = class(TFrame)
    ToolBar8: TToolBar;
    ShareButton: TSpeedButton;
    WebBrowser1: TWebBrowser;
    ToolBarBackgroundRect: TRectangle;
    spedProjBack: TSpeedButton;
    ActionList1: TActionList;
    ShowShareSheetAction1: TShowShareSheetAction;
    SaveDialog: TSaveDialog;
    Label6: TLabel;
    procedure spedProjBackClick(Sender: TObject);
    procedure ShareButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  formMain, uDataModule, wwEmailWithAttachment
  {$IFDEF MSWINDOWS}
  , Windows, ShellAPI
  {$ENDIF}
  ;

procedure TReportingFrame.ShareButtonClick(Sender: TObject);
{$IF DEFINED(MSWINDOWS)}
var
LPath: String;
{$ENDIF}
begin
  {$IF DEFINED(MSWINDOWS) OR (DEFINED(MACOS) AND NOT DEFINED(IOS))}
  if SaveDialog.Execute then
    begin
      frmMain.mmoReport.Lines.SaveToFile(SaveDialog.FileName);
      {$IF DEFINED(MSWINDOWS)}
        LPath := ExtractFilePath(SaveDialog.FileName);
        ShellExecute(0, 'OPEN', PChar(LPath), '', '', SW_SHOWNORMAL);
      {$ENDIF}
    end;
  {$ELSE}
  frmMain.mmoReport.Lines.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,'report.html'));
 // mainDM.ShareReportAsEmail('','New Report','Take a look at the report!',TPath.Combine(TPath.GetDocumentsPath,'report.html'));
  wwEmail([''],
    [], [], 'New Report',
      'Take a look at the report!', TPath.Combine(TPath.GetDocumentsPath,'report.html'));
  {$ENDIF}
end;

procedure TReportingFrame.spedProjBackClick(Sender: TObject);
begin
  WebBrowser1.Visible := False;
  frmMain.SetBackToProjectDetailScreen;
end;


end.
