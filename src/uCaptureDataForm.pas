unit uCaptureDataForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media,
  FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation, System.Sensors,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions,
  System.Sensors.Components, FMX.Objects, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ScrollBox, FMX.Grid, FMX.ListBox, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    ToolBar1: TToolBar;
    lblToolBar: TLabel;
    TabItem1: TTabItem;
    CameraComponent1: TCameraComponent;
    LocationSensor1: TLocationSensor;
    OrientationSensor1: TOrientationSensor;
    ToolBar2: TToolBar;
    ActionList1: TActionList;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    Image1: TImage;
    Button3: TButton;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    Button4: TButton;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    ShowShareSheetAction1: TShowShareSheetAction;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ListBox1: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    Switch1: TSwitch;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    TakePhotoFromCameraAction2: TTakePhotoFromCameraAction;
    alProjects: TActionList;
    taProjectList: TAction;
    taProjectsEdit: TAction;
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure Button4Click(Sender: TObject);
    procedure ShowShareSheetAction1BeforeExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}
{$R *.iPhone4in.fmx IOS}
{$R *.iPhone.fmx IOS}
{$R *.iPad.fmx IOS}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}

uses dmIBLite, FireDAC.Stan.Param;
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}
{$R *.iPhone55in.fmx IOS}

//**********************************************************
//*  SAVE LOG_ENTRIES (CAMERA) Data to IBLite database
//**********************************************************
procedure TForm1.Button4Click(Sender: TObject);
var
  stream: TMemoryStream;
  Proj_Id: Integer;
  TStamp : TDateTime; //  TIMESTAMP :=  TStamp := Now;
  LONGITUDE, LATITUDE: Double;
  picture: TImage;
begin
  // Convert BitMap to TStream for the LoadFromStream method
  // http://www.delphigroups.info/2/2/313189.html

  //stream := TMemoryStream.Create;

  // Image1.Picture.Bitmap.SaveToStream(a);

  //Image1.Bitmap.SaveToStream(stream);

  // You must use any of the TStream descendants that
  // implement something, so TFileStream, TMemoryStream,
  // TWhateverStream
  //
  //Grant Select, Insert, Update on LOG_ENTRIES to staff
  //Grant Select, Insert, Update on PROJECTS to staff
  //Grant All on LOG_ENTRIES to manager
  //Grant All on PROJECTS to manager

(*
    dmIBLite.DataModule1.qryPICTURE.Open();
    dmIBLite.DataModule1.qryPICTURE.Append;
    dmIBLite.DataModule1.qryPICTUREPICTURE.LoadFromStream(stream);
    dmIBLite.DataModule1.qryPICTURE.Post;
    dmIBLite.DataModule1.qryPICTURE.Close;
*)

(*
    Option #2
/* Table: LOG_ENTRIES, Owner: SYSDBA */

CREATE TABLE "LOG_ENTRIES"
(
  "PICTURE"	BLOB SUB_TYPE 0 SEGMENT SIZE 80 NOT NULL,
  "PROJ_ID"	INTEGER NOT NULL,
  "LONGITUDE"	DECIMAL(10, 10),
  "LATITUDE"	DECIMAL(10, 10),
  "DATE_STAMP"	DATE NOT NULL,
  "FRAMES"	VARCHAR(10),
  "MEGAPIXELS"	VARCHAR(5),
  "TIMESTAMPPHONE"	TIMESTAMP NOT NULL,
  "USER_NOTES"	BLOB SUB_TYPE TEXT SEGMENT SIZE 80
);
ALTER TABLE "LOG_ENTRIES" ADD CONSTRAINT "PROJ_ID" FOREIGN KEY ("PROJ_ID") REFERENCES "PROJECTS" ("PROJ_ID") ON UPDATE SET DEFAULT ON DELETE SET DEFAULT;

*)
(*
  insert into LOG_ENTRIES (PICTURE, PROJ_ID, TIMESTAMP, LONGITUDE, LATITUDE)
  values (:PICTURE, :PROJ_ID, :TIMESTAMP, :LONGITUDE, :LATITUDE)

 //SQL errors:  Unknown token TIMESTAMP ?
 // For InterBase,
 // CREATE TABLE TEST (DT TIMESTAMP DEFAULT NOW)
 // The point is that NOW is not a valid default value for a TIMESTAMP column, you should use CURRENT_TIMESTAMP instead.
 //
// IBCQuery.SQL.Text := 'update LOG_ENTRIES set dt=''now'' where id=1'; //dt is DATE
// IBCQuery.Execute;
*)
// Save Captured Data to IBlite Database
//Test data for tesing qryInsert
  Proj_Id := 3;
  if (Proj_Id <> 0) then
  begin
  TStamp := Now;
  longitude := -73.935242;
  latitude := 40.730610;
  //picture := dmIBLite.DataModule1.qryPICTUREPICTURE.LoadFromFile('C:\Images\MARBLES.BMP');
    //dmIBLite.DataModule1.qryInsertLogEntries.ParamByName('PICTURE').Value := picture;
    dmIBLite.DataModule1.qryInsertLogEntries.Params.ParamByName('PROJ_ID').Value := Proj_Id;
    dmIBLite.DataModule1.qryInsertLogEntries.Params.ParamByName('TIMESTAMP').Value := TStamp;
    dmIBLite.DataModule1.qryInsertLogEntries.Params.ParamByName('LONGITUDE').Value := longitude;
    dmIBLite.DataModule1.qryInsertLogEntries.Params.ParamByName('LATITUDE').Value := latitude;
  end;
    try
      dmIBLite.DataModule1.qryInsertLogEntries.ExecSQL();
      dmIBLite.DataModule1.qryPICTURE.Open();
      dmIBLite.DataModule1.qryPICTURE.Append;
      dmIBLite.DataModule1.qryPICTUREPICTURE.LoadFromStream(stream);
      dmIBLite.DataModule1.qryPICTURE.Post;
      dmIBLite.DataModule1.qryPICTURE.Close;
    finally
      dmIBLite.DataModule1.qryInsertLogEntries.Free;
      ShowMessage('The Captured data is saved!');
    end;
end;

//**********************************************************
//* SAVE PROJECT data to IBlite Database
//**********************************************************
(*
  //* Table: PROJECTS, Owner: SYSDBA */

  CREATE TABLE "PROJECTS"
  (
    "PROJ_ID"	INTEGER NOT NULL,
    "PROJ_TITLE"	VARCHAR(40) NOT NULL,
    "PROJ_DESCRIPTION"	BLOB SUB_TYPE TEXT SEGMENT SIZE 80,
   PRIMARY KEY ("PROJ_ID")
  );
*)

procedure TForm1.ShowShareSheetAction1BeforeExecute(Sender: TObject);
begin
  ShowShareSheetAction1.Bitmap.Assign(Image1.Bitmap);
end;

procedure TForm1.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

procedure TForm1.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

end.
