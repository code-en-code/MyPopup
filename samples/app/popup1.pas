unit popup1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Effects,
  FMX.ListBox,

  mypopup;

type
  TPopup1View = class(TFrame)
    btnCancel: TButton;
    btnApply: TButton;
    recBg: TRectangle;
    sdwBg: TShadowEffect;
    ToolBar1: TToolBar;
    ListBox1: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem5: TListBoxItem;
    lblName: TLabel;
    edtName: TEdit;
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

{ TPopup1View }

procedure TPopup1View.SetMyPopup(APopup: IMyPopup);
begin
  FMyPopup := APopup;
end;

procedure TPopup1View.SetFocus(Sender: TObject);
begin
  edtName.SetFocus;
end;

procedure TPopup1View.Clean;
begin
  edtName.Text := '';
end;

procedure TPopup1View.btnCancelClick(Sender: TObject);
begin
  if Assigned(FMyPopup) then
    FMyPopup.Hide;
end;

procedure TPopup1View.btnApplyClick(Sender: TObject);
begin
  if not edtName.Text.IsEmpty then
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
