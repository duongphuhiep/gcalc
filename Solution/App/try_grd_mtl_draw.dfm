object Form1: TForm1
  Left = 294
  Top = 77
  Width = 373
  Height = 452
  ActiveControl = StringGrid1
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 184
    Top = 320
    Width = 37
    Height = 13
    Caption = 'OnClick'
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 345
    Height = 145
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    OnClick = StringGrid1Click
    OnExit = StringGrid1Exit
    OnGetEditMask = StringGrid1GetEditMask
    OnGetEditText = StringGrid1GetEditText
    OnKeyDown = StringGrid1KeyDown
    OnMouseDown = StringGrid1MouseDown
    OnSetEditText = StringGrid1SetEditText
  end
  object edt_GEM: TLabeledEdit
    Left = 16
    Top = 176
    Width = 121
    Height = 21
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'OnGetEditMask'
    TabOrder = 1
  end
  object edt_GET: TLabeledEdit
    Left = 184
    Top = 176
    Width = 121
    Height = 21
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = 'OnGetEditText'
    TabOrder = 2
  end
  object edt_SET: TLabeledEdit
    Left = 16
    Top = 216
    Width = 289
    Height = 21
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = 'OnSetEditText'
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 16
    Top = 248
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 184
    Top = 336
    Width = 153
    Height = 21
    TabOrder = 5
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 184
    Top = 248
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'Edit3'
  end
  object edt_con: TLabeledEdit
    Left = 16
    Top = 296
    Width = 161
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'Control State'
    TabOrder = 7
  end
  object edt_com: TLabeledEdit
    Left = 16
    Top = 336
    Width = 161
    Height = 21
    EditLabel.Width = 82
    EditLabel.Height = 13
    EditLabel.Caption = 'Component State'
    TabOrder = 8
  end
  object Edit4: TEdit
    Left = 16
    Top = 376
    Width = 321
    Height = 21
    TabOrder = 9
    Text = 'Edit4'
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 312
    Top = 216
  end
end
