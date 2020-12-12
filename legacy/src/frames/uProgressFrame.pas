//---------------------------------------------------------------------------

// This software is Copyright (c) 2018 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------
unit uProgressFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Objects, FMX.Controls.Presentation;

type
  TProgressFrame = class(TFrame)
    ProgressCircle: TCircle;
    ProgressArc: TArc;
    CenterCircle: TCircle;
    ProgFloatAnimation: TFloatAnimation;
    BackgroundRectangle: TRectangle;
    DelayTimer: TTimer;
    Label1: TLabel;
    procedure DelayTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowActivity;
    procedure HideActivity;
  end;

implementation

{$R *.fmx}

uses
  formMain;

procedure TProgressFrame.ShowActivity;
begin
  DelayTimer.Enabled := True;
end;

procedure TProgressFrame.DelayTimerTimer(Sender: TObject);
begin
  Self.Visible := True;
  Self.BringToFront;
  //ProgFloatAnimation.Enabled := True;
  DelayTimer.Enabled := False;
end;

procedure TProgressFrame.HideActivity;
begin
  //ProgFloatAnimation.Enabled := False;
  Self.Visible := False;
  DelayTimer.Enabled := False;
end;

end.
