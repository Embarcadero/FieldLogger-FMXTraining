// ---------------------------------------------------------------------------

// This software is Copyright (c) 2018 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

// ---------------------------------------------------------------------------

unit uLoginForm2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uLoginFrame2,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm2Login = class(TForm)
    CopperDarkStyleBook: TStyleBook;
    LoginFrame21: TLoginFrame2;
    labelLoggedInUser: TLabel;
    procedure LoginFrame21SignInRectBTNClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2Login: TForm2Login;

implementation

{$R *.fmx}

uses dmIBLite, uHomeFrame2,
  FireDAC.Stan.Consts, // used for Handling FireDAC Connection Errors
  FireDAC.Stan.Error,  // used for Handling FireDAC Connection Errors
  uProjectData, uCaptureDataForm, uHomeForm2, uProjectsForm, uProjectsTypes;

// Changes to the layout should be made inside of the TFrame itself. Once changes are made
// to the TFrame you can delete it from the TForm and re-add it. Set it's Align property to
// Client. Optionally, it's ClipChildren property can be set to True if there are any overlapping
// background images.

procedure TForm2Login.LoginFrame21SignInRectBTNClick(Sender: TObject);
begin
  LoginFrame21.SignInText.Text := 'Autenticating...';
  dmIBLite.dmMain.FDConnectionIBLite.Params.Values['USER_NAME'] :=
    LoginFrame21.UsernameEdit.Text;
  dmIBLite.dmMain.FDConnectionIBLite.Params.Values['Password'] :=
    LoginFrame21.PasswordEdit.Text;

  // see:   http://docwiki.embarcadero.com/RADStudio/Rio/en/Establishing_Connection_(FireDAC)
  try
    Begin
      dmIBLite.dmMain.FDConnectionIBLite.Connected := True;
      labelLoggedInUser.Text := LoginFrame21.UsernameEdit.Text + ' logged in';
      LoginFrame21.SignInText.Text := 'Connected!';
      uHomeForm2.Form2Home.Hide;
      uProjectsForm.frmProjectList.Show;
    End;
  Except
    on E: Exception do
    begin
      labelLoggedInUser.Text := LoginFrame21.UsernameEdit.Text +
        ' failed to log in';
      LoginFrame21.SignInText.Text := 'SIGN IN';
      ShowMessage('Invalid UserName/Password or Connection to IBLite database');
    end;

  end;
end;


end.
