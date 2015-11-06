object Form_ptb4: TForm_ptb4
  Left = 216
  Top = 213
  Width = 457
  Height = 323
  Caption = 'Giai phuong trinh trung phuong'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 308
    Height = 16
    Caption = 'Gi'#182'i ph'#173#172'ng tr'#215'nh: a*x^4 + b*x^2 + c*x + d = 0 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 32
    Width = 209
    Height = 161
    Caption = 'Nh'#203'p h'#214' s'#232
    TabOrder = 0
    object LEdit1: TLabeledEdit
      Left = 40
      Top = 40
      Width = 145
      Height = 24
      EditLabel.Width = 21
      EditLabel.Height = 16
      EditLabel.Caption = '&a = '
      LabelPosition = lpLeft
      MaxLength = 1000
      TabOrder = 0
    end
    object LEdit2: TLabeledEdit
      Left = 40
      Top = 72
      Width = 145
      Height = 24
      EditLabel.Width = 21
      EditLabel.Height = 16
      EditLabel.Caption = '&b = '
      LabelPosition = lpLeft
      MaxLength = 1000
      TabOrder = 1
    end
    object LEdit3: TLabeledEdit
      Left = 40
      Top = 104
      Width = 145
      Height = 24
      Ctl3D = True
      EditLabel.Width = 20
      EditLabel.Height = 16
      EditLabel.Caption = '&c = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentCtl3D = False
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 232
    Top = 32
    Width = 201
    Height = 161
    Caption = 'K'#213't qu'#182' hi'#214'u d'#244'ng'
    TabOrder = 1
    object LEdit4: TLabeledEdit
      Left = 40
      Top = 24
      Width = 145
      Height = 24
      Color = clBtnFace
      EditLabel.Width = 26
      EditLabel.Height = 16
      EditLabel.Caption = 'x&1 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ReadOnly = True
      TabOrder = 0
    end
    object LEdit5: TLabeledEdit
      Left = 40
      Top = 56
      Width = 145
      Height = 24
      Color = clBtnFace
      EditLabel.Width = 26
      EditLabel.Height = 16
      EditLabel.Caption = 'x&2 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ReadOnly = True
      TabOrder = 1
    end
    object LEdit6: TLabeledEdit
      Left = 40
      Top = 88
      Width = 145
      Height = 24
      Color = clBtnFace
      EditLabel.Width = 26
      EditLabel.Height = 16
      EditLabel.Caption = 'x&3 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ReadOnly = True
      TabOrder = 2
    end
    object LEdit7: TLabeledEdit
      Left = 40
      Top = 120
      Width = 145
      Height = 24
      Color = clBtnFace
      EditLabel.Width = 26
      EditLabel.Height = 16
      EditLabel.Caption = 'x&4 = '
      LabelPosition = lpLeft
      TabOrder = 3
    end
  end
  object BitBtn1: TBitBtn
    Left = 72
    Top = 208
    Width = 121
    Height = 25
    Caption = #167#183' nh'#203'p &xong!'
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 296
    Top = 208
    Width = 89
    Height = 25
    Caption = '&Tho'#184't'
    TabOrder = 3
    Kind = bkClose
  end
  object Edit1: TEdit
    Left = 16
    Top = 248
    Width = 417
    Height = 24
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
end
