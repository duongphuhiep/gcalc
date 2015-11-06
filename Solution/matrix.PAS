unit matrix;

interface

uses SysUtils;

const
  ID_MARK='MAT';
  //ID_MARK_LIST='MTL';
  MAX_ROW=256;
  MAX_COL=256;

type
  str3=string[3];
  TMatrix=Record
    h,w: integer; {HxW -> h height, w width}
    data: array [1..MAX_ROW,1..MAX_COL] of extended;
    errmsg: string;
  end;
  PMatrix=^TMatrix;

function m_add(a,b: PMatrix; r: PMatrix): boolean;
function m_sub(a,b: PMatrix; r: PMatrix): boolean;
function m_mul(a,b: PMatrix; r: PMatrix): boolean;
function m_power(a: PMatrix; w: integer; r: PMatrix): boolean;
function m_boo(a,b: PMatrix; r: PMatrix): boolean;
procedure m_transp(a: PMatrix; r: PMatrix); {r la ma tran chuyen vi cua a}
function m_rev(a1: PMatrix; r: PMatrix): boolean; {r la ma tran nghich dao cua a}

function m_det(p: PMatrix): Extended;
function LoadMT(path: string; r: PMatrix): boolean;
function SaveMT(path: string; r: PMatrix): boolean;

implementation

(* MATRIX METHOD ************************************************************)

uses UCommon;

function LoadMT(path: string; r: PMatrix): boolean;
var
  f: file;
  i,h1,w1: integer;
  mark: array [0..2] of char;
begin
  assignFile(f,path);
  {$I-} reset(f,1); {$I+}
  if ioResult<>0 then
    begin LoadMT:=false; r.errmsg:='Kh«ng thÓ ®äc file '+path; exit; end;
  blockRead(f,mark[0],3);
  if mark<>ID_MARK then
    begin LoadMT:=false; r.errmsg:='Khu«n d¹ng file'+path+'kh«ng phï hîp.'; exit; end;
  blockRead(f,h1,4);
  blockRead(f,w1,4);
  r^.h:=h1; r^.w:=w1;
  for i:=1 to h1 do
    blockRead(f,r^.data[i],w1*10);
  closeFile(f);
  LoadMT:=true;
end;

function SaveMT(path: string; r: PMatrix): boolean;
var
  f: file;
  i: integer;
begin
  assignFile(f,path);
  {$I-} rewrite(f,1); {$I+}
  if ioResult<>0 then
    begin SaveMT:=false; r.errmsg:='Kh«ng thÓ ghi vµo file '+path; exit; end;
  blockWrite(f,ID_MARK,3);
  with r^ do
  begin
    blockWrite(f,h,4);
    blockWrite(f,w,4);
    for i:=1 to h do
      blockWrite(f,data[i],w*10);
    closeFile(f);
    SaveMT:=true;
  end;
end;

{procedure TMatrix.print;
var i,j: integer;
begin
  with frm_matrix do
  begin
    edt_width.Value:=w;
    edt_height.Value:=h;
    for i:=1 to h do
      for j:=1 to w do
        grd_matrix.Cells[j-1,i-1]:=FloatToStr(data[i,j]);
  end;
end;
}
(* PROCESS OF MATRIX ********************************************************)

function m_add(a,b: PMatrix; r: PMatrix): boolean;
var
  i,j: integer;
begin
  fillChar(r^,sizeOf(r^),0);
  if (a^.h=b^.h)and(a^.w=b^.w) then m_add:=True
  else
    begin m_add:=False; r^.errmsg:='ChØ céng ®­îc 2 ma trËn cã cïng kÝch th­íc.'; exit; end;

  r^.h:=a^.h;
  r^.w:=b^.w;
  for i:=1 to a^.h do
    for j:=1 to a^.w do
      r^.data[i,j] := a^.data[i,j] + b^.data[i,j];
end;

function m_sub(a,b: PMatrix; r: PMatrix): boolean;
var
  i,j: integer;
begin
  fillChar(r^,sizeOf(r^),0);
  if (a^.h=b^.h)and(a^.w=b^.w) then m_sub:=True
  else
    begin m_sub:=False; r^.errmsg:='ChØ trõ ®­îc 2 ma trËn cã cïng kÝch th­íc.'; exit; end;

  r^.h:=a^.h;
  r^.w:=b^.w;
  for i:=1 to a^.h do
    for j:=1 to a^.w do
      r^.data[i,j] := a^.data[i,j] - b^.data[i,j];
end;

function m_mul(a,b: PMatrix; r: PMatrix): boolean;
var
  i,j,k: integer;
  s: extended;
begin
  fillChar(r^,sizeOf(r^),0);
  {correct so as a.w=b^.h if data is real regular}
  if a^.w=b^.h then m_mul:=True
  else
    begin m_mul:=False; r^.errmsg:='Sè cét cña ma trËn 1 kh«ng b»ng sè dßng cña ma trËn 2'; exit; end;

  r^.h:=a^.h; r^.w:=b^.w;
  for i:=1 to a^.h do
    for j:=1 to b^.w do
    begin
      s:=0;
      for k:=1 to a^.w do
        s := s + a^.data[i,k] * b^.data[k,j];
      r^.data[i,j]:=s;
    end;
end;

function m_power(a: PMatrix; w: integer; r: PMatrix): boolean;
var
  i: integer;
  tmp: PMatrix;
begin
  if a^.w<>a^.h then
    begin m_power:=False; r^.errmsg:='ChØ thùc hiÖn phÐp lòy thõa víi ma trËn vu«ng'; exit; end
  else m_power:=True;
  fillChar(r^,sizeOf(r^),0);
  r^.h:=a^.h;
  r^.w:=a^.w;
  for i:=1 to r^.h do r^.data[i,i]:=1;
  new(tmp);
  for i:=1 to w do
  begin
    move(r^,tmp^,sizeOf(TMatrix));
    m_mul(tmp,a,r);
  end;
  dispose(tmp);
end;

function m_boo(a,b: PMatrix; r: PMatrix): boolean;
var
  i,j,k,s: integer;
begin
  fillChar(r^,sizeOf(r^),0);
  {correct so as a^.w=b^.h if data is real regular}
  if a^.w=b^.h then m_boo:=True {not modify!}
  else
    begin m_boo:=False; r^.errmsg:='Sè cét cña ma trËn 1 kh«ng b»ng sè dßng cña ma trËn 2'; exit; end;

  r^.h:=a^.h; r^.w:=b^.w;
  for i:=1 to a^.h do
    for j:=1 to b^.w do
    begin
      s:=0;
      for k:=1 to a^.w do
        if (a^.data[i,k]=1) and (b^.data[k,j]=1) then
          begin s:=1; {terminal k loop} break; end;
      r^.data[i,j]:=s;
    end;
end;

procedure m_transp(a: PMatrix; r: PMatrix);
var i,j: integer;
begin
  fillChar(r^,sizeOf(r^),0);
  r^.h:=a^.w;
  r^.w:=a^.h;
  for i:=1 to r^.h do
    for j:=1 to r^.w do
    begin
      r^.data[i,j]:=a^.data[j,i];
    end;
end;

function m_rev(a1: PMatrix; r: PMatrix): boolean;
var
  i,j,k,n,t: integer; e,x,max: extended;
  tmp: array [1..MAX_ROW] of extended;
  ok: boolean;
  a: PMatrix;
begin
  FillChar(r^,sizeOf(TMatrix),0);
  new(a);
  Move(a1^,a^,sizeOf(TMatrix));
  if a^.w<>a^.h then
    begin
      m_rev:=False;
      r^.errmsg:='ChØ nghÞch ®¶o ®­îc ma trËn vu«ng';
      dispose(a); m_rev:=False;
      Exit;
    end
  else
    m_rev:=True;
  n:=a^.h;
  {init r^}
  fillChar(r^,sizeof(r^),0);
  r^.w:=n; r^.h:=n;
  for i:=1 to n do r^.data[i,i]:=1;

  for j:=1 to n do
  begin
    if j<n then
    begin
      t:=j; max:=abs(a^.data[t,j]);
      for i:=j+1 to n do
      begin
        x:=abs(a^.data[i,j]);
        if (x>max) then
          begin max:=x; t:=i end;
      end;
      if max=0 then
      begin
        r^.errmsg:='Ma trËn kh«ng kh¶ nghÞch.';
        dispose(a); m_rev:=False;
        Exit;
      end;
      with a^ do
      begin
        move(data[t],tmp,sizeOf(tmp));
        move(data[j],data[t],sizeOf(tmp));
        move(tmp,data[j],sizeOf(tmp));
      end;
      with r^ do
      begin
        move(data[t],tmp,sizeOf(tmp));
        move(data[j],data[t],sizeOf(tmp));
        move(tmp,data[j],sizeOf(tmp));
      end;
    end
    else
    if a^.data[j,j]=0 then
    begin
      r^.errmsg:='Ma trËn kh«ng kh¶ nghÞch.';
      dispose(a); m_rev:=False;
      Exit;
    end;

    for i:=1 to n do
      if (i<>j)and(a^.data[i,j]<>0) then
      begin
        e:=a^.data[i,j]/a^.data[j,j];
        for k:=1 to n do
        begin
          r^.data[i,k]:=r^.data[i,k]-r^.data[j,k]*e;
          a^.data[i,k]:=a^.data[i,k]-a^.data[j,k]*e;
        end;
        {write('r^',i,' = r^',i,' - r^',j,' * ',e:0:2,' ---- '); a.print;}
      end;
  end;
  for i:=1 to n do
  begin
    x:=a^.data[i,i];
    for j:=1 to n do
      r^.data[i,j]:=r^.data[i,j]/x;
  end;
  dispose(a); m_rev:=True;
end;

function m_det(p: PMatrix): Extended;
var
  p2: PMatrix;
  ar: TArray33;
  i,j: Integer;
  sum: Extended;
begin
  with p^ do
    if w=3 then
    begin
      Move(data[1,1],ar[1,1],3*SizeOf(Extended));
      Move(data[2,1],ar[2,1],3*SizeOf(Extended));
      Move(data[3,1],ar[3,1],3*SizeOf(Extended));
      m_det:=det3(ar);
    end
    else
    if w=2 then
      m_det:=data[1,1]*data[2,2]-data[1,2]*data[2,1]
    else
    begin
      sum:=0;
      for j:=1 to w do
        if data[1,j]<>0 then
        begin
          new(p2);
          p2^.h:=h-1;
          p2^.w:=w-1;
          for i:=2 to w do
          begin
            move(data[i,1],p2^.data[i-1,1],(j-1)*SizeOf(Extended));
            move(data[i,j+1],p2^.data[i-1,j],(w-j)*SizeOf(Extended));
          end;
          if j mod 2=0 then
            sum:=sum-data[1,j]*m_det(p2)
          else
            sum:=sum+data[1,j]*m_det(p2);
          dispose(p2);
          m_det:=sum;
        end;
    end;
end;

end.