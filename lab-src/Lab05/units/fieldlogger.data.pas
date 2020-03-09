/// <summary>
/// Provides interfaces for working with the projects and logentries tables
/// of our database. NOTE:!! The IProjectData and ILogData interfaces and
/// their respective implementations are sufficiently similar that it may
/// make sense to use Generics instead of individual interfaces /
/// implementations. In this case, each interface and class is kept
/// separate for simplicity, however, generics would make for easier
/// scaling of this CRUD based system.
/// </summary>
unit fieldlogger.data;

interface

uses
  FMX.Graphics, classes, data.DB, FireDAC.Comp.Client;

type
{$REGION ' Project Data'}
  /// <summary>
  /// A record representing a single entry into the projects database table.
  /// </summary>
  TProject = record
    ID: uint32;
    Title: string;
    Description: string;
  end;

  /// <summary>
  /// Dynamic array of TProject for passing collections of projects to
  /// IProjectData.
  /// </summary>
  TArrayOfProject = array of TProject;

  /// <summary>
  /// Dynamic array of uint32, used for passing project or log entry
  /// ID's to the Delete() methods of IProjectData and ILogData.
  /// </summary>
  TArrayOfUInt32 = array of uint32;

{$ENDREGION}
{$REGION ' Log Data'}

  /// <summary>
  /// Used by members of TLogEntry to represent origin, heading, bearing etc.
  /// </summary>
  TVector = record
    X: Double;
    Y: Double;
    Z: Double;
  end;

  /// <sumamry>
  /// A record representing a single entry into the log_entires database
  /// table.
  /// </summary>
  TLogEntry = record
  private
    // - Going to store the image data in a dynamic array so that we don't have
    // - to marshal a TBitmap.
    ImageData: array of uint8;
  public
    ID: uint32;
    ProjectID: uint32;
    Longitude: Double;
    Latitude: Double;
    TimeDateStamp: TDateTime;
    Origin: TVector;
    Heading: TVector;
    Acceleration: TVector;
    Angle: TVector;
    Distance: Double;
    Motion: Double;
    Speed: Double;
    Note: string;
  public
    function getPicture: TBitmap;
    procedure SavePictureToStream(var AStream: TMemoryStream);
    procedure LoadPictureFromStream(AStream: TMemoryStream);
    procedure setPicture(aBitmap: TBitmap);
  end;

  /// <summary>
  /// A dynamic array of log entries.
  /// </summary>
  TArrayOfLogEntry = array of TLogEntry;

{$ENDREGION}

implementation

{ TLogEntry }

function TLogEntry.getPicture: TBitmap;
var
  MS: TMemoryStream;
  idx: uint32;
begin
  Result := TBitmap.Create;
  if Length(ImageData) = 0 then
  begin
    exit;
  end;
  MS := TMemoryStream.Create;
  try
    for idx := 0 to pred(Length(ImageData)) do
    begin
      MS.Write(ImageData[idx], sizeof(uint8));
    end;
    MS.Position := 0;
    Result.LoadFromStream(MS);
  finally
    MS.DisposeOf;
  end;
end;

procedure TLogEntry.SavePictureToStream(var AStream: TMemoryStream);
var
  MS: TMemoryStream;
  idx: uint32;
begin
  if Length(ImageData) = 0 then
  begin
    exit;
  end;

  for idx := 0 to pred(Length(ImageData)) do
  begin
    AStream.Write(ImageData[idx], sizeof(uint8));
  end;
  AStream.Position := 0;
end;

procedure TLogEntry.LoadPictureFromStream(AStream: TMemoryStream);
var
  idx: uint32;
begin
  try
    AStream.Position := 0;
    SetLength(ImageData, AStream.Size);
    if Length(ImageData) = 0 then
    begin
      exit;
    end;
    for idx := 0 to pred(Length(ImageData)) do
    begin
      AStream.Read(ImageData[idx], sizeof(uint8));
    end;
  finally

  end;
end;


procedure TLogEntry.setPicture(aBitmap: TBitmap);
var
  MS: TMemoryStream;
  idx: uint32;
begin
  MS := TMemoryStream.Create;
  try
    // resize the images to 512 on the largest size
    if aBitmap.Height > aBitmap.Width then
      aBitmap.Resize(Trunc(aBitmap.Width / aBitmap.Height * 512), 512)
    else
      aBitmap.Resize(512, Trunc(aBitmap.Height / aBitmap.Width * 512));
    aBitmap.SaveToStream(MS);
    MS.Position := 0;
    SetLength(ImageData, MS.Size);
    if Length(ImageData) = 0 then
    begin
      exit;
    end;
    for idx := 0 to pred(Length(ImageData)) do
    begin
      MS.Read(ImageData[idx], sizeof(uint8));
    end;
  finally
    MS.DisposeOf;
  end;
end;

end.
