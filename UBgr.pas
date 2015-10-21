unit UBgr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtDlgs, ExtCtrls;

type
  TForm7 = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation
uses UPaint, UWndDraw;
{$R *.DFM}
procedure TForm7.FormActivate(Sender: TObject);
begin
  if BmpBk then
    RadioButton2.Checked:=true
  else
    RadioButton1.Checked:=true;
  Shape1.Brush.Color:=FillGrColor;
  OpenPictureDialog1.FileName:=grPathName;
  Edit1.Text:=IntToStr(Bkgr.Width);
  Edit2.Text:=IntToStr(Bkgr.Height);
end;

procedure TForm7.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm7.BitBtn2Click(Sender: TObject);
var w,h,t,l: Integer;
begin
  FillGrColor:=Shape1.Brush.Color;
  grPathName:=OpenPictureDialog1.FileName;
  if bmpbk<>RadioButton2.Checked then
  begin
    bmpbk:=RadioButton2.Checked;
    posln.HideOk:=False;
  end;
  l:=Form4.Image1.Left; t:=Form4.Image1.Top;
  //w:=430; h:=320;
  if bmpbk then
    with Form4.Image1 do
    begin
      Picture.LoadFromFile(grPathName);
      w:=Picture.Width; h:=Picture.Height;
      Width:=w; Height:=h;
      Edit1.Text:=IntToStr(w);
      Edit2.Text:=IntToStr(h);
      RectGr:=Rect(l,t,l+w,t+h);
    end
  else
  begin
    w:=StrToInt(Edit1.Text);
    if w<1 then w:=430;
    h:=StrToInt(Edit2.Text);
    if h<1 then h:=320;
    RectGr:=Rect(l,t,l+w,t+h);
    with Form4.Image1 do
    begin
      width:=w; height:=h;
      picture.bitmap.Width:=w;
      picture.bitmap.Height:=h;
      Canvas.Brush.Color:=FillGrColor;
      Canvas.FillRect(RectGr);
    end;
  end;
  BkGr.Graphic.Width:=w;
  BkGr.Graphic.Height:=h;

  //BkGr.Bitmap.Canvas.CopyRect(RectGr,Form4.Image1.Canvas,RectGr);
  BkGr.Bitmap.Canvas.CopyRect(RectGr,Form4.Image1.Picture.Bitmap.Canvas,RectGr);
  //BkGr.Bitmap:=Form4.Image1.Picture.Bitmap;

  Form4.ClientWidth:=w; Form4.ClientHeight:=h;
  posln.HideOk:=False;
end;

procedure TForm7.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
  begin
    Shape1.Brush.Color:=ColorDialog1.Color;
    RadioButton1.Checked:=true;
  end;
end;

procedure TForm7.BitBtn1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    grPathName:=OpenPictureDialog1.FileName;
    RadioButton2.Checked:=true;
  end;
end;

procedure TForm7.RadioButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Edit1.Enabled:=True; Edit2.Enabled:=True;
end;


procedure TForm7.RadioButton2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Edit1.Enabled:=False; Edit2.Enabled:=False;
end;

end.
