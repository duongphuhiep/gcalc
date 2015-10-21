unit U_doi_ps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TForm_frac = class(TForm)
    LEdit1: TLabeledEdit;
    Edit1: TEdit;
    procedure Xuly;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_frac: TForm_frac;

implementation

uses UCommon, UMain;
{$R *.dfm}

procedure error;
begin
  MessageDlg('Ph¶i nhËp sè víi khu«n d¹ng: "x.y(z)" hoÆc "x.y" hoÆc "x.(z)"'+#10+#13+
    'VÝ dô: 12.10(35); 2.125; 3.(12);  ...'+#10+#13+#10+#13+
    'HoÆc nhËp sè víi khu«n d¹ng: "x.yEz" hoÆc "xEz"'+#10+#13+
    'VÝ dô: 12.101E3; 0.123E-2; 31E4; 501E-10;  ...',
    mtInformation,[mbOk],0);
end;

procedure TForm_frac.Xuly;
var
  s,s2: String; ck,ext,int,p,l_ck,l_ext,i: Integer; //int.ext(ck)
  ts,ms,l: Integer; x: Extended; am: Boolean;
begin
  //xoa space trong xau
  s:=LEdit1.Text;
  if s='' then begin error; exit; end;
  p:=pos(' ',s); while p>0 do begin delete(s,p,1); p:=pos(' ',s); end;
  if s[1]='-' then am:=true else am:=false;
  try x:=StrToFloat(s);
    p:=pos('E',s);
    if p>0 then {neu viet so dang khoa hoc thi doi sang dang so thuc}
    begin
      if am then begin delete(s,1,1); dec(p); end;
      s2:=copy(s,1,p-1); //s2 chua phan chinh
      delete(s,1,p); //s chua phan phu
      p:=pos('.',s2); if p=0 then p:=length(s2)+1 else delete(s2,p,1);
      l:=length(s2);
      p:=p+StrToInt(s); //tinh vi tri moi cua dau cham
      if p>1 then
      begin
        if p<=l then insert('.',s2,p)
        else
          begin inc(l); for i:=l to p-1 do insert('0',s2,l); end;
      end
      else
      begin
        for i:=1 downto p do insert('0',s2,1);
        insert('.',s2,2);
      end;
      if am then s2:=concat('-',s2);
      Edit1.Text:=s2; Exit;
    end
    else {neu khong, doi sang phan so binh thuong}
    begin
      if frac(x)=0 then
        begin ms:=1; ts:=trunc(x); end
      else
      begin
        s2:='1';
        for i:=pos('.',s)+1 to length(s) do s2:=s2+'0';
        ms:=StrToInt(s2);
        ts:=trunc(x*ms);
        rutgon(ts,ms);
        if am and (ts>0) then ts:=-ts;
      end;
    end;
  except //Neu x co chu ky\
    p:=pos('.',s);
    try
      int:=StrToInt(copy(s,1,p-1));
      Delete(s,1,p);
    except
      error; Exit;
    end;
    p:=pos('(',s);
    try
      ext:=StrToInt(copy(s,1,p-1));
      l_ext:=p-1;
      Delete(s,1,p);
    except
      ext:=0; l_ext:=0; Delete(s,1,1);
    end;
    try
      ck:=StrToInt(copy(s,1,length(s)-1));
      l_ck:=length(s)-1;
    except
      error; Exit;
    end;
    s2:=''; for i:=1 to l_ck do s2:=s2+'9';
    s:=s2; for i:=1 to l_ext do s:=s+'0';
    ms:=StrToInt(s);
    ts:=ck+ext*StrToInt(s2);
    rutgon(ts,ms);
    inc(ts,int*ms);
    if am and (ts>0) then ts:=-ts;
  end;
  Edit1.Text:=IntToStr(ts)+':'+IntToStr(ms);
end;

procedure TForm_frac.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
    13: xuly;
    27: Close;
  end;
end;

end.
