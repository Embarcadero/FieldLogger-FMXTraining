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
  end;

  /// <summary>
  /// A dynamic array of log entries.
  /// </summary>
  TArrayOfLogEntry = array of TLogEntry;

{$ENDREGION}

implementation


end.
