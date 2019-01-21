unit uCameraForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media,
  FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    ToolBar1: TToolBar;
    Camera: TLabel;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    CameraComponent1: TCameraComponent;
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

end.
