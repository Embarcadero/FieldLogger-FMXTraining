//---------------------------------------------------------------------------

// This software is Copyright (c) 2018 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit uLoginFrame2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects;

type
  TLoginFrame2 = class(TFrame)
    VertScrollBox1: TVertScrollBox;
    HeaderLayout: TLayout;
    FormLayout: TLayout;
    UsernameEdit: TEdit;
    PasswordEdit: TEdit;
    SignUpLayout: TLayout;
    SignupTextBTN: TText;
    SignInBackgroundRect: TRectangle;
    SignInRectBTN: TRectangle;
    SignInText: TText;
    LockImage: TImage;
    UserImage: TImage;
    CenterLayout: TLayout;
    LogoImage: TImage;
    BackgroundImage: TImage;
    BackgroundGaussianBlurEffect: TGaussianBlurEffect;
    LogoCircle: TCircle;
    FormSpacerLayout: TLayout;
    Layout1: TLayout;
    WelcomeLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uHomeFrame2, uHomeForm2;

end.
