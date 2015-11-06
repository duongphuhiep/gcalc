object Form_hpt2: TForm_hpt2
  Left = 225
  Top = 131
  BorderStyle = bsDialog
  Caption = 'Solve set of equation with two unknow numbers'
  ClientHeight = 289
  ClientWidth = 393
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 97
    Caption = 'Nh'#203'p h'#214' s'#232
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 13
      Height = 35
      Caption = '{'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
    end
    object LEdit1: TLabeledEdit
      Left = 32
      Top = 24
      Width = 81
      Height = 22
      EditLabel.Width = 27
      EditLabel.Height = 16
      EditLabel.Caption = '* x  +'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clBlack
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object LEdit2: TLabeledEdit
      Left = 152
      Top = 24
      Width = 81
      Height = 22
      EditLabel.Width = 15
      EditLabel.Height = 14
      EditLabel.Caption = '* y'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object LEdit3: TLabeledEdit
      Left = 272
      Top = 24
      Width = 81
      Height = 22
      EditLabel.Width = 17
      EditLabel.Height = 14
      EditLabel.Caption = ' =  '
      LabelPosition = lpLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object LEdit4: TLabeledEdit
      Left = 32
      Top = 56
      Width = 81
      Height = 22
      EditLabel.Width = 29
      EditLabel.Height = 14
      EditLabel.Caption = '* x  +'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object LEdit5: TLabeledEdit
      Left = 152
      Top = 56
      Width = 81
      Height = 22
      EditLabel.Width = 15
      EditLabel.Height = 14
      EditLabel.Caption = '* y'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object LEdit6: TLabeledEdit
      Left = 272
      Top = 56
      Width = 81
      Height = 22
      EditLabel.Width = 17
      EditLabel.Height = 14
      EditLabel.Caption = ' =  '
      LabelPosition = lpLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 144
    Width = 377
    Height = 137
    Caption = 'K'#213't qu'#182
    TabOrder = 2
    object LEdit7: TLabeledEdit
      Left = 32
      Top = 24
      Width = 81
      Height = 22
      TabStop = False
      Color = 14215660
      EditLabel.Width = 15
      EditLabel.Height = 14
      EditLabel.Caption = 'D='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object LEdit8: TLabeledEdit
      Left = 152
      Top = 24
      Width = 81
      Height = 22
      TabStop = False
      Color = 14215660
      EditLabel.Width = 21
      EditLabel.Height = 14
      EditLabel.Caption = 'Dx='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object LEdit9: TLabeledEdit
      Left = 272
      Top = 24
      Width = 81
      Height = 22
      TabStop = False
      Color = 14215660
      EditLabel.Width = 21
      EditLabel.Height = 14
      EditLabel.Caption = 'Dy='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
    end
    object LEdit10: TLabeledEdit
      Left = 32
      Top = 64
      Width = 153
      Height = 22
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '&x='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
    end
    object LEdit11: TLabeledEdit
      Left = 32
      Top = 96
      Width = 153
      Height = 22
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '&y='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
    end
    object LEdit12: TLabeledEdit
      Left = 208
      Top = 64
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '=  '
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
    end
    object LEdit13: TLabeledEdit
      Left = 208
      Top = 96
      Width = 145
      Height = 22
      Color = 14215660
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '=  '
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
    end
  end
  object Edit1: TEdit
    Left = 136
    Top = 112
    Width = 145
    Height = 24
    TabStop = False
    Color = 16772332
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'ABC Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 112
    Width = 121
    Height = 25
    Caption = #167#183' nh'#203'p &Xong!'
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 288
    Top = 112
    Width = 97
    Height = 25
    Caption = '&K'#213't th'#243'c'
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkCancel
  end
end
