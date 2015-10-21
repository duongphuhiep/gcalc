unit UWndDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ExtDlgs;

type
  TForm4 = class(TForm)
    Image1: TImage;
    Labelx: TLabel;
    Labely: TLabel;
    PopupMenu1: TPopupMenu;
    BkgrOpt: TMenuItem;
    ZoomOpt: TMenuItem;
    OrgAxisOpt: TMenuItem;
    Hinndanhschtmtt1: TMenuItem;
    FastInfoTable: TMenuItem;
    ReturnMng: TMenuItem;
    Export: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BkgrOptClick(Sender: TObject);
    procedure ZoomOptClick(Sender: TObject);
    procedure OrgAxisOptClick(Sender: TObject);
    procedure FastInfoTableClick(Sender: TObject);
    procedure ExportDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure ReturnMngClick(Sender: TObject);
    procedure ExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InfoShow: Boolean;
  end;


  TPosLine=object
  private
    Prevx,Prevy: Integer; //save old x,y
    ox,oy: Integer; //if hide then need hide Lnx(Prevx,y->prev)  Lny(x1->x2,Prevy)
    e: Integer; //distance from label to axis (X,Y)
    dot: Integer; //dist of line axis
  public
    HideOk: Boolean;
    doc,ngang: array [0..1024] of TColor; //save background of axis
    x,y: Integer; //current x,y
    procedure Init;
    procedure Draw;
    procedure Hide;
  end;

var
  Form4: TForm4;
  posln: TPosLine;

implementation

uses UGrDlg, UPaint, UZoom, UBgr, UOrg, UFastInfo, UMain;
{$R *.DFM}

procedure updateInfo;
var i: byte; 
begin
  for i:=1 to AmountOfGr do
    with Gr[i] do
    begin
      //param
      if Countm>0 then
        Form3.StringGrid1.Cells[5,order]:=FloatToStr(m);
      //color
      AColor[order]:=color;
    end;
  Form4.Hide; Form8.Hide; Form3.Show;
end;

procedure TPosLine.Init;
begin
  e:=5; dot:=1; HideOk:=False;
end;

procedure TPosLine.Draw;
var
  i,dx,dy,xx,yy,w,h: Integer;
  b: Boolean;
  kx1,kx2,kx3,ky1,ky4,ky5,xmin,xmax,ymin,ymax: Integer;
  px,py: Byte;
  s: String;
begin
  HideOk:=True;
  //Draw axis
  Form4.labelx.Visible:=true; Form4.labely.Visible:=true;
  if x<xorg then dx:=dot else dx:=-dot;
  if y<yorg then dy:=dot else dy:=-dot;
  prevx:=x; prevy:=y; ox:=XORG; oy:=YORG;

  i:=x; b:=False;
  if x<xORG then
  while (i<XORG)and(i>RectGr.Left)and(i<RectGr.Right) do
  begin
    if b then
      with Form4.Image1.Canvas do
      begin
        ngang[i]:=Pixels[i,y];
        Pixels[i,y]:=AxisColor;
      end;
    b:=not b;
    inc(i,dx);
  end
  else
  while (i>XORG)and(i>RectGr.Left)and(i<RectGr.Right) do
  begin
    if b then
      with Form4.Image1.Canvas do
      begin
        ngang[i]:=Pixels[i,y];
        Pixels[i,y]:=AxisColor;
      end;
    b:=not b;
    inc(i,dx);
  end;

  i:=y; b:=False;
  if y<yorg then
  while (i<YORG)and(i>RectGr.Top)and(i<RectGr.Bottom) do
  begin
    if b then
      with Form4.Image1.Canvas do
      begin
        doc[i]:=Pixels[x,i];
        Pixels[x,i]:=AxisColor;
      end;
    b:=not b;
    inc(i,dy);
  end
  else
  while (i>YORG)and(i>RectGr.Top)and(i<RectGr.Bottom) do
  begin
    if b then
      with Form4.Image1.Canvas do
      begin
        doc[i]:=Pixels[x,i];
        Pixels[x,i]:=AxisColor;
      end;
    b:=not b;
    inc(i,dy);
  end;

  xmin:=RectGr.Left+e;
  ymin:=RectGr.Top+e;

  //Calc hintRect **************
  //Calc HintRecty:
  Str((YORG-Y)/ZY:0:3,s); Form4.labely.Caption:=s;
  w:=Form4.labely.Width; h:=Form4.labely.Height;
  xmax:=RectGr.Right-(w+e); ymax:=RectGr.Bottom-(h+e);

  kx1:=XORG-(w+e); kx3:=XORG+e; ky1:=y-(h+e); ky4:=y-h div 2; ky5:=y+e;
  if x>xorg then
  begin
    if kx1>=xmin then xx:=kx1 else if kx3>=xmin then xx:=kx3 else xx:=xmin;
    if (xx=kx1)and(ky4>=ymin)and(ky4<=ymax) then yy:=ky4
    else
    if ky5<=ymax then yy:=ky5 else yy:=ky1;
  end
  else
  begin
    if kx3<=xmax then xx:=kx3 else if kx1<=xmax then xx:=kx1 else xx:=xmax;
    if (xx=kx3)and(ky4>=ymin)and(ky4<=ymax) then yy:=ky4
    else
    if ky5<=ymax then yy:=ky5 else yy:=ky1;
  end;
  Form4.labely.Left:=xx; Form4.labely.Top:=yy;

  //Calc HintRectx:
  Str((X-XORG)/ZX:0:3,s); Form4.labelx.Caption:=s;
  w:=Form4.labelx.Width; h:=Form4.labelx.Height;
  xmax:=RectGr.Right-(w+e); ymax:=RectGr.Bottom-(h+e);

  kx1:=x-(w+e); kx2:=x-w div 2; kx3:=x+e; ky1:=YORG-(h+e); ky5:=YORG+e;
  if y>YORG then
  begin
    if ky1>=ymin then yy:=ky1 else if ky5>=ymin then yy:=ky5 else yy:=ymin;
    if (yy=ky1)and(kx2<=xmax)and(kx2>=xmin) then xx:=kx2
    else
    if kx3<=xmax then xx:=kx3 else xx:=kx1;
  end
  else
  begin
    if ky5<=ymax then yy:=ky5 else if ky1<=ymax then yy:=ky1 else yy:=ymax;
    if (yy=ky5)and(kx2<=xmax)and(kx2>=xmin) then xx:=kx2
    else
    if kx3<=xmax then xx:=kx3 else xx:=kx1;
  end;
  Form4.labelx.Left:=xx; Form4.labelx.Top:=yy;
end;

procedure TPosLine.Hide;
var
  i,dx,dy: Integer;
  b: Boolean;
begin
  if not HideOk then Exit;
  Form4.labelx.Visible:=False; Form4.labely.Visible:=False;
  if prevx<ox then dx:=dot else dx:=-dot;
  if prevy<oy then dy:=dot else dy:=-dot;
  prevx:=prevx; prevy:=prevy; ox:=ox; oy:=oy;

  i:=prevx; b:=False;
  if prevx<ox then
  while (i<ox)and(i>RectGr.Left)and(i<RectGr.Right) do
  begin
    if b then
      Form4.Image1.Canvas.Pixels[i,prevy]:=ngang[i];
    b:=not b;
    inc(i,dx);
  end
  else
  while (i>ox)and(i>RectGr.Left)and(i<RectGr.Right) do
  begin
    if b then
      Form4.Image1.Canvas.Pixels[i,prevy]:=ngang[i];
    b:=not b;
    inc(i,dx);
  end;

  i:=prevy; b:=False;
  if prevy<oy then
  while (i<oy)and(i>RectGr.Top)and(i<RectGr.Bottom) do
  begin
    if b then
      Form4.Image1.Canvas.Pixels[prevx,i]:=doc[i];
    b:=not b;
    inc(i,dy);
  end
  else
  while (i>oy)and(i>RectGr.Top)and(i<RectGr.Bottom) do
  begin
    if b then
      Form4.Image1.Canvas.Pixels[prevx,i]:=doc[i];
    b:=not b;
    inc(i,dy);
  end;
end;

procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: Integer; change: Boolean;
begin
  change:=false;
  case key of
    121: form1.Show;
    32: //Space
      begin
        if Form8.Visible then Form8.Hide else Form8.Show;
        InfoShow:=Form8.Visible;
      end;
    71: //'G'
      OrgAxisOptClick(Sender);
    78: //'N'
      BkgrOptClick(Sender);
    90: //'Z'
      ZoomOptClick(Sender);
    107: //'+'
      begin inc(ZX,DZXY); inc(ZY,DZXY); change:=true; end;
    109: //'-'
      if (ZX-DZXY>10) and (ZY-DZXY>10) then
        begin dec(ZX,DZXY); dec(ZY,DZXY); change:=true; end;
     33: //PgUp
       begin
         change:=true;
         for i:=AmountOfGr downto 1 do
           with Gr[i] do
             if Countm>0 then
               begin m:=m-dm; Hide; end;
         FastInfoUpd;
       end;
     34: //PgDn
       begin
         change:=true;
         for i:=AmountOfGr downto 1 do
           with Gr[i] do
             if Countm>0 then
               begin m:=m+dm; Hide; end;
         FastInfoUpd;
       end;
     38: //Up
       begin
         change:=true;
         if (ssCtrl in shift) then dec(YORG,DORG shl 1)
         else dec(YORG,DORG);
         if (ssShift in shift) then inc(ZY,DZY)
       end;
     40://Dn
       begin
         change:=true;
         if (ssCtrl in shift) then inc(YORG,DORG shl 1)
         else inc(YORG,DORG);
         if (ssShift in shift) and (ZY>DZY) then dec(ZY,DZY)
       end;
     37://Left
       begin
         change:=true;
         if (ssCtrl in shift) then dec(XORG,DORG shl 1)
         else dec(XORG,DORG);
         if (ssShift in shift) and (ZX>DZX) then dec(ZX,DZX)
       end;
     39://Right
       begin
         change:=true;
         if (ssCtrl in shift) then inc(XORG,DORG shl 1)
         else inc(XORG,DORG);
         if (ssShift in shift) then inc(ZX,DZX)
       end;
     27: //ESC
       UpdateInfo;
     116: //F5
       begin
         Hide; Form8.Hide; Form3.Show;
       end;
     88: //'X'
       ExportClick(Sender);
  end;
  if change then
  begin
    Posln.Hide; posln.HideOk:=False;
    for i:=AmountOfGr downto 1 do Gr[i].Hide;
    HideAxis; DrawAxis;
    for i:=1 to AmountOfGr do
      with gr[i] do
        begin {visible:=false; vis} Calculate; Draw; end;
  end;
end;
procedure TForm4.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  posln.Hide;
  posln.x:=X;
  posln.y:=Y;
  posln.Draw;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Bkgr:=TPicture.Create;
  BkGr.Bitmap.Width:=430;
  BkGr.Bitmap.Height:=320;
  posln.Init;
{  posln.x:=200;
  posln.y:=160;}
  posln.Draw;
end;

procedure TForm4.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Byte;
  p: TPoint;
begin
  case Button of
    mbLeft:
    begin
      XORG:=x; YORG:=y;
      Posln.Hide; posln.HideOk:=False;
      for i:=AmountOfGr downto 1 do Gr[i].Hide;
      HideAxis; DrawAxis;
      for i:=1 to AmountOfGr do
      with gr[i] do
        begin {visible:=false; vis} Calculate; Draw; end;
    end;
    mbRight:
    begin
      p.x:=X; p.y:=Y;
      Windows.ClientToScreen(Handle,p);
      PopupMenu1.Popup(p.X,p.Y);
    end;
  end;
end;

procedure TForm4.BkgrOptClick(Sender: TObject);
var i: Byte;
begin
  Form7.ShowModal;
  posln.Hide;
  posln.HideOk:=False;
  for i:=AmountOfGr downto 1 do Gr[i].Hide;
  HideAxis;
  DrawAxis;
  for i:=1 to AmountOfGr do
    with gr[i] do
      begin {visible:=false; vis} Calculate; Draw; end;
end;

procedure TForm4.ZoomOptClick(Sender: TObject);
var i: Byte;
begin
  Form5.ShowModal;
  Posln.Hide; posln.HideOk:=False;
  for i:=AmountOfGr downto 1 do Gr[i].Hide;
  HideAxis; DrawAxis;
  for i:=1 to AmountOfGr do
    with gr[i] do
      begin {visible:=false; vis} Calculate; Draw; end;
end;

procedure TForm4.OrgAxisOptClick(Sender: TObject);
var i: Byte;
begin
  Form6.ShowModal;
  Posln.Hide; posln.HideOk:=False;
  DrawAxis;
  for i:=1 to AmountOfGr do
    with gr[i] do
      begin {visible:=false; vis} Calculate; Draw; end;
end;

procedure TForm4.FastInfoTableClick(Sender: TObject);
begin
  if Form8.Visible then Form8.Hide else Form8.Show;
  Form4.InfoShow:=Form8.Visible;
end;

procedure TForm4.ExportDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  s: String; sc: TShortCut;
  t: Integer;
begin
  with (Sender as TMenuItem) do
  begin
    s:=Caption;
    sc:=ShortCut;
  end;
  delete(s,pos('&',s),1);
  with ACanvas do
  begin
    if Selected then
    begin
      Brush.Color:=$00C6FFCD;
      FillRect(ARect);
      ACanvas.Pen.Color:=clTeal;
      Rectangle(ARect);
    end
    else
    begin
      Brush.Color:=clWhite;
      FillRect(ARect);
    end;
    if s='-' then
      with ARect do
      begin
        t:=Top+(Bottom-Top+1) div 2;
        MoveTo(Left,t);
        LineTo(Right,t);
      end
    else
    begin
      with ARect do
        t:=Top+(Bottom-Top+1-ACanvas.TextHeight(s)) div 2;
      Font.Name:='GCalc System Font   ';
      Font.Color:=clBlack;
      TextOut(ARect.Left+1,t,s);
      s:=ShortCutToText(sc);
      TextOut(ARect.Right-2-TextWidth(s),t,s);
    end;
  end;
end;

procedure TForm4.ReturnMngClick(Sender: TObject);
begin
  updateInfo;
end;

procedure TForm4.ExportClick(Sender: TObject);
var path: string;
begin
  Posln.Hide;
  if SavePictureDialog1.Execute then
  begin
    path:=SavePictureDialog1.FileName;
    if pos('.',path)=0 then path:=path+'.bmp';
    Image1.Picture.SaveToFile(path);
  end;
end;

end.
