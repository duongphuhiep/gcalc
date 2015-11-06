object Form_ptb3: TForm_ptb3
  Left = 367
  Top = 140
  BorderStyle = bsDialog
  Caption = 'Solve equation of the third degree'
  ClientHeight = 241
  ClientWidth = 425
  Color = 14215660
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'GCalc System Font   '
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  ScreenSnap = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 74
    Top = 10
    Width = 286
    Height = 14
    Caption = 'Gi'#182'i ph'#173#172'ng tr'#215'nh: a*x^3 + b*x^2 + c*x + d = 0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 72
    Top = 8
    Width = 286
    Height = 14
    Caption = 'Gi'#182'i ph'#173#172'ng tr'#215'nh: a*x^3 + b*x^2 + c*x + d = 0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 201
    Height = 161
    Caption = 'Nh'#203'p h'#214' s'#232
    TabOrder = 0
    object LEdit1: TLabeledEdit
      Left = 40
      Top = 24
      Width = 145
      Height = 22
      EditLabel.Width = 20
      EditLabel.Height = 14
      EditLabel.Caption = '&a = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object LEdit2: TLabeledEdit
      Left = 40
      Top = 56
      Width = 145
      Height = 22
      EditLabel.Width = 20
      EditLabel.Height = 14
      EditLabel.Caption = '&b = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object LEdit3: TLabeledEdit
      Left = 40
      Top = 88
      Width = 145
      Height = 22
      Ctl3D = True
      EditLabel.Width = 19
      EditLabel.Height = 14
      EditLabel.Caption = '&c = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object LEdit7: TLabeledEdit
      Left = 40
      Top = 120
      Width = 145
      Height = 22
      EditLabel.Width = 20
      EditLabel.Height = 14
      EditLabel.Caption = '&d = '
      LabelPosition = lpLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 216
    Top = 32
    Width = 201
    Height = 161
    Caption = 'K'#213't qu'#182' hi'#214'u d'#244'ng'
    TabOrder = 2
    object LEdit4: TLabeledEdit
      Left = 40
      Top = 40
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 25
      EditLabel.Height = 14
      EditLabel.Caption = 'x&1 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object LEdit5: TLabeledEdit
      Left = 40
      Top = 72
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 26
      EditLabel.Height = 14
      EditLabel.Caption = 'x&2 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object LEdit6: TLabeledEdit
      Left = 40
      Top = 104
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 26
      EditLabel.Height = 14
      EditLabel.Caption = 'x&3 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 208
    Width = 129
    Height = 25
    Caption = #167#183' nh'#203'p &Xong!'
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 208
    Width = 81
    Height = 25
    Caption = '&K'#213't th'#243'c'
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkCancel
  end
  object Edit1: TEdit
    Left = 144
    Top = 208
    Width = 153
    Height = 24
    TabStop = False
    Color = 16772332
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
end
