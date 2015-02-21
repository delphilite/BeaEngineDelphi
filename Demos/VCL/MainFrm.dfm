object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'BeaEngineDelphi'
  ClientHeight = 322
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    544
    322)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 544
    Height = 322
    Align = alClient
    BevelInner = bvNone
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 430
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Disasm'
    TabOrder = 0
    OnClick = Button1Click
  end
end
