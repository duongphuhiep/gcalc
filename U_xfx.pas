unit U_xfx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UPaint, ComCtrls;

type
  TLapNghiem=object(TGraph)
  public
    xht: Extended; //nghiem hien tai
    delta: Extended; //delta=f(x)-x neu ham so hoi tu thi delta ngay cang tien toi 0
    solan: Integer; //So lan lap de tim ra nghiem tren
    procedure Lap;
  end;

type
  TForm_xfx = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Label1: TLabel;
    EPhuongtrinh: TLabeledEdit;
    ENhan: TLabeledEdit;
    Edit1: TEdit;
    ESoLan: TLabeledEdit;
    Panel2: TPanel;
    ENghiem: TLabeledEdit;
    EDaLap: TLabeledEdit;
    procedure BitBtn3Click(Sender: TObject);
    function doc_dl: Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    g: TLapNghiem;
    x0: Extended; //hat nhan
    NTimes: Integer; //So lan phai lap
  public
    { Public declarations }
  end;

var
  Form_xfx: TForm_xfx;

implementation

uses UCommon, UMain;
{$R *.dfm}

procedure TForm_xfx.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

function TForm_xfx.doc_dl: Boolean;
var tmp: Extended;
begin
  doc_dl:=True;
  g.content:=EPhuongtrinh.Text;
  g.Init; g.delta:=INFINITY;
  if g.err<>'' then
  begin
    with EPhuongtrinh do
    begin
      Edit1.Text:=Text; Edit1.Hint:=Text;
      Text:=g.err; Hint:=g.err;
    end;
    doc_dl:=False; Exit;
  end;
  if not doc_hs(x0,ENhan,Edit1) then
    begin doc_dl:=False; Exit; end;
  g.xht:=x0;
  if not doc_hs(tmp,ESoLan,Edit1) then
    begin doc_dl:=False; Exit; end;
  NTimes:=round(tmp);
  g.solan:=0;
end;

procedure TLapNghiem.Lap;
var i: Byte; xx,old_delta: Extended;
begin
  inc(solan);
  for i:=1 to Countx do Expression[Markx[i]].num:=xht;
  xx:=xht;
  if not F(xht) then err:='Thua! kh«ng t×m ®­îc nghiÖm!'
  else
  begin
    old_delta:=delta; delta:=abs(xht-xx);
    if old_delta<delta then
      err:='Kh«ng t×m ®­îc nghiÖm víi khëi t¹o nh­ vËy.';
  end;
end;

procedure TForm_xfx.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  g.Finish;
end;

procedure TForm_xfx.BitBtn2Click(Sender: TObject);
var s: String;
begin
  s:=BitBtn2.Caption;
  if s='B¾t ®Çu &LÆp' then
  begin
    Edit1.Text:='';
    BitBtn2.Caption:='T¹m &Dõng';
    if not doc_dl then Exit;
    Timer1.Enabled:=True;
    with ProgressBar1 do
      begin Visible:=true; Max:=NTimes; Min:=0; step:=1; end;
  end
  else
  if s='T¹m &Dõng' then
  begin
    with EDaLap do
      begin Text:=IntToStr(g.solan); Hint:=Text; end;
    with ENghiem do
      begin Text:=FloatToStr(g.xht); Hint:=Text; end;
    BitBtn2.Caption:='&TiÕp tôc';
    Timer1.Enabled:=False;
  end
  else //if s='tiep tuc'
  begin
    BitBtn2.Caption:='T¹m &Dõng';
    Timer1.Enabled:=True;
  end;
end;

procedure TForm_xfx.Timer1Timer(Sender: TObject);
begin
  if g.solan<NTimes then
    begin
      g.Lap;
      EDaLap.Text:=IntToStr(g.solan);
      ENghiem.Text:=FloatToStr(g.xht);
      ProgressBar1.StepIt;
      if g.err<>'' then
      begin
        Timer1.Enabled:=False;
        Edit1.Text:=g.err; Edit1.Hint:=g.err;
        BitBtn2.Caption:='B¾t ®Çu &LÆp';
      end;
    end
  else //ket thuc
  begin
    BitBtn2.Caption:='B¾t ®Çu &LÆp';
    Progressbar1.Visible:=False;
    ProgressBar1.Position:=0;
    with EDaLap do
      begin Text:=IntToStr(g.solan); Hint:=Text; end;
    with ENghiem do
      begin Text:=FloatToStr(g.xht); Hint:=Text; end;
  end;
end;

procedure TForm_xfx.BitBtn1Click(Sender: TObject);
begin
  BitBtn2.Caption:='B¾t ®Çu &LÆp';
  if not doc_dl then Exit;
  Timer1.Enabled:=False;
  g.delta:=INFINITY;
  with ProgressBar1 do
    begin Visible:=False; position:=0; Max:=NTimes; Min:=0; step:=1; end;
end;

procedure TForm_xfx.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    121: form1.Show;
  end;
end;

end.
