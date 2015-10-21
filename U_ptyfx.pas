unit U_ptyfx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, UPaint, ComCtrls;

type
  TEpNghiem=object(TGraph)
  public
    sai_so: Extended;
    n: Integer; //so lan da ep khoang
    procedure ep_nghiem; {Tim nghiem cua phuong trinh neu duoc}
    function co_nghiem: Boolean; {kiem tra xem co duoc ep nghiem khong}
  end;

  TForm_yfx = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    ELim1: TLabeledEdit;
    ELim2: TLabeledEdit;
    EPhuongtrinh: TLabeledEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ESoLan: TLabeledEdit;
    ESaiSo: TLabeledEdit;
    ELoi: TEdit;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    g: TEpNghiem;
    count: Integer; //dem so lan ep khoang
    epxilon: Extended;

    OldLim1,OldLim2,
    OldEpxilon,
    OldCount: String;
    OldCheck1: Boolean;
  public
    { Public declarations }
  end;

var
  Form_yfx: TForm_yfx;

implementation

uses UCommon, UMain;
{$R *.dfm}

function TEpNghiem.co_nghiem: Boolean;
var i: Byte; y1,y2: Extended;
begin
  for i:=1 to Countx do
    Expression[Markx[i]].num:=Limit1;
  if not F(y1) then err:='Hµm sè kh«ng liªn tôc trªn kho¶ng ®· cho.';
  for i:=1 to Countx do
    Expression[Markx[i]].num:=Limit2;
  if not F(y2) then err:='Hµm sè kh«ng liªn tôc trªn kho¶ng ®· cho.';
  if y1*y2<=0 then co_nghiem:=true else co_nghiem:=false;
  sai_so:=Limit2-Limit1; n:=0;
end;

procedure TEpNghiem.ep_nghiem;
var
  i: Byte; y1,y2,y3,x3: Extended;
begin
  for i:=1 to Countx do Expression[Markx[i]].num:=Limit1;
  if not F(y1) then err:='Hµm sè kh«ng liªn tôc trªn kho¶ng ®· cho.';

  x3:=(Limit1+limit2)/2;
  for i:=1 to Countx do Expression[Markx[i]].num:=x3;
  if not F(y3) then err:='Hµm sè kh«ng liªn tôc trªn kho¶ng ®· cho.';

  for i:=1 to Countx do Expression[Markx[i]].num:=Limit2;
  if not F(y2) then err:='Hµm sè kh«ng liªn tôc trªn kho¶ng ®· cho.';

  if err='' then
  begin
    if y1*y3<=0 then limit2:=x3 else limit1:=x3;
    sai_so:=limit2-limit1; inc(n);
  end;
end;

procedure TForm_yfx.BitBtn4Click(Sender: TObject);
begin
  close;
end;

procedure TForm_yfx.BitBtn1Click(Sender: TObject);
var tmp: Extended; ok: Boolean; s: String;
begin
  s:=BitBtn1.Caption;
  if s='TÝnh &L¹i' then BitBtn2.Caption:='T¹m &Dõng'
  else
  if s='&B¾t ®Çu tÝnh' then
  begin
  //read data
  if not doc_hs(g.Limit1,ELim1,ELoi) then Exit;
  if not doc_hs(g.Limit2,ELim2,ELoi) then Exit;
  if g.Limit1<g.Limit1 then
    begin tmp:=g.limit1; g.limit1:=g.limit2; g.limit2:=tmp; end;
  with g do
  begin
    content:=EPhuongTrinh.Text;
    Init;
    if err<>'' then
    begin
      ELoi.Text:=EPhuongtrinh.Text; EPhuongtrinh.Text:=g.err; Exit;
    end;
    if not co_nghiem then
    begin
      ELoi.Text:=EPhuongtrinh.Text;
      EPhuongtrinh.Text:='Ph­¬ng tr×nh kh«ng ®¬n ®iÖu hoÆc v« nghiÖm trªn kho¶ng ®· cho.';
      EPhuongtrinh.Hint:=EPhuongtrinh.Text; Exit;
    end;
    if err<>'' then
    begin
      ELoi.Text:=EPhuongtrinh.Text;
      EPhuongtrinh.Text:=err; EPhuongtrinh.Hint:=err; Exit;
    end;
  end;

  ok:=true;
  if RadioButton1.Checked then
    if not doc_hs(tmp,ESoLan,ELoi) then ok:=false
    else count:=round(abs(tmp))
  else
    if not doc_hs(epxilon,ESaiSo,ELoi) then ok:=false
    else epxilon:=abs(epxilon);

  if ok then
  begin
    //luu trang thai ok cuoi cung 
    OldLim1:=ELim1.Text;
    OldLim2:=ELim2.Text;
    OldEpxilon:=ESaiSo.Text;
    OldCount:=ESoLan.Text;
    OldCheck1:=RadioButton1.Checked;
  end;

  end //end if s='Bat dau tinh'
  else
    ok:=true;

  //khoi dong tinh toan
  if ok then
  begin
    Bitbtn1.Enabled:=False;
    BitBtn2.Enabled:=true;
    BitBtn3.Enabled:=False;
    Timer1.Enabled:=true;
  end;
end;

procedure TForm_yfx.RadioButton1Click(Sender: TObject);
begin
  ESaiSo.Color:=clBtnFace;
  ESaiSo.ReadOnly:=true;
  ESoLan.Color:=clWhite;
  ESoLan.ReadOnly:=false;
end;

procedure TForm_yfx.RadioButton2Click(Sender: TObject);
begin
  ESoLan.Color:=clBtnFace;
  ESoLan.ReadOnly:=true;
  ESaiSo.Color:=clWhite;
  ESaiSo.ReadOnly:=false;
end;

procedure TForm_yfx.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  g.Finish;
end;

procedure TForm_yfx.BitBtn3Click(Sender: TObject);
begin
  ELim1.Text:=OldLim1;
  ELim2.Text:=OldLim2;
  ESaiSo.Text:=OldEpxilon;
  ESoLan.Text:=OldCount;
  BitBtn1.Caption:='&B¾t ®Çu tÝnh';
  BitBtn2.Caption:='T¹m &Dõng';
  RadioButton1.Checked:=OldCheck1;
end;

procedure TForm_yfx.Timer1Timer(Sender: TObject);
  procedure KetThucTinh;
  begin
    Timer1.Enabled:=False;
    BitBtn1.Caption:='&B¾t ®Çu tÝnh';
    Bitbtn1.Enabled:=True;
    Bitbtn2.Enabled:=False;
    BitBtn3.Enabled:=true;

    ELim1.Hint:=ELim1.Text;
    ELim2.Hint:=ELim2.Text;
    ESoLan.Hint:=ESoLan.Text;
    ESaiSo.Hint:=ESaiSo.Text;

    ELoi.Text:=''; ELoi.Hint:='';
  end;

  procedure xuly;
  begin
    g.ep_nghiem;
    if g.err<>'' then
    begin
      ELoi.Text:=EPhuongtrinh.Text;
      EPhuongtrinh.Text:=g.err;
      KetThucTinh;
    end
    else
    begin
      ESoLan.Text:=IntToStr(g.n);
      ESaiSo.Text:=FloatToStr(g.sai_so);
      ELim1.Text:=FloatToStr(g.Limit1);
      ELim2.Text:=FloatToStr(g.Limit2);
    end;  
  end;
begin
  //tinh toan
  if OldCheck1 then
    if g.n<count then xuly
    else KetThucTinh
  else
    if g.sai_so>epxilon then xuly
    else KetThucTinh
end;

procedure TForm_yfx.BitBtn2Click(Sender: TObject);
begin
  if BitBtn2.Caption='T¹m &Dõng' then //tam dung
  begin
    Timer1.Enabled:=False;
    Bitbtn1.Enabled:=True;
    BitBtn1.Caption:='TÝnh &L¹i';
    Bitbtn2.Caption:='&TiÕp tôc';
    BitBtn3.Enabled:=True;
    ESoLan.Text:=FloatToStr(g.n);
    ESaiSo.Text:=FloatToStr(g.sai_so);
    ELim1.Text:=FloatToStr(g.Limit1);
    ELim2.Text:=FloatToStr(g.Limit2);
    ELim1.Hint:=ELim1.Text;
    ELim2.Hint:=ELim2.Text;
  end
  else //tiep tuc tinh
  begin
    Timer1.Enabled:=True;
    BitBtn1.Enabled:=False;
    Bitbtn2.Caption:='T¹m &Dõng';
    BitBtn2.Enabled:=true;
    BitBtn3.Enabled:=False;
    Timer1.Enabled:=true;
    {ELim1.Text:=FloatToStr(g.Limit1);
    ELim2.Text:=FloatToStr(g.Limit2);}
  end;
end;

procedure TForm_yfx.FormCreate(Sender: TObject);
begin
  OldLim1:=''; OldLim2:='';
  OldEpxilon:=''; OldCount:='';
  OldCheck1:=true;
  RadioButton1.Checked:=true;
  {EPhuongtrinh.Text:='-2*x^3+-3*x-5';
  ESaiso.Text:='10^-5';
  ELim1.Text:='-10';
  ELim2.Text:='10';}
end;

procedure TForm_yfx.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
