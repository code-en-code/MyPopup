unit mypopup;

interface

uses
  //delphi
  System.Classes,
  System.SysUtils,
  System.Types,

  //fmx
  FMX.Layouts,
  FMX.Types,
  FMX.Objects,
  FMX.Graphics,
  FMX.Forms,
  FMX.Controls,
  FMX.Platform,
  FMX.VirtualKeyboard,
  FMX.Ani;

type
  IMyPopup = interface;

  TMyPopupOrientation = (orBottomLeft, orBottomRight, orTopLeft, orTopRight);

  IMyPopup = interface
    ['{A4F1B1B4-C66E-4A95-BB57-5675AFBED71E}']
    function Show(const ASender: TControl; const AContents: TFrame; const AOrientation: TMyPopupOrientation): IMyPopup;
    function Hide(const ADestroy: Boolean = False): IMyPopup;
    function Apply(const AHide: Boolean = True): IMyPopup;
    function Reposition: IMyPopup;
    function OnAfterShowing(const ANotifyEvent: TNotifyEvent): IMyPopup;
    function OnAfterHiding(ANotifyEvent: TNotifyEvent): IMyPopup;
    function OnApply(const ANotifyEvent: TNotifyEvent): IMyPopup;
  end;

  TMyPopup = class(TInterfacedObject, IMyPopup)
  private
    { private declarations }
    FContainerIn: TFloatAnimation;
    FContainerOut: TFloatAnimation;
    FBody: TLayout;
    FGray: TRectangle;
    FContainer: TLayout;
    FContents: TFrame;
    FControl: TControl;
    FOrientation: TMyPopupOrientation;
    FOnAfterShowing: TNotifyEvent;
    FOnAfterHiding: TNotifyEvent;
    FOnApply: TNotifyEvent;

    procedure CreateInfra;
    procedure DestroyInfra;

    procedure CreateBody;
    procedure CreateGray;
    procedure CreateContainer;

    procedure OnClickGray(Sender: TObject);

    procedure ContainerIn;
    procedure ContainerOut;
    procedure OnFinishContainerOut(Sender: TObject);

    procedure EmbedBody;
    procedure EmbedContents(const AContents: TFrame);
    procedure SetValues(const ASender: TControl; const AOrientation: TMyPopupOrientation);
    procedure ContainerPosition(const ASender: TControl; const AContents: TFrame; const AOrientation: TMyPopupOrientation);
    procedure ContainerBounds(const ABounds: TRectF);
    procedure RemoveFocus;
    procedure HideKeyboard;
    procedure BringToFront;
    procedure RunAnimationsIn;
    procedure RunAnimationsOut;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    class function New: IMyPopup;

    function Show(const ASender: TControl; const AContents: TFrame; const AOrientation: TMyPopupOrientation): IMyPopup;
    function Hide(const ADestroy: Boolean = False): IMyPopup;
    function Apply(const AHide: Boolean = True): IMyPopup;
    function Reposition: IMyPopup;
    function OnAfterShowing(const ANotifyEvent: TNotifyEvent): IMyPopup;
    function OnAfterHiding(ANotifyEvent: TNotifyEvent): IMyPopup;
    function OnApply(const ANotifyEvent: TNotifyEvent): IMyPopup;
  end;

implementation

{ TMyPopup }

constructor TMyPopup.Create;
begin
  FBody := nil;
  FGray := nil;
  FContainer := nil;
  FContents := nil;
  FControl := nil;
  FOnAfterShowing := nil;
  FOnAfterHiding := nil;
  FOnApply := nil;
  CreateInfra;
end;

destructor TMyPopup.Destroy;
begin
  DestroyInfra;
  inherited;
end;

class function TMyPopup.New: IMyPopup;
begin
  Result := Self.Create;
end;

procedure TMyPopup.CreateInfra;
begin
  CreateBody;
  CreateGray;
  CreateContainer;
end;

procedure TMyPopup.DestroyInfra;
begin
  if Assigned(FContainer) then
    FreeAndNil(FContainer);
  if Assigned(FGray) then
    FreeAndNil(FGray);
  if Assigned(FBody) then
    FreeAndNil(FBody);
end;

procedure TMyPopup.CreateBody;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FBody := TLayout.Create(nil);
    FBody.BeginUpdate;
      FBody.Align := TAlignLayout.Contents;
      FBody.ClipChildren := False;
      FBody.HitTest := False;
      FBody.Opacity := 1;
      FBody.Parent := nil;
      FBody.TabStop := False;
      FBody.Visible := True;
    FBody.EndUpdate;
  end);
end;

procedure TMyPopup.CreateGray;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FGray := TRectangle.Create(FBody);
    FGray.BeginUpdate;
      FGray.Align := TAlignLayout.Contents;
      FGray.ClipChildren := False;
      FGray.Fill.Kind := TBrushKind.None;
      FGray.HitTest := True;
      FGray.Opacity := 1;
      FGray.Parent := FBody;
      FGray.Stroke.Kind := TBrushKind.None;
      FGray.TabStop := False;
      FGray.Visible := True;
      FGray.OnClick := OnClickGray;
    FGray.EndUpdate;
  end);
end;

procedure TMyPopup.CreateContainer;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FContainer := TLayout.Create(FGray);
    FContainer.BeginUpdate;
      FContainer.Align := TAlignLayout.None;
      FContainer.ClipChildren := False;
      FContainer.Height := 0;
      FContainer.HitTest := False;
      FContainer.Opacity := 0;
      FContainer.Parent := FGray;
      FContainer.TabStop := False;
      FContainer.Visible := True;
      FContainer.Width := 0;
    FContainer.EndUpdate;
  end);
end;

procedure TMyPopup.OnClickGray(Sender: TObject);
begin
  Hide;
end;

procedure TMyPopup.ContainerIn;
begin
  FContainerIn := TFloatAnimation.Create(FContainer);
  FContainerIn.AnimationType := TAnimationType.&In;
  FContainerIn.Delay := 0.1;
  FContainerIn.Duration := 0.2;
  FContainerIn.Interpolation := TInterpolationType.Linear;
  FContainerIn.Parent := FContainer;
  FContainerIn.PropertyName := 'Opacity';
  FContainerIn.StartValue := 0;
  FContainerIn.StopValue := 1;
  FContainerIn.Start;
end;

procedure TMyPopup.ContainerOut;
begin
  FContainerOut := TFloatAnimation.Create(FContainer);
  FContainerOut.AnimationType := TAnimationType.Out;
  FContainerOut.Delay := 0.1;
  FContainerOut.Duration := 0.2;
  FContainerOut.Interpolation := TInterpolationType.Linear;
  FContainerOut.Parent := FContainer;
  FContainerOut.PropertyName := 'Opacity';
  FContainerOut.StartValue := 1;
  FContainerOut.StopValue := 0;
  FContainerOut.OnFinish := OnFinishContainerOut;
  FContainerOut.Start;
end;

procedure TMyPopup.OnFinishContainerOut(Sender: TObject);
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FBody.BeginUpdate;
      FBody.Parent := nil;
    FBody.EndUpdate;

    FContents.BeginUpdate;
      FContents.Parent := nil;
    FContents.EndUpdate;
    FContents := nil;

    FControl := nil;

    if Assigned(FOnAfterHiding) then
      FOnAfterHiding(Self);

    FOnAfterShowing := nil;
    FOnAfterHiding := nil;
    FOnApply := nil;
  end);
end;

procedure TMyPopup.EmbedBody;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FBody.BeginUpdate;
      FBody.Parent := TFmxObject(Application.MainForm);
    FBody.EndUpdate;
  end);
end;

procedure TMyPopup.EmbedContents(const AContents: TFrame);
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FContents := AContents;
    FContents.BeginUpdate;
      FContents.Parent := FContainer;
    FContents.EndUpdate;
  end);
end;

procedure TMyPopup.SetValues(const ASender: TControl; const AOrientation: TMyPopupOrientation);
begin
  FControl := ASender;
  FOrientation := AOrientation;
end;

procedure TMyPopup.ContainerPosition(const ASender: TControl; const AContents: TFrame; const AOrientation: TMyPopupOrientation);
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    case AOrientation of
      orBottomLeft:
        begin
          FContainer.Position.X := ASender.AbsoluteRect.Location.X;
          FContainer.Position.Y := ASender.AbsoluteRect.Location.Y + ASender.Height;
        end;
      orBottomRight:
        begin
          FContainer.Position.X := (ASender.AbsoluteRect.Location.X - AContents.Width) + ASender.Width;
          FContainer.Position.Y := ASender.AbsoluteRect.Location.Y + ASender.Height;
        end;
      orTopLeft:
        begin
          FContainer.Position.X := ASender.AbsoluteRect.Location.X;
          FContainer.Position.Y := ASender.AbsoluteRect.Location.Y - AContents.Height;
        end;
      orTopRight:
        begin
          FContainer.Position.X := (ASender.AbsoluteRect.Location.X - AContents.Width) + ASender.Width;
          FContainer.Position.Y := ASender.AbsoluteRect.Location.Y - AContents.Height;
        end;
    end;
  end);
end;

procedure TMyPopup.ContainerBounds(const ABounds: TRectF);
const
  SHADOW_MARGIN = 20;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FContainer.Height := ABounds.Height + SHADOW_MARGIN;
    FContainer.Width := ABounds.Width + SHADOW_MARGIN;
  end);
end;

procedure TMyPopup.RemoveFocus;
begin
  if Assigned(Application.MainForm) then
    Application.MainForm.Focused := nil;
end;

procedure TMyPopup.HideKeyboard;
var
  LKeyboard: IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, LKeyboard) then
  begin
    if TVirtualKeyBoardState.Visible in LKeyboard.GetVirtualKeyBoardState then
      LKeyboard.HideVirtualKeyboard;
  end;
  LKeyboard := nil;
end;

procedure TMyPopup.BringToFront;
begin
  FBody.BringToFront;
  FGray.BringToFront;
  FContainer.BringToFront;
end;

procedure TMyPopup.RunAnimationsIn;
begin
  ContainerIn;
  if Assigned(FOnAfterShowing) then
    FOnAfterShowing(Self);
end;

procedure TMyPopup.RunAnimationsOut;
begin
  ContainerOut;
end;

function TMyPopup.Show(const ASender: TControl; const AContents: TFrame; const AOrientation: TMyPopupOrientation): IMyPopup;
begin
  Result := Self;
  if not Assigned(FBody) then
    CreateInfra;
  EmbedBody;
  EmbedContents(AContents);
  SetValues(ASender, AOrientation);
  ContainerPosition(ASender, AContents, AOrientation);
  ContainerBounds(AContents.BoundsRect);
  RemoveFocus;
  HideKeyboard;
  BringToFront;
  RunAnimationsIn;
end;

function TMyPopup.Reposition: IMyPopup;
begin
  ContainerPosition(FControl, FContents, FOrientation);
end;

function TMyPopup.Hide(const ADestroy: Boolean): IMyPopup;
begin
  Result := Self;
  if ADestroy then
  begin
    DestroyInfra;
    Exit;
  end;
  RemoveFocus;
  HideKeyboard;
  RunAnimationsOut;
end;

function TMyPopup.Apply(const AHide: Boolean): IMyPopup;
begin
  Result := Self;
  if AHide then
    Hide;
  if Assigned(FOnApply) then
    FOnApply(Self);
end;

function TMyPopup.OnAfterShowing(const ANotifyEvent: TNotifyEvent): IMyPopup;
begin
  Result := Self;
  FOnAfterShowing := ANotifyEvent;
end;

function TMyPopup.OnAfterHiding(ANotifyEvent: TNotifyEvent): IMyPopup;
begin
  Result := Self;
  FOnAfterHiding := ANotifyEvent;
end;

function TMyPopup.OnApply(const ANotifyEvent: TNotifyEvent): IMyPopup;
begin
  Result := Self;
  FOnApply := ANotifyEvent;
end;

end.
