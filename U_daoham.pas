unit U_daoham;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UCommon;

type
  Tfrm_daoham = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_daoham: Tfrm_daoham;

implementation

{$R *.dfm}
type
  TStack=array [0..1000] of String;

const
  errstr: string='';
  saiso=1E-10;

procedure tinhbt(s: string);
begin

end;

function daoham(s: string): string;
var
  stack: ^TStack;
  suf: ^TPartArray;
  p1,p2,p3,s1,s2,toantu: string;
  sp,i,nsuf: integer;
  n1,n2: Extended;
begin
  if errstr<>'' then
    begin daoham:=errstr; exit; end;
  if s='x' then daoham:='1'
  else
  begin
    try
      StrToFloat(s);
      daoham:='0';
    except
      //De qui
      analyse(s,True); //Neu tinh bieu thuc thi la False
      errstr:=errmsg;
      if errstr<>'' then
        begin daoham:=errstr; exit; end;
      new(suf); new(stack);
      nsuf:=sufcount;
      move(suffix,suf^,sizeOf(TPart)*nsuf);

      sp:=0; i:=0;
      while i<nsuf do
      begin
        inc(i);
        if (suf^[i].kind<>kOpr) then
        begin
          inc(sp);
          case suf^[i].kind of
            kNum: stack^[sp]:=FloatToStr(suf^[i].num);
            kVar: stack^[sp]:='x';
            else
              begin
                errstr:='KiÓu cña to¸n h¹ng(tham sè) kh«ng hîp lÖ!'; exit;
              end;
          end;
        end
        else
        begin
          toantu:=opr[suf^[i].AOpr].name;

          if (toantu='+')or(toantu='-') then
          begin
            p1:=stack^[sp]; dec(sp); p2:=stack^[sp];
            s1:=daoham(p1); s2:=daoham(p2);
            if (s1='0')and(s2='0') then p3:='0'
            else if (s1='0') then p3:=s2
            else if (s2='0') then p3:=s1
            else p3:='('+s2+'+'+s1+')';
          end
          else

          if (toantu='—') then
          begin
            p1:=stack^[sp];
            p3:='-'+'('+daoham(p1)+')';
          end
          else

          if (toantu='*') then
          begin
            p1:=stack^[sp]; dec(sp); p2:=stack^[sp]; {p2*p1}
            if (p1='0')or(p2='0') then p3:='0'
            else
            begin
              s1:=daoham(p1); s2:=daoham(p2);
              //p3:=p2*s1+s2*p1
              //p2=p2*s1
              if s1='0' then p2:='0'
              else if p2='1' then p2:=s1
              else if s1<>'1' then p2:=p2+'*'+s1;
              //p1=s2*p1
              if s2='0' then p1:='0'
              else if p1='1' then p1:=s2
              else if s2<>'1' then p1:=s2+'*'+p1;
              //p3=p2+p1
              if (p1='0')and(p2='0') then p3:='0'
              else if (p1='0') then p3:=p2
              else if (p2='0') then p3:=p1
              else p3:='('+p2+'+'+p1+')';
            end;
          end
          else

          if (toantu='/') then
          begin
            p1:=stack^[sp]; dec(sp); p2:=stack^[sp]; {p2/p1}
            if p1='0' then
              begin errstr:='MÉu sè ph¶i kh¸c 0'; exit; end;
            if p2='0' then
              begin p3:='0'; exit; end;
            try
              n1:=StrToFloat(p1);
              n2:=1/n1;
              if frac(n2)<saiso then
                p3:=FloatToStr(n2)+'*'+daoham(p2)
              else  
                p3:=daoham(p2)+'/'+p1;
            except
              try
                n1:=StrToFloat(p2);
                p3:=FloatToStr(-n1)+'*'+daoham(p1)+'/'+p1+'^2';
              except
                s1:=daoham(p1); s2:=daoham(p2);
                //(s2*p1-p2*s1)/p1^2 (p1,p2<>0,1)
                p3:=p1+'^2';//p3=mau so
                //p1=s2*p1
                if s2='0' then p1:='0'
                else if s2<>'1' then p1:=s2+'*'+p1;
                //p2=s1*p2
                if s1='0' then p2:='0'
                else if s1<>'1' then p2:=s1+'*'+p2;
                //p3=(p1-p2)/p3
                if p1='0' then p3:='-'+p2+'/'+p3
                else if p2='0' then p3:=p1+'/'+p3
                else p3:='('+p1+'-'+p2+')/'+p3;
              end;
            end;
          end
          else


          begin
            errstr:='Kh«ng t×m ®­îc ®¹o hµm cña ';
            if opr[suf^[i].AOpr].func then errstr:=errstr+'to¸n tö ''' else errstr:=errstr+'hµm ''';
            errstr:=errstr+toantu+'''';
          end;

          if errstr='' then stack^[sp]:=p3 else break;
        end;
      end;
      if (sp>1)and(errmsg='') then
        errstr:='ThiÕu to¸n tö(hµm) hoÆc thõa to¸n h¹ng(tham sè)!'
      else
        daoham:=stack^[1];
      dispose(suf);
      dispose(stack);
    end;
  end;
end;

procedure Tfrm_daoham.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s,kq: string;
begin
  case key of
    27: close;
    13:
      begin
        s:=memo1.Lines.Strings[0];
        errstr:='';
        kq:=daoham(s);
        if errstr<>'' then memo2.Lines.Strings[0]:=errstr
        else memo2.Lines.Strings[0]:=kq;
      end;
  end;
end;

procedure Tfrm_daoham.FormCreate(Sender: TObject);
var s,kq: string;
begin
  s:='2*x+3';
  kq:=daoham(s);
  s:=kq;
end;

end.

//Chu y phep chia co mau la 1 bieu thuc <>0
