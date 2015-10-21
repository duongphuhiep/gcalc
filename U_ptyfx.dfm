object Form_yfx: TForm_yfx
  Left = 191
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Solve equation y=f(x)'
  ClientHeight = 313
  ClientWidth = 433
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object BitBtn2: TBitBtn
    Left = 328
    Top = 88
    Width = 97
    Height = 33
    Caption = 'T'#185'm &D'#245'ng'
    Enabled = False
    TabOrder = 1
    OnClick = BitBtn2Click
    Glyph.Data = {
      F6000000424DF60000000000000076000000280000000C000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00008888008888
      0000099998099998000009F99809F9980000099F98099F98000009F99809F998
      0000099F98099F98000009F99809F9980000099F98099F98000009F99809F998
      0000099F98099F98000009F99809F9980000099F98099F98000009F99809F998
      0000099F98099F98000009999009999000000000000000000000}
  end
  object BitBtn3: TBitBtn
    Left = 328
    Top = 128
    Width = 97
    Height = 33
    Caption = '&Reset'
    TabOrder = 2
    OnClick = BitBtn3Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
      33333333333F8888883F33330000324334222222443333388F3833333388F333
      000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
      F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
      223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
      3338888300003AAAAAAA33333333333888888833333333330000333333333333
      333333333333333333FFFFFF000033333333333344444433FFFF333333888888
      00003A444333333A22222438888F333338F3333800003A2243333333A2222438
      F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
      22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
      33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
      3333333333338888883333330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn4: TBitBtn
    Left = 328
    Top = 192
    Width = 97
    Height = 33
    Caption = '&K'#213't th'#243'c'
    TabOrder = 3
    OnClick = BitBtn4Click
    Kind = bkCancel
  end
  object BitBtn1: TBitBtn
    Left = 328
    Top = 48
    Width = 97
    Height = 33
    BiDiMode = bdLeftToRight
    Caption = '&B'#190't '#174#199'u t'#221'nh'
    Default = True
    ModalResult = 1
    ParentBiDiMode = False
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      B6000000424DB600000000000000760000002800000008000000100000000100
      04000000000040000000232E0000232E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F8FFFFFF008F
      FFFF0208FFFF0A208FFF02A208FF0A2A208F02A2A2080A2A2A200AA2A2A00AAA
      AA0F0AAAA0FF0AAA0FFF0AA0FFFF0A0FFFFF00FFFFFFFFFFFFFF}
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 313
    Height = 297
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 193
      Height = 14
      Caption = 'T'#215'm nghi'#214'm g'#199'n '#174#243'ng c'#241'a ph'#173#172'ng tr'#215'nh:'
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 72
      Width = 297
      Height = 73
      Caption = 'Trong kho'#182'ng'
      TabOrder = 0
      object Label2: TLabel
        Left = 144
        Top = 32
        Width = 11
        Height = 20
        Caption = '..'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ELim1: TLabeledEdit
        Left = 24
        Top = 32
        Width = 113
        Height = 22
        EditLabel.Width = 5
        EditLabel.Height = 20
        EditLabel.Caption = '('
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -16
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        LabelPosition = lpLeft
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object ELim2: TLabeledEdit
        Left = 160
        Top = 32
        Width = 113
        Height = 22
        EditLabel.Width = 5
        EditLabel.Height = 20
        EditLabel.Caption = ')'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -16
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        LabelPosition = lpRight
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object EPhuongtrinh: TLabeledEdit
      Left = 32
      Top = 40
      Width = 249
      Height = 22
      EditLabel.Width = 20
      EditLabel.Height = 14
      EditLabel.Caption = ' = &0'
      LabelPosition = lpRight
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 152
      Width = 297
      Height = 105
      Caption = 'V'#237'i '#174#233' ch'#221'nh x'#184'c t'#221'nh theo'
      TabOrder = 2
      object RadioButton1: TRadioButton
        Left = 32
        Top = 28
        Width = 105
        Height = 17
        Caption = 'S'#232' l'#199'n '#208'p kho'#182'ng'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioButton1Click
      end
      object RadioButton2: TRadioButton
        Left = 32
        Top = 60
        Width = 49
        Height = 17
        Caption = 'Sai s'#232
        TabOrder = 2
        TabStop = True
        OnClick = RadioButton2Click
      end
      object ESoLan: TLabeledEdit
        Left = 176
        Top = 24
        Width = 89
        Height = 22
        EditLabel.Width = 26
        EditLabel.Height = 14
        EditLabel.Caption = ' =     '
        LabelPosition = lpLeft
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object ESaiSo: TLabeledEdit
        Left = 104
        Top = 56
        Width = 161
        Height = 22
        Color = 14215660
        EditLabel.Width = 17
        EditLabel.Height = 14
        EditLabel.Caption = ' =  '
        LabelPosition = lpLeft
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
      end
    end
    object ELoi: TEdit
      Left = 32
      Top = 264
      Width = 249
      Height = 22
      Color = 16772332
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 360
    Top = 232
  end
end
