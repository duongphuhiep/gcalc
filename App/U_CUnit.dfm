object frm_cvunit: Tfrm_cvunit
  Left = 207
  Top = 120
  Width = 561
  Height = 403
  Caption = 'Convert units'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'EasyCalc System Font'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 17
    Top = 8
    Width = 27
    Height = 14
    Caption = '&Nh'#227'm'
    FocusControl = lst_group
  end
  object lst_group: TListView
    Left = 16
    Top = 24
    Width = 65
    Height = 285
    Align = alCustom
    Columns = <>
    ParentShowHint = False
    PopupMenu = pmn_group
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsList
  end
  object lst_A: TListView
    Left = 96
    Top = 48
    Width = 161
    Height = 261
    Columns = <>
    GridLines = True
    PopupMenu = pmn_unit
    ShowColumnHeaders = False
    TabOrder = 1
    ViewStyle = vsReport
  end
  object lst_B: TListView
    Left = 264
    Top = 48
    Width = 273
    Height = 261
    Columns = <
      item
        Width = 130
      end>
    GridLines = True
    ShowColumnHeaders = False
    TabOrder = 2
    ViewStyle = vsReport
  end
  object edt_A: TLabeledEdit
    Left = 96
    Top = 24
    Width = 161
    Height = 22
    EditLabel.Width = 84
    EditLabel.Height = 14
    EditLabel.Caption = 'Gi'#184' tr'#222' c'#199'n '#174#230'i (&A)'
    EditLabel.Font.Charset = ANSI_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'EasyCalc System Font'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 3
  end
  object edt_B: TLabeledEdit
    Left = 264
    Top = 24
    Width = 273
    Height = 22
    EditLabel.Width = 55
    EditLabel.Height = 14
    EditLabel.Caption = 'K'#213't qu'#182' (&B)'
    EditLabel.Font.Charset = ANSI_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'EasyCalc System Font'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 324
    Width = 65
    Height = 25
    Caption = '&T'#215'm ki'#213'm..'
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 96
    Top = 316
    Width = 441
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 6
    object edt_mul: TLabeledEdit
      Left = 8
      Top = 12
      Width = 121
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      EditLabel.Width = 27
      EditLabel.Height = 14
      EditLabel.Caption = '*A + '
      LabelPosition = lpRight
      TabOrder = 0
    end
    object edt_plus: TLabeledEdit
      Left = 160
      Top = 12
      Width = 121
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      EditLabel.Width = 21
      EditLabel.Height = 14
      EditLabel.Caption = ' = B'
      LabelPosition = lpRight
      TabOrder = 1
    end
    object BitBtn2: TBitBtn
      Left = 328
      Top = 8
      Width = 105
      Height = 25
      Caption = '<< '#167#230'i c'#171'ng th'#248'c'
      Enabled = False
      TabOrder = 2
    end
  end
  object pmn_group: TPopupMenu
    OwnerDraw = True
    Left = 48
    Top = 96
    object hmnhm1: TMenuItem
      Caption = 'Th'#170'm'
      OnDrawItem = hmnhm1DrawItem
    end
    object hmnhm2: TMenuItem
      Caption = 'Xo'#184
      OnClick = hmnhm2Click
      OnDrawItem = hmnhm1DrawItem
    end
    object Spxp1: TMenuItem
      Caption = 'S'#190'p x'#213'p'
      OnDrawItem = hmnhm1DrawItem
    end
  end
  object pmn_unit: TPopupMenu
    OwnerDraw = True
    Left = 112
    Top = 56
    object MenuItem1: TMenuItem
      Caption = 'Th'#170'm'
      OnDrawItem = hmnhm1DrawItem
    end
    object MenuItem2: TMenuItem
      Caption = 'Xo'#184
      OnDrawItem = hmnhm1DrawItem
    end
    object MenuItem3: TMenuItem
      Caption = 'S'#190'p x'#213'p'
      OnDrawItem = hmnhm1DrawItem
    end
  end
end
