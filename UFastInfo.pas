unit UFastInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ActnList, Menus;

type
  TForm8 = class(TForm)
    Image1: TImage;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure FastInfoUpd;

const
  Wpix: Integer=10; //can le cho report
  Hpix: Integer=10;

var
  Form8: TForm8;

implementation

uses UPaint, UWndDraw;
{$R *.DFM}

var h1: integer;

procedure FastInfoUpd;
var
  i,j: Byte; X,Y,l,w1,w2,w3: Integer;
  s: array [1..256] of String;
  s1: string;
//w1: content's;  w2: param's width;  X,Y is size of canvas
begin
  w1:=0; w2:=0; w3:=0;
  for i:=1 to AmountOfGr do
  begin
    //quy chuan xau content:
    s1:=Gr[i].content;
    //doi dau tru mot ngoi ve dau tru binh thuong
    for j:=1 to length(s1) do
      if s1[j]='—' then s1[j]:='-'; //doi dau tru mot ngoi ve dau tru binh thuong
    if Gr[i].kind=pXY then s1:=concat('y=',s1) else s1:=concat('x=',s1);
    s[i]:=s1;
    //tim xau phuong trinh dai nhat
    l:=Form8.Image1.Canvas.TextWidth(s[i]);
    if l>w1 then w1:=l;
    //tim xau tham so dai nhat (w2)
    if Gr[i].countm>0 then
    begin
      Str(Gr[i].m:0:3,s1);
      l:=Form8.Image1.Canvas.TextWidth(s1);
      if l>w2 then w2:=l;
    end;
    //tim xau ten dai nhat (w3)
    l:=Form8.Image1.Canvas.TextWidth(Gr[i].name);
    if l>w3 then w3:=l;
  end;

  //Calc size
  X:=Wpix+h1+5+w1+20+w2+20+w3+Wpix; //h1 is width of color rect
  Y:=Hpix+(h1+3)*AmountOfGr+Hpix;

  //Clear old info
  with Form8.Image1 do
  begin
    Width:=X; Height:=Y;
    Picture.Graphic.Width:=X;
    Picture.Graphic.Height:=Y;
    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(bounds(0,0,X,Y));
  end;

  Form8.ClientHeight:=Y;
  Form8.ClientWidth:=X;

  with Form8.Image1.Canvas do
  begin
    //Color rect
    X:=Wpix; Y:=Hpix;
    for i:=1 to AmountOfGr do
    begin
      Brush.Color:=Gr[i].Color;
      {FillRect(rect(X,Y,X+h1,Y+h1));}
      Pen.Color:=clBlack;
      RoundRect(X,Y,X+h1,Y+h1,10,10);
      inc(Y,h1+3);
    end;
    Brush.Color:=clWhite;
    //content
    inc(X,h1+5); Y:=Hpix;
    for i:=1 to AmountOfGr do
    begin
      TextOut(X,Y,s[i]);
      inc(Y,h1+3);
    end;
    //param m
    inc(X,w1+20); Y:=Hpix;
    for i:=1 to AmountOfGr do
    begin
      if Gr[i].Countm>0 then
        begin Str(Gr[i].m:0:3,s1); TextOut(X,Y,s1); end;
      inc(Y,h1+3);
    end;
    //Name
    inc(X,w2+20); Y:=Hpix;
    for i:=1 to AmountOfGr do
    begin
      TextOut(X,Y,Gr[i].name);
      inc(Y,h1+3);
    end;
  end;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  with Image1.Canvas.Font do
  begin
    Name:='MS Sans Serif';
    Size:=12;
    Color:=clBlack;
  end;
  h1:=Image1.Canvas.TextHeight('H');
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  FastInfoUpd;
end;

procedure TForm8.FormActivate(Sender: TObject);
begin
  Form4.Show;
end;

//Kiem tra diem x,y co nam trong hinh chu nhat khong? 
function inside(x,y: Integer; r: TRect): Boolean;
begin
  if (x>=r.Left)and(x<=r.Right)and
     (y>=r.Top)and(y<=r.Bottom)
  then
    inside:=true
  else
    inside:=false;
end;

procedure TForm8.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var r: TRect; i,j: Integer;
begin
  with r do
  begin
    Left:=Wpix;
    Top:=Hpix;
    Right:=Wpix+h1;
    Bottom:=Hpix+h1;
  end;
  for i:=1 to AmountOfGr do
  begin
    if inside(X,Y,r) then //if click mouse to color fields then show color dialog
      if ColorDialog1.Execute then
      begin
        Gr[i].Color:=ColorDialog1.Color;
        posln.Hide; posln.HideOk:=False;
        for j:=1 to AmountOfGr do
          Gr[j].Draw;
        DrawAxis;
        FastInfoUpd;
      end;
    inc(r.Top,h1+3);
    inc(r.Bottom,h1+3);
  end;
end;

end.
