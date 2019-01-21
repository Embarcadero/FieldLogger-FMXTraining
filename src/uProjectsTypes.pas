unit uProjectsTypes;

interface

uses
  System.Generics.Collections;

type
  TProject = record
    Proj_Id: integer;
    Proj_Title: string;
    Proj_Desc: string;
  end;

  TProjects = TList<TProject>;

  IProjectsData = interface
    function ProjectsCreate(aValue: TProject): integer;
    function ProjectsRead(id: integer; out aValue: TProject): boolean;
    function ProjectsUpdate(aValue: TProject): boolean;
    function ProjectsDelete(id: integer): boolean;
    procedure ProjectsList(aList: TProjects);
  end;

implementation

end.
