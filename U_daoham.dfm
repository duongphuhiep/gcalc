object frm_daoham: Tfrm_daoham
  Left = 278
  Top = 212
  BorderStyle = bsDialog
  Caption = 'Derivative'
  ClientHeight = 186
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'ABC Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StaticText2: TStaticText
    Left = 8
    Top = 64
    Width = 56
    Height = 17
    Caption = #167#185'o h'#181'&m:'
    FocusControl = Memo2
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 8
    Width = 76
    Height = 17
    Caption = '&Ph'#173#172'ng tr'#215'nh:'
    FocusControl = Memo1
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 233
    Height = 33
    TabOrder = 0
    WantReturns = False
    OnKeyDown = Memo1KeyDown
  end
  object Memo2: TMemo
    Left = 8
    Top = 80
    Width = 233
    Height = 84
    Color = 14215660
    ReadOnly = True
    TabOrder = 1
  end
end
