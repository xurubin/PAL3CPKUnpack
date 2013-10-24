object Form1: TForm1
  Left = 192
  Top = 103
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'CPKFile'
  ClientHeight = 230
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 7
    Top = 28
    Width = 132
    Height = 12
    Caption = #30446#26631#30446#24405#65288#24517#39035#23384#22312#65289#65306
  end
  object Label2: TLabel
    Left = 0
    Top = 191
    Width = 334
    Height = 16
    Caption = 'Powered by Robin: xurubin@sina.com.cn'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 7
    Top = 4
    Width = 54
    Height = 12
    Caption = 'CPK'#25991#20214#65306
  end
  object Button1: TButton
    Left = 339
    Top = 187
    Width = 70
    Height = 25
    Caption = #65319#65359#65281
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 47
    Width = 409
    Height = 121
    Enabled = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 136
    Top = 23
    Width = 241
    Height = 20
    TabOrder = 2
  end
  object ProgBar1: TProgressBar
    Left = 0
    Top = 169
    Width = 409
    Height = 18
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 64
    Top = 0
    Width = 313
    Height = 20
    Enabled = False
    TabOrder = 4
  end
  object Button2: TButton
    Left = 376
    Top = 1
    Width = 33
    Height = 19
    Caption = '...'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 376
    Top = 24
    Width = 33
    Height = 19
    Caption = '...'
    TabOrder = 6
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'cpk'
    Filter = 'Cpk File|*.cpk'
    Left = 296
    Top = 48
  end
end
