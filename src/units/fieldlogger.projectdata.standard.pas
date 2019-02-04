/// <summary>
///  Provides the 'standard' implementation of the IProjectData interface
///  as defined in fieldlogger.data.pas
/// </summary>
unit fieldlogger.projectdata.standard;

interface
uses
  Data.DB
, FireDAC.Comp.Client
, fieldlogger.data
;

type
  TProjectData = class( TInterfacedObject, IProjectData )
  private
    [weak] fConnection: TFDConnection; //- Weak reference because we are not responsible for freeing.
  strict private //- IProjectData -//
    function CreateProject( Project: TProject ): uint32;
    function Read( out Projects: TArrayOfProject; ID: uint32 = 0 ): integer;
    function Update( Projects: TArrayOfProject ): boolean;
    function Delete( Projects: TArrayOfUInt32 ): boolean;
  public
    constructor Create( Connection: TFDConnection; out ValidConnection: Boolean ); reintroduce;
    destructor Destroy; override;
  end;

implementation
uses
  sysutils
;

{ TProjectData }

constructor TProjectData.Create(Connection: TFDConnection; out ValidConnection: Boolean);
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

function TProjectData.CreateProject(Project: TProject): uint32;
var
  qry: TFDQuery;
begin
  Result := 0;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := fConnection;
    //- Using a select statement here instead of insert because,
    //- with select it is easier to obtain the primary key generated
    //- for this entry.
    qry.SQL.Text := 'SELECT * FROM PROJECTS;';
    qry.Active := True;
    if not qry.Active then begin
      exit;
    end;
    qry.Append;
    qry.FieldByName('PROJ_ID').AsInteger := 0;
    qry.FieldByName('PROJ_TITLE').AsString := Project.Title;
    qry.FieldByName('PROJ_DESC').AsString := Project.Description;
    qry.Post;
    qry.Refresh;
    qry.Last;
    Result := qry.FieldByName('PROJ_ID').AsInteger;
  finally
    qry.DisposeOf;
  end;
end;

function TProjectData.Delete(Projects: TArrayOfUInt32): boolean;
var
  transaction: TFDTransaction;
  qry: TFDQuery;
  idx: integer;
begin
  Result := False;
  if Length(Projects)=0 then begin
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
        qry.SQL.Text := 'DELETE FROM PROJECTS WHERE PROJ_ID=:ID;';
        for idx := 0 to pred(length(Projects)) do begin
          qry.Params.ParamByName('ID').AsInteger := Projects[idx];
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


destructor TProjectData.Destroy;
begin
  fConnection := nil;
  inherited Destroy;
end;

function TProjectData.Read(out Projects: TArrayOfProject; ID: uint32): integer;
var
  qry: TFDQuery;
  idx: integer;
begin
  Result := 0;
  SetLength( Projects, 0 );
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := fConnection;
    if ID=0 then begin
      qry.SQL.Text := 'SELECT * FROM PROJECTS;';
    end else begin
      qry.SQL.Text := 'SELECT * FROM PROJECTS WHERE PROJ_ID=:ID;';
      qry.Params.ParamByName('ID').AsInteger := ID;
    end;
    qry.Active := True;
    if not qry.Active then begin
      exit;
    end;
    if qry.RecordCount=0 then begin
      exit;
    end;
    SetLength(Projects,qry.RecordCount);
    idx := 0;
    qry.First;
    while not qry.EOF do begin
      Projects[idx].ID := qry.FieldByName('PROJ_ID').AsInteger;
      Projects[idx].Title := qry.FieldByName('PROJ_TITLE').AsString;
      Projects[idx].Description := qry.FieldByName('PROJ_DESC').AsString;
      inc(idx);
      qry.Next;
    end;
    Result := qry.RecordCount;
  finally
    qry.DisposeOf;
  end;
end;


function TProjectData.Update(Projects: TArrayOfProject): boolean;
var
  transaction: TFDTransaction;
  qry: TFDQuery;
  idx: integer;
begin
  Result := False;
  if Length(Projects)=0 then begin
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
        qry.SQL.Text := 'UPDATE PROJECTS SET PROJ_TITLE=:PROJ_TITLE, PROJ_DESC=:PROJ_DESC WHERE PROJ_ID=:ID;';
        for idx := 0 to pred(length(projects)) do begin
          qry.Params.ParamByName('ID').AsInteger := Projects[idx].ID;
          qry.Params.ParamByName('PROJ_TITLE').AsString := Projects[idx].Title;
          qry.Params.ParamByName('PROJ_DESC').AsString := Projects[idx].Description;
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
