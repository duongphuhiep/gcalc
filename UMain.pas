{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE ON}
{$WARN UNSAFE_CODE ON}
{$WARN UNSAFE_CAST ON}
unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus, ComCtrls, UCommon, Spin,
  ToolWin, ImgList, U_daoham;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    SpinEdit1: TSpinEdit;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    RichEdit1: TRichEdit;
    CheckBox1: TCheckBox;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton17: TToolButton;
    ToolButton15: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure Calc;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure xuat_ra_edit2;
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure MyShowHint(var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    { Public declarations }
    {
    procedure WndProc(var Msg: TMessage); override;
    function DrawCaption(fActive: Boolean): Boolean;}
  end;

var
  Form1: TForm1;

implementation

//{$APPTYPE CONSOLE}

{$R *.DFM}
uses UVarDlg, UGrDlg, UPaint, UWndDraw, U_ptb2, U_ptb3, U_hpt2, U_hpt3,
  U_ptyfx, U_xfx, U_doi_ps, U_splash, U_Matran, U_CUnit;

procedure TForm1.MyShowHint(var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
var i: Integer;
begin
  for i:=0 to Application.ComponentCount-1 do
    if Application.Components[i] is THintWindow then
      with THintWindow(Application.Components[i]).Canvas do
      begin
        Font.Name:='GCalc System Font   ';
        Font.Size:=9;
      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
  procedure ass(str: TStr10; w,s: byte; f: boolean);
    begin
      inc(AmountOfOperator);
      with opr[AmountOfOperator] do
        begin name:=str; weight:=w; state:=s; func:=f; end;
    end;
  var i,j: integer; tmp: TOperator;
begin
  //mark(AllOfPointer);
  ShortDateFormat:='d/m/yyyy';
  //khoi tao thong tin ve cac toan tu.
  AmountOfConst:=0;  AmountOfOperator:=0;
  ass('(',0,0,false);      ass(')',0,0,false);      ass(',',20,0,false);
  ass('[',0,0,false);      ass(']',0,0,false);      ass(':',4,2,false);

  ass('+',1,2,false);      ass('-',1,2,false);
  ass('*',2,2,false);      ass('/',2,2,false);      ass('^',3,2,false);
  ass('div',2,2,false);    ass('mod',2,2,false);

  ass('and',3,2,false);    ass('or',3,2,false);     ass('xor',3,2,false);
  ass('->',3,2,false);     ass('<->',3,2,false);
  ass('>',4,2,false);      ass('<',4,2,false);      ass('>=',4,2,false);
  ass('<=',4,2,false);     ass('=',4,2,false);

  ass('not',5,1,true);     ass('ó',5,1,true); //phep tru mot ngoi

  ass('exp',5,1,true);     ass('ln',5,1,true);       ass('lg',5,1,true);

  ass('sin',5,1,true);     ass('cos',5,1,true);      ass('tg',5,1,true);
  ass('cotg',5,1,true);    ass('arcsin',5,1,true);   ass('arccos',5,1,true);
  ass('arctg',5,1,true);   ass('arccotg',5,1,true);

  ass('sinh',5,1,true);    ass('cosh',5,1,true);     ass('tgh',5,1,true);
  ass('cotgh',5,1,true);   ass('arcsinh',5,1,true);  ass('arccosh',5,1,true);
  ass('arctgh',5,1,true);  ass('arccotgh',5,1,true);

  ass('sqrt',6,2,true);    ass('sqr',6,2,true);      ass('trunc',6,1,true);
  ass('ceiling',6,1,true); ass('floor',6,1,true);    ass('round',6,1,true);

  ass('dtor',6,1,true);    ass('rtod',6,1,true);     ass('dtog',6,1,true);
  ass('dtoc',6,1,true);    ass('rtog',6,1,true);     ass('rtoc',6,1,true);
  ass('gtod',6,1,true);    ass('gtor',6,1,true);     ass('gtoc',6,1,true);
  ass('ctod',6,1,true);    ass('ctor',6,1,true);     ass('ctog',6,1,true);

  ass('random',6,2,true);

  ass('log',7,2,true);     ass('above',7,2,true);   ass('below',7,2,true);

  ass('abs',8,1,true);     ass('!',10,1,false);     ass('if',9,3,true);
  ass('bin',9,1,true);     ass('hex',9,1,true);     ass('oct',9,1,true);
  ass('base',9,3,true);    ass('tonum',9,1,true);

  ass('crn',9,2,true);     ass('arn',9,2,true);

  ass('dow',9,1,true);
  ass('sec',9,1,true);     ass('min',9,1,true);     ass('hour',9,1,true);
  ass('todate',9,1,true);  ass('totime',9,1,true);  ass('todatetime',9,1,true);

  ass('can_y',9,1,true);   ass('chi_y',9,1,true);   ass('canchi_y',9,1,true);
  ass('can_m',9,1,true);   ass('chi_m',9,1,true);   ass('canchi_m',9,1,true);
  {ass('can_h',9,1,true);   ass('chi_h',9,1,true);   ass('canchi_h',9,1,true);}

  ass('ucln',9,2,true);    ass('bcnn',9,2,true);    ass('ptnt',9,1,true);

  ass('eraday',9,1,true);  ass('countday',9,1,true);

  {sap xep thu tu cac toan tu co do dai giam dan de phong truong hop
  toan tu nay bao ham toan tu khac. VD: 'dtor' bao ham 'or'; 'arctg' bao ham 'tg';
  se gay roi loan khi danh dau cac toan tu (trong mang mark cua analyse)}
  for i:=1 to AmountOfOperator do
    for j:=i+1 to AmountOfOperator do
      begin
        if length(opr[i].name)<length(opr[j].name) then
          begin tmp:=opr[i]; opr[i]:=opr[j]; opr[j]:=tmp; end;
      end;
   CVar.kind:=kNum; CVar.num:=0;

  //Cac hang so mac dinh
  ln10val:=ln(10); exp1val:=exp(1);
  {assc('pi',pi); assc('e',exp1val); assc('K',273); assc('C',299792.5);
  assc('N',6.02252E23);  assc('h',6.6256E-27); assc('g',9.8067);
  inc(AmountOfConst); aconst[AmountOfConst].name:='TB';
  aconst[AmountOfConst].kind:=kStr; aconst[AmountOfConst].s:='N®m nay lµ n®m ';
  inc(AmountOfConst); aconst[AmountOfConst].name:='NS';
  aconst[AmountOfConst].kind:=kDate; aconst[AmountOfConst].s:='4/2/1984';
   }
  //Cac thiet lap ban dau
  Label1.FocusControl:=Edit1;
  SpinEdit1.Visible:=False;

  RectGr:=Rect(0,0,430,320);
  {for i:=0 to 255 do
    Gr[i].Visible:=False; vis}
  Application.OnShowHint:=MyShowHint;
end;

function TPartToStr(r: TPart): string;
begin
  if errmsg='' then
    with r do
    case kind of
      kBool: TPartToStr:=BoolToStr(bool);
      kStr: TPartToStr:='['+name+']';
      kDate: TPartToStr:='['+name+']';
      kFrac: TPartToStr:=IntToStr(t)+':'+IntToStr(m);
      else
      if Form1.CheckBox1.State=cbChecked then
      begin
        try TPartToStr:='['+DateTimeToStr(num)+']';
        except
          try TPartToStr:='['+DateToStr(num)+']';
          except
            try TPartToStr:='['+TimeToStr(num)+']';
            except
              TPartToStr:='Kh´ng ÆÊi k’t qu∂ '+FloatToStr(num)+' sang ki”u ngµy/giÍ';
            end;
          end;
        end;
      end
      else
      begin
        if curbase=10 then TPartToStr:=FloatToStr(num)
        else TPartToStr:='['+DecToBase(curbase,round(num))+']';
      end;
    end
  else
    TPartToStr:='LÁi: '+errmsg;
end;

procedure TForm1.Calc;
var s: string; i: integer;
begin
  richEdit1.Clear;
  s:=edit1.text; analyse(s,False);
  if errmsg<>'' then
    begin edit2.Font.Color:=clRed; edit2.text:='LÁi: '+errmsg; end
  else
    begin
      result:=NormalCalc;
      if errmsg='' then
        begin edit2.Font.Color:=clBlack; Edit2.Text:=TPartToStr(result); end
      else
        begin edit2.Font.Color:=clRed; edit2.text:='LÁi: '+errmsg; end
    end;
  if cwar>0 then
  begin
    for i:=1 to cwar do
      richEdit1.Lines.Add(war[i]);
  end;
end;
{}
{
//dung de kiem tra
procedure check;
var s: string; i: integer; result: TPart;
begin
  with form1 do
  begin
  s:=Edit1.Text;
  analyse(s,false);
  writeln(#10,#13);
  if errmsg<>'' then writeLn(errmsg)
  else
    begin
      for i:=1 to precount do
        with prefix[i] do
          case kind of
            kNum: write(Num:0:1);
            kOpr:
              if opr[AOpr].name='ó' then write('%') else write(opr[AOpr].name);
            kBool: write(Bool);
            kParam,kVar,kStr,kDate: write(Name);
          end;
      writeln;
      for i:=1 to sufcount do
        begin
          with suffix[i] do
          case kind of
            kNum: write(Num:0:1);
            kOpr:
              if opr[AOpr].name='ó' then write('%') else write(opr[AOpr].name);
            kBool: write(Bool);
            kParam,kVar,kStr,kDate: write(Name);
          end;
          write(' ');
        end;

      result:=NormalCalc;
      writeln;
      if errmsg='' then
        with result do
          if kind=kBool then write(bool) else write(num:0:3)
      else writeln(errmsg);
    end;
  end;
end;
{}

procedure TForm1.xuat_ra_edit2;
begin
  if errmsg<>'' then
    begin edit2.Font.Color:=clRed; edit2.text:='LÁi: '+errmsg; end
  else
    begin edit2.Font.Color:=clBlack; Edit2.Text:=TPartToStr(result); end
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  curbase:=10; xuat_ra_edit2;
  SpinEdit1.Visible:=False;
end;
procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  curbase:=16; xuat_ra_edit2;
  SpinEdit1.Visible:=False;
end;
procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  curbase:=2; xuat_ra_edit2;
  SpinEdit1.Visible:=False;
end;
procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  curbase:=8; xuat_ra_edit2;
  SpinEdit1.Visible:=False;
end;
procedure TForm1.RadioButton5Click(Sender: TObject);
begin
  SpinEdit1.Visible:=true;
  curbase:=SpinEdit1.Value;
  if curbase>36 then
    begin curbase:=36; SpinEdit1.Value:=36; end
  else
  if curbase<2 then
    begin curbase:=2; SpinEdit1.Value:=2; end;
  xuat_ra_edit2;
end;
procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  curbase:=SpinEdit1.Value;
  if curbase in [2..36] then xuat_ra_edit2;
end;
procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  SpinEdit1.Enabled:=not SpinEdit1.Enabled;
  RadioButton1.Enabled:=not RadioButton1.Enabled;
  RadioButton2.Enabled:=not RadioButton2.Enabled;
  RadioButton3.Enabled:=not RadioButton3.Enabled;
  RadioButton4.Enabled:=not RadioButton4.Enabled;
  RadioButton5.Enabled:=not RadioButton5.Enabled;
  if errmsg='' then
  with result do
    case kind of
      kBool: edit2.text:=BoolToStr(bool);
      kDate,kStr: edit2.text:='['+name+']';
      else
        if Form1.CheckBox1.State=cbChecked then
          begin
            try edit2.text:='['+DateTimeToStr(result.num)+']';
            except
              try edit2.text:='['+DateToStr(result.num)+']';
              except
                try edit2.text:='['+TimeToStr(result.num)+']';
                except
                  edit2.text:='Kh´ng ÆÊi k’t qu∂ '+FloatToStr(result.num)+' sang ki”u ngµy/giÍ';
                end;
              end;
            end;
          end{if}
            else
              begin
                if curbase=10 then edit2.text:=FloatToStr(num)
                else edit2.text:='['+DecToBase(curbase,round(num))+']';
              end;
    end;
end;

{
//tieng Viet cho Caption cua Form
procedure TForm1.WndProc(var Msg: TMessage);
begin
  inherited;
  with Msg do
  case msg of
    WM_NCPAINT:
      DrawCaption(Handle=GetActiveWindow);
    WM_NCACTIVATE:
      DrawCaption(wParam<>0);
  end;
end;
function TForm1.DrawCaption(fActive: Boolean): Boolean;
var
  DC: HDC;
  rgb_txt,rgb_bk: TColor;
  lf: TLogFont;
  fon: HFont;
  capstr: PChar;
begin
  DC:=GetWindowDC(Handle);
  //thiet lap mau sac cho caption
  if fActive then
  begin
    rgb_txt:=ColorToRGB(clCaptionText);
    rgb_bk:=ColorToRGB(clActiveCaption);
  end
  else
  begin
    rgb_txt:=ColorToRGB(clInactiveCaptionText);
    rgb_bk:=ColorToRGB(clInactiveCaption);
  end;
  SetBkColor(DC,rgb_bk);
  SetBkMode(DC,TRANSPARENT);

  //cac thong tin ve font chu
  FillChar(lf,SizeOf(TLogFont),#0);
  lf.lfHeight:=15;
  lf.lfCharSet:=ANSI_CHARSET;
  lf.lfQuality:=DEFAULT_QUALITY;
  lf.lfClipPrecision:=CLIP_LH_ANGLES or CLIP_STROKE_PRECIS;
  lf.lfPitchAndFamily:=FF_SWISS;
  lf.lfFaceName:='MS Sans Serif';
  CapStr:='General Calculation M∏y t›nh';

  //tao doi tuong fon voi cac thong tin tren
  fon:=CreateFontIndirect(lf);
  //viet tieu de
  SetTextColor(DC,clBlack);
  TextOut(DC,26,8,CapStr,length(CapStr));
  SetTextColor(DC,rgb_txt);
  TextOut(DC,25,7,CapStr,length(CapStr));
  //chon font moi va luu lai font cu
  fon:=SelectObject(DC,fon);
  //giai phong doi tuong fon
  DeleteObject(fon);
  //tra bo dieu khien khung ve cho window
  ReleaseDC(Handle,DC);
end;
}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Byte;
begin
  for i:=1 to 255 do Gr[i].Finish;
  BkGr.Free;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  Form_gptb2.show;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  Form_ptb3.show;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  Form_hpt2.Show;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
  Form_hpt3.Show;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  Form_yfx.Show;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
  Form_xfx.Show;
end;

procedure TForm1.ToolButton10Click(Sender: TObject);
begin
  Form_frac.show
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  SplashForm.ShowModal;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in shift) and (key=115) then
    Close
  else  
  if (ssShift in Shift) then
    case key of
      113: if form_hpt2.Visible then form_hpt2.Hide else form_hpt2.Show;
      114: if form_hpt3.Visible then form_hpt3.Hide else form_hpt3.Show;
      115: if form_xfx.Visible then form_xfx.Hide else form_xfx.Show;
    end
  else
  case key of
    13: {begin{} Calc; {check; end;{} 
    113: if form_gptb2.Visible then form_gptb2.Hide else form_gptb2.Show;
    114: if form_ptb3.Visible then form_ptb3.Hide else form_ptb3.Show;
    115: if form_yfx.Visible then form_yfx.Hide else form_yfx.Show;
  end;

end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var s: String; SaveCV: TPart;
begin
  SaveCV:=CVar; s:=TPartToStr(CVar); errmsg:='';
  repeat
    if InputQuery('Input variable value:',
         'NhÀp gi∏ trﬁ ki”u sË ho∆c bi”u th¯c cho k’t qu∂ ki”u sË:',s)
    then
    begin
      Analyse(s,False); if errmsg='' then CVar:=NormalCalc;
      if (errmsg<>'') then
        MessageDlg('LÁi: '+errmsg,mtError,[mbOk],0)
      else
      if (CVar.kind<>kNum) then errmsg:='Bi’n sË ph∂i lµ ki”u sË!';
    end
    else
    begin
      if errmsg<>'' then CVar:=SaveCV;
      errmsg:='';
    end;
  until errmsg='';
  Calc;
end;

procedure TForm1.ToolButton12Click(Sender: TObject);
begin
  frm_matrix.Show;
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.ToolButton15Click(Sender: TObject);
begin
  frm_cvunit.Show;
end;

end.

