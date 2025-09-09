program NewNNet;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  FrameBPNNet in 'FrameBPNNet.pas' {Frame1: TFrame},
  NNet in 'NNet.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
