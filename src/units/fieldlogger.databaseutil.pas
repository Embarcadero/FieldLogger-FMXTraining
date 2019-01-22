unit fieldlogger.databaseutil;

interface
uses
  FireDAC.Comp.Client;

type
  TDatabaseUtils = class
  public
    class function DataFilename: string;
    class procedure ConfigureConnection( Connection: TFDConnection );
    class procedure CreateDatabase( Connection: TFDConnection );
  end;

implementation
uses
  sysutils
, IOUtils
;

const
  cDatafileName = 'EMBEDDEDIBLITE.IB';

class procedure TDatabaseUtils.ConfigureConnection(Connection: TFDConnection);
begin
  Connection.LoginPrompt := False;
  Connection.Params.Database := TDatabaseUtils.DataFilename;
end;

class procedure TDatabaseUtils.CreateDatabase(Connection: TFDConnection);
var
  qry: TFDQuery;
begin
  Connection.Params.Values['CreateDatabase'] := BoolToStr(True,True);
  Connection.Connected := True;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Connection;
    //- Create LOG_ENTRIES table
    qry.SQL.Clear;
    qry.SQL.Add(' CREATE TABLE "LOG_ENTRIES" ( ');
    qry.SQL.Add('   "LOG_ID"	INTEGER NOT NULL, ');
    qry.SQL.Add('   "PROJ_ID"	INTEGER NOT NULL, ');
    qry.SQL.Add('   "PICTURE"	BLOB SUB_TYPE 0 SEGMENT SIZE 80, ');
    qry.SQL.Add('   "LONGITUDE"	FLOAT, ');
    qry.SQL.Add('   "LATITUDE"	FLOAT, ');
    qry.SQL.Add('   "TIMEDATESTAMP"	TIMESTAMP, ');
    qry.SQL.Add('   "OR_X"	FLOAT, ');
    qry.SQL.Add('   "OR_Y"	FLOAT, ');
    qry.SQL.Add('   "OR_Z"	FLOAT, ');
    qry.SQL.Add('   "OR_DISTANCE"	FLOAT, ');
    qry.SQL.Add('   "HEADING_X"	FLOAT, ');
    qry.SQL.Add('   "HEADING_Y"	FLOAT, ');
    qry.SQL.Add('   "HEADING_Z"	FLOAT, ');
    qry.SQL.Add('   "V_X"	FLOAT, ');
    qry.SQL.Add('   "V_Y"	FLOAT, ');
    qry.SQL.Add('   "V_Z"	FLOAT, ');
    qry.SQL.Add('   "ANGLE_X"	FLOAT, ');
    qry.SQL.Add('   "ANGLE_Y"	FLOAT, ');
    qry.SQL.Add('   "ANGLE_Z"	FLOAT, ');
    qry.SQL.Add('   "MOTION"	FLOAT, ');
    qry.SQL.Add('   "SPEED"	FLOAT, ');
    qry.SQL.Add('   "NOTE"	BLOB SUB_TYPE TEXT SEGMENT SIZE 80 ');
    qry.SQL.Add('   ); ');
    qry.ExecSQL;
    //- Create PROJECTS table
    qry.SQL.Clear;
    qry.SQL.Add('   CREATE TABLE "PROJECTS" ( ');
    qry.SQL.Add('     "PROJ_ID"	INTEGER NOT NULL, ');
    qry.SQL.Add('     "PROJ_TITLE"	VARCHAR(30) NOT NULL, ');
    qry.SQL.Add('     "PROJ_DESC"	BLOB SUB_TYPE TEXT SEGMENT SIZE 80, ');
    qry.SQL.Add('    PRIMARY KEY ("PROJ_ID") ');
    qry.SQL.Add('   ); ');
    qry.ExecSQL;
    //- Apply primary key to LOG_ENTRIES
    qry.SQL.Clear;
    qry.SQL.Add('   ALTER TABLE "LOG_ENTRIES" ADD PRIMARY KEY ("LOG_ID"); ');
    qry.ExecSQL;

    //- Apply foriegn key to LOG_ENTRIES
    qry.SQL.Clear;
    qry.SQL.Add('   ALTER TABLE "LOG_ENTRIES" ADD FOREIGN KEY ("PROJ_ID") REFERENCES ');
    qry.SQL.Add('     "PROJECTS" ("PROJ_ID") ON UPDATE SET DEFAULT ON DELETE SET DEFAULT; ');
    qry.ExecSQL;
    //- Create auto id generator
    qry.SQL.Clear;
    qry.SQL.Add(' CREATE GENERATOR "GENAUTOINC"; ');
    qry.ExecSQL;
    //- Apply auto id generator to projects table
    qry.SQL.Clear;
    qry.SQL.Add(' CREATE TRIGGER "AUTOINC_P" FOR "PROJECTS" ');
    qry.SQL.Add(' ACTIVE BEFORE INSERT POSITION 0 ');
    qry.SQL.Add(' AS ');
    qry.SQL.Add(' begin ');
    qry.SQL.Add('  new."PROJ_ID" = gen_id(GENAUTOINC,1); ');
    qry.SQL.Add('end ');
    qry.SQL.Add(' ; ');
    qry.ExecSQL;
    //- Apply auto id generator to projects table
    qry.SQL.Clear;
    qry.SQL.Add(' CREATE TRIGGER "AUTOINC_E" FOR "LOG_ENTRIES" ');
    qry.SQL.Add(' ACTIVE BEFORE INSERT POSITION 0 ');
    qry.SQL.Add(' AS ');
    qry.SQL.Add(' begin ');
    qry.SQL.Add('  new."LOG_ID" = gen_id(GENAUTOINC,1); ');
    qry.SQL.Add('end ');
    qry.SQL.Add(' ; ');
    qry.ExecSQL;
    //- Create management role
    qry.SQL.Text := 'CREATE ROLE "MGMTROLE"; ';
    qry.ExecSQL;
    qry.SQL.Text := 'GRANT "MGMTROLE" TO MANAGER; ';
    qry.ExecSQL;
    //- Create staff role
    qry.SQL.Text := 'CREATE ROLE "STAFFROLE"; ';
    qry.ExecSQL;
    qry.SQL.Text := 'GRANT "STAFFROLE" TO STAFF; ';
    qry.ExecSQL;
  finally
    qry.DisposeOf;
  end;
end;

class function TDatabaseUtils.DataFilename: string;
begin
  Result := TPath.GetDocumentsPath + TPath.DirectorySeparatorChar + cDatafileName;
end;

end.
