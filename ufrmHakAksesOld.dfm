object frmHakAksesOld: TfrmHakAksesOld
  Left = 228
  Top = 86
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Administrator'
  ClientHeight = 536
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    816
    536)
  PixelsPerInch = 96
  TextHeight = 13
  object NextGrid1: TNextGrid
    Left = 8
    Top = 8
    Width = 801
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    AppearanceOptions = [aoBoldTextSelection, aoHideSelection, aoIndicateSelectedCell]
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLinesColor = clSilver
    HeaderStyle = hsOldStyle
    HideScrollBar = False
    Options = [goDisableColumnMoving, goGrid, goHeader, goSelectFullRow]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnSelectCell = NextGrid1SelectCell
    object namalogin: TNxTextColumn
      Color = 16312540
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      Footer.Color = clHighlightText
      Header.Color = 16246494
      Header.Caption = 'Nama Login'
      Options = [coCanClick, coCanInput, coPublicUsing]
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
    end
    object password: TNxTextColumn
      Color = 16312540
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      Footer.Color = clHighlightText
      Header.Color = 16246494
      Header.Caption = 'Password'
      Options = [coCanClick, coCanInput, coPublicUsing]
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Visible = False
    end
    object namalengkap: TNxTextColumn
      Color = 16312540
      DefaultWidth = 702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      Footer.Color = clHighlightText
      Header.Color = 16246494
      Header.Caption = 'Nama Lengkap'
      Options = [coAutoSize, coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
      Width = 702
    end
    object akses: TNxTextColumn
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Akses'
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Visible = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 801
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Operator '
    Enabled = False
    TabOrder = 5
    DesignSize = (
      801
      97)
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 57
      Height = 13
      Caption = 'Nama Login'
    end
    object Label2: TLabel
      Left = 16
      Top = 43
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label3: TLabel
      Left = 16
      Top = 67
      Width = 73
      Height = 13
      Caption = 'Nama Lengkap'
    end
    object Edit1: TEdit
      Left = 96
      Top = 16
      Width = 81
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 96
      Top = 40
      Width = 81
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 96
      Top = 64
      Width = 200
      Height = 21
      TabOrder = 2
    end
    object btnBatal: TButton
      Left = 640
      Top = 64
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Batal'
      TabOrder = 3
      OnClick = btnBatalClick
    end
    object btnYa: TButton
      Left = 720
      Top = 64
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ya'
      TabOrder = 4
      OnClick = btnYaClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 288
    Width = 801
    Height = 241
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Wewenang '
    Enabled = False
    TabOrder = 6
    DesignSize = (
      801
      241)
    object NextGrid2: TNextGrid
      Left = 8
      Top = 16
      Width = 785
      Height = 217
      Anchors = [akLeft, akTop, akRight, akBottom]
      Options = [goGrid, goHeader]
      TabOrder = 0
      TabStop = True
      object NxTreeColumn1: TNxTreeColumn
        DefaultWidth = 200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = 'Menu'
        Options = [coCanClick, coCanInput, coDisableMoving, coPublicUsing]
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 200
      end
      object NxTextColumn1: TNxTextColumn
        DefaultWidth = 100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = 'Nama'
        Options = [coCanClick, coCanInput, coDisableMoving, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Visible = False
        Width = 100
      end
      object NxCheckBoxColumn1: TNxCheckBoxColumn
        Alignment = taCenter
        DefaultWidth = 50
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.Caption = 'Aktif'
        Options = [coCanClick, coCanInput, coDisableMoving, coEditing, coPublicUsing]
        ParentFont = False
        Position = 2
        SortType = stBoolean
        Width = 50
      end
    end
    object TreeView1: TTreeView
      Left = 392
      Top = 96
      Width = 121
      Height = 97
      Indent = 19
      TabOrder = 1
      Visible = False
    end
  end
  object btnHapus: TButton
    Left = 176
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Hapus'
    TabOrder = 3
    OnClick = btnHapusClick
  end
  object btnEdit: TButton
    Left = 96
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnTambah: TButton
    Left = 16
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Tambah'
    TabOrder = 1
    OnClick = btnTambahClick
  end
  object btnRefresh: TButton
    Left = 736
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 4
    OnClick = btnRefreshClick
  end
end
