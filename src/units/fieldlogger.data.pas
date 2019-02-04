///  <summary>
///    Provides interfaces for working with the projects and logentries tables
///    of our database. NOTE:!! The IProjectData and ILogData interfaces and
///    their respective implementations are sufficiently similar that it may
///    make sense to use Generics instead of individual interfaces /
///    implementations. In this case, each interface and class is kept
///    separate for simplicity, however, generics would make for easier
///    scaling of this CRUD based system.
///  </summary>
unit fieldlogger.data;

interface
uses
  FMX.Graphics
, classes
, Data.DB
, FireDAC.Comp.Client
;

type
{$region ' Project Data'}
  ///  <summary>
  ///    A record representing a single entry into the projects database table.
  ///  </summary>
  TProject = record
    ID: uint32;
    Title: string[30];
    Description: string;
  end;

  ///  <summary>
  ///    Dynamic array of TProject for passing collections of projects to
  ///    IProjectData.
  ///  </summary>
  TArrayOfProject = array of TProject;

  ///  <summary>
  ///    Dynamic array of uint32, used for passing project or log entry
  ///    ID's to the Delete() methods of IProjectData and ILogData.
  ///  </summary>
  TArrayOfUInt32 = array of uint32;

  ///  <summary>
  ///    An implementation of IProjectData provides a CRUD style interface to
  ///    the projects database table.
  ///  </summary>
  IProjectData = interface
    ['{13D2A1EF-9205-432B-A776-F2E30F5F672F}']

    ///  <summary>
    ///    Creates a new project entry in the database and populates it with
    ///    data provided in the 'Project' parameter. The ID field of the
    ///    Project will be ignored, a new ID will be created and returned
    ///    from CreateProject().
    ///  </summary>
    function CreateProject( Project: TProject ): uint32;

    ///  <summary>
    ///    Reads one or more entries from the projects table.
    ///    If the optional ID parameter is set to anything other than
    ///    zero, this method will attempt to fetch the project with that
    ///    ID. If the requested entry does not exist in the database, the
    ///    projects array will have a length of zero, and zero is returned
    ///    from Read().
    ///    If the optional ID parameter is not set (=zero), then this method
    ///    will attempt to read  all entries from the database. The result of
    ///    Read() will be the number of entries found (and will match the
    ///    length of the projects array).
    ///  </summary>
    function Read( out Projects: TArrayOfProject; ID: uint32 = 0 ): integer;

    ///  <summary>
    ///    Attempts to update one or more project entries in the database.
    ///    Provide an array of TProject objects containing the changes to be
    ///    made. The Update method will loop the array and attempt to update
    ///    each entry who's ID field is matched in the database.
    ///    This method will fail if any of the records cannot be updated.
    ///  </summary>
    function Update( Projects: TArrayOfProject ): boolean;

    ///  <summary>
    ///    Attempts to delete those records who's ID's are specified in
    ///    the projects array.
    ///  </summary>
    function Delete( Projects: TArrayOfUInt32 ): boolean;
  end;

{$endregion}

{$region ' Log Data'}
  ///  <summary>
  ///    Used by members of TLogEntry to represent origin, heading, bearing etc.
  ///  </summary>
  TVector = record
    X: Double;
    Y: Double;
    Z: Double;
  end;

  ///  <sumamry>
  ///    A record representing a single entry into the log_entires database
  ///   table.
  ///  </summary>
  TLogEntry = record
  private
    //- Going to store the image data in a dynamic array so that we don't have
    //- to marshal a TBitmap.
    ImageData: array of uint8;
  public
    ID: uint32;
    ProjectID: uint32;
    Longitude: double;
    Latitude: double;
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
    procedure setPicture( aBitmap: TBitmap );
  end;

  ///  <summary>
  ///    A dynamic array of log entries.
  ///  </summary>
  TArrayOfLogEntry = array of TLogEntry;

  ///  <summary>
  ///    An implmentation of ILogData provides CRUD access to the logentries
  ///    database table.
  ///  </summary>
  ILogData = interface
    ['{BE00A332-B2A6-4082-8901-7B941E7BF17B}']

    ///  <summary>
    ///    Creates a new log entry in the database and populates it with
    ///    data provided in the 'Entry' parameter. The ID field of the
    ///    entry will be ignored, a new ID will be created and returned
    ///    from CreateEntry().
    ///    The ProjectID field must be non-zero in order to create this
    ///    log entry as a detail of the projects table. If the ProjectID
    ///    is not set to a valid project id, this method will fail to
    ///    meet the database constraints and an exception will be raised.
    ///  </summary>
    function CreateEntry( Entry: TLogEntry ): uint32;

    ///  <summary>
    ///    NOTE:!! The PROJECT_ID is not the ID of a log entry, but due to
    ///    the LOG_ENTRIES table being a detail of the PROJECTS table, it
    ///    specifies the ID of the project which masters the log entry
    ///    detail !!
    ///    Reads one or more entries from the logentries table.
    ///    If the optional PROJECT_ID parameter is set to anything other than
    ///    zero, this method will attempt to fetch the log entry with the
    ///    foriegn key into projects matching the PROJECT_ID.
    ///    If the requested entry/entries do not exist in the database, the
    ///    entries array will have a length of zero, and zero is returned
    ///    from Read().
    ///    If the optional PROJECT_ID parameter is not set (=zero),
    ///    then this method will attempt to read all entries from the database.
    ///    The result of Read() will be the number of entries found (and will
    ///    match the length of the projects array).
    ///  </summary>
    function Read( out Entries: TArrayOfLogEntry; PROJECT_ID: uint32 = 0 ): integer;

    ///  <summary>
    ///    Attempts to update one or more log entries in the database.
    ///    Provide an array of TLogEnmtry objects containing the changes to be
    ///    made. The Update method will loop the array and attempt to update
    ///    each entry who's ID field is matched in the database.
    ///    This method will fail if any of the records cannot be updated.
    ///    If an update is made to a TLogEntry.ProjectID field, and a matching
    ///    project for that ID does not exist in the database, a key constraint
    ///    violation will occur and an exception will be raised.
    ///  </summary>
    function Update( Entries: TArrayOfLogEntry ): boolean;

    ///  <summary>
    ///    Attempts to delete those records who's ID's are specified in
    ///    the entries array.
    ///  </summary>
    function Delete( Entries: TArrayOfUInt32 ): boolean;

  end;

{$endregion}


type
  ///  <summary>
  ///    This is a factory record for creating instances of IProjectData.
  ///  </summary>
  TProjectData = record
  public

    ///  <summary>
    ///    Creates a new instance of IProjectData.
    ///    If the instance could not be created (Database connection not
    ///    valid), then this method will return nil.
    ///  </summary>
    class function Create( Connection: TFDConnection ): IProjectData; static;
  end;

  ///  <summary>
  ///    This is a factory reccord for creating instances of ILogData.
  ///  </summary>
  TLogData = record
  public

    ///  <summary>
    ///    Creates a new instance of ILogData.
    ///    If the instance could not be created (Database connection not
    ///    valid), then this method will return nil.
    ///  </summary>
    class function Create( Connection: TFDConnection ): ILogData; static;
  end;

implementation
uses
  fieldlogger.projectdata.standard
, fieldlogger.logdata.standard;

{ TLogData }

class function TLogData.Create(Connection: TFDConnection): ILogData;
var
  ValidConnection: Boolean;
begin
  Result := fieldlogger.logdata.standard.TLogData.Create(Connection, ValidConnection );
  if not ValidConnection then begin
    Result := nil;
  end;
end;


{ TProjectData }

class function TProjectData.Create(Connection: TFDConnection): IProjectData;
var
  ValidConnection: Boolean;
begin
  Result := fieldlogger.projectdata.standard.TProjectData.Create( Connection, ValidConnection );
  if not ValidConnection then begin
    Result := nil;
  end;
end;

{ TLogEntry }

function TLogEntry.getPicture: TBitmap;
var
  MS: TMemoryStream;
  idx: uint32;
begin
  Result := TBitmap.Create;
  if Length(ImageData)=0 then begin
    exit;
  end;
  MS := TMemoryStream.Create;
  try
    for idx := 0 to pred(Length(ImageData)) do begin
      MS.Write(ImageData[idx],sizeof(uint8));
    end;
    MS.Position := 0;
    Result.LoadFromStream(MS);
  finally
    MS.DisposeOf;
  end;
end;

procedure TLogEntry.setPicture(aBitmap: TBitmap);
var
  MS: TMemoryStream;
  idx: uint32;
begin
  MS := TMemoryStream.Create;
  try
    aBitmap.SaveToStream(MS);
    MS.Position := 0;
    SetLength(ImageData,MS.Size);
    if Length(ImageData)=0 then begin
      exit;
    end;
    for idx := 0 to pred(Length(ImageData)) do begin
      MS.Read(ImageData[idx],sizeof(uint8));
    end;
  finally
    MS.DisposeOf;
  end;
end;

end.
