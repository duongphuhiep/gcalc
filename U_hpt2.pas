unit U_hpt2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm_hpt2 = class(TForm)
    GroupBox1: TGroupBox;
    LEdit1: TLabeledEdit;
    LEdit2: TLabeledEdit;
    LEdit3: TLabeledEdit;
    LEdit4: TLabeledEdit;
    LEdit5: TLabeledEdit;
    LEdit6: TLabeledEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    LEdit7: TLabeledEdit;
    LEdit8: TLabeledEdit;
    LEdit9: TLabeledEdit;
    LEdit10: TLabeledEdit;
    LEdit11: TLabeledEdit;
    LEdit12: TLabeledEdit;
    LEdit13: TLabeledEdit;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_hpt2: TForm_hpt2;

implementation
uses UCommon, UMain;
{$R *.dfm}

procedure TForm_hpt2.BitBtn1Click(Sender: TObject);
var
  a1,b1,c1,a2,b2,c2,d,dx,dy: Extended;
  t,m: Integer;
begin
  //Doc he so
  if not doc_hs(a1,LEdit1,Edit1) then Exit;
  if not doc_hs(b1,LEdit2,Edit1) then Exit;
  if not doc_hs(c1,LEdit3,Edit1) then Exit;
  if not doc_hs(a2,LEdit4,Edit1) then Exit;
  if not doc_hs(b2,LEdit5,Edit1) then Exit;
  if not doc_hs(c2,LEdit6,Edit1) then Exit;
  Edit1.Text:='';

  //giai he pt
  d:=a1*b2-a2*b1; dx:=c1*b2-c2*b1; dy:=a1*c2-a2*c1;
  LEdit7.Text:=FloatToStr(d);
  LEdit8.Text:=FloatToStr(dx);
  LEdit9.Text:=FloatToStr(dy);
  LEdit12.Text:=''; LEdit13.Text:='';
  if (dx=0)and(dy=0) then
  begin
    LEdit10.Text:='v« sè nghiÖm';
    LEdit11.Text:='v« sè nghiÖm';
  end
  else
  if d=0 then
  begin
    LEdit10.Text:='v« nghiÖm';
    LEdit11.Text:='v« nghiÖm';
  end
  else
  begin
    if Frac(d)=0 then
    begin
      if (Frac(dx)=0)and(dx<>0) then
      begin
        t:=trunc(dx); m:=trunc(d); rutgon(t,m);
        if m=1 then LEdit10.Text:=IntToStr(t)
        else
        begin
          LEdit10.Text:=IntToStr(t)+':'+IntToStr(m);
          LEdit12.Text:=FloatToStr(dx/d);
        end;  
      end
      else
        LEdit10.Text:=FloatToStr(dx/d);

      if (Frac(dy)=0)and(dy<>0) then
      begin
        t:=trunc(dy); m:=trunc(d); rutgon(t,m);
        if m=1 then LEdit11.Text:=IntToStr(t)
        else
        begin
          LEdit11.Text:=IntToStr(t)+':'+IntToStr(m);
          LEdit13.Text:=FloatToStr(dy/d);
        end;  
      end
      else
        LEdit11.Text:=FloatToStr(dy/d);
    end
    else
    begin
      LEdit10.Text:=FloatToStr(dx/d);
      LEdit11.Text:=FloatToStr(dy/d);
    end;
  end;
  LEdit7.Hint:=LEdit7.Text;
  LEdit8.Hint:=LEdit8.Text;
  LEdit9.Hint:=LEdit9.Text;
end;

procedure TForm_hpt2.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TForm_hpt2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
