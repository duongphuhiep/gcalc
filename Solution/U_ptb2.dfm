object Form_gptb2: TForm_gptb2
  Left = 206
  Top = 155
  BorderStyle = bsDialog
  Caption = 'Solve equation of the second degree'
  ClientHeight = 273
  ClientWidth = 449
  Color = 14215660
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'GCalc System Font   '
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  ScreenSnap = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 115
    Top = 11
    Width = 232
    Height = 14
    Caption = 'Gi'#182'i ph'#173#172'ng tr'#215'nh: a*x^2 + b*x + c = 0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 113
    Top = 9
    Width = 232
    Height = 14
    Caption = 'Gi'#182'i ph'#173#172'ng tr'#215'nh: a*x^2 + b*x + c = 0'
    Color = 14215660
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 209
    Height = 129
    Caption = 'Nh'#203'p h'#214' s'#232
    TabOrder = 0
    object LEdit1: TLabeledEdit
      Left = 48
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
      Left = 48
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
      Left = 48
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
  end
  object GroupBox2: TGroupBox
    Left = 224
    Top = 32
    Width = 217
    Height = 129
    Caption = 'K'#213't qu'#182' ch'#221'nh x'#184'c'
    TabOrder = 2
    object LEdit4: TLabeledEdit
      Left = 56
      Top = 24
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 35
      EditLabel.Height = 14
      EditLabel.Caption = '&delta ='
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object LEdit5: TLabeledEdit
      Left = 56
      Top = 56
      Width = 145
      Height = 22
      EditLabel.Width = 25
      EditLabel.Height = 14
      EditLabel.Caption = 'x&1 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object LEdit6: TLabeledEdit
      Left = 56
      Top = 88
      Width = 145
      Height = 22
      EditLabel.Width = 26
      EditLabel.Height = 14
      EditLabel.Caption = 'x&2 = '
      LabelPosition = lpLeft
      MaxLength = 1000
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
  end
  object BitBtn1: TBitBtn
    Left = 56
    Top = 168
    Width = 145
    Height = 25
    Caption = #167#183' nh'#203'p &Xong!'
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 88
    Top = 240
    Width = 81
    Height = 25
    Caption = '&K'#213't th'#243'c'
    TabOrder = 4
    OnClick = BitBtn2Click
    Kind = bkCancel
  end
  object Edit1: TEdit
    Left = 56
    Top = 200
    Width = 145
    Height = 22
    TabStop = False
    Color = 16772332
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object GroupBox3: TGroupBox
    Left = 224
    Top = 168
    Width = 217
    Height = 97
    Caption = 'K'#213't qu'#182' hi'#214'u d'#244'ng'
    TabOrder = 3
    object LEdit7: TLabeledEdit
      Left = 56
      Top = 24
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 25
      EditLabel.Height = 14
      EditLabel.Caption = 'x1 = '
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object LEdit8: TLabeledEdit
      Left = 56
      Top = 56
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 26
      EditLabel.Height = 14
      EditLabel.Caption = 'x2 = '
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
  end
end
