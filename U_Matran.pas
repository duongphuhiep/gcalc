unit U_Matran;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Buttons, Spin, ComCtrls, ActnList, Matrix;

const
  MT_LIMIT=256;
  APP_ZERO=1E-10;

type
  TMatrixOperator=(moAdd,moSub,moMul,moBoo,moPow,moRev,moTra);

  type
  TCaseData = (cdNum,cdLin,cdErr,cdEmp);
  TStr255 = String[255];
  TOneLine = Record
    Cells: Array [1..MAX_COL] of Extended;
    N: Integer;
  end;

  TInfoToChangeMatrix = Record
    case Category: TCaseData of
      cdNum: (Value: Extended);
      cdLin: (Line: TOneLine;); //N is length of line (col or row)
      cdErr: (Errmsg: TStr255);
  end;

  Tfrm_matrix = class(TForm)
    btn_attach: TSpeedButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    edt_a2: TEdit;
    btn_add: TSpeedButton;
    btn_sub: TSpeedButton;
    btn_mul: TSpeedButton;
    btn_trans: TSpeedButton;
    btn_rev: TSpeedButton;
    btn_power: TSpeedButton;
    edt_b1: TEdit;
    edt_a1: TEdit;
    edt_b: TLabeledEdit;
    edt_a: TLabeledEdit;
    Bevel1: TBevel;
    btn_save: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edt_height: TSpinEdit;
    edt_width: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    btn_cut: TSpeedButton;
    btn_load: TSpeedButton;
    Bevel4: TBevel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    grd_matrix: TStringGrid;
    lst_mt: TListView;
    Panel3: TPanel;
    edt_dest: TEdit;
    btn_assign: TSpeedButton;
    edt_src1: TLabeledEdit;
    edt_src2: TLabeledEdit;
    edt_src3: TLabeledEdit;
    edt_src4: TEdit;
    edt_exch1: TEdit;
    btn_exch: TSpeedButton;
    edt_exch2: TEdit;
    edt_pos: TEdit;
    btn_det: TSpeedButton;
    edt_det: TLabeledEdit;
    btn_below: TSpeedButton;
    btn_both: TSpeedButton;
    Bevel3: TBevel;
    Bevel2: TBevel;
    procedure btn_attachClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grd_matrixDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grd_matrixSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btn_cutClick(Sender: TObject);
    procedure edt_heightKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lst_mtSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lst_mtEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure btn_loadClick(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_subClick(Sender: TObject);
    procedure btn_mulClick(Sender: TObject);
    procedure btn_powerClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure grd_matrixExit(Sender: TObject);
    procedure btn_revClick(Sender: TObject);
    procedure btn_transClick(Sender: TObject);
    procedure lst_mtAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lst_mtInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lst_mtMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_assignClick(Sender: TObject);
    procedure grd_matrixClick(Sender: TObject);
    procedure btn_exchClick(Sender: TObject);
    procedure btn_belowClick(Sender: TObject);
    procedure btn_bothClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_detClick(Sender: TObject);
    procedure lst_mtExit(Sender: TObject);
    procedure grd_matrixMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    //Khi chon mot Item se hien thi noi dung Iem do. MtChange se kiem tra xem
    //noi dung Item co bi thay doi khong, neu bi thay doi thi update lai
    //prevpos la Item truoc Item duoc chon hien tai, prevpos need update
    MtChanged: Boolean;
    prevpos: Integer;
    procedure input(var t: TMatrix);
    procedure output(t: PMatrix);
    function taoten: string;
    //Check regular edt_a, edt_a1, edt_a2,
    // if haven't error return index of matrix else return error message if have
    function CheckA(var r,a,b: Integer): string;
    procedure CalcMat(opr: TMatrixOperator);
    procedure CalcMat2(opr: TMatrixOperator);
    function GetITCM(S: String): TInfoToChangeMatrix;
    function GetITCM2(S: String; var OnRow: Boolean; var Index: Integer ): String;

    procedure PlusITCM(var R: TInfoToChangeMatrix; A,B: TInfoToChangeMatrix);
    procedure MulITCM(var R: TInfoToChangeMatrix; A,B: TInfoToChangeMatrix);
  public
    { Public declarations }
  end;

var
  frm_matrix: Tfrm_matrix;

implementation

uses UMain;

{$R *.dfm}

function Tfrm_matrix.taoten: string;
var s: string; a,b: char;
begin
  for a:='A' to 'Z' do
    for b:='0' to '9' do
    begin
      s:=a+b;
      if lst_mt.FindCaption(0,s,False,True,False)=Nil then
        begin taoten:=s; exit; end;
    end;
end;

procedure Tfrm_matrix.output(t: PMatrix);
var i,j: integer; 
begin
  MtChanged:=False;
  with t^ do
  begin
    if (w=0) or (h=0) then
    begin
      edt_width.Value:=0;
      edt_height.Value:=0;
      grd_matrix.Visible:=false;
      btn_attach.Enabled:=false;
      btn_both.Enabled:=false;
      btn_below.Enabled:=false;
      edt_pos.Text:='';
    end
    else
    begin
      grd_matrix.Visible:=true;
      btn_attach.Enabled:=true;
      edt_height.Value:=h;
      edt_width.Value:=w;
      grd_matrix.RowCount:=h;
      grd_matrix.ColCount:=w;
      for i:=1 to h do
        for j:=1 to w do
          try grd_matrix.Cells[j-1,i-1]:=FloatToStr(data[i,j]);
          except
            grd_matrix.Cells[j-1,i-1]:='0';
          end;
      edt_pos.Text:='D'+IntToStr(grd_matrix.Row+1)+' : '+'C'+IntToStr(grd_matrix.Col+1);
    end;
  end;
end;

procedure Tfrm_matrix.input(var t: TMatrix);
var i,j: integer;
begin
  with t do
  begin
    h:=edt_height.Value;
    w:=edt_width.Value;
    for i:=0 to h-1 do
      for j:=0 to w-1 do
        try data[i+1,j+1]:=strToFloat(grd_matrix.Cells[j,i]);
        except
          {
          edt_error.Text:=grd_matrix.Cells[j,i];
          grd_matrix.Cells[j,i]:='???';
          input:=false; exit;
          }
          data[i+1,j+1]:=0;
        end;
  end;
end;

procedure Tfrm_matrix.btn_attachClick(Sender: TObject);
var t: PMatrix;
begin
  with lst_mt do
  begin
    if Items.Count=MT_LIMIT then
      ShowMessage('L­îng ma trËn tèi ®a trong danh s¸ch lµ '
        +intToStr(MT_LIMIT)+'. NÕu muèn nhiÒu h¬n, xin liªn hÖ víi t¸c gi¶.')
    else
    begin
      getMem(t,sizeOf(TMatrix));
      input(t^);
      AddItem(TaoTen,TObject(t));
      ItemFocused:=Items[Items.Count-1];
      //prevpos=ItemIndex=Count
      prevpos:=Items.Count-1;
      mtChanged:=False;
      ItemFocused.Selected:=true;

      if Items.Count=1 then
      begin
        Visible:=true;
        btn_cut.Enabled:=true;
        btn_save.Enabled:=true;
        btn_both.Enabled:=true;
        btn_below.Enabled:=true;
        //btn_saveItem.Enabled:=true;
      end;
    end;
  end;
end;

procedure Tfrm_matrix.btn_cutClick(Sender: TObject);
begin
  lst_mt.ItemFocused.Delete;
  if lst_mt.Items.Count>0 then
  begin
    output(PMatrix(lst_mt.ItemFocused.Data));
    mtChanged:=False; //xxx
    lst_mt.ItemFocused.Selected:=true;
    //if not lst_mt.Focused then lst_mtExit(lst_mt);
  end
  else
  begin
    btn_cut.Enabled:=False;
    btn_save.Enabled:=False;
    btn_both.Enabled:=False;
    btn_below.Enabled:=False;
  end;
end;

procedure Tfrm_matrix.grd_matrixDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var v: Extended; loi: Integer;
begin
  //if (gdFocused in State)or(gdSelected in State) then
  with grd_matrix do
  begin
    Val(Cells[ACol,ARow],v,loi);
    if loi>0 then Canvas.Font.Color:=clRed
    else
    if abs(v)<APP_ZERO then
      Canvas.Font.Color:=clGray
    else
      Canvas.Font.Color:=clBlack;
    Canvas.TextRect(Rect,
      Rect.Left+6,
      Rect.Top+(RowHeights[ARow]-Canvas.TextHeight('W')) shr 1,
      Cells[ACol,ARow]);
    if State<>[] then
      Canvas.DrawFocusRect(Rect);
  end;
end;

{
  if Value<>'' then
  begin
    try StrToFloat(Value);
    except
      ShowMessage('Must be a number!');
    end;
  end;
}

procedure Tfrm_matrix.grd_matrixSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if (Value<>'')and(Value<>'-') then
  begin
    try StrToFloat(Value);
    except
      ShowMessage('ChØ ®­îc nhËp sè vµo b¶ng');
    end;
  end;
  MtChanged:=true;
end;

procedure Tfrm_matrix.FormCreate(Sender: TObject);
begin
  edt_height.MaxValue:=MAX_ROW;
  edt_width.MaxValue:=MAX_COL;
end;

procedure Tfrm_matrix.edt_heightKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var h,w,oldh,oldw: integer; vis: Boolean;
begin
  if key in [13,27] then
  begin
    h:=edt_height.Value;
    w:=edt_width.Value;
    oldh:=grd_matrix.RowCount;
    oldw:=grd_matrix.ColCount;
    case ord(key) of
    13:
      begin
        vis:=(h>0)and(w>0);
        if lst_mt.Items.Count>0 then
          with lst_mt.ItemFocused do
          begin
            PMatrix(Data)^.h:=h;
            PMatrix(Data)^.w:=w;
            mtChanged:=False;
          end;
        grd_matrix.Visible:=vis;
        btn_attach.Enabled:=vis;
        grd_matrix.RowCount:=h;
        grd_matrix.ColCount:=w;
      end;
    27:
      begin
        edt_height.Value:=oldh;
        edt_width.Value:=oldw;
      end;
    end;
  end;
end;

procedure Tfrm_matrix.lst_mtSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
    if mtChanged then //update item at prevpos
    begin
      input(PMatrix(TListView(Sender).Items[prevpos].Data)^);
      mtChanged:=False;
    end;  
    output(PMatrix(Item.Data));
    prevpos:=lst_mt.ItemIndex
  end;
end;

procedure Tfrm_matrix.lst_mtEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  if S[1] in ['0'..'9'] then
  begin
    MessageDlg('Tªn ma trËn kh«ng ®­îc b¾t ®Çu bëi sè!',mtError,[mbOk],0);
    S:=Item.Caption;
  end
  else
  if TListView(Sender).FindCaption(0,S,False,True,False)<>Nil then
  begin
    MessageDlg('Ma trËn tªn '''+S+''' ®· tån t¹i. H·y ®Æt tªn kh¸c ®i!',mtError,[mbOk],0);
    S:=Item.Caption;
  end;
end;

procedure Tfrm_matrix.btn_loadClick(Sender: TObject);
var
  path: string;
  t: PMatrix;
  c,i,l: Integer;
begin
  if OpenDialog1.Execute then
  begin
    path:=OpenDialog1.FileName;
    if pos('.',path)=0 then path:=path+'.mat';
    Getmem(t,sizeOf(TMatrix));
    if not LoadMT(path,t) then
    begin
      MessageDlg(t^.errmsg,mtError,[mbOk],0);
      FreeMem(t,sizeOf(TMatrix));
      Exit;
    end;
    //Ten cua ma tran moi chinh la ten file ma tran, neu khong thi tao ten moi 
    l:=length(path);
    for i:=l downto 0 do
      if path[i]='\' then Break;
    path:=copy(path,i+1,l-i-4);
    if lst_mt.FindCaption(0,path,False,True,False)<>Nil then path:=taoten;

    lst_mt.AddItem(path,TObject(t));
    c:=lst_mt.Items.Count-1;
    lst_mt.ItemFocused:=lst_mt.Items[c];
    output(PMatrix(lst_mt.ItemFocused.Data));
    lst_mt.ItemFocused.Selected:=True;
    //if not lst_mt.Focused then lst_mtExit(lst_mt);

    if c=0 then
    begin
      Visible:=true;
      btn_cut.Enabled:=true;
      btn_save.Enabled:=true;
      btn_both.Enabled:=true;
      btn_below.Enabled:=true;
      //btn_saveItem.Enabled:=true;
    end;
  end;
end;

procedure Tfrm_matrix.btn_saveClick(Sender: TObject);
var
  path: String;
  t: PMatrix;
begin
  SaveDialog1.FileName:=lst_mt.ItemFocused.Caption+'.mat';
  if SaveDialog1.Execute then
  begin
    if mtChanged then
    begin
      input(PMatrix(lst_mt.ItemFocused.Data)^);
      mtChanged:=False;
    end;
    path:=SaveDialog1.FileName;
    if pos('.',path)=0 then path:=path+'.mat';
    t:=lst_mt.ItemFocused.Data;
    if not SaveMT(path,t) then
      MessageDlg(t^.errmsg,mtError,[mbOk],0)
  end;
end;

function Tfrm_matrix.CheckA(var r,a,b: integer): string;
var t: TListItem; s: string;
begin
  s:=edt_a1.Text;
  if s='' then
  begin
    CheckA:='Ph¶i nhËp tªn c¸c ma trËn vµo 2 hép v¨n b¶n bªn tr¸i';
    Exit;
  end;
  t:=lst_mt.FindCaption(0,s,False,True,False);
  if t=Nil then
  begin
    CheckA:='Ma trËn '''+s+''' kh«ng tån t¹i trong danh s¸ch';
    Exit;
  end;
  a:=t.Index;

  s:=edt_a2.Text;
  if s='' then
  begin
    CheckA:='Ph¶i nhËp tªn c¸c ma trËn vµo 2 hép v¨n b¶n bªn tr¸i';
    Exit;
  end;
  t:=lst_mt.FindCaption(0,s,False,True,False);
  if t=Nil then
  begin
    CheckA:='Ma trËn '''+s+''' kh«ng tån t¹i trong danh s¸ch';
    Exit;
  end;
  b:=t.Index;

  s:=edt_a.Text;
  t:=lst_mt.FindCaption(0,s,False,True,False);
  if t=Nil then r:=-1 else r:=t.Index;
end;

procedure Tfrm_matrix.CalcMat(opr: TMatrixOperator);
var
  errmsg: string;
  r,a,b: integer;
  t,t1,t2: PMatrix;
  s: string;
  tmp: TListItem;
  noErr: boolean;
begin
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;
  //Kiem tra ma tran nhap vao co hop le khong
  if opr=moPow then
  begin
    s:=edt_a1.Text;
    if s='' then
    begin
      errmsg:='Ph¶i nhËp tªn mét ma trËn vu«ng vµo hép v¨n b¶n trªn cïng';
      MessageDlg(errmsg,mtError,[mbOk],0);
      Exit;
    end;
    tmp:=lst_mt.FindCaption(0,s,False,True,False);
    if tmp=Nil then
    begin
      errmsg:='Ma trËn '''+s+''' kh«ng tån t¹i trong danh s¸ch';
      MessageDlg(errmsg,mtError,[mbOk],0);
      Exit;
    end
    else
      t1:=tmp.Data;
    try
      b:=StrToInt(edt_a2.Text);
      if b<0 then errmsg:='Ph¶i nhËp 1 sè nguyªn d­¬ng vµo hép v¨n b¶n phÝa d­íi.';
    except
      errmsg:='Ph¶i nhËp 1 sè nguyªn d­¬ng vµo hép v¨n b¶n phÝa d­íi.';
    end;
    if errmsg<>'' then
      begin MessageDlg(errmsg,mtError,[mbOk],0); Exit; end;

    tmp:=lst_mt.FindCaption(0,edt_a.Text,False,True,False);
    if tmp<>Nil then r:=tmp.Index else r:=-1;
  end
  else
  begin
    errmsg:=CheckA(r,a,b);
    if errmsg<>'' then
      begin MessageDlg(errmsg,mtError,[mbOk],0); exit; end;
  end;

  getMem(t,sizeOf(TMatrix));
  if opr=moPow then
    noErr:=m_power(t1,b,t)
  else
  begin
    //kiem tra xem co tinh duoc khong
    t1:=lst_mt.Items[a].Data; t2:=lst_mt.Items[b].Data;
    case opr of
      moAdd: noErr:=m_add(t1,t2,t);
      moSub: noErr:=m_sub(t1,t2,t);
      moMul: noErr:=m_mul(t1,t2,t);
      moBoo: noErr:=m_boo(t1,t2,t);
    end;
  end;

  if noErr then
  begin
    s:=edt_a.Text;
    if s='' then
    begin
      s:=taoten; edt_a.Text:=s;
    end
    else
    if (r>0) then
    begin
      if r>0 then
      MessageDlg('Ma trËn '''+s+''' ®· tån t¹i.'
        +' Ch­¬ng tr×nh sÏ tù ®éng ®Æt tªn kh¸c cho ma trËn kÕt qu¶.',mtInformation,[mbOk],0);
      s:=taoten; edt_a.Text:=s;
    end;
    lst_mt.AddItem(s,TObject(t));
    {with lst_mt do
    begin
      Items.Add;
      ItemIndex:=Items.Count-1;
      ItemFocused.Data:=t;
    end;}

    output(t);
    with lst_mt do
    begin
      ItemFocused:=Items[Items.Count-1];
      ItemFocused.Selected:=true;
      if not Focused then lst_mtExit(lst_mt);
    end;
  end
  else
  begin
    MessageDlg(t^.errmsg,mtError,[mbOk],0);
    FreeMem(t,sizeOf(TMatrix));
  end;
end;

procedure Tfrm_matrix.CalcMat2(opr: TMatrixOperator);
var s: string; t: TListItem; r: PMatrix; noError: Boolean;
begin
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;
  s:=edt_b1.Text;
  if s='' then
    with lst_mt do
      if ItemFocused.Index>=0 then
      begin
        t:=ItemFocused;
        edt_b1.Text:=ItemFocused.Caption;
      end
      else Exit
  else
  begin
    t:=lst_mt.FindCaption(0,s,False,True,False);
    if t=Nil then
    begin
      MessageDlg('Ma trËn '''+s+''' kh«ng tån t¹i trong danh s¸ch',mtError,[mbOk],0);
      Exit;
    end;
  end;
  getMem(r,sizeOf(TMatrix));
  case opr of
    moRev:
      if not m_rev(PMatrix(t.Data),r) then
      begin
        MessageDlg(r^.errmsg,mtError,[mbOk],0);
        FreeMem(r,sizeOf(TMatrix)); Exit;
      end;
    moTra: m_transp(PMatrix(t.Data),r);
  end;

  s:=edt_b.Text;
  if s='' then
  begin
    s:=taoten; edt_b.Text:=s;
  end
  else
  if lst_mt.FindCaption(0,s,False,True,False)<>Nil then
  begin
    MessageDlg('Ma trËn '''+s+''' ®· tån t¹i.'
      +' Ch­¬ng tr×nh sÏ tù ®éng ®Æt tªn kh¸c cho ma trËn kÕt qu¶.',mtInformation,[mbOk],0);
    s:=taoten; edt_b.Text:=s;
  end;
  lst_mt.AddItem(s,TObject(r));
  output(r);
  with lst_mt do
  begin
    ItemFocused:=Items[Items.Count-1];
    ItemFocused.Selected:=true;
    if not Focused then lst_mtExit(lst_mt);
  end
end;

procedure Tfrm_matrix.btn_addClick(Sender: TObject);
begin
  CalcMat(moAdd);
end;

procedure Tfrm_matrix.btn_subClick(Sender: TObject);
begin
   CalcMat(moSub);
end;

procedure Tfrm_matrix.btn_mulClick(Sender: TObject);
begin
   CalcMat(moMul);
end;

procedure Tfrm_matrix.btn_powerClick(Sender: TObject);
begin
   CalcMat(moPow);
end;

procedure Tfrm_matrix.SpeedButton1Click(Sender: TObject);
begin
   CalcMat(moBoo);
end;

procedure Tfrm_matrix.grd_matrixExit(Sender: TObject);
begin
  if mtChanged then //update item at prevpos
  begin
    input(PMatrix(lst_mt.Items[prevpos].Data)^);
    mtChanged:=False;
  end;
end;

procedure Tfrm_matrix.btn_revClick(Sender: TObject);
begin
  CalcMat2(moRev)
end;

procedure Tfrm_matrix.btn_transClick(Sender: TObject);
begin
  CalcMat2(moTra);
end;

procedure Tfrm_matrix.lst_mtAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
var
  ARect: TRect;
  txtX, txtY: integer;
  b: Boolean;
begin
  {
  //ARect:=item.DisplayRect(drLabel);

  //ARect.Right:=Sender.Width;
  txtX:=ARect.Left+2;
  txtY:=ARect.Top+((ARect.Bottom-ARect.Top)-Sender.Canvas.TextHeight('W')) shr 1;
  if cdsFocused in State then
  begin
    Sender.Canvas.Brush.Color:=$00C6FFCD;
    Sender.Canvas.Pen.Color:=clTeal;
  end
  else
  begin
    Sender.Canvas.Brush.Color:=clWhite;
    Sender.Canvas.Pen.Color:=clWhite;
  end;
  Sender.Canvas.Rectangle(ARect);

  //Sender.Canvas.Font.Pitch:=fpVariable;
  with Sender.Canvas do
  begin
    Font.Size:=8;
    Font.Height:=-11;
    Font.Color:=clRed;
    TextOut(txtX,txtY,Item.Caption);
  end;
  {}
end;

procedure Tfrm_matrix.lst_mtInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  with PMatrix(Item.Data)^ do
    InfoTip:=IntToStr(h)+'x'+IntToStr(w);
end;

procedure Tfrm_matrix.lst_mtMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var t: TListItem;
begin
  t:=lst_mt.GetItemAt(2,Y);
  if t<>Nil then
  begin
    t.Selected:=true;
    lst_mt.ItemFocused:=t;
    lst_mt.OnSelectItem(Sender,t,True);
  end;
end;

function Tfrm_matrix.GetITCM(S: String): TInfoToChangeMatrix;
var
  R: TInfoToChangeMatrix;
  P: PMatrix;
  n,i,Loi,Index: Integer;
begin
  R.Errmsg:='';
  if S='' then
    R.Category:=cdEmp
  else
    try
      R.Value:=StrToFloat(s);
      R.Category:=cdNum
    except
      FillChar(R,SizeOf(TInfoToChangeMatrix),0);
      P:=lst_mt.ItemFocused.Data;
      case S[1] of
        'D','d':
          begin
            Delete(S,1,1);
            Val(S,Index,Loi);
            if (Loi>0) or (Index<1) or (Index>P^.h) then
            begin
              R.Category:=cdErr;
              R.Errmsg:='Dßng ''D'+S+''' lµ kh«ng hîp lÖ: ChØ sè dßng ph¶i lµ sè nguyªn d­¬ng nhá h¬n sè dßng max cña ma trËn hiÖn t¹i';
            end
            else
            begin
              R.Category:=cdLin;
              n:=P^.w; R.Line.N:=n;
              Move(P^.data[Index,1],R.Line.Cells[1],n*SizeOf(Extended));
              {for i:=1 to n do
                R.Line.Cells[i]:=P^.Data[Index,i];}
            end;
          end;
        'C','c':
          begin
            Delete(S,1,1);
            Val(S,Index,Loi);
            if (Loi>0) or (Index<1) or (Index>P^.w) then
            begin
              R.Category:=cdErr;
              R.Errmsg:='Cét ''C'+S+''' lµ kh«ng hîp lÖ: ChØ sè cét ph¶i lµ sè nguyªn d­¬ng nhá h¬n sè cét max cña ma trËn hiÖn t¹i';
            end
            else
            begin
              R.Category:=cdLin;
              n:=P^.h; R.Line.N:=n;
              for i:=1 to n do
                R.Line.Cells[i]:=P^.Data[i,Index];
            end;
          end;
        else //case
          begin
            R.Category:=cdErr;
            R.Errmsg:='Ph¶i nhËp vµo theo khu«n d¹ng lµ Dxxx hoÆc Cxxx (xxx lµ mét sè nguyªn d­¬ng ®ãng vai trß lµ chØ sè dßng hoÆc cét cña ma trËn)';
          end;
      end; //case
    end; //try
    GetITCM:=R;
end;

procedure Tfrm_matrix.PlusITCM(var R: TInfoToChangeMatrix; A,B: TInfoToChangeMatrix);
var i: Integer;
begin
  if (A.Category=cdErr)or(B.Category=cdErr) then
  begin
    R.Category:=cdErr;
    if A.Errmsg='' then R.Errmsg:=A.Errmsg
    else
    if B.Errmsg='' then R.Errmsg:=A.Errmsg
    else
      R.Errmsg:=A.Errmsg+'. '+B.Errmsg;
  end
  else
  if (A.Category=cdEmp)and(B.Category=cdEmp) then R.Category:=cdEmp
  else
  if (A.Category=cdEmp) then Move(B,R,SizeOf(TInfoToChangeMatrix))
  else
  if (B.Category=cdEmp) then Move(A,R,SizeOf(TInfoToChangeMatrix))
  else
  if (A.Category=cdNum) and (B.Category=cdNum) then
  begin
    R.Category:=cdNum; R.Value:=A.Value+B.Value;
  end
  else
  if (A.Category=cdLin) and (B.Category=cdLin) then
    if A.Line.N>B.Line.N then
    begin
      Move(A,R,SizeOf(TInfoToChangeMatrix));
      for i:=1 to B.Line.N do
        R.Line.Cells[i]:=R.Line.Cells[i]+B.Line.Cells[i];
    end
    else
    begin
      Move(B,R,SizeOf(TInfoToChangeMatrix));
      for i:=1 to A.Line.N do
        R.Line.Cells[i]:=R.Line.Cells[i]+A.Line.Cells[i];
    end
  else
  if (A.Category=cdNum) then
  begin
    Move(B,R,SizeOf(TInfoToChangeMatrix));
    for i:=1 to R.Line.N do
      R.Line.Cells[i]:=R.Line.Cells[i]+A.Value;
  end
  else
  if (B.Category=cdNum) then
  begin
    Move(A,R,SizeOf(TInfoToChangeMatrix));
    for i:=1 to R.Line.N do
      R.Line.Cells[i]:=R.Line.Cells[i]+B.Value;
  end;
end;

procedure Tfrm_matrix.MulITCM(var R: TInfoToChangeMatrix; A,B: TInfoToChangeMatrix);
var i: Integer;
begin
  if (A.Category=cdErr)or(B.Category=cdErr) then
  begin
    R.Category:=cdErr;
    if A.Errmsg='' then R.Errmsg:=A.Errmsg
    else
    if B.Errmsg='' then R.Errmsg:=A.Errmsg
    else
      R.Errmsg:=A.Errmsg+'. '+B.Errmsg;
  end
  else
  if (A.Category=cdEmp)and(B.Category=cdEmp) then R.Category:=cdEmp
  else
  if (A.Category=cdEmp) then Move(B,R,SizeOf(TInfoToChangeMatrix))
  else
  if (B.Category=cdEmp) then Move(A,R,SizeOf(TInfoToChangeMatrix))
  else
  if (A.Category=cdNum) and (B.Category=cdNum) then
  begin
    R.Category:=cdNum; R.Value:=A.Value*B.Value;
  end
  else
  if (A.Category=cdLin) and (B.Category=cdLin) then
    if A.Line.N>B.Line.N then
    begin
      Move(A,R,SizeOf(TInfoToChangeMatrix));
      for i:=1 to B.Line.N do
        R.Line.Cells[i]:=R.Line.Cells[i]*B.Line.Cells[i];
    end
    else
    begin
      Move(B,R,SizeOf(TInfoToChangeMatrix));
      for i:=1 to A.Line.N do
        R.Line.Cells[i]:=R.Line.Cells[i]*A.Line.Cells[i];
    end
  else
  if (A.Category=cdNum) then
  begin
    Move(B,R,SizeOf(TInfoToChangeMatrix));
    for i:=1 to R.Line.N do
      R.Line.Cells[i]:=R.Line.Cells[i]*A.Value;
  end
  else
  if (B.Category=cdNum) then
  begin
    Move(A,R,SizeOf(TInfoToChangeMatrix));
    for i:=1 to R.Line.N do
      R.Line.Cells[i]:=R.Line.Cells[i]*B.Value;
  end;
end;

function Tfrm_matrix.GetITCM2(S: String; var OnRow: Boolean; var Index: Integer): String;
var Loi: Integer;
begin
  GetITCM2:='';
  case s[1] of
    'D','d':
      begin
        OnRow:=True;
        Delete(s,1,1);
        Val(s,Index,Loi);
        if (Loi>0) or (Index<0) or (Index>PMatrix(lst_mt.ItemFocused.Data).h) then
          GetITCM2:='ChØ sè dßng ph¶i lµ sè nguyªn d­¬ng nhá h¬n sè dßng max cña ma trËn hiÖn t¹i';
      end;
    'C','c':
      begin
        OnRow:=False;
        Delete(s,1,1);
        Val(s,Index,Loi);
        if (Loi>0) or (Index<0) or (Index>PMatrix(lst_mt.ItemFocused.Data).w) then
          GetITCM2:='ChØ sè cét ph¶i lµ sè nguyªn d­¬ng nhá h¬n sè cét max cña ma trËn hiÖn t¹i';
      end;
    else
      GetITCM2:='Ph¶i nhËp vµo theo khu«n d¹ng lµ Dxxx hoÆc Cxxx (xxx lµ mét sè nguyªn d­¬ng ®ãng vai trß lµ chØ sè dßng hoÆc cét cña ma trËn)';
  end;
end;

procedure Tfrm_matrix.btn_assignClick(Sender: TObject);
const
  errmsg: string='';
var
  src1,src2,src3,src4,r1,r2,r: TInfoToChangeMatrix;
  //Se dua kq vao day:
  OnRow: Boolean; Index,i: Integer;
  P: PMatrix;
begin
  if (edt_dest.Text='') or ((edt_src1.Text='')and(edt_src2.Text='')and(edt_src3.Text='')and(edt_src4.Text='')) then exit;
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;
  //Kiem tra dich den
  errmsg:=GetITCM2(edt_dest.Text,OnRow,Index);
  if errmsg<>'' then
  begin
    MessageDlg('Th«ng tin trong « v¨n b¶n ®Çu tiªn kh«ng hîp lÖ:'+#10+#13+errmsg,mtError,[mbOk],0);
    Exit;
  end;
  //Tinh toan
  src1:=GetITCM(edt_src1.Text);
  if src1.Category=cdErr then begin MessageDlg(src1.Errmsg,mtError,[mbOk],0); Exit; end;
  src2:=GetITCM(edt_src2.Text);
  if src1.Category=cdErr then begin MessageDlg(src2.Errmsg,mtError,[mbOk],0); Exit; end;
  src3:=GetITCM(edt_src3.Text);
  if src1.Category=cdErr then begin MessageDlg(src3.Errmsg,mtError,[mbOk],0); Exit; end;
  src4:=GetITCM(edt_src4.Text);
  if src1.Category=cdErr then begin MessageDlg(src4.Errmsg,mtError,[mbOk],0); Exit; end;
  MulITCM(r1,src1,src2);
  MulITCM(r2,src3,src4);
  PlusITCM(r,r1,r2);
  //Dua ket qua vao trong ma tran
  case r.Category of
    cdErr: MessageDlg(r.Errmsg,mtError,[mbOk],0);
    cdEmp: MessageDlg('Ph¶i nhËp th«ng tin vµo c¸c hép v¨n b¶n!',mtError,[mbOk],0);
    cdNum:
      begin
        P:=lst_mt.ItemFocused.Data;
        if OnRow then
          for i:=1 to P^.w do
            P^.data[Index,i]:=r.Value
        else
          for i:=1 to P^.h do
            P^.data[i,Index]:=r.Value;
        output(P);
      end;
    cdLin:
      begin
        P:=lst_mt.ItemFocused.Data;
        if OnRow then
          for i:=1 to P^.w do
            P^.data[Index,i]:=r.Line.Cells[i]
        else
          for i:=1 to P^.h do
            P^.data[i,Index]:=r.Line.Cells[i];
         output(P);
      end;
  end;
end;

procedure Tfrm_matrix.grd_matrixClick(Sender: TObject);
begin
  edt_pos.Text:='D'+IntToStr(grd_matrix.Row+1)+' : '+'C'+IntToStr(grd_matrix.Col+1);
end;

procedure Tfrm_matrix.btn_exchClick(Sender: TObject);
var
  Index1,Index2,i: Integer;
  OnRow1,OnRow2: Boolean;
  Errmsg,Errmsg1,Errmsg2: String;
  tmp: array [1..MAX_COL] of Extended;
  x: Extended;
  P: PMatrix;
begin
  if (edt_exch1.Text='')or(edt_exch1.Text='') then exit;
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;  
  Errmsg1:=GetITCM2(edt_exch1.Text,OnRow1,Index1);
  Errmsg2:=GetITCM2(edt_exch2.Text,OnRow2,Index2);
  if (Errmsg1<>'')or(Errmsg2<>'') then
    if Errmsg1='' then Errmsg:=Errmsg2
    else
    if Errmsg2='' then Errmsg:=Errmsg1
    else
      Errmsg:=Errmsg1+'. '+Errmsg2
  else
    Errmsg:='';
  if Errmsg<>'' then
    MessageDlg(Errmsg,mtError,[mbOk],0)
  else
  begin
    P:=lst_mt.ItemFocused.Data;
    with P^ do
    begin
      if OnRow1 and OnRow2 then
      begin
        Move(Data[Index1,1],tmp,W*SizeOf(Extended));
        Move(Data[Index2,1],Data[Index1,1],W*SizeOf(Extended));
        Move(tmp,Data[Index2,1],W*SizeOf(Extended));
        Output(P);
      end
      else
      if not (OnRow1 or OnRow2) then
      begin
        for i:=1 to H do
        begin
          x:=Data[i,Index1];
          Data[i,Index1]:=Data[i,Index2];
          Data[i,Index2]:=x;
        end;
        Output(P);
      end
      else
      if w<>h then
        MessageDlg('ChØ ho¸n vÞ ®uîc 1 dßng víi 1 cét khi ma trËn vu«ng',mtError,[mbOk],0)
      else
      if OnRow1 then
      begin
        Move(Data[Index1,1],tmp,W*SizeOf(Extended));
        for i:=1 to w do
          Data[Index1,i]:=Data[i,Index2];
        for i:=1 to w do
          Data[i,Index2]:=tmp[i];
        Output(P);
      end
      else
      if OnRow2 then
      begin
        for i:=1 to w do
          tmp[i]:=Data[i,Index1];
        for i:=1 to w do
          Data[i,Index1]:=Data[Index2,i];
        Move(tmp,Data[Index2,1],W*SizeOf(Extended));
        Output(P);
      end;
    end;//with
  end; //else
end;

procedure Tfrm_matrix.btn_belowClick(Sender: TObject);
var
  i,j,k,n,t: integer; e,x,max: extended;
  tmp: array [1..MAX_ROW] of extended;
  a: PMatrix;
begin
  a:=lst_mt.ItemFocused.Data;
  if a^.w>a^.h then n:=a^.h else n:=a^.w;
  for j:=1 to n do
  begin
    if j<n then
    begin
      t:=j; max:=abs(a^.data[t,j]);
      for i:=j+1 to n do
      begin
        x:=abs(a^.data[i,j]);
        if (x>max) then
          begin max:=x; t:=i end;
      end;
      if t<>j then
        with a^ do
        begin
          move(data[t],tmp,sizeOf(tmp));
          move(data[j],data[t],sizeOf(tmp));
          move(tmp,data[j],sizeOf(tmp));
        end;
    end;
    if a^.data[j,j]<>0 then
      for i:=j+1 to n do
        if (a^.data[i,j]<>0) then
        begin
          e:=a^.data[i,j]/a^.data[j,j];
          for k:=1 to a^.w do
            a^.data[i,k]:=a^.data[i,k]-a^.data[j,k]*e;
        end;
  end;
  output(a);
end;

procedure Tfrm_matrix.btn_bothClick(Sender: TObject);
var
  i,j,k,n,t: integer; e,x,max: extended;
  tmp: array [1..MAX_ROW] of extended;
  a: PMatrix;
begin
  a:=lst_mt.ItemFocused.Data;
  if a^.w>a^.h then n:=a^.h else n:=a^.w;
  for j:=1 to n do
  begin
    if j<n then
    begin
      t:=j; max:=abs(a^.data[t,j]);
      for i:=j+1 to n do
      begin
        x:=abs(a^.data[i,j]);
        if (x>max) then
          begin max:=x; t:=i end;
      end;
      if t<>j then
        with a^ do
        begin
          move(data[t],tmp,sizeOf(tmp));
          move(data[j],data[t],sizeOf(tmp));
          move(tmp,data[j],sizeOf(tmp));
        end;
    end;
    if a^.data[j,j]<>0 then
      for i:=1 to n do
        if (i<>j)and(a^.data[i,j]<>0) then
        begin
          e:=a^.data[i,j]/a^.data[j,j];
          for k:=1 to a^.w do
            a^.data[i,k]:=a^.data[i,k]-a^.data[j,k]*e;
        end;
  end;
  output(a);
end;

procedure Tfrm_matrix.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    27:
      if mtChanged then
      begin
        Output(PMatrix(lst_mt.ItemFocused.Data));
        mtChanged:=False;
      end;
    121: form1.Show;
  end;
end;

procedure Tfrm_matrix.btn_detClick(Sender: TObject);
var
  i,j,k,n,t: integer; e,x,max,det: extended;
  tmp: array [1..MAX_ROW] of extended;
  doidau: Boolean;
  a: PMatrix;
begin
  doidau:=false;
  new(a);
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;
  move(pMatrix(lst_mt.ItemFocused.Data)^,a^,SizeOf(TMatrix));
  if a^.w<>a^.h then
  begin
    if a^.w>a^.h then n:=a^.h else n:=a^.w;
    MessageDlg('Ma trËn nµy kh«ng vu«ng, ch­¬ng tr×nh sÏ tÝnh ®Þnh thøc cña ma trËn vu«ng con lín nhÊt cña nã ë gãc trªn tr¸i.',
      mtInformation,[mbOk],0);
  end
  else
    n:=a^.w;
  for j:=1 to n do
  begin
    if j<n then
    begin
      t:=j; max:=abs(a^.data[t,j]);
      for i:=j+1 to n do
      begin
        x:=abs(a^.data[i,j]);
        if (x>max) then
          begin max:=x; t:=i end;
      end;
      if t<>j then
      begin
        doidau:=not doidau;
        with a^ do
        begin
          move(data[t],tmp,sizeOf(tmp));
          move(data[j],data[t],sizeOf(tmp));
          move(tmp,data[j],sizeOf(tmp));
        end;
      end;
    end;
    if a^.data[j,j]<>0 then
      for i:=j+1 to n do
        if (a^.data[i,j]<>0) then
        begin
          e:=a^.data[i,j]/a^.data[j,j];
          for k:=1 to a^.w do
            a^.data[i,k]:=a^.data[i,k]-a^.data[j,k]*e;
        end;
  end;
  det:=1;
  for i:=1 to n do
  begin
    det:=det*a^.data[i,i];
    if det=0 then Break;
  end;
  if doidau then det:=-det;
  edt_det.Text:=FloatToStr(det);
  dispose(a);
end;
{
var p: PMatrix;
begin
  new(p);
  if mtChanged then
  begin
    input(PMatrix(lst_mt.ItemFocused.Data)^);
    mtChanged:=False;
  end;
  move(pMatrix(lst_mt.ItemFocused.Data)^,p^,SizeOf(TMatrix));
  if p^.w<>p^.h then
  begin
    if p^.w>p^.h then p^.w:=p^.h else p^.h:=p^.w;
    MessageDlg('Ma trËn nµy kh«ng vu«ng, ch­¬ng tr×nh sÏ tÝnh ®Þnh thøc cña ma trËn vu«ng con lín nhÊt cña nã á gãc trªn tr¸i.',
      mtInformation,[mbOk],0);
  end;
  edt_det.Text:=FloatToStr(m_det(p));
  dispose(p);
end;
{}
procedure Tfrm_matrix.lst_mtExit(Sender: TObject);
var ARect: TRect; txtX,txtY: Integer;
begin
  with lst_mt do
  begin
    ARect:=ItemFocused.DisplayRect(drLabel);
    txtX:=ARect.Left+2;
    txtY:=ARect.Top+((ARect.Bottom-ARect.Top)-Canvas.TextHeight('W')) shr 1;
    Canvas.Font.Style:=[fsBold];

    Canvas.Font.Color:=clTeal;
    Canvas.TextRect(ARect,txtx+1,txty,ItemFocused.Caption);
  end;
end;

procedure Tfrm_matrix.grd_matrixMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var S: String; AC,AR: Integer;
begin
  if lst_mt.Items.Count>0 then
    S:='Ma trËn: '+lst_mt.ItemFocused.Caption
  else
    S:='Ch­a cã ma trËn!';
  with grd_matrix do
  begin
    MouseToCell(X,Y,AC,AR);
    if (AC>0) and (AR>0) then
      S:=S+#10+#13+'Gt: '+Cells[AC,AR];
    Hint:=S;
  end;
end;

end.
