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
    ('Gi�p','�t','B�nh','�inh','M�u','K�','Canh','T�n','Nh�m','Qu�');
  ChiStr: array [1..12] of string[4]=
    ('T�','S�u','D�n','M�o','Th�n','T�','Ng�','M�i','Th�n','D�u','Tu�t','H�i');

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
          errmsg:='X�u "'+s+'" kh�ng ��ng khu�n d�ng'+' ['+srange+'].';
      if r>=a then
        errmsg:='X�u "'+s+'" kh�ng ��ng khu�n d�ng'+' ['+srange+'].';
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
      errmsg:='X�u '+s+' kh�ng ph�i l� ki�u ng�y!';
    nmonth:=k;
  end;
function nyear(s: string): integer;
  var i,j,k: integer;
  begin
    errmsg:=''; i:=FindStr('/',s,pos('/',s)+1); j:=length(s);
    try k:=StrToInt(copy(s,i+1,j-i)); except k:=3000; end;
    if (k<1)or(k>2100) then
      errmsg:='N�m trong x�u '+s+' ph�i n�m trong kho�ng [1..2100].';
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
      errmsg:='X�u '+s+' kh�ng ph�i l� ki�u ng�y!'
    else nday:=k;
  end;
procedure ymd(s: string; var y,m,d: integer);
  var i,r: byte;
  begin
    errmsg:=''; i:=pos('/',s);
    try d:=StrToInt(copy(s,1,i-1)); delete(s,1,i);
    except errmsg:='X�u '+s+' kh�ng ph�i l� ki�u ng�y!'; exit;
    end;
    i:=pos('/',s);
    try m:=StrToInt(copy(s,1,i-1)); delete(s,1,i);
    except m:=0;
    end;
    try y:=StrToInt(s);
    except y:=0;
    end;
    if not ((m in [1..12])and(y>=1)and(y<=2100)) then
      begin errmsg:='X�u '+s+' kh�ng ph�i l� ki�u ng�y ho�c kh�ng thu�c kho�ng [1..2100].'; exit; end;
    case m of
      2: if nhuan(y)=0 then r:=28 else r:=29;
      4,6,9,11: r:=30
      else r:=31;
    end;
    if (d>r) then
      errmsg:='Ng�y trong ['+s+'] ph�i n�m trong kho�ng [1..'+IntToStr(r);
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
            errmsg:='Kh�ng hi�u "'+s+'" l� g�!'; toPart.Kind:=kStr;
            if dangve then
              begin grok:=false; grerr:=errmsg; end
            else
            begin
              inc(cwar);
              war[cwar]:=IntToStr(cwar)+') Ch� �: T�n c�c h�ng s� ph�i ch�nh x�c c� v� vi�c vi�t ch� hoa hay ch� th��ng';
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
            errmsg:='Kh�ng hi�u "'+s+'" l� g�!'; toPart.Kind:=kStr;
            if dangve then
              begin grok:=false; grerr:=errmsg; end
            else
            begin
              inc(cwar);
              war[cwar]:=IntToStr(cwar)+') Ch� �: T�n c�c h�ng s� ph�i ch�nh x�c c� v� vi�c vi�t ch� hoa hay ch� th��ng';
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
      begin errmsg:='Bi�u th�c r�ng!'; grOk:=False; exit; end
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
            errmsg:='Th�a d�u ")" � v� tr� th� '+inttostr(i)+' trong bi�u th�c!';
            grOk:=False; exit;
          end;
      end;
    if j>0 then
      begin errmsg:='Thi�u '+IntToStr(abs(j))+' d�u ")"!'; grOk:=False; exit; end;

    //Kiem tra va danh dau '[',']'
    FillChar(mark,SizeOf(mark),0);
    if (pos('[[',s)>0)or(pos(']]',s)>0) then
      begin errmsg:='Kh�ng ���c ��t c�c d�u "[" hay "]" li�n nhau!'; exit; end;
    p:=pos('[',s);
    if p>0 then
      begin
        while p>0 do
          begin
            j:=findStr(']',s,p+1);
            if j=0 then begin errmsg:='Thi�u d�u "]"!'; exit; end;
            p:=findStr('[',s,j+1);
          end;
        if findStr(']',s,j+1)>0 then begin errmsg:='Th�a d�u "]"'; exit; end;
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
    if s[1]='-' then s[1]:='�'; //neu dau '-' xuat hien dau tien thi la dau '-' 1 ngoi.
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
        if next1 then s[p]:='�'; //thay the phep'-' 2 ngoi bang phep '�' 1 ngoi.
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
    if (prefix[1].kind=kOpr)and(opr[prefix[1].AOpr].name='�')and
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
                    if opr[stack[sp]].name='�' then
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
              grerr:='Ph��ng tr�nh �� v� �� th� kh�ng ���c ch�a ki�u x�u hay ki�u logic!'
          end
        else
          begin
          toantu:=opr[suffix[i].AOpr].name;

          if (toantu=':') then
            begin
              if grerr='' then
              begin
                grok:=false; grerr:='To�n t� ":" kh�ng ���c s� d�ng trong bi�u th�c v� �� th�!';
              end;
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                 (p2.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                 (frac(p1.num)=0) and (frac(p2.num)=0) then
              begin
                {$Q+}
                t1:=trunc(p2.num); t2:=trunc(p1.num);
                if t2=0 then
                  begin errmsg:='M�u s� trong ph�p ":" ph�i kh�c 0.'; exit; end;
                rutgon(t1,t2); p3.t:=t1; p3.m:=t2; p3.num:=t1/t2;
                if t2=1 then
                  if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar
                  else p3.kind:=kNum
                else p3.kind:=kFrac;
                {$Q-}
              end
              else
                errmsg:='T� s� v� m�u s� trong to�n h�ng ":" ph�i l� s� nguy�n!'
            end
          else

          if (toantu='+') then {*}
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                              errmsg:='Kh�ng ��i ���c gi� tr� '+FloatToStr(p3.num)+'c�a ph�p "+" sang ki�u ng�y/gi�';
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
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: Ph�p "+" 2 to�n t� ki�u Logic t��ng ���ng v�i ph�p "or".';
                  end
                else
                if (p1.kind in [kStr,kDate])or(p2.kind in [kStr,kDate]) then
                  begin p3.kind:=kStr; p3.name:=toStr(p2)+toStr(p1); end
                else errmsg:='Hai to�n h�ng c�a ph�p "+" kh�c lo�i nhau!';
            end
          else

          if (toantu='-') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: Ph�p "-" 2 to� t� Logic t��ng ���ng v�i ph�p "and".';
                  end
                else errmsg:='Hai to�n h�ng c�a ph�p "-" kh�c lo�i nhau!';
            end
          else

          if (toantu='*') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                      war[cwar]:=IntToStr(cwar)+') M�ch n��c: Ph�p "*" 2 to�n t� ki�u Logic t��ng ���ng v�i ph�p "xor".';
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "*" kh�c lo�i nhau!';
            end
          else

          if (toantu='/') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                      begin errmsg:='Bi�u th�c sau ph�p "/" b�ng 0.'; grok:=p1.kind=kVar; end
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
                      war[cwar]:=IntToStr(cwar)+') M�ch n��c: Logic1/Logic2 t��ng ���ng not(Logic1 xor Logic2)';
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "/" kh�c lo�i nhau!';
            end
          else

          if (toantu='abs') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                      war[cwar]:=IntToStr(cwar)+') M�ch n��c: H�m "abs" v�i tham s� l� bi�u th�c Logic cho k�t qu� l� ki�u Logic v�i gi� tr� l� T';
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "*" kh�c lo�i nhau!';
            end
          else

          if (toantu='^') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kBool,kStr]) or (p2.kind in [kBool,kStr]) then
                  errmsg:='To�n h�ng c�a ph�p "^" kh�ng h�p l�!'
                else
                  begin
                    if (p1.kind=kVar)or(p2.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                    {if p1.kind=kFrac then
                    begin
                      if p1.t<0 then tmp1:=1/exp(p1.num*ln(-p1.t))
                      else tmp1:=exp(p1.t*ln(p2.num));
                      if (tmp1<0)and(not odd(p1.m)) then
                        errmsg:='Kh�ng th�c hi�n ���c ph�p "^"!'
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
                        errmsg:='Kh�ng th�c hi�n ���c ph�p "^"!';
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') Nguy�n nh�n l�i: C� s� �m m� s� m� l�i c� d�ng l� c�n b�c ch�n; VD: (-3)^(1/2) hay (-3)^(1/4)';
                        if grerr='' then grerr:='C� s� c�a ph�p "^" ph�i d��ng!';
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
                          errmsg:='Kh�ng th�c hi�n ���c ph�p "^"!';
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') Nguy�n nh�n l�i: Khi c� s� �m, s� m� ph�i c� d�ng n ho�c (1/n) v�i n l� s� nguy�n';
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
              if sp<=0 then errmsg:='Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  if p1.num<p2.num then p3:=p1 else p3:=p2
                else
                if (p1.kind in [kStr,kDate])and(p2.kind in [kStr,kDate]) then
                  if p1.name<p2.name then p3:=p1 else p3:=p2
                else
                  errmsg:='Tham s� h�m "below" kh�ng h�p l�!'
            end
          else

          if (toantu='above') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  if p1.num>p2.num then p3:=p1 else p3:=p2
                else
                if (p1.kind in [kStr,kDate])and(p2.kind in [kStr,kDate]) then
                  if p1.name>p2.name then p3:=p1 else p3:=p2
                else
                  errmsg:='Tham s� h�m "above" kh�ng h�p l�!'
            end
          else

          if (toantu='div') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                    begin
                      errmsg:='Bi�u th�c sau ph�p "div" b�ng 0.'; grOk:=p1.kind=kVar;
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
                          war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "div" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                        end;
                      end;
                  end
                else
                  errmsg:='To�n h�ng c�a ph�p "div" kh�ng h�p l�!';
            end
          else

          if (toantu='mod') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) and
                  (p2.kind in [kNum,kVar,kParam,kDate,kFrac])
                then
                  begin
                    if p1.num=0 then
                      begin errmsg:='Bi�u th�c sau ph�p "mod" b�ng 0.'; grOk:=p1.kind=kVar; end
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
                          war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "mod" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                        end;
                      end;
                  end
                else
                  errmsg:='To�n h�ng c�a ph�p "mod" kh�ng h�p l�!';
            end
          else

          if (toantu='and') then
            begin
              if grerr='' then
                grerr:='To�n t� "and" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool and p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: C� th� d�ng ph�p "-" thay v� ph�p "and" 2 to�n h�ng ki�u Logic';
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
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "and" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;
                      p3.kind:=kNum; p3.num:=round(p2.num) and round(p1.num);
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "and" kh�c lo�i nhau!';
            end
          else

          if (toantu='or') then
            begin
              if grerr='' then
                grerr:='To�n t� "or" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool or p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: C� th� d�ng ph�p "+" thay v� ph�p "or" 2 to�n h�ng ki�u Logic';
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
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "or" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;      
                      p3.kind:=kNum; p3.num:=round(p2.num) or round(p1.num);
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "or" kh�c lo�i nhau!';
            end
          else

          if (toantu='xor') then
            begin
              if grerr='' then
                grerr:='To�n t� "xor" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kBool) and (p2.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=p1.Bool xor p2.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: C� th� d�ng ph�p "*" thay v� ph�p "xor" 2 to�n h�ng ki�u Logic';
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
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "xor" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;
                      p3.kind:=kNum; p3.num:=round(p2.num) xor round(p1.num);
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "xor" kh�c lo�i nhau!';
            end
          else

          if (toantu='->') then
            begin
              if grerr='' then
                grerr:='To�n t� "->" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "->" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;
                      p3.kind:=kNum; p3.num:=not(round(p2.num)) or round(p1.num);
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "->" kh�c lo�i nhau!';
            end
          else

          if (toantu='<->') then
            begin
              if grerr='' then
                grerr:='To�n t� "<->" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                            ' to�n h�ng c�a ph�p "<->" kh�ng nguy�n n�n  ���c t� ��ng l�m tr�n';
                      end;
                      p3.kind:=kNum; t1:=round(p1.num); t2:=round(p2.num);
                      p3.num:=(not t1 or t2)and(not t2 or t1);
                    end
                  else errmsg:='Hai to�n h�ng c�a ph�p "<->" kh�c lo�i nhau!';
            end
          else

          if (toantu='>') then
            begin
              if grerr='' then
                grerr:='To�n t� ">" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                errmsg:='Hai to�n h�ng c�a ph�p ">" kh�c lo�i nhau!';
            end
          else

          if (toantu='>=') then
            begin
              if grerr='' then
                grerr:='To�n t� ">=" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                errmsg:='Hai to�n h�ng c�a ph�p ">=" kh�c lo�i nhau!';
            end
          else

          if (toantu='<') then
            begin
              if grerr='' then
                grerr:='To�n t� "<" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                errmsg:='Hai to�n h�ng c�a ph�p "<" kh�c lo�i nhau!';
            end
          else

          if (toantu='<=') then
            begin
              if grerr='' then
                grerr:='To�n t� "<=" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                errmsg:='Hai to�n h�ng c�a ph�p "<=" kh�c lo�i nhau!';
            end
          else

          if (toantu='not') then
            begin
              if grerr='' then
                grerr:='To�n t� "not" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kBool) then
                  begin
                    p3.kind:=kBool; p3.Bool:=not p1.Bool;
                    if p3.bool then p3.num:=1 else p3.num:=0;
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: C� th� d�ng ph�p "-" thay v� ph�p "not" 1 to�n h�ng ki�u Logic';
                  end
                else
                  begin
                    if frac(p1.num)<>0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: To�n h�ng c�a ph�p "not" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                    end;
                    p3.kind:=kNum; p3.num:=(not round(p1.num));
                  end
            end
          else

          if (toantu='if') then
            begin
              if grerr='' then
                grerr:='H�m "if" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp]; dec(sp); p4:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if p4.kind=kBool then
                if p4.bool then p3:=p2 else p3:=p1
              else
                errmsg:='Tham s� th� nh�t c�a h�m "if" ph�i l� ki�u Logic!';
            end
          else

          if (toantu='�') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                    war[cwar]:=IntToStr(cwar)+') M�ch n��c: C� th� d�ng ph�p "not" thay v� ph�p "-" 1 to�n h�ng ki�u Logic';
                  end;
            end
          else

          if (toantu='exp') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum;
                    p3.num:=exp(p1.num);
                  end
                else
                  errmsg:='Tham s� c�a h�m "exp" kh�ng h�p l�!'
            end
          else

          if (toantu='ln') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  if p1.num<=0 then
                    begin errmsg:='Tham s� h�m "ln" kh�ng du�ng!'; grOk:=p1.kind=kVar; end
                  else
                    begin if (p1.kind=kVar)then p3.kind:=kVar else p3.kind:=kNum; p3.num:=ln(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "ln" kh�ng h�p l�!';
            end
          else

          if (toantu='log') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  if p1.num<=0 then
                    begin
                      errmsg:='Tham s� h�m "log" kh�ng du�ng!';
                      grOk:=p1.kind=kVar;
                    end
                  else
                    begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=ln(p1.num)/ln10val; end
                else
                  errmsg:='Tham s� c�a h�m "log" kh�ng h�p l�!';
            end
          else

          if (toantu='lg') then
            begin
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!'
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
                            errmsg:='C� s� trong h�m "lg" b�ng 1.'; grok:=p2.kind=kVar;
                          end;
                      end
                    else
                      begin
                        errmsg:='Hai bi�u th�c trong h�m "lg" ph�i d��ng!';
                        grok:=((p2.kind=kVar)and(p1.kind=kNum))
                          or ((p1.kind=kVar)and(p2.kind=kNum));
                      end;
                  end
                else
                  errmsg:='Tham s� c�a h�m "lg" kh�ng h�p l�!';
            end
          else

          if (toantu='arn') then
            begin
              if grerr='' then
                grerr:='H�m "arn" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!'
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
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                        ' to�n h�ng c�a h�m "arn" ���c t� ��ng l�m tr�n ho�c ��i d�u th�nh d��ng';
                  end;
                  t1:=abs(round(p1.num)); t2:=abs(round(p2.num));
                  if t2>t1 then errmsg:='Trong h�m "arn" tham s� th� 1 (r) ph�i nh� h�n tham s� th� 2 (n).'
                  else
                    begin
                      p3.kind:=kNum; p3.num:=1;
                      for t1:=round(p1.num) downto round(p1.num)-round(p2.num)+1 do
                        p3.num:=p3.num*t1;
                    end;
                end
              else
                errmsg:='Hai tham s� c�a h�m "arn" ph�i l� s� nguy�n d��ng v� tham s� th� 1 (r) ph�i nh� h�n tham s� th� 2 (n).';
            end
          else

          if (toantu='crn') then
            begin
              if grerr='' then
                grerr:='H�m "crn" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!'
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
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                        ' to�n h�ng c�a h�m "crn" ���c t� ��ng l�m tr�n ho�c ��i d�u th�nh d��ng';
                  end;
                  t1:=abs(round(p1.num)); t2:=abs(round(p2.num));
                  if t2>t1 then errmsg:='Trong h�m "crn" tham s� th� 1 (r) ph�i nh� h�n tham s� th� 2 (n).'
                  else
                    begin
                      p3.kind:=kNum;
                      p3.num:=giaithua(t1)/(giaithua(t1-t2)*giaithua(t2));
                    end;
                end
              else
                errmsg:='Hai tham s� c�a h�m "crn" ph�i l� s� nguy�n d��ng v� tham s� th� 1 (r) ph�i nh� h�n tham s� th� 2 (n).';
            end
          else

          if (toantu='sinh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sinh(p1.num); end
            else
            errmsg:='Tham s� c�a h�m "sinh" kh�ng h�p l�!';
          end
          else

          if (toantu='cosh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cosh(p1.num); end
            else
            errmsg:='Tham s� c�a h�m "cosh" kh�ng h�p l�!';
          end
          else

          if (toantu='tgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=tanh(p1.num); end
            else
            errmsg:='Tham s� c�a h�m "tgh" kh�ng h�p l�!';
          end
          else

          if (toantu='cotgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if p3.num<>0 then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=coth(p1.num); end
              else
              begin
                errmsg:='Tham s� c�a h�m "cotgh" ph�i kh�c 0';
                grok:=p1.kind=kVar;
              end
            else
            errmsg:='Tham s� c�a h�m "cotgh" kh�ng h�p l�!';
          end
          else

          if (toantu='arcsinh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arcsinh(p1.num); end
            else
            errmsg:='Tham s� c�a h�m "arcsinh" kh�ng h�p l�!';
          end
          else

          if (toantu='arccosh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if p1.num>=1 then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccosh(p1.num); end
              else
              begin
                errmsg:='Tham s� c�a h�m "arccosh" ph�i >=1';
                grok:=p1.kind=kVar;
              end
            else
              errmsg:='Tham s� c�a h�m "arccosh" kh�ng h�p l�!';
          end
          else

          if (toantu='arctgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if (p1.num>=-1)and (p1.num<=1) then
              begin
                if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arctanh(p1.num);
              end
              else
              begin
                grok:=p1.kind=kVar;
                errmsg:='Tham s� c�a h�m "arctgh" ph�i n�m trong kho�ng [-1..1]'
              end
            else errmsg:='Tham s� c�a h�m "arctgh" kh�ng h�p l�!';
          end
          else

          if (toantu='arccotgh') then
          begin
            p1:=stack[sp];
            if sp<=0 then errmsg:='Thi�u to�n h�ng!'
            else
            if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
              if (p1.num>=1)or(p1.num<=-1) then
                begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccoth(p1.num); end
              else
                begin
                  errmsg:='Tham s� c�a h�m "arccotgh" ph�i kh�c [-1..1]';
                  grok:=p1.kind=kVar;
                end
            else
            errmsg:='Tham s� c�a h�m "arccotgh" kh�ng h�p l�!';
          end
          else

          if (toantu='sin') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sin(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "sin" kh�ng h�p l�!';
            end
          else

          if (toantu='cos') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cos(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "cos" kh�ng h�p l�!';
            end
          else

          if (toantu='tg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=cos(p1.num);
                    if tmp1=0 then
                      begin errmsg:='tg(pi/2+k*pi) kh�ng x�c ��nh!'; grok:=p1.kind=kVar; end
                    else
                      begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sin(p1.num)/tmp1; end;
                  end
                else
                  errmsg:='Tham s� c�a h�m "tg" kh�ng h�p l�!';
            end
          else

          if (toantu='cotg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=sin(p1.num);
                    if tmp1=0 then
                      begin errmsg:='cotg(k*pi) kh�ng x�c ��nh!'; grok:=p1.kind=kVar; end
                    else
                      begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=cos(p1.num)/tmp1; end;
                  end
                else
                  errmsg:='Tham s� c�a h�m "cotg" kh�ng h�p l�!';
            end
          else

          if (toantu='arcsin') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=p1.num; //sin
                    if (tmp1<-1)or(tmp1>1) then
                      begin
                        errmsg:='Tham s� trong h�m "arcsin" kh�ng n�m trong kho�ng [-1,1]';
                        grok:=p1.kind=kVar;
                      end
                    else
                      begin
                        if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arcsin(tmp1);
                      end;
                  end
                else
                  errmsg:='Tham s� c�a h�m "arcsin" kh�ng h�p l�!';
            end
          else

          if (toantu='arccos') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    tmp1:=p1.num; //cos
                    if (tmp1<-1)or(tmp1>1) then
                      begin
                        errmsg:='Tham s� trong h�m "arccos" kh�ng n�m trong kho�ng [-1,1]';
                        grok:=p1.kind=kVar;
                      end
                    else
                      begin
                        if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccos(tmp1);
                      end;
                  end
                else
                  errmsg:='Tham s� c�a h�m "arccos" kh�ng h�p l�!';
            end
          else

          if (toantu='arctg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arctan(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "arctg" kh�ng h�p l�!';
            end
          else

          if (toantu='arccotg') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=arccot(p1.num);
                  end
                else
                  errmsg:='Tham s� c�a h�m "arccotg" kh�ng h�p l�!';
            end
          else

          if (toantu='sqrt') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin
                    if p1.num<0 then
                      begin errmsg:='Tham s� c�a h�m "sqrt" �m!'; grok:=p1.kind=kVar; end
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
                  errmsg:='Tham s� c�a h�m "sqrt" kh�ng h�p l�!';
            end
          else

          if (toantu='sqr') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=sqr(p1.num); end
                else
                if (p1.kind=kFrac) then
                  begin p3.kind:=kFrac; p3.t:=sqr(p1.t); p3.m:=sqr(p1.m); p3.num:=sqr(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "sqr" kh�ng h�p l�!';
            end
          else

          if (toantu='round') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=round(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "round" kh�ng h�p l�!';
            end
          else

          if (toantu='trunc')or(toantu='floor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=trunc(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "trunc" ho�c h�m "floor" kh�ng h�p l�!';
            end
          else

          if (toantu='ceiling') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=trunc(p1.num)+1; end
                else
                  errmsg:='Tham s� c�a h�m "ceilling" kh�ng h�p l�!';
            end
          else

          if (toantu='dtor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p1.num*pi/180; end
                else
                  errmsg:='Tham s� c�a h�m "dtor" kh�ng h�p l�!';
            end
          else

          if (toantu='rtod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=p1.num*180/pi; end
                else
                  errmsg:='Tham s� c�a h�m "rtod" kh�ng h�p l�!';
            end
          else

          if (toantu='gtod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoDeg(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "gtod" kh�ng h�p l�!';
            end
          else

          if (toantu='gtor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoRad(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "gtor" kh�ng h�p l�!';
            end
          else

          if (toantu='dtog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=DegtoGrad(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "dtog" kh�ng h�p l�!';
            end
          else

          if (toantu='rtog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=RadtoGrad(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "rtog" kh�ng h�p l�!';
            end
          else

          if (toantu='ctog') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoGrad(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "ctog" kh�ng h�p l�!';
            end
          else

          if (toantu='rtoc') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=RadtoCycle(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "rtoc" kh�ng h�p l�!';
            end
          else

          if (toantu='ctod') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoDeg(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "ctod" kh�ng h�p l�!';
            end
          else

          if (toantu='ctor') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=CycletoRad(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "ctor" kh�ng h�p l�!';
            end
          else

           if (toantu='dtoc') then
             begin
               p1:=stack[sp];
               if sp<=0 then errmsg:='Thi�u to�n h�ng!'
               else
                 if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                   begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=DegtoCycle(p1.num); end
                 else
                   errmsg:='Tham s� c�a h�m "dtoc" kh�ng h�p l�!';
             end
           else

           if (toantu='gtoc') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate,kFrac]) then
                  begin if (p1.kind=kVar) then p3.kind:=kVar else p3.kind:=kNum; p3.num:=GradtoCycle(p1.num); end
                else
                  errmsg:='Tham s� c�a h�m "gtoc" kh�ng h�p l�!';
            end
          else

           if (toantu='!') then
            begin
              if grerr='' then
                grerr:='To�n t� "!" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind in [kNum,kVar,kParam,kDate]) then
                  begin
                    if frac(p1.num)<>0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: To�n h�ng th� cu� ph�p t�nh "!" ���c t� ��ng l�m tr�n';
                    end;
                    p3.kind:=kNum; t1:=round(p1.num);
                    tmp1:=1; for t2:=2 to t1 do tmp1:=tmp1*t2; p3.num:=tmp1;
                  end
                else
                  errmsg:='Tham s� c�a to�n t� "!" kh�ng h�p l�!';
            end
          else

          if (toantu='hex') then
            begin
              if grerr='' then
                grerr:='H�m "hex" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';	
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(16,p1.name); end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "hex" ph�i l� x�u k� t�!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: hex(''FA00'')';
                  end;
            end
          else

          if (toantu='bin') then
            begin
              if grerr='' then
                grerr:='H�m "bin" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(2,p1.name); end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "bin" ph�i l� x�u k� t�!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: bin(''101011'')';
                  end;
            end
          else

          if (toantu='oct') then
            begin
              if grerr='' then
                grerr:='H�m "oct" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p1.kind=kStr) then
                  begin p3.kind:=kNum; p3.num:=BaseToDec(8,p1.name); end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "oct" ph�i l� x�u k� t�!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: oct(''17624'')';
                  end;
            end
          else

          if (toantu='base') then
            begin
              if grerr='' then
                grerr:='H�m "base" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if (p2.kind in [kNum,kVar,kParam,kDate]) and (p1.kind=kStr) then
                  begin
                    t1:=round(p2.num);
                    if t1 in [2..36] then
                      begin p3.kind:=kNum; p3.num:=BaseToDec(t1,p1.name); end
                    else
                      errmsg:='H�m "base" ch� c� th� chuy�n ��i c�c h� c� s� t� 2 d�n 36 sang h� c� s� 10';
                  end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "base" ph�i l� m�t s� v� m�t x�u k� t�!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: base(5,''2431'')';
                  end;
            end
          else

          if (toantu='random') then
            begin
              if grerr='' then
                grerr:='H�m "random" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                        ' to�n h�ng c�a h�m "random" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                  end;
                  t1:=round(p1.num); t2:=round(p2.num);
                  if t2>t1 then //doi vi tri t1,t2 de t2<t1
                    begin t1:=t1+t2; t2:=t1-t2; t1:=t1-t2; end;
                  randomize; p3.kind:=kNum; p3.num:=random(t1-t2+1)+t2;
                end
              else
                begin
                  errmsg:='Tham s� h�m "random" kh�ng h�p l�';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') Tham s� h�m "random" l� 2 s� nguy�n kh�ng �m';
                end;
            end
          else

          if (toantu='ucln') then
            begin
              if grerr='' then
                grerr:='H�m "ucln" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                  war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                    ' to�n h�ng c�a h�m "ucln" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                end;
                p3.num:=ucln(round(p1.num),round(p2.num));
              end
              else
                errmsg:='Tham s� c�a h�m "ucln" ph�i l� s� nguy�n d��ng!'
            end
          else

          if (toantu='bcnn') then
            begin
              if grerr='' then
                grerr:='H�m "bcnn" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; dec(sp); p2:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                  war[cwar]:=IntToStr(cwar)+') C�nh b�o: '+IntToStr(t1)+
                    ' to�n h�ng c�a h�m "bcnn" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                end;
                t1:=round(p1.num); t2:=round(p2.num);
                p3.num:=t1*t2/ucln(t1,t2);
              end
              else
                errmsg:='Tham s� c�a h�m "bcnn" ph�i l� s� nguy�n d��ng!'
            end
          else

          if (toantu='ptnt') then
            begin
              if grerr='' then
                grerr:='H�m "ptnt" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind in [kNum,kParam,kVar] then
                begin
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: To�n h�ng c�a h�m "ptnt" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                  end;
                  p3.kind:=kStr;
                  p3.name:=ptnt(round(p1.num));
                end
                else
                  errmsg:='Tham s� c�a h�m "ptnt" ph�i l� s� nguy�n!';
            end

          else
          if (toantu='dow') then
            begin
              if grerr='' then
                grerr:='H�m "dow" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind=kDate then
                  begin
                    try d1:=StrToDate(p1.name);
                    except
                      errmsg:='Tham s� c�a h�m "dow" kh�ng h�p l�!';
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') VD: dow([25/12/2002]) ho�c dow([25/12/2002]+100)l� h�p l�';
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
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n dow([25/12/2002]) v�i dow(25/12/2002)=dow(0.001041)';
                  end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "dow" kh�ng h�p l�!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: dow([25/12/2002]) ho�c dow([25/12/2002]+100)l� h�p l�';
                  end;
            end
          else

          if (toantu='sec') then
            begin
              if grerr='' then
                grerr:='H�m "sec" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "sec" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;
                      t1:=round(num);
                      if t1>86399 then errmsg:='Tham s� c�a h�m "sec" ph�i l� s� nguy�n nh� h�n 86400.'
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
                grerr:='H�m "min" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "min" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
                      end;
                      t1:=round(num);
                      if t1>1439 then errmsg:='Tham s� c�a h�m "min" ph�i l� s� nguy�n nh� h�n 1440.'
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
                grerr:='H�m "hour" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                  with p1 do
                    begin
                      if frac(p1.num)<>0 then
                      begin
                        inc(cwar);
                        war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "hour" kh�ng nguy�n n�n ���c t� ��ng l�m tr�n';
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
                grerr:='H�m "todate" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=DateToStr(p1.num);
                  except
                    errmsg:='Kh�ng th� ��i s� '+FloatToStr(p1.num)+' sang ki�u ng�y!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham s� c�a h�m "todate" kh�ng h�p l�!';

            end
          else

          if (toantu='totime') then
            begin
              if grerr='' then
                grerr:='H�m "totime" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=TimeToStr(p1.num);
                  except
                    errmsg:='Kh�ng th� ��i s� '+FloatToStr(p1.num)+' sang ki�u gi�!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham s� c�a h�m "totime" kh�ng h�p l�!';
            end
          else

          if (toantu='todatetime') then
            begin
              if grerr='' then
                grerr:='H�m "todatetime" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if p1.kind in [kNum,kVar,kParam,kDate,kFrac] then
                begin
                  try p3.name:=DateToStr(p1.num)+' '+TimeToStr(p1.num);
                  except
                    errmsg:='Kh�ng th� ��i s� '+FloatToStr(p1.num)+' sang ki�u th�i gian!'
                  end;
                  if errmsg='' then p3.kind:=kDate;
                end
              else
                errmsg:='Tham s� c�a h�m "todatetime" kh�ng h�p l�!';
            end
          else

          if (toantu='canchi_y') then
            begin
              if grerr='' then
                grerr:='H�m "canchi_y" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='Thi�u to�n h�ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                begin
                  t1:=StrToInt(FormatDateTime('yyyy',p1.num))-4;
                  t2:=t1 mod 12+1; t1:=t1 mod 10+1;
                end
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n canchi_y([4/2/1984]) v�i canchi_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "canchi_y" ���c t� ��ng ��i d�u v� l�m tr�n'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "canchi_y" ���c t� ��ng l�m tr�n';
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "canchi_y" �m n�n ���c t� ��ng ��i d�u';
                    end;
                  t1:=abs(round(p1.num)); t2:=t1;
                  if t1>3 then
                    begin t1:=(t1-4) mod 10+1; t2:=(t2-4) mod 12+1; end
                  else
                    begin t1:=(t1+6) mod 10+1; t2:=(t2+8) mod 12+1; end;
                end
              else
                begin
                  t2:=0; errmsg:='Tham s� c�a h�m "canchi_y" ph�i l� ki�u ng�y ho�c l� 1 s� nguy�n d��ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: canchi_y(2002) ho�c canchi_y([12/2/2002]+100)';
                end;
              p3.kind:=kStr; p3.name:=canstr[t1]+' '+chistr[t2];
            end
          else

          if (toantu='chi_y') then
            begin
              if grerr='' then
                grerr:='H�m "chi_y" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='Thi�u to�n h�ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                t1:=(StrToInt(FormatDateTime('yyyy',p1.num))-4)mod 12+1
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n chi_y([4/2/1984]) v�i chi_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "chi_y" ���c t� ��ng ��i d�u v� l�m tr�n'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "chi_y" ���c t� ��ng l�m tr�n'
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "chi_y" �m n�n ���c t� ��ng ��i d�u';
                    end;
                  t1:=abs(round(p1.num));
                  if t1>3 then t1:=(t1-4) mod 12+1 else t1:=(t1+8) mod 12+1;
                end
              else
                begin
                  errmsg:='Tham s� c�a h�m "chi_y" ph�i l� ki�u ng�y ho�c l� 1 s� nguy�n d��ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: chi_y(2002) ho�c chi_y([12/2/2002]-100)';
                end;
              p3.kind:=kStr; p3.name:=ChiStr[t1];
            end
          else

          if (toantu='can_y') then
            begin
              if grerr='' then
                grerr:='H�m "can_y" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp]; t1:=0;
              if sp<=0 then begin errmsg:='Thi�u to�n h�ng!'; grok:=grerr=''; exit; end;
              if (p1.kind=kDate) then
                t1:=(StrToInt(FormatDateTime('yyyy',p1.num))-4) mod 10+1
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n can_y([4/2/1984]) v�i can_y(4/2/1984)';
                  if (frac(p1.num)<>0)and(p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "can_y" ���c t� ��ng ��i d�u v� l�m tr�n'
                  end
                  else
                  if frac(p1.num)<>0 then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "can_y" ���c t� ��ng l�m tr�n'
                  end
                  else
                    if p1.num<0 then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "can_y" �m n�n ���c t� ��ng ��i d�u';
                    end;
                  t1:=abs(round(p1.num));
                  if t1>3 then t1:=(t1-4) mod 10+1 else t1:=(t1+6) mod 10+1;
                end
              else
                begin
                  errmsg:='Tham s� c�a h�m "can_y" ph�i l� ki�u ng�y ho�c l� 1 s� nguy�n d��ng!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_y(2002) ho�c can_y([12/2/2002]+100)';
                end;
              p3.kind:=kStr; p3.name:=CanStr[t1];
            end
          else

          if (toantu='can_m') then
            begin
              if grerr='' then
                grerr:='H�m "can_m" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if (p1.kind in [kDate,kNum,kVar,kParam]) then
                begin
                  if p1.kind in [kVar,kParam,kNum] then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n can_m([4/2/1984]) v�i can_m(4/2/1984)';
                  end;
                  p3.kind:=kStr;
                  p3.name:=canstr[1+(2*(((StrToInt(FormatDateTime('yyyy',p1.num))-4)
                    mod 10) mod 5)+StrToInt(FormatDateTime('mm',p1.num))+1) mod 10];
                end
              else
                begin
                  errmsg:='Tham s� c�a h�m "can_m" ph�i l� ki�u ng�y!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_m([4/2/1984])';
                end;
            end
          else

          if (toantu='canchi_m') then
            begin
              if grerr='' then
                grerr:='H�m "canchi_m" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
              if (p1.kind in [kDate,kNum,kParam,kVar]) then
                begin
                  if p1.kind in [kNum,kParam,kVar] then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Kh�ng ���c nh�m l�n can_m([4/2/1984]) v�i can_m(4/2/1984)';
                  end;
                  p3.kind:=kStr;
                  t1:=StrToInt(FormatDateTime('mm',p1.num));
                  p3.name:=canstr[1+(2*(((StrToInt(FormatDateTime('yyyy',p1.num))-4)
                    mod 10) mod 5)+t1+1) mod 10]+' '+chistr[t1];
                end
              else
                begin
                  errmsg:='Tham s� c�a h�m "can_m" ph�i l� ki�u ng�y!';
                  inc(cwar);
                  war[cwar]:=IntToStr(cwar)+') VD: can_m([4/2/1984])';
                end;
            end
          else

          if (toantu='chi_m') then
            begin
              if grerr='' then
                grerr:='H�m "chi_m" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then begin errmsg:='Thi�u to�n h�ng!'; grok:=grerr=''; exit; end; t1:=0;
              if p1.kind=kDate then
                t1:=StrToInt(FormatDateTime('mm',p1.num))
              else
              if p1.kind in [kNum,kVar,kParam] then
                begin
                  t1:=abs(round(p1.num));
                  if not (t1 in [1..12]) then
                    errmsg:='Tham s� c�a h�m "chi_m" ph�i l� ki�u ng�y ho�c l� 1 s� trong kho�ng [1..12].'
                  else
                  if (frac(p1.num)<>0) or (p1.num<0) then
                  begin
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "chi_m" ���c t� ��ng l�m tr�n ho�c ��i d�u';
                  end;
                end;
              p3.kind:=kStr; p3.name:=chistr[t1];
            end
          else

          {if (toantu='can_h') then
            begin
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                  errmsg:='Tham s� c�a h�m "can_h" ph�i l� ki�u gi�!';
                  with ComboBox1.Items do
                    add(IntToStr(count+1)+') VD: can_h([3:5:10]) hay can_h([3:5:10+sec(100)])...');
                end;
            end
          else}

          if (toantu='countday') then
            begin
              if grerr='' then
                grerr:='H�m "countday" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind=kDate then
                  begin p3.kind:=kNum; p3.num:=p1.num+693595; end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "countday" ph�i l� ki�u ng�y!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: countday([4/2/1984]) ho�c countday(cdate)';
                  end;
            end
          else

          if (toantu='eraday') then
            begin
              if grerr='' then
                grerr:='H�m "eraday" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
              else
                if p1.kind=kNum then
                  begin
                    if (p1.num<0)or(frac(p2.num)<>0) then
                    begin
                      inc(cwar);
                      war[cwar]:=IntToStr(cwar)+') C�nh b�o: Tham s� c�a h�m "eraday" �m n�n ���c t� ��ng ��i d�u!';
                    end;
                    p3.kind:=kDate; p3.num:=abs(p1.num)-693595;
                    p3.name:=DateToStr(p3.num);
                  end
                else
                  begin
                    errmsg:='Tham s� c�a h�m "eraday" ph�i l� 1 s� nguy�n d��ng!';
                    inc(cwar);
                    war[cwar]:=IntToStr(cwar)+') VD: eraday(39000) ho�c eraday(4020)';
                  end;
            end
          else

          if (toantu='tonum') then
            begin
              if grerr='' then
                grerr:='H�m "tonum" kh�ng s� d�ng ���c trong bi�u th�c v� �� th�!';
              p1:=stack[sp];
              if sp<=0 then errmsg:='Thi�u to�n h�ng!'
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
                          errmsg:='Kh�ng th� ��i x�u k� t� '+p1.name+' sang ki�u s�!';
                          inc(cwar);
                          war[cwar]:=IntToStr(cwar)+') H�m "tonum" ch� c� th� ��i c�c x�u ch� ng�y (Monday..) ho�c can, chi (Nh�m, Ng�..) sang ki�u s�';
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
      grok:=(grerr='')and(errmsg<>'Thi�u to�n h�ng!')and
        (errmsg<>'Thi�u to�n h�ng ho�c d�u ph�y ng�n c�ch hai tham s�!');

    if (sp>1)and(errmsg='') then
    begin
      errmsg:='Thi�u to�n t�(h�m) ho�c th�a to�n h�ng(tham s�)!';
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
      Edit1.Text:=LEdit.Text; LEdit.Text:='H� s� n�y ph�i l� ki�u s�';
      LEdit.Hint:=LEdit.Text; Exit;
    end;
    n:=p.num; LEdit.Hint:=FloatToStr(p.num);
  end;
end;

end.
