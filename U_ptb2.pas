unit U_ptb2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm_gptb2 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LEdit1: TLabeledEdit;
    LEdit2: TLabeledEdit;
    LEdit3: TLabeledEdit;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    LEdit4: TLabeledEdit;
    LEdit5: TLabeledEdit;
    LEdit6: TLabeledEdit;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    GroupBox3: TGroupBox;
    LEdit7: TLabeledEdit;
    LEdit8: TLabeledEdit;
    Label2: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure tim_nghiem;
    procedure tim_he_so;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_gptb2: TForm_gptb2;

implementation

uses UCommon, UMain;
{$R *.dfm}

procedure TForm_gptb2.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TForm_gptb2.tim_nghiem;
var
  a,b,c,delta,x1,x2,rt,rm: Extended;
  t,m,u: Integer;
begin
  //Doc he so
  if not doc_hs(a,LEdit1,Edit1) then Exit;
  if a=0 then
    begin Edit1.Text:=LEdit1.Text; LEdit1.Text:='HÖ sè nµy ph¶i kh¸c 0.'; Exit; end;
  if not doc_hs(b,LEdit2,Edit1) then Exit;
  if not doc_hs(c,LEdit3,Edit1) then Exit;
  Edit1.Text:='';

  //tim nghiem
  delta:=b*b-4*a*c;
  LEdit4.Text:=FloatToStr(delta);
  if delta<0 then
  begin
    LEdit5.Text:='v« nghiÖm'; LEdit6.Text:='v« nghiÖm';
    LEdit7.Text:='v« nghiÖm'; LEdit8.Text:='v« nghiÖm';
    Exit;
  end;
  x1:=-b; x1:=x1+sqrt(delta); x1:=x1/(2*a);
  LEdit7.Text:=FloatToStr(x1); //??? LEdit7.Text:=FloatoStr(-b+sqrt(delta)/(2*a))

  x2:=-b; x2:=x2-sqrt(delta); x2:=x2/(2*a);
  LEdit8.Text:=FloatToStr(x2); //??? LEdit8.Text:=FloatoStr(-b-sqrt(delta)/(2*a))
  rm:=a*2;

  if frac(sqrt(delta))=0 then
  begin
    delta:=sqrt(delta);
    //nghiem lon x1
    rt:=-b+delta;
    if (frac(rt)=0) and (frac(rm)=0) then
    begin
      t:=trunc(rt); m:=trunc(rm);
      if t mod m=0 then
        LEdit5.Text:=IntToStr(t div m)
      else
      begin
        u:=ucln(t,m); t:=t div u; m:=m div u;
        if m<0 then begin t:=-t; m:=-m; end;
        LEdit5.Text:=IntToStr(t)+':'+IntToStr(m);
      end;
    end
    else
      LEdit5.Text:=FloatToStr(rt/rm);
    if delta<>0 then
    begin
    //nghiem nho x2
    rt:=-b-delta;
    if (frac(rt)=0) and (frac(rm)=0) then
    begin
      t:=trunc(rt); m:=trunc(rm);
      if t mod m=0 then
        LEdit6.Text:=IntToStr(t div m)
      else
      begin
        u:=ucln(t,m); t:=t div u; m:=m div u;
        if m<0 then begin t:=-t; m:=-m; end;
        LEdit6.Text:=IntToStr(t)+':'+IntToStr(m);
      end;
    end
    else
      LEdit5.Text:=FloatToStr(rt/rm);
    end {if delta=0}
    else
      begin LEdit6.Text:=''; LEdit8.Text:=''; end;
  end
  else //neu delta khong phai la so chinh phuong
  begin
    LEdit5.Text:='('+FloatToStr(-b)+'+sqrt('+FloatToStr(delta)+'))/'+FloatToStr(rm);
    LEdit6.Text:='('+FloatToStr(-b)+'-sqrt('+FloatToStr(delta)+'))/'+FloatToStr(rm);
  end;
end;

procedure TForm_gptb2.tim_he_so;
var
  a,b,hs1,hs2: Extended;
begin
  if not doc_hs(a,LEdit5,Edit1) then Exit;
  if not doc_hs(b,LEdit6,Edit1) then Exit;
  Edit1.Text:='';
  hs1:=-(a+b);
  hs2:=a*b;
  LEdit1.Text:='1';
  LEdit2.Text:=FloatToStr(hs1);
  LEdit3.Text:=FloatToStr(hs2);
  LEdit4.Text:=FloatToStr(hs1*hs1-4*hs2);
  LEdit7.Text:=FloatToStr(a); LEdit8.Text:=FloatToStr(b);
end;

procedure TForm_gptb2.BitBtn1Click(Sender: TObject);
begin
  if (LEdit1.Text='')and(LEdit2.Text='')and((LEdit3.Text='')) and
     (LEdit5.Text<>'')and(LEdit6.Text<>'')
  then
    tim_he_so
  else
  begin
    if LEdit1.Text='' then LEdit1.Text:='1';
    if LEdit2.Text='' then LEdit1.Text:='0';
    if LEdit3.Text='' then LEdit1.Text:='0';
    tim_nghiem;
  end;
end;

procedure TForm_gptb2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
