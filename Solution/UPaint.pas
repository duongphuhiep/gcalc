unit UPaint;

interface
uses Classes, Graphics, Windows, Math, UCommon;

type
  TPixelGraphInfo=Record
    ok: Boolean; //Co ve diem nay hay khong?
    y: Integer; //Ve o vi tri nao
    y1,y2: Integer; //Ve tu dau toi dau de do thi lien net
  end;
  TDataOfGraph=array [-1..1024] of TPixelGraphInfo;
  TBackOfGraph=array [0..1023] of TColor;
  TKindOfGraph=(pXY,pYX);

type
  TGraph=object
  private
    OverClip: Boolean;
    PartCount: Integer; //So phan tu trong Expression
  public
    Expression: TPartArray; {bieu thuc viet theo nghich dao Balan cua pt can ve}
    kind: TKindOfGraph; {Kieu ve y=f(x) hay x=f(y)}
    X: ^TDataOfGraph; {mang chua ket qua tinh toan}
    Limit1,Limit2: Extended; {khoang ve}
    pix1,pix2: Integer; //Gioi han ve
    NoLimit: Boolean;
    Markx: array [1..1000] of Integer; //Vi tri cac bien so trong Expression
    Countx: Integer; //So cac bien xuat hien trong Expression
    Markm: array [1..1000] of Integer;
    Countm: Integer; //So tham so xuat hien trong Expression
    Order: byte;

    name,content: String; {ten va noi dung cua phuong trinh muon ve}
    Color: TColor;
    m,dm: Extended; {Buoc tang cua tham so m}
    err: string;
    //Visible: Boolean; {trang thai cua Graph}

    function F(var r: Extended): Boolean; //Tinh toan 1 phan tu theo Expression
    procedure Init; {Kiem tra xem co ve duoc khong, neu khong thi tra ve error}
    procedure Finish; {Giai phong memory}
    procedure Calculate; {Tinh toan mang X va Mark}
    procedure Draw; {Ve theo mang X theo Mark}
    procedure Hide; {An Graph di tam thoi}
  end;

{procedure ResetGr;}
procedure DrawAxis;
procedure HideAxis;

const
  INFINITY=2147483646;
  grPathName: String='Default.bmp';
  BmpBk: Boolean=False; //BackGround la Bitmap?

  ZX: Integer=20; OZX: Integer=20; //Zoom x and Old Zoom x
  ZY: Integer=20; OZY: Integer=20;
  DZXY: Integer=5;
  DZX: Integer=5;
  DZY: Integer=5;
  AxisColor: TColor=clBlack;
  RulerStep: Integer=1; //Vach thuoc
  ORulerStep: Integer=1; //Old Rule Step
  FillGrColor: TColor=clWhite;
  XORG: Integer=215; YORG: Integer=160;
  DORG: Integer=10;

var
  AColor: array [1..255] of TColor;
  Gr: array [1..255] of TGraph;
  AmountOfGr: Byte; //So luong cac do thi se ve
  AxisX,AxisY: Integer; //Toa do ORG truoc khi dich chuyen

  RectGr: TRect; //Ve do thi trong gioi han khung ve nay
  Bkgr: TPicture;

implementation

uses UWndDraw;

procedure DrawAxis;
var xStep,yStep,t,max,min: Integer;
begin
  with Form4.Image1.Canvas do
  begin
    Pen.Color:=AxisColor;

    Penpos:=(Point(XORG,0));
    LineTo(XORG,RectGr.Bottom);

    Penpos:=(Point(0,YORG));
    LineTo(RectGr.Right,YORG);

    //Draw rule
    ORulerStep:=RulerStep;
    if RulerStep>0 then
    begin
      xStep:=RulerStep*ZX;
      max:=RectGr.Right; min:=RectGr.Left;
      t:=XORG;
      while t<max do
        begin inc(t,xStep); Pixels[t,YORG-1]:=AxisColor; Pixels[t,YORG+1]:=AxisColor; end;
      t:=XORG;
      while t>min do
        begin dec(t,xStep); Pixels[t,YORG-1]:=AxisColor; Pixels[t,YORG+1]:=AxisColor; end;
      yStep:=RulerStep*ZY;
      max:=RectGr.Bottom; min:=RectGr.Top;
      t:=YORG;
      while t<max do
        begin inc(t,yStep); Pixels[XORG-1,t]:=AxisColor; Pixels[XORG+1,t]:=AxisColor; end;
      t:=YORG;
      while t>min do
        begin dec(t,yStep); Pixels[XORG-1,t]:=AxisColor; Pixels[XORG+1,t]:=AxisColor; end;
    end;
  end;
  AxisX:=YORG; AxisY:=XORG;
  OZX:=ZX; OZY:=ZY;
end;

procedure HideAxis;
var i,xStep,yStep,t,max,min: Integer;
begin
    with Form4 do
    begin
      for i:=0 to RectGr.Bottom do
        Image1.Canvas.Pixels[AxisY,i]:=BkGr.Bitmap.Canvas.Pixels[AxisY,i];
      for i:=0 to RectGr.Right do
        Image1.Canvas.Pixels[i,AxisX]:=BkGr.Bitmap.Canvas.Pixels[i,AxisX];
    //Hide rule
    if RulerStep>0 then
    begin
      xStep:=ORulerStep*OZX;
      max:=RectGr.Right; min:=RectGr.Left;
      t:=AxisY;
      while t<max do
        begin
          inc(t,xStep);
          Image1.Canvas.Pixels[t,AxisX-1]:=BkGr.Bitmap.Canvas.Pixels[t,AxisX-1];
          Image1.Canvas.Pixels[t,AxisX+1]:=BkGr.Bitmap.Canvas.Pixels[t,AxisX+1];
        end;
      t:=AxisY;
      while t>min do
        begin
          dec(t,xStep);
          Image1.Canvas.Pixels[t,AxisX-1]:=BkGr.Bitmap.Canvas.Pixels[t,AxisX-1];
          Image1.Canvas.Pixels[t,AxisX+1]:=BkGr.Bitmap.Canvas.Pixels[t,AxisX+1];
        end;
      yStep:=ORulerStep*OZY;
      max:=RectGr.Bottom; min:=RectGr.Top;
      t:=AxisX;
      while t<max do
        begin
          inc(t,yStep);
          Image1.Canvas.Pixels[AxisY-1,t]:=BkGr.Bitmap.Canvas.Pixels[AxisY-1,t];
          Image1.Canvas.Pixels[AxisY+1,t]:=BkGr.Bitmap.Canvas.Pixels[AxisY+1,t];
        end;
      t:=AxisX;
      while t>min do
        begin
          dec(t,yStep);
          Image1.Canvas.Pixels[AxisY-1,t]:=BkGr.Bitmap.Canvas.Pixels[AxisY-1,t];
          Image1.Canvas.Pixels[AxisY+1,t]:=BkGr.Bitmap.Canvas.Pixels[AxisY+1,t];
        end;
    end;
    end;
end;

{procedure ResetGr;
begin
  ZX:=20;
  ZY:=20;
  DZXY:=5;
  DZX:=5;
  DZY:=5;
  AxisColor:=clBlack;
  with Form4.Image1 do
  begin
    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(Rect(Left,Top,Left+Width-1,Top+Height-1));
  end;
  with Form4.Image1 do
  begin
    XORG:=Left+Width shr 1;
    YORG:=Top+Height shr 1;
    RectGr:=Rect(Left,Top,Left+Width-1,Top+Height-1);
  end;
end;}

procedure TGraph.Init;
var i: Integer;
begin
  dangve:=true; Analyse(Content,False);
  if errmsg<>'' then err:=errmsg
  else
    NormalCalc;
  if not grok then
    if errmsg<>'' then err:=errmsg
    else err:=grerr
  else
    err:='';
  if err='' then
  begin
    Expression:=suffix;
    PartCount:=sufcount;
    //Dem va tim vi tri tat ca cac bien so trong Expression
    Countx:=0;
    for i:=1 to sufcount do
      if suffix[i].kind=kVar then
        begin inc(Countx); Markx[Countx]:=i; end;
    //Dem va tim vi tri tat ca cac bien so trong Expression
    Countm:=0;
    for i:=1 to sufcount do
      if suffix[i].kind=kParam then
        begin inc(Countm); Markm[Countm]:=i; end;
    if X=nil then
      GetMem(X,SizeOf(TDataOfGraph));
  end;
  dangve:=false;
end;

procedure TGraph.Finish;
begin
  if X<>nil then
    begin FreeMem(X,SizeOf(TDataOfGraph)); X:=nil; end;
end;

procedure TGraph.Hide;
var xv,yv: Integer;
begin
  {if Visible then
  begin
    Visible:=False; vis}
    if kind=pXY then
      for xv:=pix1 to pix2 do
        with Form4 do
        begin
          if X^[xv].ok then
            for yv:=X^[xv].y1 to X^[xv].y2 do
              Image1.Canvas.Pixels[xv,yv]:=BkGr.Bitmap.Canvas.Pixels[xv,yv];
        end
    else
      for yv:=pix1 to pix2 do
        with Form4 do
        begin
          if X^[yv].ok then
            for xv:=X^[yv].y1 to X^[yv].y2 do
              Image1.Canvas.Pixels[xv,yv]:=BkGr.Bitmap.Canvas.Pixels[xv,yv];
        end;
  {end; vis}
  HideAxis; DrawAxis;
  {with Form4 do
    Image2.Canvas.CopyRect(RectGr,Image1.Canvas,RectGr);}
  {  BitBlt(Form4.Image2.Canvas.Handle,
    0,0,640,480,
    Form4.Image1.Canvas.Handle,
    0,0,SRCCOPY);}
end;

procedure TGraph.Draw;
var xv,yv: Integer;
begin
  if OverClip {or Visible vis} then exit;
  {Visible:=true; vis}
  if kind=pXY then
    for xv:=pix1 to pix2 do
      with Form4.Image1 do
      begin
        if X^[xv].ok then
          for yv:=X^[xv].y1 to X^[xv].y2 do
            Canvas.Pixels[xv,yv]:=Color;
      end
  else
    for yv:=pix1 to pix2 do
      with Form4.Image1 do
      begin
        if X^[yv].ok then
          for xv:=X^[yv].y1 to X^[yv].y2 do
            Canvas.Pixels[xv,yv]:=Color;
      end;
  {with Form4 do
    Image2.Canvas.CopyRect(RectGr,Image1.Canvas,RectGr);
    
  {Form4.Image1.Visible:=true;}
  {with Form4 do
    BitBlt(Image2.Canvas.Handle,
      0,0,Image1.Width,Image1.Height,
      Image1.Canvas.Handle,
      0,0,SRCCOPY);}
end;

procedure TGraph.Calculate;
var
  i,xv,xvmax,xvmin,xLim1,xLim2,xRec1,xRec2,ky1,ky2: Integer;
  ytmax,ytmin,yt,xt: Extended;
  {over: array [0..1024] of byte;}
begin
    //Tham so
    for i:=1 to countm do Expression[markm[i]].num:=m;
    {FillChar(over,SizeOf(Over),0);}
    //tim gioi han ve tu pixel xvmin->pixel xvmax
    if kind=pXY then
    begin
      xRec1:=RectGr.Left; xRec2:=RectGr.Right;
    end
    else
    begin
      xRec1:=RectGr.Top; xRec2:=RectGr.Bottom;
    end;
    if NoLimit then
      begin xvmin:=xRec1; xvmax:=xRec2; end
    else
    begin
      if kind=pXY then
      begin
        xLim1:=trunc(Limit1*ZX+XORG);
        xLim2:=trunc(Limit2*ZX+XORG);
      end
      else
      begin
        xLim1:=trunc(Limit1*ZY+YORG);
        xLim2:=trunc(Limit2*ZY+YORG);
      end;
      if (xLim1>xRec2)or(xLim2<xRec1) then
        begin overClip:=true; Exit; end
      else OverClip:=False;
      if (xLim1<xRec1) then xvmin:=xRec1 else xvmin:=xLim1;
      if (xLim2>xRec2) then xvmax:=xRec2 else xvmax:=xLim2;
    end;

    pix1:=xvmin; pix2:=xvmax;
    //gioi han gia tri cua ham so
    if kind=pXY then
    begin
      ytmin:=(YORG-RectGr.Bottom)/ZY;
      ytmax:=(YORG-RectGr.Top)/ZY;
    end
    else
    begin
      ytmin:=(RectGr.Left-XORG)/ZX;
      ytmax:=(RectGr.Right-XORG)/ZX;
    end;

    //tinh toa do cac diem ve se ve do thi theo (xv,X^[xv].y) neu X^[xv].ok=true
    if kind=pXY then
      for xv:=xvmin to xvmax do
      begin
        xt:=(xv-XORG)/ZX;
        //thay cac bien x trong bieu thuc thanh xt
        for i:=1 to Countx do
          Expression[Markx[i]].num:=xt;
        //Tinh lai gia tri bieu thuc, neu tinh duoc
        if F(yt) and (yt>ytmin)and(yt<ytmax) then
          {if (yt<ytmin) then
            begin over[xv]:=1; X^[xv].ok:=False; end
          else
          if (yt>ytmax) then
            begin over[xv]:=2; X^[xv].ok:=False; end
          else}
          begin
            X^[xv].y:=trunc(YORG-yt*ZY);
            X^[xv].ok:=true;
          end
        else
          {begin
            over[xv]:=0;}
            X^[xv].ok:=False;
          {end;}
      end
    else
    for xv:=xvmin to xvmax do
      begin
        xt:=(YORG-xv)/ZY;
        //thay cac bien x trong bieu thuc thanh xt
        for i:=1 to Countx do
          Expression[Markx[i]].num:=xt;
        //Tinh lai gia tri bieu thuc, neu tinh duoc
        if F(yt) and (yt>ytmin)and(yt<ytmax) then
        begin
          X^[xv].y:=trunc(yt*ZX+XORG);
          X^[xv].ok:=true;
        end
        else
          X^[xv].ok:=False;
      end;

    //dieu kien bien cua do thi
    X[xvmin-1].ok:=False;
    X[xvmax+1].ok:=False;
    //noi cac diem tren thanh duong lien net
    for xv:=xvmin to xvmax do
      if X^[xv].ok then
      begin
        if X^[xv-1].ok then
          ky1:=X^[xv].y-(X^[xv].y-X^[xv-1].y) div 2
        else
        {case over[xv] of
          0:} ky1:=X^[xv].y;
          {1: if kind=pXY then ky1:=RectGr.Top else ky1:=RectGr.Left;
          2: if kind=pXY then ky1:=RectGr.Bottom else ky1:=RectGr.Right;
        end;}

        if X^[xv+1].ok then
          ky2:=X^[xv].y+(X^[xv+1].y-X^[xv].y) div 2
        else
        {case over[xv] of
          0:} ky2:=X^[xv].y;
          {1: if kind=pXY then ky2:=RectGr.Top else ky2:=RectGr.Left;
          2: if kind=pXY then ky2:=RectGr.Bottom else ky2:=RectGr.Right;
        end;}

        //Hoan vi de X^[xv].y1<X^[xv].y2
        if ky1<ky2 then
          begin X^[xv].y1:=ky1; X^[xv].y2:=ky2; end
        else
          begin X^[xv].y1:=ky2; X^[xv].y2:=ky1; end
      end;
end;

function TGraph.F(var r: Extended): Boolean;
var
  i,sp: Integer;
  stack: array [0..1000] of Extended;
  toantu: string;
  p1,p2,p3,tmp1: Extended;
begin
  i:=0; sp:=0; F:=True; p3:=0;
  while i<PartCount do
  begin
    inc(i);
    if (Expression[i].kind<>kOpr) then
      begin inc(sp); stack[sp]:=Expression[i].num; end
    else
    begin
      toantu:=opr[Expression[i].AOpr].name;

      if toantu='+' then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp]; p3:=p2+p1;
      end
      else

      if toantu='-' then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp]; p3:=p2-p1;
      end
      else

      if toantu='*' then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp]; p3:=p2*p1;
      end
      else

      if toantu='/' then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p1=0 then
        begin
          F:=False;
          if p2<0 then p3:=-INFINITY
          else
          if p2>0 then p3:=INFINITY
        end  
        else
          p3:=p2/p1;
      end
      else

      if toantu='abs' then p3:=abs(stack[sp])
      else

      if toantu='^' then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p2<0 then
          if odd(trunc(p1)) then
            p3:=-exp(p1*ln(-p2))
          else
            p3:=exp(p1*ln(-p2))
        else
        if p2=0 then p3:=0
        else p3:=exp(p1*ln(p2));
      end
      else

      if (toantu='below') then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p1<p2 then p3:=p1 else p3:=p2;
      end
      else

      if (toantu='above') then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p1>p2 then p3:=p1 else p3:=p2;
      end
      else

      if (toantu='div') then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p1=0 then begin F:=False; exit; end; p3:=round(p2) div round(p1);
      end
      else

      if (toantu='mod') then
      begin
        p1:=stack[sp]; dec(sp); p2:=stack[sp];
        if p1=0 then begin F:=False; exit; end;
        p3:=round(p2) mod round(p1);
      end
      else

      if (toantu='—') then p3:=-stack[sp]
      else

      if (toantu='exp') then p3:=exp(stack[sp])
      else

      if (toantu='ln') then
        begin p1:=stack[sp]; if p1<=0 then F:=False else p3:=ln(p1); end
      else

      if (toantu='log') then
        begin
          p1:=stack[sp]; if p1<=0 then F:=False
          else
            p3:=ln(p1)/ln10val;
        end
      else

      if (toantu='lg') then
        begin
          p1:=stack[sp]; dec(sp); p2:=stack[sp];
          if (p1>0)and(p2>0)and(p2<>1) then
            p3:=ln(p1)/ln(p2)
          else F:=False
        end
      else

      if (toantu='sin') then p3:=sin(stack[sp])
      else

      if (toantu='cos') then p3:=cos(stack[sp])
      else

      if (toantu='tg') then
      begin
        p1:=stack[sp]; tmp1:=cos(p1);
        if tmp1=0 then F:=false else p3:=sin(p1)/tmp1;
      end
      else

      if (toantu='cotg') then
      begin
        p1:=stack[sp]; tmp1:=sin(p1);
        if tmp1=0 then F:=false else p3:=cos(p1)/tmp1;
      end
      else

      if (toantu='arcsin') then
      begin
        p1:=stack[sp];
        if (p1<-1)or(p1>1) then F:=false
        else
          p3:=arcsin(p1)
      end
      else

      if (toantu='arccos') then
      begin
        p1:=stack[sp];
        if (p1<-1)or(p1>1) then F:=false
        else
          p3:=arccos(p1);
      end
      else

      if (toantu='arctg') then p3:=arctan(stack[sp])
      else

      if (toantu='arccotg') then p3:=arccot(stack[sp])
      else

      if (toantu='sqrt') then
      begin
        p1:=stack[sp];
        if p1<0 then F:=false else p3:=sqrt(p1);
      end
      else

      if (toantu='sqr') then p3:=sqr(stack[sp])
      else

      if (toantu='round') then p3:=round(stack[sp])
      else

      if (toantu='trunc')or(toantu='floor') then p3:=trunc(stack[sp])
      else

      if (toantu='ceiling') then p3:=trunc(stack[sp])+1
      else

      if (toantu='dtor') then p3:=stack[sp]*pi/180
      else

      if (toantu='rtod') then p3:=stack[sp]*180/pi
      else

      if (toantu='sinh') then p3:=sinh(stack[sp])
      else

      if (toantu='cosh') then p3:=cosh(stack[sp])
      else

      if (toantu='tgh') then p3:=tanh(stack[sp])
      else

      if (toantu='cotgh') then
        if stack[sp]<>0 then p3:=coth(stack[sp]) else F:=false
      else

      if (toantu='arcsinh') then p3:=arcsinh(stack[sp])
      else

      if (toantu='arccosh') then
      begin
        p1:=stack[sp];
        if p1>1 then p3:=arccosh(p1) else F:=false;
      end
      else

      if (toantu='arctgh') then
      begin
        p1:=stack[sp];
        if (p1>=-1)and(p1<=1) then p3:=arctanh(p1) else F:=false;
      end
      else

      if (toantu='arccotgh') then
      begin
        p1:=stack[sp];
        if (p1<=-1)or(p1>=1) then p3:=arccoth(p1) else F:=false;
      end
      else

      if (toantu='dtog') then p3:=DegtoGrad(stack[sp])
      else

      if (toantu='dtoc') then p3:=DegtoCycle(stack[sp])
      else

      if (toantu='rtog') then p3:=RadtoGrad(stack[sp])
      else

      if (toantu='rtoc') then p3:=RadtoCycle(stack[sp])
      else

      if (toantu='gtod') then p3:=GradtoDeg(stack[sp])
      else

      if (toantu='gtor') then p3:=GradtoRad(stack[sp])
      else

      if (toantu='gtoc') then p3:=GradtoCycle(stack[sp])
      else

      if (toantu='ctod') then p3:=CycletoDeg(stack[sp])
      else

      if (toantu='ctor') then p3:=CycletoRad(stack[sp])
      else

      if (toantu='ctog') then p3:=CycletoGrad(stack[sp])
      else
      ;

      stack[sp]:=p3;
    end;
  end;
  r:=stack[1]
end;

end.

