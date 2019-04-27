unit uframeSignIn;

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
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts;

type
  TframeSignIn = class(TFrame)
    VertScrollBox1: TVertScrollBox;
    SignUpLayout: TLayout;
    SignupTextBTN: TText;
    SignInBackgroundRect: TRectangle;
    FormLayout: TLayout;
    UsernameEdit: TEdit;
    UserImage: TImage;
    PasswordEdit: TEdit;
    LockImage: TImage;
    SignInRectBTN: TRectangle;
    SignInText: TText;
    FormSpacerLayout: TLayout;
    HeaderLayout: TLayout;
    CenterLayout: TLayout;
    LogoCircle: TCircle;
    Image2: TImage;
    Layout1: TLayout;
    WelcomeLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
