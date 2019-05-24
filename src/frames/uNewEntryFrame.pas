unit uNewEntryFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.MediaLibrary, FMX.Platform,
  System.Permissions, FMX.DialogService, FMX.Ani, System.IOUtils
{$IFDEF ANDROID}
  , Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  System.Android.Sensors
{$ENDIF ANDROID}
  ;

type
  TNewEntryFrame = class(TFrame)
    Layout3: TLayout;
    ToolBar2: TToolBar;
    ToolBarBackgroundRect: TRectangle;
    Label17: TLabel;
    btnNewEntryCancel: TButton;
    ActionList1: TActionList;
    CaptureButton: TButton;
    ActionTakePhotoFromLibrary: TTakePhotoFromLibraryAction;
    ActionTakePhotoFromCamera: TTakePhotoFromCameraAction;
    ActionShowShareSheet: TShowShareSheetAction;
    ActionClearImage: TAction;
    ButtonRemovePhoto: TButton;
    RemoveBtnAnimation: TFloatAnimation;
    LoadImageButton: TButton;
    ImageContainer: TImage;
    GridPanelLayout1: TGridPanelLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    SaveButton: TButton;
    OpenDialog: TOpenDialog;
    Layout4: TLayout;
    IrisImage: TImage;
    Layout5: TLayout;
    CameraImage: TImage;
    CameraImageBlue: TImage;
    procedure btnNewEntryCancelClick(Sender: TObject);
    procedure CaptureButtonClick(Sender: TObject);
    procedure ActionTakePhotoFromLibraryDidFinishTaking(Image: TBitmap);
    procedure ActionTakePhotoFromCameraDidFinishTaking(Image: TBitmap);
    procedure ActionShowShareSheetBeforeExecute(Sender: TObject);
    procedure ActionClearImageExecute(Sender: TObject);
    procedure LoadImageButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
    FPermissionCamera,
    FPermissionReadExternalStorage,
    FPermissionWriteExternalStorage: string;
    procedure DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    procedure TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
  public
    { Public declarations }
    procedure ClearImage;
  end;

implementation

{$R *.fmx}

uses
  formMain;

procedure TNewEntryFrame.ClearImage;
begin
  ActionClearImage.Execute;
end;

// Optional rationale display routine to display permission requirement rationale to the user
procedure TNewEntryFrame.DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionCamera then
      RationaleMsg := RationaleMsg + 'The app needs to access the camera to take a photo' + SLineBreak + SLineBreak
    else if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg + 'The app needs to load photo files from your device';
  end;

  // Show an explanation to the user *asynchronously* - don't block this thread waiting for the user's response!
  // After the user sees the explanation, invoke the post-rationale routine to request the permissions
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure TNewEntryFrame.ActionClearImageExecute(Sender: TObject);
var
  LRawBitmap: TBitmap;
begin
  LRawBitmap := TBitmap.Create(0, 0);
  RemoveBtnAnimation.Start;
  LRawBitmap.SetSize(0, 0);
  ImageContainer.Bitmap.SetSize(0, 0);
  ImageContainer.Bitmap.Assign(LRawBitmap);
  FreeAndNil(LRawBitmap);
end;

procedure TNewEntryFrame.ActionShowShareSheetBeforeExecute(Sender: TObject);
begin
  ActionShowShareSheet.Bitmap := ImageContainer.Bitmap;
end;

procedure TNewEntryFrame.ActionTakePhotoFromCameraDidFinishTaking(
  Image: TBitmap);
var
  ScaleFactor: Single;
begin
  if Image.Width > 1024 then
  begin
    ScaleFactor := Image.Width / 1024;
    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
  end;
  ImageContainer.Bitmap.Assign(Image);
end;

procedure TNewEntryFrame.ActionTakePhotoFromLibraryDidFinishTaking(
  Image: TBitmap);
var
  ScaleFactor: Single;
begin
  if Image.Width > 1024 then
  begin
    ScaleFactor := Image.Width / 1024;
    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
  end;
  ImageContainer.Bitmap.Assign(Image);
end;

procedure TNewEntryFrame.btnNewEntryCancelClick(Sender: TObject);
begin
  frmMain.SetBackToProjectDetailScreen;
end;

procedure TNewEntryFrame.LoadImageButtonClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  if OpenDialog.Execute then
    begin
      if TFile.Exists(OpenDialog.FileName) then
        ImageContainer.Bitmap.LoadFromFile(OpenDialog.FileName);
    end;
{$ELSE}

  {$IFDEF ANDROID}
    FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
    FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  {$ENDIF}

    PermissionsService.RequestPermissions([FPermissionReadExternalStorage, FPermissionWriteExternalStorage], LoadPicturePermissionRequestResult, DisplayRationale);
{$ENDIF}
end;

procedure TNewEntryFrame.CaptureButtonClick(Sender: TObject);
begin
{$IFDEF ANDROID}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
{$ENDIF}

  PermissionsService.RequestPermissions([FPermissionCamera, FPermissionReadExternalStorage, FPermissionWriteExternalStorage], TakePicturePermissionRequestResult, DisplayRationale);
end;

procedure TNewEntryFrame.TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permissions involved: CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 3) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) and
     (AGrantResults[2] = TPermissionStatus.Granted) then
    ActionTakePhotoFromCamera.Execute
  else
    TDialogService.ShowMessage('Cannot take picture because the required permissions are not granted');
end;

procedure TNewEntryFrame.LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
  // 2 permissions involved: READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 2) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) then
    ActionTakePhotoFromLibrary.Execute
  else
    TDialogService.ShowMessage('Cannot do photo editing because the required permissions are not granted');
end;

procedure TNewEntryFrame.SaveButtonClick(Sender: TObject);
begin
  if (ImageContainer.Bitmap.Width=0) AND (ImageContainer.Bitmap.Height=0) then
    ImageContainer.Bitmap.Assign(IrisImage.Bitmap);
  frmMain.SaveNewEntry(ImageContainer.Bitmap);
end;

end.
