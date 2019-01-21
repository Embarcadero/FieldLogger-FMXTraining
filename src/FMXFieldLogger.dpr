//---------------------------------------------------------------------------

// This software is Copyright (c) 2018 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

program FMXFieldLogger;

uses
  System.StartUpCopy,
  FMX.Forms,
  uHomeForm2 in 'uHomeForm2.pas' {Form2Home},
  uHomeFrame2 in 'uHomeFrame2.pas' {HomeFrame2: TFrame},
  uLoginFrame2 in 'uLoginFrame2.pas' {LoginFrame2: TFrame},
  uLoginForm2 in 'uLoginForm2.pas' {Form2Login},
  dmIBLite in 'dmIBLite.pas' {DataModule1: TDataModule},
  uProjectsTypes in 'uProjectsTypes.pas',
  uProjectsForm in 'uProjectsForm.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2Home, Form2Home);
  Application.CreateForm(TForm2Login, Form2Login);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
