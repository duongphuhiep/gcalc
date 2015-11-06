unit UZoom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm5 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Bevel1: TBevel;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses UPaint;
{$R *.DFM}

procedure TForm5.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm5.BitBtn1Click(Sender: TObject);
begin
  ZX:=StrToInt(Edit1.Text);
  ZY:=StrToInt(Edit2.Text);
  DZX:=StrToInt(Edit3.Text);
  DZY:=StrToInt(Edit4.Text);
  DZXY:=StrToInt(Edit5.Text);
end;

procedure TForm5.FormActivate(Sender: TObject);
begin
  Edit1.Text:=IntToStr(ZX);
  Edit2.Text:=IntToStr(ZY);
  Edit3.Text:=IntToStr(DZX);
  Edit4.Text:=IntToStr(DZY);
  Edit5.Text:=IntToStr(DZXY);
end;

end.
