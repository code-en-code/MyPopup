program app;

uses
  System.StartUpCopy,
  FMX.Forms,
  index in 'index.pas' {IndexView},
  popup1 in 'popup1.pas' {Popup1View: TFrame},
  popup2 in 'popup2.pas' {Popup2View: TFrame},
  mypopup in '..\..\src\mypopup.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TIndexView, IndexView);
  Application.Run;
end.
