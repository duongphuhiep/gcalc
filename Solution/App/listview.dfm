object Form2: TForm2
  Left = 89
  Top = 145
  Width = 544
  Height = 457
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 64
    Width = 37
    Height = 13
    Caption = 'OnClick'
  end
  object Label2: TLabel
    Left = 88
    Top = 112
    Width = 76
    Height = 13
    Caption = 'OnSelectedItem'
  end
  object ListView1: TListView
    Left = 16
    Top = 24
    Width = 66
    Height = 345
    Columns = <
      item
        Caption = 'Ten'
      end>
    FlatScrollBars = True
    GridLines = True
    Items.Data = {
      0B010000090000000000000000000000FFFFFFFF030000000000000008546875
      632076617403436179024375035175610000000001000000FFFFFFFF02000000
      0000000008446F6E67207661740343686F034D656F00000000FFFFFFFFFFFFFF
      FF000000000000000009436F6E206E67756F6900000000FFFFFFFFFFFFFFFF00
      00000000000000034B696D00000000FFFFFFFFFFFFFFFF000000000000000003
      4D6F6300000000FFFFFFFFFFFFFFFF0000000000000000045468757900000000
      FFFFFFFFFFFFFFFF000000000000000003486F6100000000FFFFFFFFFFFFFFFF
      00000000000000000354686F00000000FFFFFFFFFFFFFFFF0000000000000000
      00FFFFFFFFFFFFFFFFFFFF}
    ShowWorkAreas = True
    TabOrder = 0
    ViewStyle = vsList
    OnClick = ListView1Click
    OnEdited = ListView1Edited
    OnSelectItem = ListView1SelectItem
  end
  object Button1: TButton
    Left = 88
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Cut'
    TabOrder = 1
    OnClick = Button1Click
  end
  object SpinEdit1: TSpinEdit
    Left = 88
    Top = 80
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 88
    Top = 128
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 88
    Top = 176
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object Edit1: TEdit
    Left = 224
    Top = 176
    Width = 113
    Height = 21
    TabOrder = 5
    Text = 'Edit1'
  end
end
