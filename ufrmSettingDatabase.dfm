object frmSettingDatabase: TfrmSettingDatabase
  Left = 0
  Top = 0
  Caption = 'Setting Database'
  ClientHeight = 181
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbledtHostname: TLabeledEdit
    Left = 16
    Top = 24
    Width = 265
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'Hostname'
    TabOrder = 0
  end
  object lbledtUser: TLabeledEdit
    Left = 16
    Top = 64
    Width = 265
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'User'
    TabOrder = 1
  end
  object lbledtPassword: TLabeledEdit
    Left = 16
    Top = 104
    Width = 265
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Password'
    TabOrder = 2
  end
  object btnSimpan: TButton
    Left = 206
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Simpan'
    TabOrder = 3
    OnClick = btnSimpanClick
  end
end
