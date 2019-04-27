unit fieldlogger.authentication;

interface

uses
  FireDAC.Comp.Client;

type
  TAuthentication = class
  public
    class function Authenticate(conn: TFDConnection; Username, Password: string ): boolean;
  end;

implementation

{ TAuthentication }

class function TAuthentication.Authenticate(conn: TFDConnection; Username, Password: string ): boolean;
begin
  Result := False;
  conn.Connected := False;
  conn.Params.Values['USER_NAME'] := Username;
  conn.Params.Values['Password'] := Password;
  try
    conn.Connected := True;
  finally
    Result := conn.Connected;
  end;
end;

end.
