object Form2: TForm2
  Left = 949
  Top = 136
  Width = 309
  Height = 308
  Caption = 'Report'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 280
    Height = 280
    ColCount = 10
    DefaultColWidth = 20
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 135
    Top = 129
    object Refresh1: TMenuItem
      Caption = 'Refresh;'
      OnClick = Refresh1Click
    end
  end
end
