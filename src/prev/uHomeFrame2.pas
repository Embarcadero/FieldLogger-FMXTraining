//---------------------------------------------------------------------------

// This software is Copyright (c) 2018 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit uHomeFrame2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.MultiView,
  FMX.Effects, FMX.Filter.Effects;

type
  THomeFrame2 = class(TFrame)
    HeaderToolBar: TToolBar;
    MenuButton: TButton;
    BackgroundRect: TRectangle;
    MenuGridPanelLayout: TGridPanelLayout;
    LogoImage: TImage;
    LearnLayout: TLayout;
    SupportLayout: TLayout;
    AdvocateLayout: TLayout;
    EventsLayout: TLayout;
    LoginBackgroundRect: TRectangle;
    LearnCenterLayout: TLayout;
    LearnImage: TImage;
    LoginLabel: TLabel;
    LearnCircle: TCircle;
    SupportBackgroundRect: TRectangle;
    AdvocateBackgroundRect: TRectangle;
    EventsBackgroundRect: TRectangle;
    SupportCenterLayout: TLayout;
    SupportImage: TImage;
    SupportLabel: TLabel;
    SupportCircle: TCircle;
    AdvocateCenterLayout: TLayout;
    AdvocateImage: TImage;
    AdvocateLabel: TLabel;
    AdvocateCircle: TCircle;
    EventsCenterLayout: TLayout;
    EventsImage: TImage;
    EventsLabel: TLabel;
    EventsCircle: TCircle;
    HeaderBackgroundRect: TRectangle;
    DrawerMultiView: TMultiView;
    MenuLayout: TLayout;
    DrawerBackgroundRect: TRectangle;
    TopImage: TImage;
    BackgroundImage: TImage;
    BackgroundGaussianBlurEffect: TGaussianBlurEffect;
    HeaderLabel: TLabel;
    LogoLayout: TLayout;
    procedure MenuLayoutResized(Sender: TObject);
    procedure LoginBackgroundRectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uLoginForm2, uLoginFrame2, uHomeForm2, dmIBLite;


procedure THomeFrame2.LoginBackgroundRectClick(Sender: TObject);
begin
   uHomeForm2.Form2Home.Hide;
   uLoginForm2.Form2Login.Show;
end;

procedure THomeFrame2.MenuLayoutResized(Sender: TObject);
begin
  DrawerMultiView.Width := MenuLayout.Width-(MenuLayout.Width/6);
end;

end.
