unit UCommon;

interface

uses SysUtils, Math, ExtCtrls, StdCtrls;

type
  TKind=(kVar,kParam,kNum,kOpr,kBool,kStr,kDate,kFrac); //Cac the loai co the trong thanh phan tong quat

  TStr10=string[10]; //ten cua bien, tham so
  TStr255=string[255];
  TArray33=array[1..3,1..3] of Extended;

  TOperator=record
    name: TStr10; //ten toan hang
    weight: byte; //muc do uu tien
    state: byte; //phep toan 1 ngoi hay 2 ngoi (khong can lam, co cho chac an)
    func: boolean; //co phai la ham khong? VD: max,min,log
  end;

  TPart=record //thanh phan tong quat: vua la toan hang, vua la toan tu
     num: extended;
     name: TStr255;
     t,m: integer;
     case kind: TKind of
       kOpr: (AOpr: byte);
       kBool: (bool: boolean);
  end;

  TConst=record
    kind: TKind;
    name: TStr255;
    num: extended;
    s: TStr255;
    t,m: integer;
    bool: boolean;
  end;

  TPartArray=array [1..1000] of TPart;
  PPartArray=^TPartArray;
  TConstArray=array [1..255] of TConst;

const
  curbase: byte=10;
  dangve: Boolean=false;
  errmsg: string='';
  grerr: string='';
  grok: Boolean=true;
  CanStr: array [1..10] of string[4]=
    ('Gi¸p','¢t','BÝnh','§inh','MËu','Kû','Canh','T©n','Nh©m','Quý');
  ChiStr: array [1..12] of string[4]=
    ('TÝ','Söu','DÇn','M·o','Th×n','Tþ','Ngä','Mïi','Th©n','DËu','TuÊt','Hîi');

var
  opr:array [1..100] of TOperator;
  prefix,suffix: TPartArray;
  aconst: TConstArray;
  result: TPart;
  AmountOfOperator,AmountOfConst: integer;
  precount,sufcount: integer;
  ln10val: extended;
  exp1val: extended;
  CVar: TPart; //gia tri mac dinh cua bien so
  war: array [1..1000] of string;
  cwar: integer;

{
mang prefix cua cac "thanh phan tong quat", la ket qua cua viec phan tich xau s ra.
thanh phan prefix[i] co the la:
   bien (kVar), tham so (kParam) toan tu (kOpr), toan hang (kNum)
}

function BoolToStr(b: boolean): TStr10;
function ucln(u,v: integer): integer;
function toPart(s: string; k: byte): TPart;
function UpperStr(s: string): string;
function OprKind(s: TStr10): byte;
function FindStr(substr,s: string; k: integer): integer;
function BaseToDec(a: byte; s: string): integer;
function DecToBase(a: byte; n: integer): string;
function giaithua(n: integer): extended;
function ptnt(n2: integer): string;
procedure assc(name: TStr255; value: extended);
procedure analyse(var s: string; ChoDaoHam: Boolean);
function NormalCalc: TPart;
procedure rutgon(var a,b: Integer);
function det3(a: TArray33): Extended;
function doc_hs(var n: Extended; var LEdit: TLabeledEdit; var Edit1: TEdit): Boolean;

implementation

uses UMain;

function BoolToStr(b: boolean): TStr10;
  begin if b then BoolToStr:='TRUE' else BoolToStr:='FALSE'; end;

function UpperStr(s: string): string;
  var s2: string; i: integer;
  begin s2:=''; for i:=1 to length(s) do s2:=s2+UpCase(s[i]); UpperStr:=s2; end;
function OprKind(s: TStr10): byte;
  var i: byte;
  begin
    OprKind:=0;
    for i:=1 to AmountOfOperator do
      if s=opr[i].name then begin OprKind:=i; break; end;
  end;

{
Tim xau ki tu substr trong xau s bat dau tu vi tri k
Neu tim thay, tra lai vi tri dau tien cua xau substr xuat hien trong s.
Neu khong thay, tra lai 0.
}
function FindStr(substr,s: string; k: integer): integer;
  var p: integer;
  begin
    if k=0 then k:=1;
    delete(s,1,k-1); p:=pos(substr,s);
    if p>0 then FindStr:=p+k-1 else FindStr:=0;
  end;

function BaseToDec(a: byte; s: string): integer;
  var
    i,l,r,c: integer; {s4+16*(s3+(16(*s2+16*(s1)))) }
    srange: string;
  function cv(c: char): byte;
    var r: byte;
    begin
      c:=upcase(c); r:=0;
      if c in ['0'..'9'] then r:=ord(c)-48
      else
        if c in ['A'..'Z'] then r:=ord(c)-55
        else
          errmsg:='X©u "'+s+'" kh«ng ®óng khu«n d¹ng'+' ['+srange+'].';
      if r>=a then
        errmsg:='X©u "'+s+'" kh«ng ®óng khu«n d¹ng'+' ['+srange+'].';
      cv:=r;
    end;
  begin
    if a<9 then srange:='0..'+IntToStr(a-1)
    else
      if a=11 then srange:='''0''..''9'',''A'''
      else
        srange:='''0''..''9'','+'''A''..'''+chr(a+54)+'''';
    errmsg:=''; l:=length(s); r:=cv(s[1]);
    if errmsg='' then
      for i:=2 to l do
        begin
          c:=cv(s[i]);
          if errmsg='' then r:=c+r*a  else break;
        end;
    BaseToDec:=r;
  end;
function DecToBase(a: byte; n: integer): string;
  var s: string; i,l: integer; c: char;
  function cv(x: integer): char;
    begin if x<10 then cv:=chr(x+48) else cv:=chr(x+55); end;
  begin
    if n=0 then begin DecToBase:='0'; exit; end;
    s:=''; while n>0 do
      begin s:=s+cv(n mod a); n:=n div a; end;
    l:=length(s);
    for i:=1 to l shr 1 do
      begin c:=s[i]; s[i]:=s[l-i+1]; s[l-i+1]:=c; end;
    DecToBase:=s;
  end;
function giaithua(n: integer): extended;
  var i: integer; p: extended;
  begin p:=1; for i:=2 to n do p:=p*i; giaithua:=p; end;
function ucln(u,v: integer): integer;
  var r: integer;
  begin
    u:=abs(u); v:=abs(v);
    while v>0 do
      begin r:=u mod v; u:=v; v:=r; end;
    ucln:=u;
  end;
procedure rutgon(var a,b: Integer);
var u: Integer;
begin
  u:=ucln(a,b);
  a:=a div u; b:=b div u;
  if b<0 then begin a:=-a; b:=-b; end;
end;
{function nhuan(y: integer): byte;
  begin
    if y mod 100=0 then
      if y mod 400=0 then nhuan:=1 else nhuan:=0
    else
      if y mod 4=0 then nhuan:=1 else nhuan:=0;
  end;}
function ptnt(n2: integer): string;
var i,j,n: integer; s: string;
begin
  n:=abs(n2); i:=1; s:='';
  if n=1 then s:='1'
  else
    while n>1 do
    begin
      inc(i);
      if n mod i=0 then
      begin
        j:=0;
        while (n>0)and(n mod i=0) do
          begin n:=n div i; inc(j); end;
        s:=s+IntToStr(i);
        if j>1 then s:=s+'^'+IntToStr(j);
        if n>1 then s:=s+'*';
      end;
    end;
  if n2<0 then insert('-',s,1);
  ptnt:=s;
end;

function det3(a: TArray33): Extended;
begin
  det3:=a[1,1]*a[2,2]*a[3,3]+a[1,3]*a[2,1]*a[3,2]+a[3,1]*a[1,2]*a[2,3]-
    a[1,3]*a[2,2]*a[3,1]-a[1,1]*a[2,3]*a[3,2]-a[3,3]*a[1,2]*a[2,1];
end;
{function nmonth(s: string): integer;
  var i,j,k: integer;
  begin
    errmsg:=''; i:=pos('/',s); j:=FindStr('/',s,i+1);
    try k:=StrToInt(copy(s,i+1,j-i-1)); except k:=0; end;
    if not(k in [1..12]) then
      errmsg:='X©u '+s+' kh«ng ph¶i lµ kiÓu ngµy!';
    nmonth:=k;
  end;
function nyear(s: string): integer;
  var i,j,k: integer;
  begin
    errmsg:=''; i:=FindStr('/',s,pos('/',s)+1); j:=length(s);
    try k:=StrToInt(copy(s,i+1,j-i)); except k:=3000; end;
    if (k<1)or(k>2100) then
      errmsg:='N¨m trong x©u '+s+' ph¶i n»m trong kho¶ng [1..2100].';
    nyear:=k;
  end;
function nday(s: string): integer;
  var k,m,r: integer;
  begin
    errmsg:=''; k:=StrToInt(copy(s,1,pos('/',s)-1));
    case nmonth(s) of
      1,3,5,7,8,10,12: r:=31;
      4,6,9,11: r:=30;
      2: if nhuan(nyear(s))=0 then r:=28 else r:=29;
    end;
    if (errmsg<>'')or(k>r) then
      errmsg:='X©u '+s+' kh«ng ph¶i lµ kiÓu ngµy!'
    else nday:=k;
  end;
procedure ymd(s: string; var y,m,d: integer);
  var i,r: byte;
  begin
    errmsg:=''; i:=pos('/',s);
    try d:=StrToInt(copy(s,1,i-1)); delete(s,1,i);
    except errmsg:='X©u '+s+' kh«ng ph¶i lµ kiÓu ngµy!'; exit;
    end;
    i:=pos('/',s);
    try m:=StrToInt(copy(s,1,i-1)); delete(s,1,i);
    except m:=0;
    end;
    try y:=StrToInt(s);
    except y:=0;
    end;
    if not ((m in [1..12])and(y>=1)and(y<=2100)) then
      begin errmsg:='X©u '+s+' kh«ng ph¶i lµ kiÓu ngµy hoÆc kh«ng thuéc kho¶ng [1..2100].'; exit; end;
    case m of
      2: if nhuan(y)=0 then r:=28 else r:=29;
      4,6,9,11: r:=30
      else r:=31;
    end;
    if (d>r) then
      errmsg:='Ngµy trong ['+s+'] ph¶i n»m trong kho¶ng [1..'+IntToStr(r);
  end;
function eraday(s: string): integer;
  const
    b: array [0..1,1..12] of integer=
      ((0,31,59,90,120,151,181,212,243,273,304,334),
       (0,31,60,91,121,152,182,213,244,274,305,335));
  var
    y,m,d,q: integer; nh: byte;
    f1,f2: boolean;
  begin
    eraday:=0;
    ymd(s,y,m,d); if errmsg<>'' then exit;
    if y mod 100=0 then
      if y mod 400=0 then nh:=1 else nh:=0
    else
      if y mod 4=0 then nh:=1 else nh:=0;
    //f1=true neu d/m/y<4/10/1852
    f1:=(y<1852) or((y=1852) and ((m<10) or ((m=10) and (d<4))));
    //f2=true neu d/m/y<15/10/1852
    f2:=(y<1852) or((y=1852) and ((m<10) or ((m=10) and (d<15))));
    case y of
      1..4: q:=0;
      1701..1800: q:=12;
      1801..1900: q:=13;
      1901..2100: q:=14;
      else
        begin
          if f1 then q:=1
          else
            if f2 then
              begin q:=11; end
            else q:=11;
        end
    end;
    eraday:=365*(y-1)+(y-1) shr 4-q+b[nh,m]+d;
  end;
}

procedure assc(name: TStr255; value: extended);
  begin
    inc(AmountOfConst);
    aconst[AmountOfConst].kind:=kNum;
    aconst[AmountOfConst].name:=name;
    aconst[AmountOfConst].num:=value;
  end;

function toPart(s: string; k: byte): TPart;
  var
    num: Extended; code,i: integer; b: boolean; s2: string;
  begin
    //Neu la toan tu
    if k>0 then
      begin
        //Neu la kieu ngay
        if k=AmountOfOperator+1 then
          begin
            toPart.kind:=kDate; s2:=copy(s,2,length(s)-2);
            toPart.name:=s2;
            if (pos('/',s2)>0)or(pos(':',s2)>0) then //co the la kieu ngay?
              try toPart.num:=StrToDateTime(s2);
              except
                try toPart.num:=StrToDate(s2);
                except
                  try toPart.num:=StrToTime(s2);
                  except
                    toPart.kind:=kStr;
                  end;
                end;
              end
            else
              toPart.kind:=kStr;
          end {if}
        else //Neu la toan tu
          toPart.Kind:=kOpr; toPart.AOpr:=k;
        exit;
      end;

    //Neu la hang so hoac toan hang
    if (s[1] in ['0'..'9']) then
      begin
        val(s,num,code);
        if code>0 then
          begin
            errmsg:='Kh«ng hiÓu "'+s+'" lµ g×!'; toPart.Kind:=kStr;
            if dangve then
              begin grok:=false; grerr:=errmsg; end
            else
            begin
              inc(cwar);
              war[cwar]:=IntToStr(cwar)+') Chó ý: Tªn c¸c h»ng sè ph¶i chÝnh x¸c c¶ vÒ viÖc viÕt ch÷ hoa hay ch÷ th­êng';
            end;
          end
        else
          begin toPart.Kind:=kNum; toPart.Num:=num; end;
        exit;
      end;

    s2:=UpperStr(s);
    if s='T' then
      begin toPart.Kind:=kBool; toPart.num:=1; toPart.Bool:=True; end
    else
    if s='F' then
      begin toPart.Kind:=kBool; toPart.num:=0; toPart.Bool:=False; end
    else
    if s2='CDATE' then
      begin toPart.Kind:=kDate; toPart.Num:=date; toPart.name:=DateToStr(date); end
    else
    if s2='CTIME' then
      begin toPart.Kind:=kDate; toPart.Num:=time; toPart.name:=TimeToStr(time); end
    else
    if s2='CDATETIME' then
      begin
        toPart.Kind:=kDate; Num:=date+time; toPart.num:=num;
        toPart.name:=DateTimeToStr(Num);
      end
    else

    //Neu la bien so
    if (s='x')or(s='y') then
      begin toPart:=CVar; toPart.Kind:=kVar; end
    else

    //Neu la tham so
    if s='m' then
      begin toPart.Kind:=kParam; toPart.Name:='m'; toPart.Num:=1; end
    else

    //Neu la xau ki tu
    if (s[1]='''')and(s[length(s)]='''') then
      begin
        toPart.Kind:=kStr; toPart.Name:=copy(s,2,length(s)-2);
      end
    else
      begin
        b:=false; //xem co phai la hang so khong?
        for i:=1 to AmountOfConst do
          if s=aconst[i].name then begin b:=true; break; end;
        if b then //neu la hang so
          begin
            toPart.kind:=aconst[i].kind;
            toPart.num:=aconst[i].num;
            toPart.name:=aconst[i].s;
            toPart.t:=aconst[i].t;
            toPart.m:=aconst[i].m;
            toPart.Bool:=aconst[i].Bool;
          end
        else
          //Neu chang phai la gi ca
          begin
            errmsg:='Kh«ng hiÓu "'+s+'" lµ g×!'; toPart.Kind:=kStr;
            if dangve then
              begin grok:=false; grerr:=errmsg; end
            else
            begin
              inc(cwar);
              war[cwar]:=IntToStr(cwar)+') Chó ý: Tªn c¸c h»ng sè ph¶i chÝnh x¸c c¶ vÒ viÖc viÕt ch÷ hoa hay ch÷ th­êng';
            end;
          end;
      end;
  end;

{
Phan tich xau s ra, thanh mang prefix chua cac phan tu tong quat TPart.
Dong thoi kiem tra tinh hop le cua xau s.
Sau do doi sang ki phap nghich dao Ba lan
tham so ChoDaoHam=true de chi ra rang, phan tich dung de dung cho viec tinh dao ham
Neu khong, phan tich de tinh bieu thuc.  
}
procedure analyse(var s: string; ChoDaoHam: boolean);
  var
    count: integer;//so luong cac toan hang va toan tu phan tich duoc trong prefix
    mark: array [1..32000] of integer; //danh dau cac vi tri xuat hien toan tu
    s2: string;
    next1: boolean;
    i,j,p,l: integer;
    stack: array [0..1000] of byte; //stack danh cho toan tu
    sp: integer; //con tro stack
    p1,p2: byte; //vi tri 2 toan tu '(',')' trong mang opr
  begin
    sufcount:=0;
    //Kiem tra xem xau s co rong khong?
    if s='' then
      begin errmsg:='BiÓu thøc rçng!'; grOk:=False; exit; end
    else errmsg:='';

    //kiem tra dau mo ngoac, dong ngoac co hop le khong?
    j:=0;
    for i:=1 to length(s) do
      begin
        if s[i]='(' then inc(j)
        else
          if s[i]=')' then dec(j);
        if j<0 then
          begin
            errmsg:='Thõa dÊu ")" ë vÞ trÝ thø '+inttostr(i)+' trong biÓu thøc!';
            grOk:=False; exit;
          end;
      end;
    if j>0 then
      begin errmsg:='ThiÕu '+IntToStr(abs(j))+' dÊu ")"!'; grOk:=False; exit; end;

    //Kiem tra va danh dau '[',']'
    FillChar(mark,SizeOf(mark),0);
    if (pos('[[',s)>0)or(pos(']]',s)>0) then
      begin errmsg:='Kh«ng ®­îc ®Æt c¸c dÊu "[" hay "]" liÒn nhau!'; exit; end;
    p:=pos('[',s);
    if p>0 then
      begin
        while p>0 do
          begin
            j:=findStr(']',s,p+1);
            if j=0 then begin errmsg:='ThiÕu dÊu "]"!'; exit; end;
            p:=findStr('[',s,j+1);
          end;
        if findStr(']',s,j+1)>0 then begin errmsg:='Thõa dÊu "]"'; exit; end;
        p:=AmountOfOperator+1; j:=0;
        for i:=1 to length(s) do
          begin
            if s[i]='[' then begin mark[i]:=p; j:=p; end
            else
            if s[i]=']' then begin mark[i]:=p; j:=0; end
            else
            mark[i]:=j;
          end;
      end;

    //xoa toan bo space trong xau.
    l:=length(s); p:=0;
    while p<l do
    begin
      inc(p);
      while (s[p]=' ')and(mark[p]=0) do //khong xoa ki tu space trong dau [ ]
        begin
          delete(s,p,1);
          for i:=p to length(s) do mark[i]:=mark[i+1]; //don lai mark
          dec(l);
        end;
    end;

    //Kiem tra cac phep tru 1 ngoi (A 0151).
    if s[1]='-' then s[1]:='—'; //neu dau '-' xuat hien dau tien thi la dau '-' 1 ngoi.
    p:=1; p:=FindStr('-',s,p);
    //tim vi tri tat ca cac dau tru.
    if p>0 then {???}
    while p>0 do
      begin
        //kiem tra xem truoc dau '-' co phai la toan tu khong?
        next1:=false; //next1 la ket qua viec kiem tra.
        for i:=AmountOfOperator downto 1 do 
          if (opr[i].name<>')')and(opr[i].name<>']') then {khong tinh toan tu ')'&']'}
            begin
              l:=length(opr[i].name);
              if l<p then
              begin
                //s2 la xau ki tu phia truoc dau '-' tim thay trong s.
                s2:=copy(s,p-l,l);
                if (s2=opr[i].name)and(s2<>'<') then begin next1:=true; break; end;
              end
              else
                Break;
            end;
        //neu truoc dau '-' la toan tu thi la '-' 1 ngoi.
        if next1 then s[p]:='—'; //thay the phep'-' 2 ngoi bang phep '—' 1 ngoi.
        //tiep tuc tim kiem dau '-' tiep theo.
        p:=FindStr('-',s,p+1);
      end;

    //Tien hanh phan tach xau S.
    //Buoc 1: Danh dau cac vi tri xuat hien toan tu.
    {VD:    3*sin12+4
    -> mark(0xyyy00z0) x,y,z.. la cac chi so cua toan tu}
    for i:=1 to AmountOfOperator do
    begin
      if (opr[i].name<>'[') and (opr[i].name<>']') then //khong danh dau cac "[","]"
      begin
        l:=length(opr[i].name);
        p:=1; p:=FindStr(opr[i].name,s,p);
        if p>0 then {???}
        while p>0 do
          begin
            //truong hop viet la 3E-5 thi dau tru khong phai la toan tu
            if (opr[i].name<>'-')and(opr[i].name<>'+') or (s[p-1]<>'E') then
            begin
              //Neu mark[p]>0 thi xay ra truong hop toan tu nay bao ham toan tu khac
              if mark[p]=0 then
                for j:=p to p+l-1 do mark[j]:=i;
            end;
            //Tim toan tu i tiep theo cho den khi khong tim thay thi thoi
            p:=FindStr(opr[i].name,s,p+l);
          end
      end;
    end;
    //Buoc 2: Phan tach cac thanh phan tong quat.
    //tim vi tri 2 toan tu '(',')'
    p1:=0; p2:=0;
    for i:=1 to AmountOfOperator do
      if opr[i].name='(' then p1:=i
      else
        if opr[i].name=')' then p2:=i;
    i:=1; l:=length(s);
    count:=0;
    while i<=l do {for???}
      begin
        {Vi cac toan tu ngoac co the xep len nhau VD '(((', gay danh dau nham
        -> phai tach rieng truong hop gap dau ngoac ra}
        if (s[i]=')')or(s[i]='(') then
          begin
            inc(count); prefix[count].kind:=kOpr;
            if s[i]='(' then prefix[count].AOpr:=p1 else prefix[count].AOpr:=p2;
          end
        else
          begin
            j:=i;
            while mark[i]=mark[i+1] do inc(i);
            inc(count); prefix[count]:=toPart(copy(s,j,i-j+1),mark[j]);
            if errmsg<>'' then begin count:=0; break; end;
          end;
        inc(i);
      end;

    //Doi mang prefix sang ky phap nghich dao Balan
    FillChar(stack,sizeOf(stack),0); sp:=0;
    //truong hop rieng dau tru 1 ngoi truoc 1 so
    if (prefix[1].kind=kOpr)and(opr[prefix[1].AOpr].name='—')and
       (not (prefix[2].kind in [kStr,kOpr]))
    then
      begin
        if prefix[2].kind=kBool then
          begin
            suffix[1].kind:=kBool; suffix[1].bool:=not prefix[2].bool;
            if suffix[1].bool then suffix[1].num:=1 else suffix[1].num:=0;
          end
        else
          begin
            suffix[1].kind:=prefix[2].kind;
            suffix[1].num:=-prefix[2].num;
            if prefix[2].kind=kFrac then
              begin
                suffix[1].t:=-prefix[2].t;
                suffix[1].m:=prefix[2].m;
              end;
          end;
        j:=1;
        if (prefix[3].kind=kOpr)and(opr[prefix[3].Aopr].name='!') then
          begin
            i:=3; suffix[1].kind:=prefix[2].kind;
            suffix[1].num:=-giaithua(round(prefix[2].num));
          end
        else
          i:=2;
      end
    else
      begin j:=0; i:=0; end;

    while i<count do
      begin
        inc(i);
        if prefix[i].kind=kOpr then
          begin
            l:=prefix[i].AOpr;
            if opr[l].name='(' then begin inc(sp); stack[sp]:=l; end
            else
            if sp>0 then //neu stack khong rong
              begin
                if (opr[l].name=')')or(opr[l].name=',') then
                  begin
                    while opr[stack[sp]].name<>'(' do
                      begin
                        inc(j); suffix[j].kind:=kOpr;
                        suffix[j].AOpr:=stack[sp]; dec(sp); {pop(suffix[j])}
                      end;
                    if opr[l].name<>',' then
                      begin
                        dec(sp); {bo dau '(' ra khoi stack}
                        //neu toan tu sau '(' la 1 toan tu ham thi bo luon ra
                        if (sp>0) and opr[stack[sp]].func then
                          begin
                            inc(j); suffix[j].kind:=kOpr;
                            suffix[j].AOpr:=stack[sp]; dec(sp);
                          end;
                      end;
                    //neu gap dau tru 1 ngoi thi bo ra luon
                    if opr[stack[sp]].name='—' then
                      begin
                        inc(j); suffix[j].kind:=kOpr;
                        suffix[j].AOpr:=stack[sp]; dec(sp);
                      end;
                  end
                else
                  begin
                    //Neu tim dao ham thi phai xet nhung phep tinh co do uu tien thap hon truoc
                    if ChoDaoHam then
                      while(sp>0)and(opr[l].weight>=opr[stack[sp]].weight)do
                      begin
                        inc(j); suffix[j].kind:=kOpr;
                        suffix[j].AOpr:=stack[sp]; dec(sp); {pop(suffix[j])}
                      end
                    else //Neu tinh bieu thuc thi giu nguyen gia tri uu tien
                      while(sp>0)and(opr[l].weight<=opr[stack[sp]].weight)do
                      begin
                        inc(j); suffix[j].kind:=kOpr;
                        suffix[j].AOpr:=stack[sp]; dec(sp); {pop(suffix[j])}
                      end;
                    inc(sp); stack[sp]:=l; {push(l)}
                  end;
              end
            else //Neu stack rong
              begin inc(sp); stack[sp]:=l; {push(l)} end;
          end
        else //neu la toan hang thi cho vao suffix luon.
          begin inc(j); suffix[j]:=prefix[i]; end;
      end;

    //xuat tat ca nhung thu con lai trong stack
    for i:=sp downto 1 do
      begin inc(j); suffix[j].kind:=kOpr; suffix[j].AOpr:=stack[i]; end;

    {//Buoc 3: xoa toan tu ',' co tac dung ngan cach.
    i:=1;
    while i<=count do
      begin
        if (prefix[i].kind=kOpr)and(opr[prefix[i].AOpr].name=',') then
          begin
            dec(count);
            for j:=i to count do prefix[j]:=prefix[j+1];
            dec(i);
          end;
        inc(i);
      end;}

    precount:=count; sufcount:=j;
  end;

procedure DelPart(n: integer); var i: integer;
  begin dec(sufcount); for i:=n to sufcount do suffix[i]:=suffix[i+1]; end;
{
*** Tinh toan bieu thuc va kiem tra loi
}

function NormalCalc: TPart;
  function toStr(x: TPart): String;
  begin
    with x do
    case kind of
      kBool: if Bool then toStr:='T' else toStr:='F';
      kFrac: toStr:=IntToStr(t)+':'+IntToStr(m);
      kVar,kParam,kNum: toStr:=FloatToStr(num);
      else
      toStr:=name;
    end;
  end;
  var
    stack: array [0..1000] of TPart;
    p1,p2,p3,p4: TPart;
    sp,i: integer;
    t1,t2: integer;
    tmp1,tmp2: extended;
    toantu,s: string;
    d1: TDateTime;
  begin
    sp:=0; errmsg:=''; i:=0; d1:=0; grerr:=''; grok:=true; cwar:=0;
    while i<sufcount do
      begin
        inc(i);

        if (suffix[i].kind<>kOpr) then
          begin
            inc(sp); stack[sp]:=suffix[i];
            if (suffix[i].kind in [kStr,kBool])and(grerr='') then
              grerr:='Ph­¬ng tr×nh ®Ó vÏ ®å thÞ kh«ng ®­îc chøa kiÓu x©u hay kiÓu logic!'
          end
        else
          begin
          toantu:=opr[suffix[i].AOpr].name;

          if (toantu=':') then
            begin
              if grerr='' then
              begin
                grok:=false; grerr:='To¸n tö ":" kh«ng ®­îc sö dông trong biÓu thøc vÏ ®å thÞ!';
              end;
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                 (p2.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                 (frac(p1.num)=0) and (frac(p2.num)=0) then
              begin
                {$Q+}
                t1:=trunc(p2.num); t2:=trunc(p1.num);
                if t2=0 then
                  begin errmsg:='MÉu sè trong phÐp ":" ph¶i kh¸c 0.'; exit; end;
                rutgon(t1,t2); p3.t:=t1; p3.m:=t2; p3.num:=t1/t2;
                if t2=1 then
                  if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar
                  else p3.kind:=kNum
                else p3.kind:=kFrac;
                {$Q-}
              end
              else
                errmsg:='Tö sè vµ mÉu sè trong to¸n h¹ng ":" ph¶i lµ sè nguyªn!'
            end
          else

          if (toantu='+') then {*}
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kFrac)and(p2.kind=kFrac) then
                  begin
                    t1:=(p1.m*p2.m) div ucln(p1.m,p2.m);
                    p3.t:=p1.t*t1 div p1.m + p2.t*t1 div p2.m; p3.m:=t1;
                    p3.num:=p3.t/p3.m;
                    if p3.m<0 then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if (frac(p3.num)=0) then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p1.kind=kFrac)and(p2.kind in [kNum,kVar,kParam,kDate])and(frac(p2.num)=0))then
                  begin
                    p3.t:=p1.t+round(p2.num)*p1.m; p3.m:=p1.m; p3.num:=p3.t/p3.m;
                    if (p3.m<0) then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p2.kind=kFrac)and(p1.kind in [kNum,kVar,kParam,kDate])and(frac(p1.num)=0)) then
                  begin
                    p3.t:=p2.t+round(p1.num)*p2.m; p3.m:=p2.m; p3.num:=p3.t/p3.m;
                    if (p3.m<0) then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                   (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    p3.num:=p1.num+p2.num;
                    if (p1.kind=kDate) or (p2.kind=kDate) then
                      begin
                        p3.kind:=kDate;
                        try p3.name:=DateTimeToStr(p3.num);
                        except
                          try p3.name:=DateToStr(p3.num);
                          except
                            try p3.name:=TimeToStr(p3.num);
                            except
                              errmsg:='Kh«ng ®æi ®­îc gi¸ trÞ '+FloatToStr(p3.num)+'cña phÐp "+" sang kiÓu ngµy/giê';
                            end;
                          end;
                        end;
                      end {if}
                    else
                      if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                  end
                else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool or p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: PhÐp "+" 2 to¸n tö kiÓu Logic t­¬ng ®­¬ng víi phÐp "or".';
                  end
                else
                if (p1.kind in [kStr,kDate])or(p2.kind in [kStr,kDate]) then
                  begin p3.kind:=kStr; p3.name:=toStr(p2)+toStr(p1); end
                else errmsg:='Hai to¸n h¹ng cña phÐp "+" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='-') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kFrac)and(p2.kind=kFrac) then
                  begin
                    p3.kind:=kFrac; t1:=(p1.m*p2.m) div ucln(p1.m,p2.m);
                    p3.t:=p2.t*t1 div p2.m-p1.t*t1 div p1.m; p3.m:=t1;
                    p3.num:=p3.t/p3.m;
                    if p3.m<0 then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p1.kind=kFrac)and(p2.kind in [kNum,kVar,kParam,kDate])and(frac(p2.num)=0))then
                  begin
                    p3.t:=round(p2.num)*p1.m-p1.t; p3.m:=p1.m; p3.num:=p3.t/p3.m;
                    if (p3.m<0) then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p2.kind=kFrac)and(p1.kind in [kNum,kVar,kParam,kDate])and(frac(p1.num)=0)) then
                  begin
                    p3.t:=round(p1.num)*p2.m-p2.t; p3.m:=p2.m; p3.num:=p3.t/p3.m;
                    if (p3.m<0) then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    p3.num:=p2.num-p1.num;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                  end
                else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool and p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: PhÐp "-" 2 to¸ tö Logic t­¬ng ®­¬ng víi phÐp "and".';
                  end
                else errmsg:='Hai to¸n h¹ng cña phÐp "-" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='*') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kFrac)and(p2.kind=kFrac) then
                  begin
                    p3.kind:=kFrac; p3.t:=p2.t*p1.t; p3.m:=p2.m*p1.m;
                    t1:=ucln(p3.t,p3.m); p3.t:=p3.t div t1; p3.m:=p3.m div t1;
                    p3.num:=p3.t/p3.m;
                    if p3.m<0 then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p1.kind=kFrac)and(p2.kind in [kNum,kVar,kParam,kDate])and(frac(p2.num)=0))then
                  begin
                    p3.t:=round(p2.num)*p1.t; p3.m:=p1.m;
                    t1:=ucln(p3.t,p3.m); p3.t:=p3.t div t1; p3.m:=p3.m div t1;
                    p3.num:=p3.t/p3.m;
                    if p3.m<0 then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if ((p2.kind=kFrac)and(p1.kind in [kNum,kVar,kParam,kDate])and(frac(p1.num)=0)) then
                  begin
                    p3.t:=round(p1.num)*p2.t; p3.m:=p2.m;
                    t1:=ucln(p3.t,p3.m); p3.t:=p3.t div t1; p3.m:=p3.m div t1;
                    p3.num:=p3.t/p3.m;
                    if p3.m<0 then begin p3.t:=-p3.t; p3.m:=-p3.m; end;
                    if frac(p3.num)=0 then p3.kind:=kNum else p3.kind:=kFrac;
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar;
                  end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p1.num*p2.num; stack[sp]:=p3; end
                else
                  if (p1.kind=kBool) and (p2.kind=kBool) then
                    begin
                      p3.kind:=kBool; p3.Bool:=p1.Bool xor p2.Bool;
                      if p3.bool then p3.num:=1 else p3.num:=0;
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: PhÐp "*" 2 to¸n tö kiÓu Logic t­¬ng ®­¬ng víi phÐp "xor".';
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "*" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='/') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                      begin errmsg:='BiÓu thøc sau phÐp "/" b»ng 0.'; grok:=p1.kind=kVar; end
                    else
                      begin
                        if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p2.num/p1.num; stack[sp]:=p3;
                      end;
                  end
                else
                  if (p1.kind=kBool) and (p2.kind=kBool) then
                    begin
                      p3.kind:=kBool; p3.Bool:=not (p1.Bool xor p2.Bool);
                      if p3.bool then p3.num:=1 else p3.num:=0;
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Logic1/Logic2 t­¬ng ®­¬ng not(Logic1 xor Logic2)';
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "/" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='abs') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if p1.kind=kFrac then
                      begin p3.kind:=kFrac; p3.t:=abs(p1.t); p3.m:=abs(p1.m); end
                    else if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                    p3.num:=abs(p1.num); end
                else
                  if (p1.kind=kBool) and (p2.kind=kBool) then
                    begin
                      p3.kind:=kBool; p3.Bool:=true; p3.num:=1;
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Hµm "abs" víi tham sè lµ biÓu thøc Logic cho kÕt qu¶ lµ kiÓu Logic víi gi¸ trÞ lµ T';
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "*" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='^') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kBool,kStr]) or (p2.kind in [kBool,kStr]) then
                  errmsg:='To¸n h¹ng cña phÐp "^" kh«ng hîp lÖ!'
                else
                  begin
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                    {if p1.kind=kFrac then
                    begin
                      if p1.t<0 then tmp1:=1/exp(p1.num*ln(-p1.t))
                      else tmp1:=exp(p1.t*ln(p2.num));
                      if (tmp1<0)and(not odd(p1.m)) then
                        errmsg:='Kh«ng thùc hiÖn ®­îc phÐp "^"!'
                      else
                      if tmp1<0 then p3.num:=1/exp(-p2.num*ln(tmp1))
                      else p3.num:=exp(p2.num*ln(tmp1))
                    end
                    else}
                    if (p2.num<0)and(p1.num<>0) then
                    begin
                      tmp1:=1/p1.num;
                      t1:=trunc(tmp1);
                      if (frac(tmp1)=0)and(not odd(t1)) then
                      begin
                        errmsg:='Kh«ng thùc hiÖn ®­îc phÐp "^"!';
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') Nguyªn nh©n lçi: C¬ sè ©m mµ sè mò l¹i cã d¹ng lµ c¨n bËc ch½n; VD: (-3)^(1/2) hay (-3)^(1/4)';
                        if grerr='' then grerr:='C¬ sè cña phÐp "^" ph¶i d­¬ng!';
                      end
                      else
                      begin
                        if frac(tmp1)=0 then
                          if odd(t1) then t2:=-1 else t2:=1
                        else
                        if frac(p1.num)=0 then
                          if odd(trunc(p1.num)) then t2:=-1 else t2:=1
                        else
                        begin
                          errmsg:='Kh«ng thùc hiÖn ®­îc phÐp "^"!';
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') Nguyªn nh©n lçi: Khi c¬ sè ©m, sè mò ph¶i cã d¹ng n hoÆc (1/n) víi n lµ sè nguyªn';
                          t2:=0;
                        end;
                        p3.num:=t2*exp(p1.num*ln(-p2.num));
                      end;
                    end
                    else
                    if p2.num=0 then p3.num:=0
                    else
                      p3.num:=exp(p1.num*ln(p2.num));
                  end;
            end
          else

          if (toantu='below') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  if p1.num<p2.num then p3:=p1 else p3:=p2
                else
                if (p1.kind in [kStr,kDate])and(p2.kind in [kStr,kDate]) then
                  if p1.name<p2.name then p3:=p1 else p3:=p2
                else
                  errmsg:='Tham sè hµm "below" kh«ng hîp lÖ!'
            end
          else

          if (toantu='above') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  if p1.num>p2.num then p3:=p1 else p3:=p2
                else
                if (p1.kind in [kStr,kDate])and(p2.kind in [kStr,kDate]) then
                  if p1.name>p2.name then p3:=p1 else p3:=p2
                else
                  errmsg:='Tham sè hµm "above" kh«ng hîp lÖ!'
            end
          else

          if (toantu='div') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                    begin
                      errmsg:='BiÓu thøc sau phÐp "div" b»ng 0.'; grOk:=p1.kind=kVar;
                    end
                    else
                      begin
                        t1:=0;
                        if frac(p2.num)<>0 then inc(t1);
                        if frac(p1.num)<>0 then inc(t1);
                        if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                        p3.num:=round(p2.num) div round(p1.num);
                        if t1>0 then
                        begin
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "div" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                        end;
                      end;
                  end
                else
                  errmsg:='To¸n h¹ng cña phÐp "div" kh«ng hîp lÖ!';
            end
          else

          if (toantu='mod') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                      begin errmsg:='BiÓu thøc sau phÐp "mod" b»ng 0.'; grOk:=p1.kind=kVar; end
                    else
                      begin
                        t1:=0;
                        if frac(p2.num)<>0 then inc(t1);
                        if frac(p1.num)<>0 then inc(t1);
                        if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                        p3.num:=round(p2.num) mod round(p1.num);
                        if t1>0 then
                        begin
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "mod" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                        end;
                      end;
                  end
                else
                  errmsg:='To¸n h¹ng cña phÐp "mod" kh«ng hîp lÖ!';
            end
          else

          if (toantu='and') then
            begin
              if grerr='' then
                grerr:='To¸n tö "and" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool and p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Cã thÓ dïng phÐp "-" thay v× phÐp "and" 2 to¸n h¹ng kiÓu Logic';
                  end
                else
                  if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                      (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                  then
                    begin
                      t1:=0;
                      if frac(p2.num)<>0 then inc(t1);
                      if frac(p1.num)<>0 then inc(t1);
                      p3.num:=round(p2.num) div round(p1.num);
                      if t1>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "and" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      p3.kind:=kNum; p3.num:=round(p2.num) and round(p1.num);
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "and" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='or') then
            begin
              if grerr='' then
                grerr:='To¸n tö "or" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool or p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Cã thÓ dïng phÐp "+" thay v× phÐp "or" 2 to¸n h¹ng kiÓu Logic';
                  end
                else
                  if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                      (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                  then
                    begin
                      t1:=0;
                      if frac(p2.num)<>0 then inc(t1);
                      if frac(p1.num)<>0 then inc(t1);
                      p3.kind:=kNum; p3.num:=round(p2.num) div round(p1.num);
                      if t1>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "or" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;      
                      p3.kind:=kNum; p3.num:=round(p2.num) or round(p1.num);
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "or" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='xor') then
            begin
              if grerr='' then
                grerr:='To¸n tö "xor" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool xor p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Cã thÓ dïng phÐp "*" thay v× phÐp "xor" 2 to¸n h¹ng kiÓu Logic';
                  end
                else
                  if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                      (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                  then
                    begin
                      t1:=0;
                      if frac(p2.num)<>0 then inc(t1);
                      if frac(p1.num)<>0 then inc(t1);
                      p3.kind:=kNum; p3.num:=round(p2.num) div round(p1.num);
                      if t1>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "xor" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      p3.kind:=kNum; p3.num:=round(p2.num) xor round(p1.num);
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "xor" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='->') then
            begin
              if grerr='' then
                grerr:='To¸n tö "->" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=(not p2.Bool) or p1.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                  end
                else
                  if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                      (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                  then
                    begin
                      t1:=0;
                      if frac(p2.num)<>0 then inc(t1);
                      if frac(p1.num)<>0 then inc(t1);
                      p3.kind:=kNum; p3.num:=round(p2.num) div round(p1.num);
                      if t1>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "->" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      p3.kind:=kNum; p3.num:=not(round(p2.num)) or round(p1.num);
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "->" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='<->') then
            begin
              if grerr='' then
                grerr:='To¸n tö "<->" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool;
                    p3.Bool:=(not p1.Bool or p2.Bool)and(not p2.Bool or p1.Bool);
                    if p3.bool then p3.num:=1 else p3.num:=0;
                  end
                else
                  if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                      (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                  then
                    begin
                      t1:=0;
                      if frac(p2.num)<>0 then inc(t1);
                      if frac(p1.num)<>0 then inc(t1);
                      p3.kind:=kNum; p3.num:=round(p2.num) div round(p1.num);
                      if t1>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                            ' to¸n h¹ng cña phÐp "<->" kh«ng nguyªn nªn  ®­îc tù ®éng lµm trßn';
                      end;
                      p3.kind:=kNum; t1:=round(p1.num); t2:=round(p2.num);
                      p3.num:=(not t1 or t2)and(not t2 or t1);
                    end
                  else errmsg:='Hai to¸n h¹ng cña phÐp "<->" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='>') then
            begin
              if grerr='' then
                grerr:='To¸n tö ">" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) and (p2.kind=kStr) then
                begin
                  p3.kind:=kBool;
                  if p2.name>p1.name then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) and
                   (p2.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) then
                begin
                  p3.kind:=kBool;
                  if p2.num>p1.num then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                errmsg:='Hai to¸n h¹ng cña phÐp ">" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='>=') then
            begin
              if grerr='' then
                grerr:='To¸n tö ">=" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) and (p2.kind=kStr) then
                begin
                  p3.kind:=kBool;
                  if p2.name>=p1.name then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) and
                   (p2.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) then
                begin
                  p3.kind:=kBool;
                  if p2.num>=p1.num then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                errmsg:='Hai to¸n h¹ng cña phÐp ">=" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='<') then
            begin
              if grerr='' then
                grerr:='To¸n tö "<" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) and (p2.kind=kStr) then
                begin
                  p3.kind:=kBool;
                  if p2.name<p1.name then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) and
                   (p2.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) then
                begin
                  p3.kind:=kBool;
                  if p2.num<p1.num then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                errmsg:='Hai to¸n h¹ng cña phÐp "<" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='<=') then
            begin
              if grerr='' then
                grerr:='To¸n tö "<=" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) and (p2.kind=kStr) then
                begin
                  p3.kind:=kBool;
                  if p2.name<=p1.name then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) and
                   (p2.kind in [kNum,kVar,kParam,kDate,kFrac,kBool]) then
                begin
                  p3.kind:=kBool;
                  if p2.num<=p1.num then begin p3.bool:=true; p3.num:=1; end
                  else begin p3.bool:=false; p3.num:=0; end
                end
                else
                errmsg:='Hai to¸n h¹ng cña phÐp "<=" kh¸c lo¹i nhau!';
            end
          else

          if (toantu='not') then
            begin
              if grerr='' then
                grerr:='To¸n tö "not" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=not p1.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Cã thÓ dïng phÐp "-" thay v× phÐp "not" 1 to¸n h¹ng kiÓu Logic';
                  end
                else
                  begin
                    if frac(p1.num)<>0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: To¸n h¹ng cña phÐp "not" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                    end;
                    p3.kind:=kNum; p3.num:=(not round(p1.num));
                  end
            end
          else

          if (toantu='if') then
            begin
              if grerr='' then
                grerr:='Hµm "if" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp]; dec(sp); p4:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if p4.kind=kBool then
                if p4.bool then p3:=p2 else p3:=p1
              else
                errmsg:='Tham sè thø nhÊt cña hµm "if" ph¶i lµ kiÓu Logic!';
            end
          else

          if (toantu='—') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if (p1.kind=kVar)then p3.kind:=kVar else p3.kind:=kNum;
                    p3.num:=-p1.num;
                  end
                else
                  begin
                    p3.kind:=kBool; p3.Bool:=not p1.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M¸ch n­íc: Cã thÓ dïng phÐp "not" thay v× phÐp "-" 1 to¸n h¹ng kiÓu Logic';
                  end;
            end
          else

          if (toantu='exp') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                    p3.num:=exp(p1.num);
                  end
                else
                  errmsg:='Tham sè cña hµm "exp" kh«ng hîp lÖ!'
            end
          else

          if (toantu='ln') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  if p1.num<=0 then
                    begin errmsg:='Tham sè hµm "ln" kh«ng du¬ng!'; grOk:=p1.kind=kVar; end
                  else
                    begin if (p1.kind=kVar)then p3.kind:=kVar else p3.kind:=kNum; p3.num:=ln(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "ln" kh«ng hîp lÖ!';
            end
          else

          if (toantu='log') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  if p1.num<=0 then
                    begin
                      errmsg:='Tham sè hµm "log" kh«ng du¬ng!';
                      grOk:=p1.kind=kVar;
                    end
                  else
                    begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=ln(p1.num)/ln10val; end
                else
                  errmsg:='Tham sè cña hµm "log" kh«ng hîp lÖ!';
            end
          else

          if (toantu='lg') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if (p1.num>0)and(p2.num>0) then
                      begin
                        tmp1:=ln(p1.num); tmp2:=ln(p2.num);
                        if tmp2<>0 then
                          begin if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=tmp1/tmp2; end
                        else
                          begin
                            errmsg:='C¬ sè trong hµm "lg" bµng 1.'; grok:=p2.kind=kVar;
                          end;
                      end
                    else
                      begin
                        errmsg:='Hai biÓu thøc trong hµm "lg" ph¶i d­¬ng!';
                        grok:=((p2.kind=kVar)and(p1.kind=kNum))
                          or ((p1.kind=kVar)and(p2.kind=kNum));
                      end;
                  end
                else
                  errmsg:='Tham sè cña hµm "lg" kh«ng hîp lÖ!';
            end
          else

          if (toantu='arn') then
            begin
              if grerr='' then
                grerr:='Hµm "arn" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!'
              else
              if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
              then
                begin
                  t1:=0;
                  if (frac(p1.num)<>0) or (p1.num<0) then inc(t1);
                  if (frac(p2.num)<>0) or (p2.num<0) then inc(t1);
                  if t1>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                        ' to¸n h¹ng cña hµm "arn" ®­îc tù ®éng lµm trßn hoÆc ®æi dÊu thµnh d­¬ng';
                  end;
                  t1:=abs(round(p1.num)); t2:=abs(round(p2.num));
                  if t2>t1 then errmsg:='Trong hµm "arn" tham sè thø 1 (r) ph¶i nhá h¬n tham sè thø 2 (n).'
                  else
                    begin
                      p3.kind:=kNum; p3.num:=1;
                      for t1:=round(p1.num) downto round(p1.num)-round(p2.num)+1 do
                        p3.num:=p3.num*t1;
                    end;
                end
              else
                errmsg:='Hai tham sè cña hµm "arn" ph¶i lµ sè nguyªn d­¬ng vµ tham sè thø 1 (r) ph¶i nhá h¬n tham sè thø 2 (n).';
            end
          else

          if (toantu='crn') then
            begin
              if grerr='' then
                grerr:='Hµm "crn" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!'
              else
              if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
              then
                begin
                  t1:=0;
                  if (frac(p1.num)<>0) or (p1.num<0) then inc(t1);
                  if (frac(p2.num)<>0) or (p2.num<0) then inc(t1);
                  if t1>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                        ' to¸n h¹ng cña hµm "crn" ®­îc tù ®éng lµm trßn hoÆc ®æi dÊu thµnh d­¬ng';
                  end;
                  t1:=abs(round(p1.num)); t2:=abs(round(p2.num));
                  if t2>t1 then errmsg:='Trong hµm "crn" tham sè thø 1 (r) ph¶i nhá h¬n tham sè thø 2 (n).'
                  else
                    begin
                      p3.kind:=kNum;
                      p3.num:=giaithua(t1)/(giaithua(t1-t2)*giaithua(t2));
                    end;
                end
              else
                errmsg:='Hai tham sè cña hµm "crn" ph¶i lµ sè nguyªn d­¬ng vµ tham sè thø 1 (r) ph¶i nhá h¬n tham sè thø 2 (n).';
            end
          else

          if (toantu='sinh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sinh(p1.num); end
            else
            errmsg:='Tham sè cña hµm "sinh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='cosh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cosh(p1.num); end
            else
            errmsg:='Tham sè cña hµm "cosh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='tgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=tanh(p1.num); end
            else
            errmsg:='Tham sè cña hµm "tgh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='cotgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if p3.num<>0 then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=coth(p1.num); end
              else
              begin
                errmsg:='Tham sè cña hµm "cotgh" ph¶i kh¸c 0';
                grok:=p1.kind=kVar;
              end
            else
            errmsg:='Tham sè cña hµm "cotgh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='arcsinh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arcsinh(p1.num); end
            else
            errmsg:='Tham sè cña hµm "arcsinh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='arccosh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if p1.num>=1 then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccosh(p1.num); end
              else
              begin
                errmsg:='Tham sè cña hµm "arccosh" ph¶i >=1';
                grok:=p1.kind=kVar;
              end
            else
              errmsg:='Tham sè cña hµm "arccosh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='arctgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if (p1.num>=-1)and (p1.num<=1) then
              begin
                if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arctanh(p1.num);
              end
              else
              begin
                grok:=p1.kind=kVar;
                errmsg:='Tham sè cña hµm "arctgh" ph¶i n»m trong kho¶ng [-1..1]'
              end
            else errmsg:='Tham sè cña hµm "arctgh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='arccotgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if (p1.num>=1)or(p1.num<=-1) then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccoth(p1.num); end
              else
                begin
                  errmsg:='Tham sè cña hµm "arccotgh" ph¶i kh¸c [-1..1]';
                  grok:=p1.kind=kVar;
                end
            else
            errmsg:='Tham sè cña hµm "arccotgh" kh«ng hîp lÖ!';
          end
          else

          if (toantu='sin') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sin(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "sin" kh«ng hîp lÖ!';
            end
          else

          if (toantu='cos') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cos(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "cos" kh«ng hîp lÖ!';
            end
          else

          if (toantu='tg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=cos(p1.num);
                    if tmp1=0 then
                      begin errmsg:='tg(pi/2+k*pi) kh«ng x¸c ®Þnh!'; grok:=p1.kind=kVar; end
                    else
                      begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sin(p1.num)/tmp1; end;
                  end
                else
                  errmsg:='Tham sè cña hµm "tg" kh«ng hîp lÖ!';
            end
          else

          if (toantu='cotg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=sin(p1.num);
                    if tmp1=0 then
                      begin errmsg:='cotg(k*pi) kh«ng x¸c ®Þnh!'; grok:=p1.kind=kVar; end
                    else
                      begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cos(p1.num)/tmp1; end;
                  end
                else
                  errmsg:='Tham sè cña hµm "cotg" kh«ng hîp lÖ!';
            end
          else

          if (toantu='arcsin') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=p1.num; //sin
                    if (tmp1<-1)or(tmp1>1) then
                      begin
                        errmsg:='Tham sè trong hµm "arcsin" kh«ng n»m trong kho¶ng [-1,1]';
                        grok:=p1.kind=kVar;
                      end
                    else
                      begin
                        if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arcsin(tmp1);
                      end;
                  end
                else
                  errmsg:='Tham sè cña hµm "arcsin" kh«ng hîp lÖ!';
            end
          else

          if (toantu='arccos') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=p1.num; //cos
                    if (tmp1<-1)or(tmp1>1) then
                      begin
                        errmsg:='Tham sè trong hµm "arccos" kh«ng n»m trong kho¶ng [-1,1]';
                        grok:=p1.kind=kVar;
                      end
                    else
                      begin
                        if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccos(tmp1);
                      end;
                  end
                else
                  errmsg:='Tham sè cña hµm "arccos" kh«ng hîp lÖ!';
            end
          else

          if (toantu='arctg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arctan(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "arctg" kh«ng hîp lÖ!';
            end
          else

          if (toantu='arccotg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccot(p1.num);
                  end
                else
                  errmsg:='Tham sè cña hµm "arccotg" kh«ng hîp lÖ!';
            end
          else

          if (toantu='sqrt') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if p1.num<0 then
                      begin errmsg:='Tham sè cña hµm "sqrt" ©m!'; grok:=p1.kind=kVar; end
                    else
                    begin
                      if (p1.kind=kFrac)and(frac(sqrt(p1.t))=0)and(frac(sqrt(p1.m))=0) then
                        begin
                          p3.kind:=kFrac; p3.t:=round(sqrt(p1.t));
                          p3.m:=round(sqrt(p1.m)); p3.num:=p3.t/p3.m;
                        end
                      else
                        begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sqrt(p1.num); end;
                    end;
                  end
                else
                  errmsg:='Tham sè cña hµm "sqrt" kh«ng hîp lÖ!';
            end
          else

          if (toantu='sqr') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sqr(p1.num); end
                else
                if (p1.kind=kFrac) then
                  begin p3.kind:=kFrac; p3.t:=sqr(p1.t); p3.m:=sqr(p1.m); p3.num:=sqr(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "sqr" kh«ng hîp lÖ!';
            end
          else

          if (toantu='round') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=round(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "round" kh«ng hîp lÖ!';
            end
          else

          if (toantu='trunc')or(toantu='floor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=trunc(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "trunc" hoÆc hµm "floor" kh«ng hîp lÖ!';
            end
          else

          if (toantu='ceiling') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=trunc(p1.num)+1; end
                else
                  errmsg:='Tham sè cña hµm "ceilling" kh«ng hîp lÖ!';
            end
          else

          if (toantu='dtor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p1.num*pi/180; end
                else
                  errmsg:='Tham sè cña hµm "dtor" kh«ng hîp lÖ!';
            end
          else

          if (toantu='rtod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p1.num*180/pi; end
                else
                  errmsg:='Tham sè cña hµm "rtod" kh«ng hîp lÖ!';
            end
          else

          if (toantu='gtod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoDeg(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "gtod" kh«ng hîp lÖ!';
            end
          else

          if (toantu='gtor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoRad(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "gtor" kh«ng hîp lÖ!';
            end
          else

          if (toantu='dtog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=DegtoGrad(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "dtog" kh«ng hîp lÖ!';
            end
          else

          if (toantu='rtog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=RadtoGrad(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "rtog" kh«ng hîp lÖ!';
            end
          else

          if (toantu='ctog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoGrad(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "ctog" kh«ng hîp lÖ!';
            end
          else

          if (toantu='rtoc') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=RadtoCycle(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "rtoc" kh«ng hîp lÖ!';
            end
          else

          if (toantu='ctod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoDeg(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "ctod" kh«ng hîp lÖ!';
            end
          else

          if (toantu='ctor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoRad(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "ctor" kh«ng hîp lÖ!';
            end
          else

           if (toantu='dtoc') then
             begin
               p1:=stack[sp];
               if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
               else
                 if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                   begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=DegtoCycle(p1.num); end
                 else
                   errmsg:='Tham sè cña hµm "dtoc" kh«ng hîp lÖ!';
             end
           else

           if (toantu='gtoc') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoCycle(p1.num); end
                else
                  errmsg:='Tham sè cña hµm "gtoc" kh«ng hîp lÖ!';
            end
          else

           if (toantu='!') then
            begin
              if grerr='' then
                grerr:='To¸n tö "!" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate]) then
                  begin
                    if frac(p1.num)<>0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: To¸n h¹ng thø cu¶ phÐp tÝnh "!" ®­îc tù ®éng lµm trßn';
                    end;
                    p3.kind:=kNum; t1:=round(p1.num);
                    tmp1:=1; for t2:=2 to t1 do tmp1:=tmp1*t2; p3.num:=tmp1;
                  end
                else
                  errmsg:='Tham sè cña to¸n tö "!" kh«ng hîp lÖ!';
            end
          else

          if (toantu='hex') then
            begin
              if grerr='' then
                grerr:='Hµm "hex" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';	
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(16,p1.name); end
                else
                  begin
                    errmsg:='Tham sè cña hµm "hex" ph¶i lµ x©u kÝ tù!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: hex(''FA00'')';
                  end;
            end
          else

          if (toantu='bin') then
            begin
              if grerr='' then
                grerr:='Hµm "bin" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(2,p1.name); end
                else
                  begin
                    errmsg:='Tham sè cña hµm "bin" ph¶i lµ x©u kÝ tù!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: bin(''101011'')';
                  end;
            end
          else

          if (toantu='oct') then
            begin
              if grerr='' then
                grerr:='Hµm "oct" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(8,p1.name); end
                else
                  begin
                    errmsg:='Tham sè cña hµm "oct" ph¶i lµ x©u kÝ tù!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: oct(''17624'')';
                  end;
            end
          else

          if (toantu='base') then
            begin
              if grerr='' then
                grerr:='Hµm "base" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if (p2.kind in [kNum,kVar,kParam,kDate]) and (p1.kind=kStr) then
                  begin
                    t1:=round(p2.num);
                    if t1 in [2..36] then
                      begin p3.kind:=kNum; p3.num:=BaseToDec(t1,p1.name); end
                    else
                      errmsg:='Hµm "base" chØ cã thÓ chuyÓn ®æi c¸c hÖ c¬ sè tõ 2 dÕn 36 sang hÖ c¬ sè 10';
                  end
                else
                  begin
                    errmsg:='Tham sè cña hµm "base" ph¶i lµ mét sè vµ mét x©u kÝ tù!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: base(5,''2431'')';
                  end;
            end
          else

          if (toantu='random') then
            begin
              if grerr='' then
                grerr:='Hµm "random" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kNum,kVar,kParam,kDate]) and
                 (p2.kind in [kNum,kVar,kParam,kDate])
              then
                begin
                  t1:=0; if (frac(p1.num)<>0) then inc(t1);
                  if (frac(p2.num)<>0) then inc(t1);
                  if t1>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                        ' to¸n h¹ng cña hµm "random" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                  end;
                  t1:=round(p1.num); t2:=round(p2.num);
                  if t2>t1 then //doi vi tri t1,t2 de t2<t1
                    begin t1:=t1+t2; t2:=t1-t2; t1:=t1-t2; end;
                  randomize; p3.kind:=kNum; p3.num:=random(t1-t2+1)+t2;
                end
              else
                begin
                  errmsg:='Tham sè hµm "random" kh«ng hîp lÖ';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') Tham sè hµm "random" lµ 2 sè nguyªn kh«ng ©m';
                end;
            end
          else

          if (toantu='ucln') then
            begin
              if grerr='' then
                grerr:='Hµm "ucln" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kNum,kParam,kVar])and
                 (p2.kind in [kNum,kParam,kVar]) then
              begin
                t1:=0;
                if (p1.num<0)or(frac(p1.num)<>0) then inc(t1);
                if (p2.num<0)or(frac(p2.num)<>0) then inc(t1);
                if t1>0 then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                    ' to¸n h¹ng cña hµm "ucln" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                end;
                p3.num:=ucln(round(p1.num),round(p2.num));
              end
              else
                errmsg:='Tham sè cña hµm "ucln" ph¶i lµ sè nguyªn d­¬ng!'
            end
          else

          if (toantu='bcnn') then
            begin
              if grerr='' then
                grerr:='Hµm "bcnn" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kNum,kParam,kVar])and
                 (p2.kind in [kNum,kParam,kVar]) then
              begin
                t1:=0;
                if (p1.num<0)or(frac(p1.num)<>0) then inc(t1);
                if (p2.num<0)or(frac(p2.num)<>0) then inc(t1);
                if t1>0 then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: '+IntToStr(t1)+
                    ' to¸n h¹ng cña hµm "bcnn" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                end;
                t1:=round(p1.num); t2:=round(p2.num);
                p3.num:=t1*t2/ucln(t1,t2);
              end
              else
                errmsg:='Tham sè cña hµm "bcnn" ph¶i lµ sè nguyªn d­¬ng!'
            end
          else

          if (toantu='ptnt') then
            begin
              if grerr='' then
                grerr:='Hµm "ptnt" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind in [kNum,kParam,kVar] then
                begin
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: To¸n h¹ng cña hµm "ptnt" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                  end;
                  p3.kind:=kStr;
                  p3.name:=ptnt(round(p1.num));
                end
                else
                  errmsg:='Tham sè cña hµm "ptnt" ph¶i lµ sè nguyªn!';
            end

          else
          if (toantu='dow') then
            begin
              if grerr='' then
                grerr:='Hµm "dow" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind=kDate then
                  begin
                    try d1:=StrToDate(p1.name);
                    except
                      errmsg:='Tham sè cña hµm "dow" kh«ng hîp lÖ!';
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') VD: dow([25/12/2002]) hoÆc dow([25/12/2002]+100)lµ hîp lÖ';
                      grok:=grerr=''; exit;
                    end;
                    p3.kind:=kStr;
                    p3.name:=FormatDateTime('dddd',d1);
                  end
                else
                if p1.kind in [kNum,kVar,kParam,kFrac] then
                  begin
                    p3.kind:=kStr;
                    p3.name:=FormatDateTime('dddd',p1.num);
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn dow([25/12/2002]) víi dow(25/12/2002)=dow(0.001041)';
                  end
                else
                  begin
                    errmsg:='Tham sè cña hµm "dow" kh«ng hîp lÖ!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: dow([25/12/2002]) hoÆc dow([25/12/2002]+100)lµ hîp lÖ';
                  end;
            end
          else

          if (toantu='sec') then
            begin
              if grerr='' then
                grerr:='Hµm "sec" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "sec" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      t1:=round(num);
                      if t1>86399 then errmsg:='Tham sè cña hµm "sec" ph¶i lµ sè nguyªn nhá h¬n 86400.'
                      else
                        begin
                          p3.kind:=kDate;
                          p3.name:=IntToStr(t1 div 3600)+':';
                          t1:=t1 mod 3600;
                          p3.name:=p3.name+IntToStr(t1 div 60)+':';
                          p3.name:=p3.name+IntToStr(t1 mod 60);
                          p3.num:=StrToTime(p3.name);
                        end;
                    end;
            end
          else

          if (toantu='min') then
            begin
              if grerr='' then
                grerr:='Hµm "min" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "min" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      t1:=round(num);
                      if t1>1439 then errmsg:='Tham sè cña hµm "min" ph¶i lµ sè nguyªn nhá h¬n 1440.'
                      else
                        begin
                          p3.kind:=kDate;
                          p3.name:=IntToStr(t1 div 60)+':';
                          p3.name:=p3.name+IntToStr(t1 mod 60)+':0';
                          p3.num:=StrToTime(p3.name);
                        end;
                    end;
            end
          else

          if (toantu='hour') then
            begin
              if grerr='' then
                grerr:='Hµm "hour" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "hour" kh«ng nguyªn nªn ®­îc tù ®éng lµm trßn';
                      end;
                      t1:=round(num);
                      p3.kind:=kDate; p3.num:=t1 div 24;
                      p3.num:=p3.num+StrToTime(IntToStr(t1 mod 24)+':0:0');
                      p3.name:=TimeToStr(p3.num);
                    end;
            end
          else

          if (toantu='todate') then
            begin
              if grerr='' then
                grerr:='Hµm "todate" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=DateToStr(p1.num);
                  except
                    errmsg:='Kh«ng thÓ ®æi sè '+FloatToStr(p1.num)+' sang kiÓu ngµy!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham sè cña hµm "todate" kh«ng hîp lÖ!';

            end
          else

          if (toantu='totime') then
            begin
              if grerr='' then
                grerr:='Hµm "totime" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=TimeToStr(p1.num);
                  except
                    errmsg:='Kh«ng thÓ ®æi sè '+FloatToStr(p1.num)+' sang kiÓu giõ!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham sè cña hµm "totime" kh«ng hîp lÖ!';
            end
          else

          if (toantu='todatetime') then
            begin
              if grerr='' then
                grerr:='Hµm "todatetime" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=DateToStr(p1.num)+' '+TimeToStr(p1.num);
                  except
                    errmsg:='Kh«ng thÓ ®æi sè '+FloatToStr(p1.num)+' sang kiÓu thêi gian!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham sè cña hµm "todatetime" kh«ng hîp lÖ!';
            end
          else

          if (toantu='canchi_y') then
            begin
              if grerr='' then
                grerr:='Hµm "canchi_y" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='ThiÕu to¸n h¹ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                begin
                  t1:=StrToInt(FormatDateTime('yyyy',p1.num))-4;
                  t2:=t1 mod 12+1; t1:=t1 mod 10+1;
                end
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn canchi_y([4/2/1984]) víi canchi_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "canchi_y" ®­îc tù ®éng ®æi dÊu vµ lµm trßn'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "canchi_y" ®­îc tù ®éng lµm trßn';
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "canchi_y" ©m nªn ®­îc tù ®éng ®æi dÊu';
                    end;
                  t1:=abs(round(p1.num)); t2:=t1;
                  if t1>3 then
                    begin t1:=(t1-4) mod 10+1; t2:=(t2-4) mod 12+1; end
                  else
                    begin t1:=(t1+6) mod 10+1; t2:=(t2+8) mod 12+1; end;
                end
              else
                begin
                  t2:=0; errmsg:='Tham sè cña hµm "canchi_y" ph¶i lµ kiÓu ngµy hoÆc lµ 1 sè nguyªn d­¬ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: canchi_y(2002) hoÆc canchi_y([12/2/2002]+100)';
                end;
              p3.kind:=kStr; p3.name:=canstr[t1]+' '+chistr[t2];
            end
          else

          if (toantu='chi_y') then
            begin
              if grerr='' then
                grerr:='Hµm "chi_y" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='ThiÕu to¸n h¹ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                t1:=(StrToInt(FormatDateTime('yyyy',p1.num))-4)mod 12+1
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn chi_y([4/2/1984]) víi chi_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "chi_y" ®­îc tù ®éng ®æi dÊu vµ lµm trßn'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "chi_y" ®­îc tù ®éng lµm trßn'
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "chi_y" ©m nªn ®­îc tù ®éng ®æi dÊu';
                    end;
                  t1:=abs(round(p1.num));
                  if t1>3 then t1:=(t1-4) mod 12+1 else t1:=(t1+8) mod 12+1;
                end
              else
                begin
                  errmsg:='Tham sè cña hµm "chi_y" ph¶i lµ kiÓu ngµy hoÆc lµ 1 sè nguyªn d­¬ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: chi_y(2002) hoÆc chi_y([12/2/2002]-100)';
                end;
              p3.kind:=kStr; p3.name:=ChiStr[t1];
            end
          else

          if (toantu='can_y') then
            begin
              if grerr='' then
                grerr:='Hµm "can_y" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='ThiÕu to¸n h¹ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                t1:=(StrToInt(FormatDateTime('yyyy',p1.num))-4) mod 10+1
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn can_y([4/2/1984]) víi can_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "can_y" ®­îc tù ®éng ®æi dÊu vµ lµm trßn'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "can_y" ®­îc tù ®éng lµm trßn'
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "can_y" ©m nªn ®­îc tù ®éng ®æi dÊu';
                    end;
                  t1:=abs(round(p1.num));
                  if t1>3 then t1:=(t1-4) mod 10+1 else t1:=(t1+6) mod 10+1;
                end
              else
                begin
                  errmsg:='Tham sè cña hµm "can_y" ph¶i lµ kiÓu ngµy hoÆc lµ 1 sè nguyªn d­¬ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_y(2002) hoÆc can_y([12/2/2002]+100)';
                end;
              p3.kind:=kStr; p3.name:=CanStr[t1];
            end
          else

          if (toantu='can_m') then
            begin
              if grerr='' then
                grerr:='Hµm "can_m" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kDate,kNum,kVar,kParam]) then
                begin
                  if p1.kind in [kVar,kParam,kNum] then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn can_m([4/2/1984]) víi can_m(4/2/1984)';
                  end;
                  p3.kind:=kStr;
                  p3.name:=canstr[1+(2*(((StrToInt(FormatDateTime('yyyy',p1.num))-4)
                    mod 10) mod 5)+StrToInt(FormatDateTime('mm',p1.num))+1) mod 10];
                end
              else
                begin
                  errmsg:='Tham sè cña hµm "can_m" ph¶i lµ kiÓu ngµy!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_m([4/2/1984])';
                end;
            end
          else

          if (toantu='canchi_m') then
            begin
              if grerr='' then
                grerr:='Hµm "canchi_m" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kDate,kNum,kParam,kVar]) then
                begin
                  if p1.kind in [kNum,kParam,kVar] then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Kh«ng ®­îc nhÇm lÉn can_m([4/2/1984]) víi can_m(4/2/1984)';
                  end;
                  p3.kind:=kStr;
                  t1:=StrToInt(FormatDateTime('mm',p1.num));
                  p3.name:=canstr[1+(2*(((StrToInt(FormatDateTime('yyyy',p1.num))-4)
                    mod 10) mod 5)+t1+1) mod 10]+' '+chistr[t1];
                end
              else
                begin
                  errmsg:='Tham sè cña hµm "can_m" ph¶i lµ kiÓu ngµy!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_m([4/2/1984])';
                end;
            end
          else

          if (toantu='chi_m') then
            begin
              if grerr='' then
                grerr:='Hµm "chi_m" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then begin errmsg:='ThiÕu to¸n h¹ng!'; grok:=grerr=''; exit; end; t1:=0;
              if p1.kind=kDate then
                t1:=StrToInt(FormatDateTime('mm',p1.num))
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  t1:=abs(round(p1.num));
                  if not (t1 in [1..12]) then
                    errmsg:='Tham sè cña hµm "chi_m" ph¶i lµ kiÓu ngµy hoÆc lµ 1 sè trong kho¶ng [1..12].'
                  else
                  if (frac(p1.num)<>0) or (p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "chi_m" ®­îc tù ®éng lµm trßn hoÆc ®æi dÊu';
                  end;
                end;
              p3.kind:=kStr; p3.name:=chistr[t1];
            end
          else

          {if (toantu='can_h') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
              if (p1.kind in [kDate,kNum,kVar,kParam]) then
                begin
                  p3.kind:=kStr;
                  t1:=StrToInt(FormatDateTime('hh',p1.num));
                  if t1 in [0,1,23] then t1:=1 else t1:=t1-((t1 shr 1) shl 1)+1;

                  p3.name:=canstr[1+(2*(((StrToInt(FormatDateTime('yyyy',p1.num))-4)
                    mod 10) mod 5)+StrToInt(FormatDateTime('mm',p1.num))+1) mod 10];
                end
              else
                begin
                  errmsg:='Tham sè cña hµm "can_h" ph¶i lµ kiÓu giê!';
                  with ComboBox1.Items do
                    add(IntToStr(count+1)+') VD: can_h([3:5:10]) hay can_h([3:5:10+sec(100)])...');
                end;
            end
          else}

          if (toantu='countday') then
            begin
              if grerr='' then
                grerr:='Hµm "countday" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind=kDate then
                  begin p3.kind:=kNum; p3.num:=p1.num+693595; end
                else
                  begin
                    errmsg:='Tham sè cña hµm "countday" ph¶i lµ kiÓu ngµy!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: countday([4/2/1984]) hoÆc countday(cdate)';
                  end;
            end
          else

          if (toantu='eraday') then
            begin
              if grerr='' then
                grerr:='Hµm "eraday" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                if p1.kind=kNum then
                  begin
                    if (p1.num<0)or(frac(p2.num)<>0) then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C¶nh b¸o: Tham sè cña hµm "eraday" ©m nªn ®­îc tù ®éng ®æi dÊu!';
                    end;
                    p3.kind:=kDate; p3.num:=abs(p1.num)-693595;
                    p3.name:=DateToStr(p3.num);
                  end
                else
                  begin
                    errmsg:='Tham sè cña hµm "eraday" ph¶i lµ 1 sè nguyªn d­¬ng!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: eraday(39000) hoÆc eraday(4020)';
                  end;
            end
          else

          if (toantu='tonum') then
            begin
              if grerr='' then
                grerr:='Hµm "tonum" kh«ng sö dông ®­îc trong biÓu thøc vÏ ®å thÞ!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='ThiÕu to¸n h¹ng!'
              else
                begin
                  p3.kind:=kNum;
                  case p1.kind of
                    kDate: p3.num:=p1.num;
                    kBool: if p1.bool then p3.num:=1 else p3.num:=0;
                    kStr:
                      try p3.num:=StrToFloat(p1.name);
                      except
                        t2:=0;
                        for t1:=1 to 7 do
                          if p1.name=LongDayNames[t1] then
                            begin t2:=1; p3.num:=t1; break; end;
                        if t2=0 then
                          for t1:=1 to 12 do
                            if p1.name=LongMonthNames[t1] then
                              begin t2:=1; p3.num:=t1; break; end;
                        if t2=0 then
                        begin
                        for t1:=0 to 9 do
                          if p1.name=CanStr[t1] then
                            begin t2:=1; p3.num:=t1; break; end;
                        if p3.num=0 then p3.num:=10;
                        end;
                        if t2=0 then
                        begin
                        for t1:=0 to 11 do
                          if p1.name=ChiStr[t1] then
                            begin t2:=1; p3.num:=t1; break; end;
                        if p3.num=0 then p3.num:=12;
                        end;
                        if t2=0 then
                        begin
                          errmsg:='Kh«ng thÓ ®æi x©u kÝ tù '+p1.name+' sang kiÓu sè!';
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') Hµm "tonum" chØ cã thÓ ®æi c¸c x©u chØ ngµy (Monday..) hoÆc can, chi (Nh©m, Ngä..) sang kiÓu sè';
                        end;
                      end;
                    else
                      p3.num:=p1.num;
                  end;
                end;
            end;

          if errmsg='' then stack[sp]:=p3 else break;

          end;
      end; {while}

    if not grok then grerr:=errmsg
    else
      grok:=(grerr='')and(errmsg<>'ThiÕu to¸n h¹ng!')and
        (errmsg<>'ThiÕu to¸n h¹ng hoÆc dÊu ph¶y ng¨n c¸ch hai tham sè!');

    if (sp>1)and(errmsg='') then
    begin
      errmsg:='ThiÕu to¸n tö(hµm) hoÆc thõa to¸n h¹ng(tham sè)!';
      grok:=false; if (grerr='') then grerr:=errmsg;
    end
    else NormalCalc:=stack[1];

  end;

function doc_hs(var n: Extended; var LEdit: TLabeledEdit; var Edit1: TEdit): Boolean;
var s: String; p: TPart;
begin
  doc_hs:=true; s:=LEdit.Text;
  try //thu doi luon ra so
    n:=StrToFloat(s); LEdit.Hint:=s;
  except //neu khong doi duoc thi tinh
    analyse(s,False);
    if errmsg<>'' then
    begin
      Edit1.Text:=LEdit.Text; LEdit.Text:=errmsg; doc_hs:=false;
      LEdit.Hint:=errmsg; Exit;
    end;
    p:=NormalCalc;
    if errmsg<>'' then
    begin
      Edit1.Text:=LEdit.Text; LEdit.Text:=errmsg; doc_hs:=false;
      LEdit.Hint:=errmsg; Exit;
    end;

    if p.kind in [kBool,kStr,kOpr] then
    begin
      Edit1.Text:=LEdit.Text; LEdit.Text:='HÖ sè nµy ph¶i lµ kiÓu sè';
      LEdit.Hint:=LEdit.Text; Exit;
    end;
    n:=p.num; LEdit.Hint:=FloatToStr(p.num);
  end;
end;

end.
