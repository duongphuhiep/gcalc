object Form_frac: TForm_frac
  Left = 327
  Top = 166
  Width = 226
  Height = 131
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Change to fraction'
  Color = 14215660
  Constraints.MaxHeight = 131
  Constraints.MinHeight = 131
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'GCalc System Font   '
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  DesignSize = (
    218
    97)
  PixelsPerInch = 96
  TextHeight = 14
  object LEdit1: TLabeledEdit
    Left = 16
    Top = 24
    Width = 186
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 74
    EditLabel.Height = 13
    EditLabel.Caption = '&Nh'#203'p s'#232' h'#247'u t'#216':'
    EditLabel.Font.Charset = ANSI_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -12
    EditLabel.Font.Name = 'VK Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 16
    Top = 56
    Width = 186
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Color = 14215660
    ReadOnly = True
    TabOrder = 1
  end
end
