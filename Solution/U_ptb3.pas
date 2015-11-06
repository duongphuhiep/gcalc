unit U_ptb3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Math;

type
  TForm_ptb3 = class(TForm)
    GroupBox1: TGroupBox;
    LEdit1: TLabeledEdit;
    LEdit2: TLabeledEdit;
    LEdit3: TLabeledEdit;
    GroupBox2: TGroupBox;
    LEdit4: TLabeledEdit;
    LEdit5: TLabeledEdit;
    LEdit6: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    LEdit7: TLabeledEdit;
    Label2: TLabel;
    Label1: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_ptb3: TForm_ptb3;

implementation

uses UCommon, UMain;
{$R *.dfm}

procedure TForm_ptb3.BitBtn2Click(Sender: TObject);
begin
  close;
end;

function can3(x: Extended): Extended;
begin
  if x>0 then can3:=exp(ln(x)/3)
  else
  if x<0 then can3:=-exp(ln(-x)/3)
  else
  can3:=0;
end;

procedure TForm_ptb3.BitBtn1Click(Sender: TObject);
var
  a,b,c,d,p,q,m,delta,x1,x2,x3: Extended;
begin
  //Doc he so
  if not doc_hs(a,LEdit1,Edit1) then Exit;
  if a=0 then
    begin
      Edit1.Text:=LEdit1.Text;
      LEdit1.Text:='HÖ sè nµy ph¶i kh¸c 0.'; Exit;
    end;
  if not doc_hs(b,LEdit2,Edit1) then Exit;
  if not doc_hs(c,LEdit3,Edit1) then Exit;
  if not doc_hs(d,LEdit7,Edit1) then Exit;
  Edit1.Text:='';

  //Tim nghiem
  b:=b/a; c:=c/a; d:=d/a;
  p:=c-b*b/3; q:=d+2*b*b*b/27-b*c/3;
  delta:=q*q+4*p*p*p/27;
  if delta>=0 then
  begin
    x1:=can3((-q+sqrt(delta))/2)+can3((-q-sqrt(delta))/2);
    x1:=x1-b/3;
  end
  else
  begin
    m:=arccos(3*q*sqrt(3)/(p*sqrt(-4*p)));
    a:=sqrt(-4*p/3); {a la bien tam}
    x1:=a*cos(m/3)-b/3;
    x2:=a*cos((m+2*pi)/3)-b/3;
    x3:=a*cos((m+4*pi)/3)-b/3;
  end;

  //Xuat ket qua
  LEdit4.Text:=FloatToStr(x1);
  if delta>=0 then
    begin LEdit5.Text:=''; LEdit6.Text:=''; end
  else
    begin LEdit5.Text:=FloatToStr(x2); LEdit6.Text:=FloatToStr(x3); end
end;

procedure TForm_ptb3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
