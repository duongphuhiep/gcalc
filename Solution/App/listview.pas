unit listview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    SpinEdit3: TSpinEdit;
    Edit1: TEdit;
    procedure ListView1Edited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure Button1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.ListView1Edited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  if TListView(Sender).FindCaption(0,S,False,True,False)<>NIL then
  begin
    ShowMessage('"'+S+'" has been exist');
    S:=Item.Caption;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  ListView1.DeleteSelected;
end;

procedure TForm2.ListView1Click(Sender: TObject);
begin
  with SpinEdit1 do Value:=Value+1;
end;

procedure TForm2.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
   if Selected then
     with SpinEdit2 do Value:=Value+1
   else
   begin
     SpinEdit3.Value:=TListView(Sender).ItemIndex;
     Edit1.Text:=Item.Caption;
   end;  
end;

end.
