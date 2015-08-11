object frmCldr: TfrmCldr
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderStyle = bsNone
  Caption = #1575#1606#1578#1582#1575#1576' '#1578#1575#1585#1740#1582' '#1607#1580#1585#1740' '#1588#1605#1587#1740
  ClientHeight = 209
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 296
    Height = 27
    Align = alTop
    TabOrder = 0
    object btnNext: TButton
      Left = 261
      Top = 1
      Width = 34
      Height = 25
      Align = alRight
      Caption = '<'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object cbbMonth: TComboBox
      AlignWithMargins = True
      Left = 157
      Top = 4
      Width = 101
      Height = 21
      Align = alRight
      TabOrder = 1
      Text = 'cbbMonth'
      OnChange = cbbMonthChange
      Items.Strings = (
        #1601#1585#1608#1585#1583#1740#1606
        #1575#1585#1583#1740#1576#1607#1588#1578
        #1582#1585#1583#1575#1583
        #1578#1740#1585
        #1605#1585#1583#1575#1583
        #1588#1607#1585#1740#1608#1585
        #1605#1607#1585
        #1570#1576#1575#1606
        #1570#1584#1585
        #1583#1740
        #1576#1607#1605#1606
        #1575#1587#1601#1606#1583)
    end
    object btnPrv: TButton
      Left = 125
      Top = 1
      Width = 29
      Height = 25
      Align = alRight
      Caption = '>'
      TabOrder = 2
      OnClick = btnPrvClick
    end
    object seYear: TSpinEdit
      Left = 0
      Top = 3
      Width = 97
      Height = 22
      MaxLength = 4
      MaxValue = 9999
      MinValue = 1
      TabOrder = 3
      Value = 1342
      OnChange = seYearChange
    end
  end
  object sgCldr: TStringGrid
    Left = 0
    Top = 27
    Width = 296
    Height = 182
    Align = alClient
    ColCount = 7
    DefaultColWidth = 40
    FixedCols = 0
    RowCount = 7
    TabOrder = 1
    OnDblClick = sgCldrDblClick
    OnDrawCell = sgCldrDrawCell
    OnKeyPress = sgCldrKeyPress
  end
end
