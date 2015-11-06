unit UOrg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TForm6 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Edit4: TEdit;
    Shape1: TShape;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses UPaint;
{$R *.DFM}

procedure TForm6.BitBtn2Click(Sender: TObject);
begin
  Close
end;

procedure TForm6.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
    Shape1.Brush.Color:=ColorDialog1.Color;
end;

procedure TForm6.FormActivate(Sender: TObject);
begin
  Shape1.Brush.Color:=AxisColor;
  Edit1.Text:=IntToStr(XORG);
  Edit2.Text:=IntToStr(YORG);
  Edit3.Text:=IntToStr(DORG);
  Edit4.Text:=IntToStr(RulerStep);
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
begin
  AxisColor:=Shape1.Brush.Color;
  XORG:=StrToInt(Edit1.Text);
  YORG:=StrToInt(Edit2.Text);
  DORG:=StrToInt(Edit3.Text);
  RulerStep:=StrToInt(Edit4.Text);
end;

end.
