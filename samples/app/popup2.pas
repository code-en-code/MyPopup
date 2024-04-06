unit popup2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Effects,
  FMX.ListBox,

  mypopup;

type
  TPopup2View = class(TFrame)
    btnCancel: TButton;
    btnApply: TButton;
    recBg: TRectangle;
    sdwBg: TShadowEffect;
    ToolBar1: TToolBar;
    ListBox1: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem5: TListBoxItem;
    lblLastName: TLabel;
    edtLastName: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
    FMyPopup: IMyPopup;
  public
    { Public declarations }
    procedure SetMyPopup(APopup: IMyPopup);
    procedure SetFocus(Sender: TObject);
    procedure Clean;
  end;

implementation

{$R *.fmx}

{ TPopup2View }

procedure TPopup2View.SetMyPopup(APopup: IMyPopup);
begin
  FMyPopup := APopup;
end;

procedure TPopup2View.SetFocus(Sender: TObject);
begin
  edtLastName.SetFocus;
end;

procedure TPopup2View.Clean;
begin
  edtLastName.Text := '';
end;

procedure TPopup2View.btnCancelClick(Sender: TObject);
begin
  if Assigned(FMyPopup) then
    FMyPopup.Hide;
end;

procedure TPopup2View.btnApplyClick(Sender: TObject);
begin
  if not edtLastName.Text.IsEmpty then
  begin
    if Assigned(FMyPopup) then
      FMyPopup.Apply;
  end
  else
  begin
    if Assigned(FMyPopup) then
      FMyPopup.Hide;
  end;
end;

end.
