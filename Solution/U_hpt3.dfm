object Form_hpt3: TForm_hpt3
  Left = 203
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Solve set of equation with three unknow numbers'
  ClientHeight = 249
  ClientWidth = 545
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
    Width = 529
    Height = 129
    Caption = 'Nh'#203'p h'#214' s'#232
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 15
      Height = 35
      Caption = '{'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LEdit1: TLabeledEdit
      Left = 32
      Top = 24
      Width = 89
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
      Left = 160
      Top = 24
      Width = 89
      Height = 22
      EditLabel.Width = 29
      EditLabel.Height = 14
      EditLabel.Caption = '* y  +'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object LEdit3: TLabeledEdit
      Left = 288
      Top = 24
      Width = 89
      Height = 22
      EditLabel.Width = 28
      EditLabel.Height = 14
      EditLabel.Caption = '* z  ='
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object LEdit4: TLabeledEdit
      Left = 416
      Top = 24
      Width = 89
      Height = 22
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object LEdit5: TLabeledEdit
      Left = 32
      Top = 56
      Width = 89
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
      TabOrder = 4
    end
    object LEdit6: TLabeledEdit
      Left = 160
      Top = 56
      Width = 89
      Height = 22
      EditLabel.Width = 29
      EditLabel.Height = 14
      EditLabel.Caption = '* y  +'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object LEdit7: TLabeledEdit
      Left = 288
      Top = 56
      Width = 89
      Height = 22
      EditLabel.Width = 28
      EditLabel.Height = 14
      EditLabel.Caption = '* z  ='
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object LEdit8: TLabeledEdit
      Left = 416
      Top = 56
      Width = 89
      Height = 22
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object LEdit9: TLabeledEdit
      Left = 32
      Top = 88
      Width = 89
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
      TabOrder = 8
    end
    object LEdit10: TLabeledEdit
      Left = 160
      Top = 88
      Width = 89
      Height = 22
      EditLabel.Width = 29
      EditLabel.Height = 14
      EditLabel.Caption = '* y  +'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object LEdit11: TLabeledEdit
      Left = 288
      Top = 88
      Width = 89
      Height = 22
      EditLabel.Width = 28
      EditLabel.Height = 14
      EditLabel.Caption = '* z  ='
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
    end
    object LEdit12: TLabeledEdit
      Left = 416
      Top = 88
      Width = 89
      Height = 22
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
    end
  end
  object BitBtn1: TBitBtn
    Left = 40
    Top = 144
    Width = 121
    Height = 25
    Caption = #167#183' nh'#203'p &Xong!'
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object Edit1: TEdit
    Left = 168
    Top = 144
    Width = 217
    Height = 22
    Color = 16772332
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 424
    Top = 144
    Width = 89
    Height = 25
    Caption = '&K'#213't th'#243'c'
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkCancel
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 176
    Width = 529
    Height = 65
    Caption = 'K'#213't qu'#182
    TabOrder = 4
    object LEdit13: TLabeledEdit
      Left = 32
      Top = 24
      Width = 137
      Height = 22
      Color = 14215660
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '&x='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object LEdit14: TLabeledEdit
      Left = 200
      Top = 24
      Width = 137
      Height = 22
      Color = 14215660
      EditLabel.Width = 14
      EditLabel.Height = 14
      EditLabel.Caption = '&y='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object LEdit15: TLabeledEdit
      Left = 368
      Top = 24
      Width = 137
      Height = 22
      Color = 14215660
      EditLabel.Width = 13
      EditLabel.Height = 14
      EditLabel.Caption = '&z='
      LabelPosition = lpLeft
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
    end
  end
end
