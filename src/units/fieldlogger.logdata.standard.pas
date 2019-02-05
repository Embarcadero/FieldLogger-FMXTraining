/// <summary>
///  Provides the 'standard' implementation of the IProjectData interface
///  as defined in fieldlogger.data.pas
/// </summary>
unit fieldlogger.logdata.standard;

interface
uses
  Data.DB
, FireDAC.Comp.Client
, fieldlogger.data
;

type
  TLogData = class( TInterfacedObject, ILogData )
  private
    [weak] fConnection: TFDConnection; //- Weak reference because we are not responsible for freeing.
  strict private //- ILogData -//
    function CreateEntry( Entry: TLogEntry ): uint32;
    function Read( out Entries: TArrayOfLogEntry; PROJECT_ID: uint32 = 0 ): integer;
    function Update( Entries: TArrayOfLogEntry ): boolean;
    function Delete( Entries: TArrayOfUInt32 ): boolean;
  public
    constructor Create( Connection: TFDConnection; out ValidConnection: Boolean ); reintroduce;
    destructor Destroy; override;
  end;

implementation
uses
  FMX.Graphics
, FireDAC.Stan.Param
, Classes
, sysutils
;

constructor TLogData.Create(Connection: TFDConnection; out ValidConnection: Boolean);
begin
  inherited Create;
  fConnection := Connection;
  //- Check that we have a valid connection which can connect to the database.
  ValidConnection := False;
  if fConnection.Connected then begin
    ValidConnection := True;
    exit;
  end;
  // Attempt connect
  try
    fConnection.Connected := True;
  except
    on E: Exception do begin
      exit; //- ValidConnection remains false
    end;
  end;
  // Check connected
  if not fConnection.Connected then begin
    exit; // ValidConnection remains false.
  end;
  ValidConnection := True;
end;

function TLogData.CreateEntry(Entry: TLogEntry): uint32;
var
  MS: TMemoryStream;
  Bitmap: TBitmap;
  qry: TFDQuery;
begin
  Result := 0;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := fConnection;
    //- Using a select statement here instead of insert because,
    //- with select it is easier to obtain the primary key generated
    //- for this entry.
    qry.SQL.Text := 'SELECT * FROM LOG_ENTRIES;';
    qry.Active := True;
    if not qry.Active then begin
      exit;
    end;
    qry.Append;
    qry.FieldByName('LOG_ID').AsInteger := 0;
    qry.FieldByName('PROJ_ID').AsInteger := Entry.ProjectID;
    qry.FieldByName('LONGITUDE').AsFloat := Entry.Longitude;
    qry.FieldByName('LATITUDE').AsFloat := Entry.Latitude;
    qry.FieldByName('TIMEDATESTAMP').AsDateTime := Entry.TimeDateStamp;
    qry.FieldByName('OR_X').AsFloat := Entry.Origin.X;
    qry.FieldByName('OR_Y').AsFloat := Entry.Origin.Y;
    qry.FieldByName('OR_Z').AsFloat := Entry.Origin.Z;
    qry.FieldByName('OR_DISTANCE').AsFloat := Entry.Distance;
    qry.FieldByName('HEADING_X').AsFloat := Entry.Heading.X;
    qry.FieldByName('HEADING_Y').AsFloat := Entry.Heading.Y;
    qry.FieldByName('HEADING_Z').AsFloat := Entry.Heading.Z;
    qry.FieldByName('V_X').AsFloat := Entry.Acceleration.X;
    qry.FieldByName('V_Y').AsFloat := Entry.Acceleration.Y;
    qry.FieldByName('V_Z').AsFloat := Entry.Acceleration.Z;
    qry.FieldByName('ANGLE_X').AsFloat := Entry.Angle.X;
    qry.FieldByName('ANGLE_Y').AsFloat := Entry.Angle.Y;
    qry.FieldByName('ANGLE_Z').AsFloat := Entry.Angle.Z;
    qry.FieldByName('MOTION').AsFloat := Entry.Motion;
    qry.FieldByName('SPEED').AsFloat := Entry.Speed;
    qry.FieldByName('NOTE').AsString := Entry.Note;
    MS := TMemoryStream.Create;
    try
      Bitmap := Entry.getPicture;
      try
        Bitmap.SaveToStream(MS);
        MS.Position := 0;
      finally
        Bitmap.DisposeOf;
      end;
      (qry.FieldByName('PICTURE') as TBlobField).LoadFromStream( MS );
      qry.Post;
    finally
      MS.DisposeOf;
    end;
    qry.Refresh;
    qry.Last;
    Result := qry.FieldByName('PROJ_ID').AsInteger;
  finally
    qry.DisposeOf;
  end;
end;

function TLogData.Delete(Entries: TArrayOfUInt32): boolean;
var
  transaction: TFDTransaction;
  qry: TFDQuery;
  idx: integer;
begin
  Result := False;
  if Length(Entries)=0 then begin
    Result := True;
    exit;
  end;
  transaction := TFDTransaction.Create(nil);
  try
    transaction.Connection := fConnection;
    transaction.StartTransaction;
    try
      qry := TFDQuery.Create(nil);
      try
        qry.Connection := fConnection;
        qry.Transaction := transaction;
        qry.SQL.Text := 'DELETE FROM LOG_ENTRIES WHERE LOG_ID=:ID;';
        for idx := 0 to pred(length(Entries)) do begin
          qry.Params.ParamByName('ID').AsInteger := Entries[idx];
          try
            qry.ExecSQL;
          except
            on E: Exception do begin
              transaction.Rollback;
              raise; //<- For exception safe, replace this with exit, function will exit result=FALSE
            end;
          end;
        end;
      finally
        qry.DisposeOf;
      end;
    finally
      transaction.Commit;
      Result := True;
    end;
  finally
    transaction.DisposeOf;
  end;
end;

destructor TLogData.Destroy;
begin
  fConnection := nil;
  inherited Destroy;
end;

function TLogData.Read(out Entries: TArrayOfLogEntry; PROJECT_ID: uint32): integer;
var
  Bitmap: TBitmap;
  MS: TMemoryStream;
  qry: TFDQuery;
  idx: integer;
begin
  Result := 0;
  SetLength( Entries, 0 );
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := fConnection;
    if PROJECT_ID=0 then begin
      qry.SQL.Text := 'SELECT * FROM LOG_ENTRIES;';
    end else begin
      qry.SQL.Text := 'SELECT * FROM LOG_ENTRIES WHERE PROJ_ID=:ID;';
      qry.Params.ParamByName('ID').AsInteger := PROJECT_ID;
    end;
    qry.Active := True;
    if not qry.Active then begin
      exit;
    end;
    if qry.RecordCount=0 then begin
      exit;
    end;
    SetLength(Entries,qry.RecordCount);
    idx := 0;
    qry.First;
    while not qry.EOF do begin
      Entries[idx].ID := qry.FieldByName('LOG_ID').AsInteger;
      Entries[idx].ProjectID := qry.FieldByName('PROJ_ID').AsInteger;
      Entries[idx].Longitude := qry.FieldByName('LONGITUDE').AsFloat;
      Entries[idx].Latitude := qry.FieldByName('LATITUDE').AsFloat;
      Entries[idx].TimeDateStamp := qry.FieldByName('TIMEDATESTAMP').AsDateTime;
      Entries[idx].Origin.X := qry.FieldByName('OR_X').AsFloat;
      Entries[idx].Origin.Y := qry.FieldByName('OR_Y').AsFloat;
      Entries[idx].Origin.Z := qry.FieldByName('OR_Z').AsFloat;
      Entries[idx].Distance := qry.FieldByName('OR_DISTANCE').AsFloat;
      Entries[idx].Heading.X := qry.FieldByName('HEADING_X').AsFloat;
      Entries[idx].Heading.Y := qry.FieldByName('HEADING_Y').AsFloat;
      Entries[idx].Heading.Z := qry.FieldByName('HEADING_Z').AsFloat;
      Entries[idx].Acceleration.X := qry.FieldByName('V_X').AsFloat;
      Entries[idx].Acceleration.Y := qry.FieldByName('V_Y').AsFloat;
      Entries[idx].Acceleration.Z := qry.FieldByName('V_Z').AsFloat;
      Entries[idx].Angle.X := qry.FieldByName('ANGLE_X').AsFloat;
      Entries[idx].Angle.Y := qry.FieldByName('ANGLE_Y').AsFloat;
      Entries[idx].Angle.Z := qry.FieldByName('ANGLE_Z').AsFloat;
      Entries[idx].Motion := qry.FieldByName('MOTION').AsFloat;
      Entries[idx].Speed := qry.FieldByName('SPEED').AsFloat;
      Entries[idx].Note := qry.FieldByName('NOTE').AsString;
      MS := TMemoryStream.Create;
      try
        (qry.FieldByName('PICTURE') as TBlobField).SaveToStream(MS);
        MS.Position := 0;
        Bitmap := TBitmap.Create;
        try
          Bitmap.LoadFromStream(MS);
          Entries[idx].setPicture( Bitmap );
        finally
          Bitmap.DisposeOf;
        end;
      finally
        MS.DisposeOf;
      end;
      inc(idx);
      qry.Next;
    end;
    Result := qry.RecordCount;
  finally
    qry.DisposeOf;
  end;
end;

function TLogData.Update(Entries: TArrayOfLogEntry): boolean;
var
  transaction: TFDTransaction;
  qry: TFDQuery;
  idx: integer;
  Bitmap: TBitmap;
  MS: TMemoryStream;
begin
  Result := False;
  if Length(Entries)=0 then begin
    Result := True;
    exit;
  end;
  transaction := TFDTransaction.Create(nil);
  try
    transaction.Connection := fConnection;
    transaction.StartTransaction;
    try
      qry := TFDQuery.Create(nil);
      try
        qry.Connection := fConnection;
        qry.Transaction := transaction;
        qry.SQL.Text := 'UPDATE LOG_ENTRIES SET  '+
          'PROJ_ID=:PROJ_ID, '+
          'LONGITUDE=:LONGITUDE, '+
          'LATITUDE=:LATITUDE, '+
          'TIMEDATESTAMP=:TIMEDATESTAMP, '+
          'OR_X=:OR_X, '+
          'OR_Y=:OR_Y, '+
          'OR_Z=:OR_Z, '+
          'OR_DISTANCE=:OR_DISTANCE, '+
          'HEADING_X=:HEADING_X, '+
          'HEADING_Y=:HEADING_Y, '+
          'HEADING_Z=:HEADING_Z, '+
          'V_X=:V_X, '+
          'V_Y=:V_Y, '+
          'V_Z=:V_Z, '+
          'ANGLE_X=:ANGLE_X, '+
          'ANGLE_Y=:ANGLE_Y, '+
          'ANGLE_Z=:ANGLE_Z, '+
          'MOTION=:MOTION, '+
          'SPEED=:SPEED, '+
          'NOTE=:NOTE, '+
          'PICTURE=:PICTURE '+
          '  WHERE LOG_ID=:ID';
        for idx := 0 to pred(length(entries)) do begin
          qry.ParamByName('PROJ_ID').AsInteger := entries[idx].ProjectID;
          qry.ParamByName('LONGITUDE').AsFloat := entries[idx].Longitude;
          qry.ParamByName('LATITUDE').AsFloat := entries[idx].Latitude;
          qry.ParamByName('TIMEDATESTAMP').AsDateTime := entries[idx].TimeDateStamp;
          qry.ParamByName('OR_X').AsFloat := entries[idx].Origin.X;
          qry.ParamByName('OR_Y').AsFloat := entries[idx].Origin.Y;
          qry.ParamByName('OR_Z').AsFloat := entries[idx].Origin.Z;
          qry.ParamByName('OR_DISTANCE').AsFloat := entries[idx].Distance;
          qry.ParamByName('HEADING_X').AsFloat := entries[idx].Heading.X;
          qry.ParamByName('HEADING_Y').AsFloat := entries[idx].Heading.Y;
          qry.ParamByName('HEADING_Z').AsFloat := entries[idx].Heading.Z;
          qry.ParamByName('V_X').AsFloat := entries[idx].Acceleration.X;
          qry.ParamByName('V_Y').AsFloat := entries[idx].Acceleration.Y;
          qry.ParamByName('V_Z').AsFloat := entries[idx].Acceleration.Z;
          qry.ParamByName('ANGLE_X').AsFloat := entries[idx].Angle.X;
          qry.ParamByName('ANGLE_Y').AsFloat := entries[idx].Angle.Y;
          qry.ParamByName('ANGLE_Z').AsFloat := entries[idx].Angle.Z;
          qry.ParamByName('MOTION').AsFloat := entries[idx].Motion;
          qry.ParamByName('SPEED').AsFloat := entries[idx].Speed;
          qry.ParamByName('NOTE').AsString := entries[idx].Note;
          Bitmap := entries[idx].getPicture;
          try
            MS := TMemoryStream.Create;
            try
              Bitmap.SaveToStream(MS);
              MS.Position := 0;
              qry.ParamByName('PICTURE').LoadFromStream(MS,TFieldType.ftBlob);
            finally
              MS.DisposeOf;
            end;
          finally
            Bitmap.DisposeOf;
          end;
          try
            qry.ExecSQL;
          except
            on E: Exception do begin
              transaction.Rollback;
              raise; //<- For exception safe, replace this with exit, function will exit result=FALSE
            end;
          end;
        end;
      finally
        qry.DisposeOf;
      end;
    finally
      transaction.Commit;
      Result := True;
    end;
  finally
    transaction.DisposeOf;
  end;
end;

end.

