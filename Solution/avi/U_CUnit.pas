unit U_CUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus;

const
  MAX_UNIT=256;
  MARK_UNIT='CVU';

type
  TString255 = String[255];

  TVarietyOfNumber = (vnFrac,vnNum);
  TNumber = Record
    case Variety: TVarietyOfNumber of
      vnFrac: (T,M: Integer;);
      vnNum: (N: Extended;);
  end;

  TConvertInfo = Record
    Factor, Extend: TNumber;
  end;

  {
  TUnit = Record
    Name: String;
    Index: Integer;
  end;

  TGroupUnit = Record
    SoUnit: Integer;
    Data: array [1..MAX_UNIT,1..MAX_UNIT] of TConvertInfo;
    Units: array [1..MAX_UNIT] of TUnit;
  end;

  PGroupUnit = ^TGroupUnit;
  }
  
  Tfrm_cvunit = class(TForm)
    lst_group: TListView;
    lst_A: TListView;
    lst_B: TListView;
    edt_A: TLabeledEdit;
    edt_B: TLabeledEdit;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Panel1: TPanel;
    edt_mul: TLabeledEdit;
    edt_plus: TLabeledEdit;
    BitBtn2: TBitBtn;
    pmn_group: TPopupMenu;
    hmnhm1: TMenuItem;
    hmnhm2: TMenuItem;
    Spxp1: TMenuItem;
    pmn_unit: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    procedure hmnhm1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure hmnhm1Click(Sender: TObject);
    procedure hmnhm2Click(Sender: TObject);
    procedure lst_groupInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure MenuItem1Click(Sender: TObject);
  private
    { Private declarations }
    procedure View(P: PGroupUnit);
  public
    { Public declarations }
  end;

var
  frm_cvunit: Tfrm_cvunit;

implementation

uses UCommon;

{$R *.dfm}
function TaoTenNhom: String;
var s: String; i: Integer;
begin
  for i:=1 to MAX_UNIT do
  begin
    s:='Group'+IntToStr(i);
    if frm_cvunit.lst_group.FindCaption(0,s,False,True,False)=Nil then
    begin
      TaoTenNhom:=s; Exit;
    end;  
  end;
end;

function StrToNum(S: String; var R: TNumber): String;
var l: Integer; n: Extended; st,sm: String;
begin
  StrToNum:='';
  Val(S,n,l);
  if l=0 then
  begin
    R.Variety:=vnNum;
    R.N:=n;
  end
  else
  begin
    l:=Pos(':',s);
    if l>0 then
    begin
      st:=Copy(S,1,l-1);
      sm:=Copy(S,l+1,Length(S)-l);
      try
        R.T:=StrToInt(st);
        R.M:=StrToInt(sm);
        if R.M=0 then StrToNum:='Lçi: MÉu sè b»ng 0'
        else
        begin
          R.Variety:=vnFrac;
          R.N:=R.T/R.M;
        end;
      except
        StrToNum:='Lçi: Tö sè vµ mÉu sè ph¶i lµ sè nguyªn';
      end;
    end//if
    else
      StrToNum:='Lçi: '''+S+''' kh«ng ph¶i lµ mét sè, còng kh«ng ph¶i lµ mét ph©n sè.'
  end;
end;

procedure NumAdd(A,B: TNumber; var R: TNumber);
var t,m,n: Integer;
begin
  if A.Variety=vnNum then
    if (B.Variety=vnNum)or(Frac(A.N)<>0) then
    begin
      R.Variety:=vnNum;
      R.N:=A.N + B.N;
    end
    else //B is vnFrac and A is integer
    begin
      R.Variety:=vnFrac;
      t:=B.T; m:=B.M; n:=trunc(A.N);
      t:=n*m+t;
      Rutgon(t,m);
      R.T:=t; R.M:=m;
    end
  else //A is vnFrac
  if (B.Variety=vnFrac)or(Frac(B.N)=0) then
  begin
    R.Variety:=vnFrac;
    if B.Variety=vnNum then
    begin
      t:=A.T; m:=A.M; n:=trunc(B.N);
      t:=n*m+t;
      Rutgon(t,m);
      R.T:=t; R.M:=m;
    end
    else
    begin
      m:=(A.M*B.M) div Ucln(A.M,B.M);
      R.T:=(m div A.M)*A.T+(m div B.M)*B.T;
      R.M:=m;
    end;
  end
  else
  begin
    R.Variety:=vnNum;
    R.N:=A.N + B.N;
  end;
  if R.Variety=vnFrac then R.N:=R.T/R.M;
end;

procedure NumMul(A,B: TNumber; var R: TNumber);
begin
  if A.Variety=vnNum then
    if (B.Variety=vnNum)or(Frac(A.N)<>0) then
    begin
      R.Variety:=vnNum;
      R.N:=A.N + B.N;
    end
    else
    begin
      R.Variety:=vnFrac;
      R.T:=Trunc(A.N)*B.T;
      R.M:=B.M;
      Rutgon(R.T,R.M);
    end
  else //A is vnFrac
  if (B.Variety=vnFrac)or(Frac(B.N)=0) then
  begin
    R.Variety:=vnFrac;
    if B.Variety=vnNum then
    begin
      R.T:=Trunc(A.N)*B.T;
      Rutgon(R.T,R.M);
    end
    else
    begin
      R.T:=A.T*B.T;
      R.M:=A.M*B.M;
      Rutgon(R.T,R.M);
    end;
  end
  else
  begin
    R.Variety:=vnNum;
    R.N:=A.N*B.N;
  end;
  if R.Variety=vnFrac then R.N:=R.T/R.M;
end;

procedure Tfrm_cvunit.hmnhm1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  s: String; sc: TShortCut;
  t: Integer;
begin
  with (Sender as TMenuItem) do
  begin
    s:=Caption;
    sc:=ShortCut;
  end;
  delete(s,pos('&',s),1);
  with ACanvas do
  begin
    if Selected then
    begin
      Brush.Color:=$00C6FFCD;
      FillRect(ARect);
      ACanvas.Pen.Color:=clTeal;
      Rectangle(ARect);
    end
    else
    begin
      Brush.Color:=clWhite;
      FillRect(ARect);
    end;
    if s='-' then
      with ARect do
      begin
        t:=Top+(Bottom-Top+1) div 2;
        MoveTo(Left,t);
        LineTo(Right,t);
      end
    else
    begin
      with ARect do
        t:=Top+(Bottom-Top+1-ACanvas.TextHeight(s)) div 2;
      Font.Name:='GCalc System Font   ';
      Font.Color:=clBlack;
      TextOut(ARect.Left+1,t,s);
      s:=ShortCutToText(sc);
      TextOut(ARect.Right-2-TextWidth(s),t,s);
    end;
  end;
end;

procedure Tfrm_cvunit.FormCreate(Sender: TObject);
var
  f: File of Byte;
  DoDaiTenNhom,DoDaiTenUnit,
  Sonhom,SoUnit,i,j: Integer;
  NhanDang: array [0..2] of Char;
  p: PGroupUnit;
  TenNhom,TenUnit: TString255;
begin
  AssignFile(f,'cunit.dat');
  {$I-}Reset(f);{$I+}
  {
  if IOResult<>0 then
  begin
    MessageDlg('Kh«ng ®äc ®­îc file CUNIT.DAT',mtError,[mbOk],0);
    Exit;
  end;
  BlockRead(f,NhanDang,3);
  if NhanDang<>MARK_UNIT then
  begin
    MessageDlg('File CUNIT.DAT kh«ng hîp lÖ',mtError,[mbOk],0);
    Exit;
  end;
  BlockRead(f,SoNhom,SizeOf(Integer));
  for i:=1 to SoNhom do
  begin
    new(p);
    BlockRead(f,DoDaiTenNhom,SizeOf(Integer));
    BlockRead(f,SoUnit,SizeOf(Integer));
    TenNhom[0]:=Chr(DoDaiTenNhom);
    BlockRead(f,TenNhom[1],DoDaiTenNhom);
    P^.SoUnit:=SoUnit;
    //Doc data
    for j:=1 to SoUnit do
      BlockRead(f,p^.Data[j],SoUnit*SizeOf(TConvertInfo));
    //Doc unit
    for j:=1 to SoUnit do
    begin
      BlockRead(f,DoDaiTenUnit,SizeOf(Integer));
      BlockRead(f,p^.Units[j].Index,SizeOf(Integer));
      TenUnit[0]:=chr(DoDaiTenUnit);
      BlockRead(f,TenUnit[1],DoDaiTenUnit);
      p^.Units[j].Name:=TenUnit;
    end;
    lst_group.AddItem(TenNhom,TObject(p));
  end;
  {}
  CloseFile(f);
end;

procedure Tfrm_cvunit.FormDestroy(Sender: TObject);
var
  f: File of Byte;
  DoDaiTenNhom,DoDaiTenUnit,
  Sonhom,SoUnit,i,j: Integer;
  p: PGroupUnit;
  TenNhom,TenUnit: TString255;
begin
  AssignFile(f,'cunit.dat');
  {$I-}Rewrite(f);{$I+}
  {
  BlockWrite(f,MARK_UNIT,3);
  SoNhom:=lst_group.Items.Count;
  BlockWrite(f,SoNhom,SizeOf(Integer));
  for i:=1 to SoNhom do
  begin
    P:=lst_group.Items[i-1].Data;
    TenNhom:=lst_group.Items[i-1].Caption;
    DoDaiTenNhom:=ord(TenNhom[0]);
    SoUnit:=P^.SoUnit;
    BlockWrite(f,DoDaiTenNhom,SizeOf(Integer));
    BlockWrite(f,SoUnit,SizeOf(Integer));
    BlockWrite(f,TenNhom[1],DoDaiTenNhom);
    //Ghi data
    for j:=1 to SoUnit do
      BlockWrite(f,P^.Data[j],SoUnit*SizeOf(TConvertInfo));
    //Ghi unit
    for j:=1 to SoUnit do
    begin
      TenUnit:=P^.Units[j].Name;
      DoDaiTenUnit:=ord(TenUnit[0]);
      BlockWrite(f,DoDaiTenUnit,SizeOf(Integer));
      BlockWrite(f,P^.Units[j].Index,SizeOf(Integer));
      BlockWrite(f,TenUnit[1],DoDaiTenUnit);
    end;
  end;
  {}
  CloseFile(f);
end;

procedure Tfrm_cvunit.View(P: PGroupUnit);
var 
begin
  with P^ do
  begin

  end;
end;

procedure Tfrm_cvunit.hmnhm1Click(Sender: TObject);
var p: PGroupUnit;
begin
  new(p);
  //p^.SoUnit:=0;
  FillChar(p^,SizeOf(TGroupUnit),0);
  lst_group.AddItem(TaoTenNhom,TObject(p));
end;

procedure Tfrm_cvunit.hmnhm2Click(Sender: TObject);
begin
  if lst_group.ItemFocused<>Nil then
    lst_group.ItemFocused.Delete;
  if lst_group.ItemFocused<>Nil then
    lst_group.ItemFocused.Selected:=true;
end;

procedure Tfrm_cvunit.lst_groupInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  InfoTip:=IntToStr(PGroupUnit(Item.Data).SoUnit);
end;

procedure Tfrm_cvunit.MenuItem1Click(Sender: TObject);
var
  P: PGroupUnit; SL,i: Integer;
begin
  P:=lst_group.ItemFocused.Data;
  with P^ do
  begin
    SL:=SoUnit;
    if SL=MAX_UNIT then
    begin
      MessageDlg('Sè l­îng ®¬n vÞ trong mét nhãm kh«ng ®­îc v­ît qu¸'+IntToStr(MAX_UNIT)+'. NÕu cÇn nhiÒu h¬n xin liªn hÖ t¸c gi¶.',mtError,[mbOk],0);
      Exit;
    end;
    inc(SL);
    SoUnit:=SL;
    Units[SL].Index:=SL;
    FillChar(Data[SL],SizeOf(Data[SL]),0);
    for i:=1 to SL do
      FillChar(Data[i,SL],SizeOf(TConvertInfo),0)
  end;
end;

end.
