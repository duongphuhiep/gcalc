unit UGrDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Buttons, ExtCtrls, mxstore, mxDB, mxpivsrc, UPaint, UCommon,
  ExtDlgs, ComCtrls;

type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ColorDialog1: TColorDialog;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFile(path: String);
    function XToDis(s: string): string; //de viet ch Enable ra file
    function DisToX(s: string): string;
    function emty(a: byte): Boolean; //dong a cua grid co rong ?
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  StateRow: array [0..255] of Byte; //=0: Normal; 1: Warning; 2: Error; 3: Disable

implementation

uses UWndDraw, UZoom, UOrg, UBgr, UFastInfo, UMain;
{$R *.DFM}
function ToRange(s: string; var a,b: Extended): Boolean;
var
  p: Integer; s1: String;
  r: TPart;
begin
  toRange:=true;
  p:=pos('..',s);

  if p=0 then
    begin toRange:=False; exit; end;

  s1:=copy(s,1,p-1); delete(s,1,p+1);

  Analyse(s1,False);
  if errmsg<>'' then
    begin toRange:=False; exit; end
  else
    begin
      r:=NormalCalc;
      if r.kind=kNum then a:=r.num
      else
        begin toRange:=False; exit; end
    end;

  Analyse(s,False);
  if errmsg<>'' then toRange:=False
  else
    begin
      r:=NormalCalc;
      if r.kind=kNum then b:=r.num
      else toRange:=False;
    end;

end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin Close; Form4.Close; end;

procedure TForm3.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var w,h: integer; s: string;
begin
  with StringGrid1 do
  begin
  w:=ColWidths[ACol]; h:=RowHeights[ARow];
  if ARow=0 then
  begin
    case ACol of
      0: s:='Bá';
      1: s:='Mµu';
      2: s:='Ph­¬ng tr×nh';
      3: s:='Kho¶ng vÏ';
      4: s:='Tªn';
      5: s:='Khëi t¹o m';
      6: s:='BiÕn ®æi m';
      7: s:='C¶nh b¸o vµ lçi (nÕu cã)';
    end;
    with Canvas do
    begin
      Font.Size:=8;
      TextRect(
        Rect,Rect.Left+(w-TextWidth(s)) shr 1,
        Rect.Top+(h-TextHeight(s)) shr 1,s);
    end;
  end
  else

  if ACol=0 then
    with Canvas do
    begin
      Font.Color:=clBlack;
      Brush.Color:=clBtnFace; FillRect(Rect);
      if Cells[0,ARow]='x' then
      TextOut(
        Rect.Left+(w-TextWidth('x')) shr 1,
        Rect.Top+(h-TextHeight('x')) shr 1,'x');
    end
  else

  if ACol=1 then
  begin
    with Canvas do
      if AColor[ARow]<>0 then
      begin
        Brush.Color:=AColor[ARow];
        Pen.Color:=clBlack;
        RoundRect(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2,10,10);
      end;
  end
  else

  begin
    s:=cells[ACol,ARow];
    with StringGrid1.Canvas do
    begin
      case StateRow[ARow] of
        1: Font.Color:=clTeal;//Warning
        2: Font.Color:=clRed;//Error
        3: Font.Color:=clGrayText;//Disable
        else //Normal;
          Font.Color:=clBlack;
      end;

      if (ACol>0)and(ARow>0) then
        begin
          if (gdFocused in state)or(gdSelected in state) then
            Brush.Color:=$00C6FFCD
          else Brush.Color:=clWhite;
          FillRect(Rect);
          TextRect(Rect,Rect.Left+6,Rect.Top+(h-TextHeight(s)) shr 1,s);
        end;
    end;
  end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var i: Integer;
begin
  FillChar(AColor,SizeOf(AColor),0);
  for i:=1 to 255 do Gr[i].X:=nil;
  {
  //test
  with StringGrid1 do
  begin
    Cells[2,1]:='y=m/x'; Cells[3,1]:='sd';
    Cells[2,2]:='y=sin(x*m)*sqrt(-1)';
    Cells[2,3]:='y=lg(2,x)';
    Cells[2,4]:='y=2*m^x';
    Cells[2,5]:='y=-2*x^2+-3*x-5';
    Cells[2,6]:='y=-2*x^3+-3*x-5';
  end;
  }
end;

procedure TForm3.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow,i: integer;
  State: TGridDrawState;
  Rect: TRect;
begin
  if Button=mbRight then
  with StringGrid1 do
  begin
    MouseToCell(X,Y,ACol,ARow);
    if (ARow>0) then
      case ACol of
        0:
          begin
            if StateRow[ARow]<>3 then
              begin StateRow[ARow]:=3; cells[0,ARow]:='x'; end
            else
              begin StateRow[ARow]:=0; cells[0,ARow]:=''; end;
            for i:=2 to 7 do
            begin
              if (Col=i)and(Row=ARow) then State:=[gdFocused]
              else State:=[];
              StringGrid1DrawCell(sender,i,ARow,CellRect(i,ARow),State);
            end;
          end;
        1:
          if ColorDialog1.Execute and (ACol=1) then
          begin
            Rect:=CellRect(ACol,ARow);
            AColor[ARow]:=ColorDialog1.Color;
            StringGrid1.Canvas.Brush.Color:=AColor[ARow];{clRed;{}
            StringGrid1.Canvas.Pen.Color:=clBlack;
            StringGrid1.Canvas.RoundRect(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2,10,10);
          end;
      end;
  end;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    Label1.Caption:=
      'NhËp th«ng tin vÒ c¸c ®å thÞ muèn vÏ (F2 ®Ó söa 1 «). Quan träng nhÊt lµ môc Ph­¬ng tr×nh, c¸c môc kh¸c cã thÓ bá qua.'
end;

procedure TForm3.StringGrid1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var ACol,ARow: Integer;
begin
  StringGrid1.MouseToCell(X,Y,ACol,ARow);
  if ARow=0 then ACol:=-1;
  case ACol of
    0:
      Label1.Caption:=
        'NhÊp ph¶i chuét ®Ó x¸c ®Þnh cã vÏ ®å thÞ ®­îc khai b¸o ë dßng nµy kh«ng? NÕu cã dÊu "x" tøc lµ t¹m thêi sÏ kh«ng vÏ.';
    1:
      Label1.Caption:=
        'NhÊp ph¶i chuét ®Ó x¸c ®Þnh mµu s¾c ®å thÞ khai b¸o ë dßng nµy. NÕu kh«ng x¸c ®iÞnh th× mÆc ®Þnh lµ mµu ®en.';
    2:
      Label1.Caption:=
        'NhËp vµo cét nµy Ph­¬ng tr×nh cña ®å thÞ VD: "y=sin(x)+m" hoÆc "x=3*y+3". Kh«ng ®­îc nhËp pt d¹ng x=f(x) hay y=f(y).';
    3:
      Label1.Caption:=
        'NhËp vµo cét nµy kho¶ng vÏ cña ®å thÞ VD: "-pi/2..pi/2". NÕu kh«ng nhËp th× lÊy mÆc ®Þnh lµ "-oo..+oo".';
    4:
      Label1.Caption:=
        'NhËp vµo cét nµy tªn ®å thÞ. NÕu kh«ng ch­¬ng tr×nh sÏ tù ®éng sinh tªn cho ®å thÞ.';
    5:
      Label1.Caption:=
        'NhËp vµo cét nµy gi¸ trÞ khëi t¹o cho tham sè m (nÕu pt cã chøa tham sè). NÕu kh«ng nhËp, sÏ lÊy mÆc ®Þnh m=0.';
    6:
      Label1.Caption:=
        'NhËp vµo cét nµy gi¸ trÞ biÕn ®æi cña tham sè m (nÕu pt cã chøa tham sè). NÕu kh«ng nhËp, sÏ lÊy mÆc ®Þnh lµ 1.';
    7:
      Label1.Caption:=
        'C¸c c¶nh b¸o vµ c¸c th«ng b¸o lçi (nÕu cã) ®­îc ghi vµo cét nµy.';      
    else
      Label1.Caption:=
        'NhËp vµo b¶ng nµy th«ng tin vÒ c¸c ®å thÞ muèn vÏ. NÕu muèn söa th«ng tin trong mét «, bÊm F2.'
    end;
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
var
  i,p: Integer;
  s: string;
  eOk: Boolean;
begin
  //Xu ly cac thong tin trong bang
  AmountOfGr:=0;
  for i:=1 to 255 do
  with StringGrid1 do
    if (Cells[0,i]='')and(Cells[2,i]<>'') then
    begin
      StateRow[i]:=0; Cells[7,i]:=''; //Delete old error and warning except
      //Quy chuan xau chua pt can ve
      s:=Cells[2,i];
      p:=pos(' ',s); while p>0 do begin delete(s,p,1); p:=pos(' ',s); end;
      //Kiem tra phuong trinh xem co dang y=f(x) hay x=f(y)

      inc(AmountOfGr);
      eOk:=true;
      if s[2]='=' then
        if s[1]='x' then Gr[AmountOfGr].kind:=pYX
        else
        if s[1]='y' then Gr[AmountOfGr].kind:=pXY
        else eOk:=false
      else
        eOk:=false;

      if eOk then
      begin
        Gr[AmountOfGr].Content:=copy(s,3,length(s)-2);
        Gr[AmountOfGr].Init;
        if Gr[AmountOfGr].err='' then
        begin
          with Gr[AmountOfGr] do
          begin
            Color:=AColor[i]; //Mau sac
            Order:=i; //So thu tu
          end;

          //Ten do thi
          if Cells[4,i]='' then Cells[4,i]:='G'+IntToStr(i);
          Gr[AmountOfGr].name:=Cells[4,i];
          //Tham so
          if Gr[AmountOfGr].Countm>0 then
          begin
            try Gr[AmountOfGr].m:=StrToInt(Cells[5,i]);
            except
              if Cells[5,i]<>'' then
              begin
                StateRow[i]:=1; Cells[7,i]:='Tham sè kh«ng hîp lÖ, lÊy mÆc ®Þnh lµ 0.'
              end;
              Gr[AmountOfGr].m:=0; //m mac dinh =0
            end;

            try Gr[AmountOfGr].dm:=StrToInt(Cells[6,i]);
            except
              if Cells[6,i]<>'' then
              begin
                StateRow[i]:=1; Cells[7,i]:='§é biÕn ®æi tham sè kh«ng hîp lÖ, lÊy mÆc ®Þnh lµ 1.'
              end;
              Gr[AmountOfGr].dm:=1; //dm mac dinh =1
            end;
          end;
          //Khoang ve
          if (Cells[3,i]='') then Gr[AmountOfGr].NoLimit:=true
          else
          begin
            if (not ToRange(Cells[3,i],Gr[AmountOfGr].Limit1,Gr[AmountOfGr].Limit2))
            then
            begin
              Gr[AmountOfGr].NoLimit:=true;
              Cells[7,i]:='Kh«ng tÝnh ®­îc kho¶ng vÏ, lÊy mÆc ®Þnh lµ: ©m v« cïng .. d­¬ng v« cïng!';
              StateRow[i]:=1;
            end
            else Gr[AmountOfGr].NoLimit:=False;
          end;
        end
        else
          begin
            Cells[7,i]:=Gr[AmountOfGr].err;
            dec(AmountOfGr); StateRow[i]:=2;
          end;
      end
      else
      begin
        dec(AmountOfGr); StateRow[i]:=2;
        Cells[7,i]:='Ph­¬ng tr×nh ®å thÞ ph¶i viÕt ®óng theo khu«n mÉu: y=f(x) hoÆc x=f(y).'
      end;
    end;
  Hide; Form8.Show; Form4.Show;
  //Clear old graph by background
  Form4.Image1.Picture:=BkGr;
  Form4.Image1.Width:=BkGr.Width;
  Form4.Image1.Height:=BkGr.Height;
  Form4.ClientWidth:=BkGr.Width;
  Form4.ClientHeight:=BkGr.Height;
  DrawAxis;
  i:=0; //For i=1->AmountOfGr?
  while i<AmountOfGr do
  begin
    inc(i);
    with Gr[i] do
      begin
        {Visible:=False; vis} Calculate; Draw;
      end;
  end;
end;

procedure TForm3.BitBtn3Click(Sender: TObject);
begin
  Form7.ShowModal;
end;

procedure TForm3.BitBtn4Click(Sender: TObject);
begin
  Form5.ShowModal;
end;

procedure TForm3.BitBtn5Click(Sender: TObject);
begin
  Form6.ShowModal;
end;

procedure TForm3.BitBtn1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption:='VÏ / vÏ l¹i ®å thÞ theo c¸c th«ng tin trong b¶ng. Muèn xem l¹i ®å thÞ hiÖn t¹i, nhÊn F5.';
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
    116:
      begin Hide; if Form4.InfoShow then Form8.Show; Form4.Show; end;
    121: form1.Show;
  end;
end;

function TForm3.emty(a: byte): Boolean; //dong a cua grid co rong ?
var i: Byte;
begin
  emty:=True;
  if AColor[a]<>0 then begin emty:=False; Exit; end;
  for i:=2 to 7 do
    if StringGrid1.Cells[i,a]<>'' then
      begin emty:=False; Exit; end;
end;

function TForm3.XToDis(s: string): string; //de viet ch Enable ra file
begin
  if s='x' then XToDis:='False' else XToDis:='True';
end;
function TForm3.DisToX(s: string): string;
begin
  if s='True' then DisToX:='' else DisToX:='x';
end;

const
  flab: array [-1..8] of String[10]=
    ('Row: ','Visible: ','Color: ','Equation: ','Range: ','Name: ','m = ','Delta m = ','S: ','State: ');
  flablen: array [-1..8] of Byte=(5,9,7,10,7,6,4,10,3,7);

procedure TForm3.SpeedButton1Click(Sender: TObject);
var
  path: String; count,i,j: Byte; f: TextFile;
begin
  if SaveDialog1.Execute then
  begin
    path:=SaveDialog1.FileName;
    if pos('.',path)=0 then path:=path+'.gr';
    count:=0; for i:=1 to 255 do if not emty(i) then inc(count);
    AssignFile(f,path); Rewrite(f);
    writeln(f,'LIST OF GRAPHICS''S GCALC');
    writeln(f,'~~~~~~~~~~~~~~~~~~~~~~~~');
    writeln(f);
    writeln(f,count,' graphics in this file.');
    writeln(f);
    for i:=1 to 255 do
      if not emty(i) then
        with StringGrid1 do
        begin
          writeln(f,flab[-1],i);
          writeln(f,flab[0],XToDis(Cells[0,i]));
          writeln(f,flab[1],AColor[i]);
          for j:=2 to 7 do writeln(f,flab[j],Cells[j,i]);
          writeln(f,flab[8],StateRow[i]);
          writeln(f,'------------------------');
        end;
    CloseFile(f);
  end;
end;

procedure TForm3.LoadFile(path: String);
var s: String; f: TextFile; Count,i,j,r: Byte;
begin
  AssignFile(f,path); Reset(f);
  readln(f,s);
  if s<>'LIST OF GRAPHICS''S GCALC' then
  begin
    ShowMessage('File is illegal, Can''t used!');
    CloseFile(f); Exit;
  end;
  readln(f); readln(f); readln(f,Count); readln(f);
  FillChar(AColor,SizeOf(AColor),0);
  FillChar(StateRow,SizeOf(StateRow),0);
  for i:=1 to Count do
    with StringGrid1 do
    begin
      readln(f,s); Delete(s,1,flablen[-1]); r:=StrToInt(s);
      readln(f,s); Delete(s,1,flablen[0]); Cells[0,r]:=DisToX(s);
      readln(f,s); Delete(s,1,flablen[1]); AColor[r]:=StrToInt(s);
      for j:=2 to 7 do
        begin readln(f,s); Delete(s,1,flablen[j]); Cells[j,r]:=s; end;
      readln(f,s); Delete(s,1,flablen[8]); StateRow[r]:=StrToInt(s);
      readln(f);
    end;
  CloseFile(f);
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadFile(OpenDialog1.FileName);
end;

end.
