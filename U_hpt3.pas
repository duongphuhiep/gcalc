unit U_hpt3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm_hpt3 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LEdit1: TLabeledEdit;
    LEdit2: TLabeledEdit;
    LEdit3: TLabeledEdit;
    LEdit4: TLabeledEdit;
    LEdit5: TLabeledEdit;
    LEdit6: TLabeledEdit;
    LEdit7: TLabeledEdit;
    LEdit8: TLabeledEdit;
    LEdit9: TLabeledEdit;
    LEdit10: TLabeledEdit;
    LEdit11: TLabeledEdit;
    LEdit12: TLabeledEdit;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    BitBtn2: TBitBtn;
    GroupBox2: TGroupBox;
    LEdit13: TLabeledEdit;
    LEdit14: TLabeledEdit;
    LEdit15: TLabeledEdit;
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
  Form_hpt3: TForm_hpt3;

implementation

uses UCommon, UMain;
{$R *.dfm}

procedure TForm_hpt3.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TForm_hpt3.BitBtn1Click(Sender: TObject);
var
  a1,b1,c1,d1,a2,b2,c2,d2,a3,b3,c3,d3,
  d,dx,dy,dz,x,y,z: Extended;
  t,m: Integer;
  a: TArray33;
begin
  //Doc he so
  if not doc_hs(a1,LEdit1,Edit1) then Exit;
  if not doc_hs(b1,LEdit2,Edit1) then Exit;
  if not doc_hs(c1,LEdit3,Edit1) then Exit;
  if not doc_hs(d1,LEdit4,Edit1) then Exit;
  if not doc_hs(a2,LEdit5,Edit1) then Exit;
  if not doc_hs(b2,LEdit6,Edit1) then Exit;
  if not doc_hs(c2,LEdit7,Edit1) then Exit;
  if not doc_hs(d2,LEdit8,Edit1) then Exit;
  if not doc_hs(a3,LEdit9,Edit1) then Exit;
  if not doc_hs(b3,LEdit10,Edit1) then Exit;
  if not doc_hs(c3,LEdit11,Edit1) then Exit;
  if not doc_hs(d3,LEdit12,Edit1) then Exit;
  Edit1.Text:='';

  a[1,1]:=a1; a[1,2]:=b1; a[1,3]:=c1;
  a[2,1]:=a2; a[2,2]:=b2; a[2,3]:=c2;
  a[3,1]:=a3; a[3,2]:=b3; a[3,3]:=c3;
  d:=det3(a);
  a[1,1]:=d1; a[1,2]:=b1; a[1,3]:=c1;
  a[2,1]:=d2; a[2,2]:=b2; a[2,3]:=c2;
  a[3,1]:=d3; a[3,2]:=b3; a[3,3]:=c3;
  dx:=det3(a);
  a[1,1]:=a1; a[1,2]:=d1; a[1,3]:=c1;
  a[2,1]:=a2; a[2,2]:=d2; a[2,3]:=c2;
  a[3,1]:=a3; a[3,2]:=d3; a[3,3]:=c3;
  dy:=det3(a);
  a[1,1]:=a1; a[1,2]:=b1; a[1,3]:=d1;
  a[2,1]:=a2; a[2,2]:=b2; a[2,3]:=d2;
  a[3,1]:=a3; a[3,2]:=b3; a[3,3]:=d3;
  dz:=det3(a);

  if d=0 then
    if (dx=0)and(dy=0)and(dz=0) then
    begin
      LEdit13.Text:='v« sè nghiÖm';
      LEdit14.Text:='v« sè nghiÖm';
      LEdit15.Text:='v« sè nghiÖm';
    end
    else
    begin
      LEdit13.Text:='v« nghiÖm';
      LEdit14.Text:='v« nghiÖm';
      LEdit15.Text:='v« nghiÖm';
    end
  else
    if frac(d)=0 then
    begin
      if frac(dx)=0 then
      begin
        t:=trunc(dx);
        m:=trunc(d);
        rutgon(t,m);
        if t mod m=0 then LEdit13.Text:=IntToStr(t div m)
        else LEdit13.Text:=IntToStr(t)+':'+IntToStr(m);
      end
      else
        LEdit13.Text:=FloatToStr(dx/d);
      if frac(dy)=0 then
      begin
        t:=trunc(dy);
        m:=trunc(d);
        rutgon(t,m);
        if t mod m=0 then LEdit14.Text:=IntToStr(t div m)
        else LEdit14.Text:=IntToStr(t)+':'+IntToStr(m);
      end
      else
        LEdit14.Text:=FloatToStr(dy/d);
      if frac(dz)=0 then
      begin
        t:=trunc(dz);
        m:=trunc(d);
        rutgon(t,m);
        if t mod m=0 then LEdit15.Text:=IntToStr(t div m)
        else LEdit15.Text:=IntToStr(t)+':'+IntToStr(m);
      end
      else
        LEdit15.Text:=FloatToStr(dz/d);
    end
    else
    begin
      LEdit13.Text:=FloatToStr(dx/d);
      LEdit14.Text:=FloatToStr(dy/d);
      LEdit15.Text:=FloatToStr(dz/d);
    end;
end;

procedure TForm_hpt3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
