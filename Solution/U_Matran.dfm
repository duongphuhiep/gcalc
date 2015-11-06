object frm_matrix: Tfrm_matrix
  Left = 157
  Top = 55
  Width = 625
  Height = 388
  Anchors = [akTop, akRight]
  Caption = 'Matrix'
  Color = 14215660
  Constraints.MinHeight = 388
  Constraints.MinWidth = 625
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'GCalc System Font   '
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    617
    354)
  PixelsPerInch = 96
  TextHeight = 14
  object btn_save: TSpeedButton
    Left = 64
    Top = 104
    Width = 33
    Height = 25
    Enabled = False
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
      00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
      00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
      00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
      00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
      0003737FFFFFFFFF7F7330099999999900333777777777777733}
    NumGlyphs = 2
    OnClick = btn_saveClick
  end
  object btn_load: TSpeedButton
    Left = 64
    Top = 128
    Width = 33
    Height = 25
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    OnClick = btn_loadClick
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 53
    Height = 14
    Caption = '&Danh s'#184'ch:'
    FocusControl = lst_mt
  end
  object btn_attach: TSpeedButton
    Left = 64
    Top = 40
    Width = 33
    Height = 25
    Caption = '<<'
    Enabled = False
    Flat = True
    Font.Charset = ARABIC_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'ABC Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btn_attachClick
  end
  object Label2: TLabel
    Left = 104
    Top = 16
    Width = 50
    Height = 14
    Caption = 'S'#232' &d'#223'ng ='
    FocusControl = edt_height
  end
  object Label3: TLabel
    Left = 208
    Top = 16
    Width = 41
    Height = 14
    Caption = 'S'#232' &c'#233't ='
    FocusControl = edt_width
  end
  object btn_cut: TSpeedButton
    Left = 64
    Top = 64
    Width = 33
    Height = 25
    Enabled = False
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
      BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBFBBBBBBBBBBFBBBB9BBBBBBBB
      BB9BBBB7FBBBBBBBBF7BBB999BBBBBBBBBBBBB877FBBBBBBBFBBBB9999BBBBBB
      B9BBBB8777FBBBBBF7BBBBB999BBBBBB9BBBBBB877FBBBBF7BBBBBBB999BBBB9
      9BBBBBBB877FBBF78BBBBBBBB999BB99BBBBBBBBB877FF78BBBBBBBBBB99999B
      BBBBBBBBBB87778BBBBBBBBBBBB999BBBBBBBBBBBBF778FBBBBBBBBBBB99999B
      BBBBBBBBBF77887FBBBBBBBBB999BB99BBBBBBBFF778BB87FBBBBBB9999BBBB9
      9BBBBBF7778BBBB87FBBBB9999BBBBBB99BBBB7778BBBBBB87FBBB999BBBBBBB
      BB9BBB778BBBBBBBBB7BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
    NumGlyphs = 2
    OnClick = btn_cutClick
  end
  object Bevel4: TBevel
    Left = 69
    Top = 96
    Width = 23
    Height = 9
    Shape = bsTopLine
    Style = bsRaised
  end
  object btn_det: TSpeedButton
    Left = 314
    Top = 13
    Width = 31
    Height = 22
    Anchors = [akTop, akRight]
    Caption = 'Det'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -13
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btn_detClick
  end
  object GroupBox1: TGroupBox
    Left = 472
    Top = 36
    Width = 137
    Height = 253
    Hint = 'C'#184'c ph'#208'p t'#221'nh c'#172' b'#182'n'
    Anchors = [akTop, akRight, akBottom]
    Caption = 'T'#221'nh ma tr'#203'n m'#237'i'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    object btn_rev: TSpeedButton
      Left = 100
      Top = 163
      Width = 25
      Height = 25
      Caption = '^-1'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -13
      Font.Name = 'GCalc System Font   '
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_revClick
    end
    object btn_add: TSpeedButton
      Left = 100
      Top = 19
      Width = 25
      Height = 26
      Caption = '+'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_addClick
    end
    object btn_sub: TSpeedButton
      Left = 100
      Top = 44
      Width = 25
      Height = 26
      Caption = '-'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -27
      Font.Name = 'GCalc System Font   '
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_subClick
    end
    object btn_mul: TSpeedButton
      Left = 100
      Top = 69
      Width = 25
      Height = 26
      Caption = 'x'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_mulClick
    end
    object btn_trans: TSpeedButton
      Left = 100
      Top = 187
      Width = 25
      Height = 25
      Caption = '^t'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -13
      Font.Name = 'GCalc System Font   '
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_transClick
    end
    object btn_power: TSpeedButton
      Left = 100
      Top = 94
      Width = 25
      Height = 25
      Caption = '^'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_powerClick
    end
    object Bevel1: TBevel
      Left = 8
      Top = 146
      Width = 121
      Height = 9
      Shape = bsBottomLine
    end
    object SpeedButton1: TSpeedButton
      Left = 100
      Top = 118
      Width = 25
      Height = 25
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        06020000424D0602000000000000760000002800000019000000190000000100
        0400000000009001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000FFFFFFFFFF66
        666FFFFFFFFFF0000000FFFFFFFF666666666FFFFFFFF0000000FFFFFFF666FF
        FFF666FFFFFFF0000000FFFFFF66FFFFFFFFF66FFFFFF0000000FFFFFF66FFFF
        FFFFF66FFFFFF0000000FFFFF66FFFFF6FFFFF66FFFFF0000000FFFFF66FFFF6
        66FFFF66FFFFF0000000FFFFF66FFFFF6FFFFF66FFFFF0000000FFFFF66FFFFF
        FFFFFF66FFFFF0000000FFFFFF66FFFFFFFFF66FFFFFF0000000FFFFFF66FFFF
        FFFFF66FFFFFF0000000FFFFFFF666FFFFF666FFFFFFF0000000FFFFFFFF6666
        66666FFFFFFFF0000000FFFFFFFFFF66666FFFFFFFFFF0000000FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000FFFFFFFFFFFF
        FFFFFFFFFFFFF0000000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = SpeedButton1Click
    end
    object edt_a2: TEdit
      Left = 64
      Top = 88
      Width = 33
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 2
    end
    object edt_b1: TEdit
      Left = 64
      Top = 176
      Width = 33
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 4
    end
    object edt_a1: TEdit
      Left = 64
      Top = 57
      Width = 33
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 1
    end
    object edt_b: TLabeledEdit
      Left = 8
      Top = 176
      Width = 33
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      Color = clWhite
      EditLabel.Width = 11
      EditLabel.Height = 14
      EditLabel.Caption = ' ='
      LabelPosition = lpRight
      TabOrder = 3
    end
    object edt_a: TLabeledEdit
      Left = 8
      Top = 72
      Width = 33
      Height = 21
      BevelKind = bkSoft
      BorderStyle = bsNone
      Color = clWhite
      EditLabel.Width = 11
      EditLabel.Height = 14
      EditLabel.Caption = ' ='
      LabelPosition = lpRight
      TabOrder = 0
    end
  end
  object edt_height: TSpinEdit
    Left = 157
    Top = 13
    Width = 44
    Height = 23
    Ctl3D = True
    MaxLength = 3
    MaxValue = 256
    MinValue = 0
    ParentCtl3D = False
    TabOrder = 0
    Value = 0
    OnKeyDown = edt_heightKeyDown
  end
  object edt_width: TSpinEdit
    Left = 253
    Top = 13
    Width = 44
    Height = 23
    Ctl3D = True
    MaxLength = 3
    MaxValue = 256
    MinValue = 0
    ParentCtl3D = False
    TabOrder = 1
    Value = 0
    OnKeyDown = edt_heightKeyDown
  end
  object Panel1: TPanel
    Left = 7
    Top = 40
    Width = 50
    Height = 249
    Anchors = [akLeft, akTop, akBottom]
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = 'ABC Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object lst_mt: TListView
      Left = 2
      Top = 2
      Width = 46
      Height = 245
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Columns = <>
      ColumnClick = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'GCalc System Font   '
      Font.Style = []
      GridLines = True
      OwnerDraw = True
      ParentFont = False
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsList
      OnAdvancedCustomDrawItem = lst_mtAdvancedCustomDrawItem
      OnEdited = lst_mtEdited
      OnExit = lst_mtExit
      OnInfoTip = lst_mtInfoTip
      OnMouseDown = lst_mtMouseDown
      OnSelectItem = lst_mtSelectItem
    end
  end
  object Panel2: TPanel
    Left = 103
    Top = 40
    Width = 360
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    Caption = 'Ma tr'#203'n 0x0'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clSilver
    Font.Height = -24
    Font.Name = 'GCalc System Font   '
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object grd_matrix: TStringGrid
      Left = 2
      Top = 2
      Width = 356
      Height = 245
      Align = alClient
      BorderStyle = bsNone
      ColCount = 1
      DefaultColWidth = 50
      DefaultRowHeight = 40
      DefaultDrawing = False
      FixedColor = clWhite
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'GCalc System Font   '
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
      ParentFont = False
      ParentShowHint = False
      ScrollBars = ssNone
      ShowHint = True
      TabOrder = 0
      Visible = False
      OnClick = grd_matrixClick
      OnDrawCell = grd_matrixDrawCell
      OnExit = grd_matrixExit
      OnMouseMove = grd_matrixMouseMove
      OnSetEditText = grd_matrixSetEditText
    end
  end
  object Panel3: TPanel
    Left = 104
    Top = 298
    Width = 505
    Height = 41
    Hint = 'C'#184'c ph'#184'p bi'#213'n '#174#230'i c'#172' b'#182'n'
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvLowered
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = False
    TabOrder = 5
    DesignSize = (
      505
      41)
    object btn_assign: TSpeedButton
      Left = 43
      Top = 8
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '='
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_assignClick
    end
    object btn_exch: TSpeedButton
      Left = 298
      Top = 8
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '<->'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 8421440
      Font.Height = -19
      Font.Name = 'GCalc System Font   '
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = btn_exchClick
    end
    object btn_below: TSpeedButton
      Left = 381
      Top = 8
      Width = 33
      Height = 25
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
        AAAAAAA6AAAAAAAAAAAAAAAAAAA7AAAA6FFFAAAAAAAAAA66AAAA7AAAAAAAAAAA
        AA7AAA66666FFAAAAAAAA66AAA77A77AAAAAAAAAA7A7A666A666FAAAAAAA668A
        A7AA7AA7AAAAAAAA7A7AA66AAA66FFAAAAA66AA8A7A7A7A7AAAAAAA7A7A866FA
        AAA66FAAAA66A8AA7A7AAA7A7AAAAA7A78AA66FAAAA66FAAA668A68A7A7AAA7A
        7AAAA7A7A78A66FAAAA66FAA66AA87687A7AAA7A7AAA7A7A877866FAAAA66FA6
        6A8A68AA7A7AAA7A7AA7A78A78AAA66FFA66FF668A68A68AA7A7A7A7AA7A7A78
        A78AA666F666F66AA8A68A68A7AA7AA7A7A7A8A78A78AA66666F66A8A68A68AA
        AA77A77A7A78A78A78AAAAAA6FF668A68A68A68AAAAA7AA7A7A78A78A78AAAAA
        AA66AA8A68A68A68AAAAAA7A7A8A78A78A78AAAAA66A8A68A68A68AAAAAAA7A7
        8A78A78A78AAAAAA668A68A68A68A68AAAAA7A7A78A78A78A78AAAA66AA8A68A
        68A68A68AAA7A7A8A78A78A78A78AA66A8A68A68A68A68AAAA7A78A78A78A78A
        78AAA668AA8A68A68A68A68AA7A7AA8A78A78A78A78A66AA8AA8AA8AA8AA8AA8
        7A7A8AA8AA8AA8AA8AA8}
      NumGlyphs = 2
      OnClick = btn_belowClick
    end
    object btn_both: TSpeedButton
      Left = 413
      Top = 8
      Width = 33
      Height = 25
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        04000000000090010000120B0000120B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAFFFAAAA
        AAAAAAA6AAAAAFFFAAAAAAAAAAA7AAAFF66FFFAAAAAAAA66AAAFF77FFFAAAAAA
        AA7FAAA666666FAAAAAAA66AAAA77AA77FAAAAAAA7F8AAA6FAAA6FFAAAAA66AA
        AAA788887FFAAAAA7F8AAA66FAAA66FAAAA66AAAAA7F8FA8A7FAAAA7F8AAAA66
        FAAA66FAAA66AAAAAA7F8FA8A7FAAA7F8AAAAA66FAAA66FAA66AAAAAAA7F8FF8
        A7FAA7F8AAAAAAA6FFFF6FFA66AAAAAAAAA788887FFA7F8AAAAAAAA666666FA6
        6AAAAAAAAAA77FF77FA7F8AAAAAAAAAAA66FFF66AAAAAAAAAAAAA77FFF7F8AAA
        AAAAAAAAAAAAA66AAFFFAAAAAAAAAAAAA7F8AFFFAAAAAAAAAAAA66AFF66FFFAA
        AAAAAAAA7F8AA77FFFAAAAAAAAA66AA666666FAAAAAAAAA7F8A77AA77FAAAAAA
        AA66AAA6FAAA6FFAAAAAAA7F8AA788887FFAAAAAA66AAA66FAAA66FAAAAAA7F8
        AA7F8FA8A7FAAAAA66AAAA66FAAA66FAAAAA7F8AAA7F8FA8A7FAAAA66AAAAA66
        FAAA66FAAAA7F8AAAA7F8FF8A7FAAA66AAAAAAA6FFFF6FFAAA7F8AAAAAA78888
        7FFAA66AAAAAAAA666666FAAA7F8AAAAAAA77FF77FAA66AAAAAAAAAAA66FFFAA
        7F8AAAAAAAAAA77FFFAA}
      NumGlyphs = 2
      OnClick = btn_bothClick
    end
    object Bevel3: TBevel
      Left = 250
      Top = 0
      Width = 3
      Height = 41
      Anchors = [akTop, akRight]
      Style = bsRaised
    end
    object Bevel2: TBevel
      Left = 367
      Top = 0
      Width = 3
      Height = 41
      Anchors = [akTop, akRight]
      Style = bsRaised
    end
    object edt_dest: TEdit
      Left = 7
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 0
    end
    object edt_src1: TLabeledEdit
      Left = 71
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      EditLabel.Width = 8
      EditLabel.Height = 16
      EditLabel.Caption = 'x'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clBlack
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Arial'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      LabelPosition = lpRight
      LabelSpacing = 1
      TabOrder = 1
    end
    object edt_src2: TLabeledEdit
      Left = 114
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      EditLabel.Width = 13
      EditLabel.Height = 19
      EditLabel.Caption = ' +'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clBlack
      EditLabel.Font.Height = -16
      EditLabel.Font.Name = 'Arial'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      LabelPosition = lpRight
      LabelSpacing = 1
      TabOrder = 2
    end
    object edt_src3: TLabeledEdit
      Left = 164
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      EditLabel.Width = 8
      EditLabel.Height = 16
      EditLabel.Caption = 'x'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clBlack
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Arial'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      LabelPosition = lpRight
      LabelSpacing = 1
      TabOrder = 3
    end
    object edt_src4: TEdit
      Left = 207
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 4
    end
    object edt_exch1: TEdit
      Left = 262
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 5
    end
    object edt_exch2: TEdit
      Left = 326
      Top = 10
      Width = 33
      Height = 21
      Anchors = [akTop, akRight]
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      TabOrder = 6
    end
  end
  object edt_pos: TEdit
    Left = 8
    Top = 308
    Width = 89
    Height = 21
    Anchors = [akLeft, akBottom]
    BevelInner = bvLowered
    BevelKind = bkFlat
    BorderStyle = bsNone
    Color = 14215660
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'GCalc System Font   '
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
  end
  object edt_det: TLabeledEdit
    Left = 356
    Top = 13
    Width = 106
    Height = 21
    Anchors = [akTop, akRight]
    BevelInner = bvLowered
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Color = 14215660
    EditLabel.Width = 8
    EditLabel.Height = 14
    EditLabel.Caption = '='
    LabelPosition = lpLeft
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    FileName = '*.mat'
    Filter = 'Matrix files (*.MAT)|*.mat|All files (*.*)|*.*'
    Left = 64
    Top = 208
  end
  object SaveDialog1: TSaveDialog
    FileName = '*.mat'
    Filter = 'Matrix files (*.MAT)|*.mat| All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 64
    Top = 160
  end
end
