unit try_grd_mtl_draw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Types, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    edt_GEM: TLabeledEdit;
    edt_GET: TLabeledEdit;
    edt_SET: TLabeledEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    edt_con: TLabeledEdit;
    edt_com: TLabeledEdit;
    Timer1: TTimer;
    Edit4: TEdit;
    Label1: TLabel;
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure StringGrid1Exit(Sender: TObject);
  private
    { Private declarations }
    CanModify, Editing: Boolean;
    function StrComState: string;
    function StrConState: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
var c1,c2,c3,c4,kq: integer;

function TForm1.StrComState: string;
var s: string;
begin
  with StringGrid1 do
  begin
    s:='';
    if csAncestor in ComponentState then s:=s+'csAncestor + ';
    if csDesigning in ComponentState then s:=s+'csDesigning + ';
    if csDestroying	in ComponentState then s:=s+'csDestroying	+ ';
    if csFixups	in ComponentState then s:=s+'csFixups	+ ';
    if csFreeNotification	in ComponentState then s:=s+'csFreeNotification	+ ';
    if csInline	in ComponentState then s:=s+'csInline	+ ';
    if csLoading in ComponentState then s:=s+'csLoading	+ ';
    if csReading in ComponentState then s:=s+'csReading	+ ';
    if csUpdating	in ComponentState then s:=s+'csUpdating	+ ';
    if csWriting in ComponentState then s:=s+'csWriting + ';
    if csDesignInstance	in ComponentState then s:=s+'csDesignInstance + ';
  end;
  StrComState:=s;
end;

function TForm1.StrConState: string;
var s: string;
begin
  with StringGrid1 do
  begin
    s:='';
    if csLButtonDown in ControlState then s:=s+'csLButtonDown	+ ';
    if csClicked in ControlState then s:=s+'csClicked	+ ';
    if csPalette in ControlState then s:=s+'csPalette	+ ';
    if csReadingState in ControlState then s:=s+'csReadingState	+ ';
    if csAlignmentNeeded in ControlState then s:=s+'csAlignmentNeeded	+ ';
    if csFocusing	in ControlState then s:=s+'csFocusing	+ ';
    if csCreating	in ControlState then s:=s+'csCreating	+ ';
    if csPaintCopy in ControlState then s:=s+'csPaintCopy	+ ';
    if csCustomPaint in ControlState then s:=s+'csCustomPaint	+ ';
    if csDestroyingHandle	in ControlState then s:=s+'csDestroyingHandle	+ ';
    if csDocking in ControlState then s:=s+'csDocking + ';
  end;
  StrConState:=s;
end;

procedure TForm1.StringGrid1GetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  inc(c1);
  edt_GEM.Text:=inttostr(c1)+'> '+value+'>'+intToStr(ACol)+':'+intToStr(ARow);
end;

procedure TForm1.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  inc(c2);
  edt_GET.Text:=inttostr(c2)+'> '+value+'>'+intToStr(ACol)+':'+intToStr(ARow);
  Editing:=True;
end;

procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  inc(c3);
  edt_SET.Text:=inttostr(c3)+'> '+value+'>'+intToStr(ACol)+':'+intToStr(ARow);
  if CanModify then
  begin
    inc(kq);
    edit4.Text:=inttostr(kq)+'> '+value+'>'+intToStr(ACol)+':'+intToStr(ARow);
    Editing:=false; CanModify:=false;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  c1:=0; c2:=0; c3:=0; c4:=0; kq:=0;
  CanModify:=false; Editing:=false;
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Edit1.Text:=intToStr(key);
  if (Key=13)and Editing then
    CanModify:=true;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin
  inc(c4);
  edit2.Text:=inttostr(c4);
  if Editing then
    CanModify:=true;
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edit3.Text:=intToStr(x)+':'+intToStr(x);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var s: string;
begin
  s:=StrComState;
  if s<>'' then
    edt_com.Text:=s;
  s:=StrConState;
  if s<>'' then
    edt_con.Text:=s;
end;

procedure TForm1.StringGrid1Exit(Sender: TObject);
begin
  if editing then
    CanModify:=true;
end;

end.
