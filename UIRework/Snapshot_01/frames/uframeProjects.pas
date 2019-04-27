unit uframeProjects;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation,
  FMX.ListView,
  FMX.Objects,
  FMX.Layouts;

type
  TframeProjects = class(TFrame)
    VertScrollBox1: TVertScrollBox;
    Layout7: TLayout;
    Layout8: TLayout;
    Rectangle21: TRectangle;
    Circle1: TCircle;
    Image6: TImage;
    Rectangle24: TRectangle;
    listViewProjects: TListView;
    Label8: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
