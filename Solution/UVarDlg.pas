unit UVarDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, Menus, UCommon;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LoadFile(path: String);
    function emty(a: byte): Boolean; //dong a cua grid co rong ?
    function XToDis(s: string): string; //de viet ch Enable ra file
    function DisToX(s: string): string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}
uses UMain;

//dung de viet ra file
const
  flab: array [-1..3] of String[10]=
    ('Row: ','State: ','Name: ','Content: ','Note: ');
  flablen: array [-1..3] of Byte=(5,7,6,9,6);

procedure TForm2.BitBtn1Click(Sender: TObject);
var i,j: integer; t: TPart; s: string;
begin
  AmountOfConst:=0;
  with StringGrid1 do
    for i:=1 to 256 do
    begin
      if (cells[1,i]<>'') and (Cells[2,i]<>'') and (cells[0,i]='') then
      begin
        s:=Cells[2,i];
        if (s[1]='[') and (s[length(s)]=']') then t:=ToPart(s,AmountOfOperator+1)
        else
        begin
          j:=pos(':',s);
          errmsg:='';
          if j>0 then
          begin
            try t.t:=StrToInt(copy(s,1,j-1));
            except errmsg:='Kh«ng hiÓu '+s+' lµ g×';
            end;
            try t.m:=StrToInt(copy(s,j+1,length(s)-j));
            except errmsg:='Kh«ng hiÓu '+s+' lµ g×';
            end;
            if errmsg='' then
            begin
              t.kind:=kFrac;
              j:=ucln(t.t,t.m);
              t.t:=t.t div j; t.m:=t.m div j;
              t.num:=t.t/t.m;
            end;
          end
          else
            t:=ToPart(s,0);
        end;
        if errmsg='' then
        begin
          inc(AmountOfConst);
          aconst[AmountOfConst].kind:=t.kind;
          aconst[AmountOfConst].name:=cells[1,i];
          aconst[AmountOfConst].num:=t.num;
          aconst[AmountOfConst].s:=t.name;
          aconst[AmountOfConst].Bool:=t.Bool;
          aconst[AmountOfConst].t:=t.t;
          aconst[AmountOfConst].m:=t.m;
        end
        else
        begin
          inc(cwar);
          war[cwar]:=intToStr(cwar)+') C¶nh b¸o: H»ng sè "'+cells[1,i]+'" kh«ng hîp lÖ';
        end;
      end;
    end;
  {viet warn}
  Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
var f: TSearchRec;
begin
  {for i:=1 to AmountOfConst do
    with aconst[i] do
    begin
      StringGrid1.cells[1,i]:=name;
      case kind of
        kBool: StringGrid1.cells[2,i]:=BoolToStr(bool);
        kStr: StringGrid1.cells[2,i]:='['+s+']';
        kDate: StringGrid1.cells[2,i]:='['+s+']';
        kFrac: StringGrid1.cells[2,i]:=IntToStr(t)+':'+IntToStr(m);
        kNum,kParam: StringGrid1.cells[2,i]:=FloatToStr(num)
      end;
    end;
  with StringGrid1 do
  begin
    col:=1; row:=AmountOfConst+1;
    Cells[3,1]:='TÝnh chu vi vµ diÖn tÝch h×nh trßn: C=2*pi*r; S=pi*r^2';
    Cells[3,2]:='e^n=exp(n); e=lim(1+1/n)^n (n->v« cïng)';
    Cells[3,3]:='§æi nhiÖt ®é:  ®é_K=273+®é_C;  ®é_F=1.8*®é_C+32'; cells[0,3]:='x';
    Cells[3,4]:='Tèc ®é ¸nh s¸ng trong ch©n kh«ng';
    Cells[3,5]:='Sè Avogadro: Sè ph©n tö trong 1 mol chÊt';
    Cells[3,6]:='H»ng sè Plank';
    Cells[3,7]:='Gia tèc träng tr­êng';
    Cells[3,8]:='X©u kÝ tù th­êng ®Ó th«ng b¸o can chi cña n¨m, VD: TB+(canchi_y(cdate))'; cells[0,8]:='x';
    Cells[3,9]:='Ngµy sinh cña t¸c gi¶; tuæi cña t¸c gi¶ lµ (cdate-NS)/365'; cells[0,9]:='x';
  end;}
  if FindFirst('default.cst',faArchive,f)=0 then
  begin
    LoadFile('default.cst');
    BitBtn1Click(Sender);
  end;

end;

procedure TForm2.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var w,h: integer; s: string;
begin
  with StringGrid1 do
  begin
  w:=ColWidths[ACol]; h:=RowHeights[ARow];
  if ARow=0 then
  begin
    case ACol of
      0: s:='Bá'; 1: s:='Tªn'; 2: s:='Néi dung'; 3: s:='Ghi chó - ý nghÜa';
    end;
    with Canvas do
      TextRect(
        Rect,Rect.Left+(w-TextWidth(s)) shr 1,
        Rect.Top+(h-TextHeight(s)) shr 1,s);
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

  begin
    s:=cells[ACol,ARow];
    if cells[0,ARow]='x' then
      Canvas.Font.Color:=clGrayText
    else
      Canvas.Font.Color:=clBlack;
    if (ACol>0)and(ARow>0) then
      with Canvas do
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

procedure TForm2.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow,i: integer;
  State: TGridDrawState;
begin
  if Button=mbRight then
  with StringGrid1 do
  begin
    MouseToCell(X,Y,ACol,ARow);
    if (ACol=0)and(ARow>0) then
    begin
      if cells[0,ARow]='x' then cells[0,ARow]:=''
      else cells[0,ARow]:='x';
      for i:=1 to 3 do
      begin
        if (Col=i)and(Row=ARow) then
          State:=[gdFocused]
        else State:=[];
        StringGrid1DrawCell(sender,i,ARow,CellRect(i,ARow),State);
      end;
    end;
  end;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
var
  i,j,k: byte; ok: boolean;
  s: string; x: integer;
begin
  if errmsg<>'' then exit;
  for k:=1 to 255 do
  begin
    ok:=true;
    for i:=1 to 255 do
    begin
      s:=StringGrid1.Cells[1,i];
      if (s<>'')and(s[1]='C') then
      begin
        val(copy(s,2,length(s)-1),j,x);
        if (x=0)and(j=k) then
          begin ok:=false; break; end;
      end;
    end;
    if ok then break;
  end;

  for i:=255 downto 1 do
    with StringGrid1 do
      if (cells[1,i-1]<>'')or(cells[2,i-1]<>'')or(cells[3,i-1]<>'') then
        begin col:=1; row:=i; break; end;

  StringGrid1.cells[1,i]:='C'+IntToStr(k);
  with result do
    case kind of
      kBool: StringGrid1.cells[2,i]:=BoolToStr(bool);
      kStr: StringGrid1.cells[2,i]:='['+name+']';
      kDate: StringGrid1.cells[2,i]:='['+name+']';
      kFrac: StringGrid1.cells[2,i]:=IntToStr(t)+':'+IntToStr(m);
      kNum,kParam: StringGrid1.cells[2,i]:=FloatToStr(num);
    end;
end;

function TForm2.emty(a: byte): Boolean; //dong a cua grid co rong ?
var i: Byte;
begin
  emty:=True;
  for i:=1 to 3 do
    if StringGrid1.Cells[i,a]<>'' then
      begin emty:=False; Exit; end;
end;
function TForm2.XToDis(s: string): string; //de viet ch Enable ra file
begin
  if s='x' then XToDis:='Disable' else XToDis:='Enable';
end;
function TForm2.DisToX(s: string): string;
begin
  if s='Enable' then DisToX:='' else DisTox:='x';
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  path: String;
  f: TextFile;
  i,j,c: byte;
begin
  if SaveDialog1.Execute then
  begin
    path:=SaveDialog1.FileName;
    if pos('.',path)=0 then path:=path+'.cst';
    c:=0; for i:=1 to 255 do if not emty(i) then inc(c);
    AssignFile(f,path); Rewrite(f);
    writeln(f,'LIST OF CONSTANTS''S GCALC');
    writeln(f,'~~~~~~~~~~~~~~~~~~~~~~~~~');
    writeln(f);
    writeln(f,c,' records in this File.');
    writeln(f);
    for i:=1 to 255 do
      if not emty(i) then
        with StringGrid1 do
        begin
          writeln(f,flab[-1],i);
          writeln(f,flab[0],XToDis(Cells[0,i]));
          for j:=1 to 3 do
            writeln(f,flab[j],Cells[j,i]);
          writeln(f,'-------------------------');
        end;
    CloseFile(f);
  end;
end;

procedure TForm2.LoadFile(path: String);
var s: String; f: TextFile; Count,i,j,r: Byte;
begin
  AssignFile(f,path); Reset(f);
  readln(f,s);
  if s<>'LIST OF CONSTANTS''S GCALC' then
  begin
    ShowMessage('File is illegal, Can''t used!');
    CloseFile(f); Exit;
  end;
  readln(f); readln(f); readln(f,Count); readln(f);
  for i:=1 to Count do
    with StringGrid1 do
    begin
      readln(f,s); Delete(s,1,flablen[-1]); r:=StrToInt(s);
      readln(f,s); Delete(s,1,flablen[0]); Cells[0,r]:=DisToX(s);
      for j:=1 to 3 do
      begin
        readln(f,s); Delete(s,1,flablen[j]); Cells[j,r]:=s
      end;
      readln(f);
    end;
  CloseFile(f);
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadFile(OpenDialog1.FileName);
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
