unit index;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls,

  popup1,
  popup2,

  mypopup;

type
  TIndexView = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    FMyPopup: IMyPopup;
    FPopup1View: TPopup1View;
    FPopup2View: TPopup2View;

    procedure SaveDataPopup1(Sender: TObject);
    procedure SaveDataPopup2(Sender: TObject);
    procedure DisplaysAfterHiding(Sender: TObject);
  public
    { Public declarations }
  end;

var
  IndexView: TIndexView;

implementation

{$R *.fmx}

procedure TIndexView.FormCreate(Sender: TObject);
begin
  FMyPopup := TMyPopup.New;

  FPopup1View := TPopup1View.Create(nil);
  FPopup1View.SetMyPopup(FMyPopup);

  FPopup2View := TPopup2View.Create(nil);
  FPopup2View.SetMyPopup(FMyPopup);
end;

procedure TIndexView.FormDestroy(Sender: TObject);
begin
  if Assigned(FPopup1View) then
    FPopup1View.DisposeOf;
  if Assigned(FPopup2View) then
    FPopup2View.DisposeOf;
  FMyPopup.Hide(True);
end;

procedure TIndexView.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  ToolBar2.Margins.Bottom := Bounds.Height;
end;

procedure TIndexView.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  ToolBar2.Margins.Bottom := Bounds.Height;
  FMyPopup.Reposition;
end;

procedure TIndexView.SaveDataPopup1(Sender: TObject);
begin
  ShowMessage(FPopup1View.edtName.Text);
  FPopup1View.Clean;
end;

procedure TIndexView.SaveDataPopup2(Sender: TObject);
begin
  ShowMessage(FPopup2View.edtLastName.Text);
  FPopup2View.Clean;
end;

procedure TIndexView.DisplaysAfterHiding(Sender: TObject);
begin
  ShowMessage('After Hiding');
end;

procedure TIndexView.Button1Click(Sender: TObject);
begin
  FMyPopup
    .OnAfterShowing(FPopup1View.SetFocus)
    .OnApply(SaveDataPopup1)
    .OnAfterHiding(DisplaysAfterHiding)
    .Show(TControl(Sender), FPopup1View, TMyPopupOrientation.orBottomLeft);
end;

procedure TIndexView.Button2Click(Sender: TObject);
begin
  FMyPopup
    .OnAfterShowing(FPopup1View.SetFocus)
    .OnApply(SaveDataPopup1)
    .OnAfterHiding(DisplaysAfterHiding)
    .Show(TControl(Sender), FPopup1View, TMyPopupOrientation.orBottomRight);
end;

procedure TIndexView.Button3Click(Sender: TObject);
begin
  FMyPopup
    .OnAfterShowing(FPopup2View.SetFocus)
    .OnApply(SaveDataPopup2)
    .OnAfterHiding(DisplaysAfterHiding)
    .Show(TControl(Sender), FPopup2View, TMyPopupOrientation.orTopLeft);
end;

procedure TIndexView.Button4Click(Sender: TObject);
begin
  FMyPopup
    .OnAfterShowing(FPopup2View.SetFocus)
    .OnApply(SaveDataPopup2)
    .OnAfterHiding(DisplaysAfterHiding)
    .Show(TControl(Sender), FPopup2View, TMyPopupOrientation.orTopRight);
end;

end.
