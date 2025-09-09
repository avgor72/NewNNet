object Form1: TForm1
  Left = 262
  Top = 356
  Caption = 'NeuroNet'
  ClientHeight = 685
  ClientWidth = 1016
  Color = clBtnFace
  Constraints.MaxHeight = 724
  Constraints.MaxWidth = 1032
  Constraints.MinHeight = 724
  Constraints.MinWidth = 1032
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 8
    Width = 1017
    Height = 681
    ActivePage = tbSheetDiff
    TabOrder = 0
    object tbSheetDiff: TTabSheet
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103
      object spbLearnDiff: TSpeedButton
        Left = 759
        Top = 359
        Width = 58
        Height = 25
        Caption = #1054#1073#1091#1095#1077#1085#1080#1077
        OnClick = spbLearnDiffClick
      end
      object lblNoise: TLabel
        Left = 758
        Top = 323
        Width = 77
        Height = 13
        Caption = #1059#1088#1086#1074#1077#1085#1100' '#1096#1091#1084#1072':'
      end
      object chrtDiff: TChart
        Left = 3
        Top = 6
        Width = 680
        Height = 483
        BackWall.Brush.Style = bsClear
        Legend.Alignment = laTop
        Legend.Shadow.HorizSize = 0
        Legend.Shadow.VertSize = 0
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object SeriesNoiseSignal: TLineSeries
          SeriesColor = clRed
          Title = #1047#1072#1096#1091#1084#1083#1077#1085#1085#1099#1081' '#1089#1080#1075#1085#1072#1083
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object SeriesDiff: TLineSeries
          SeriesColor = clGreen
          Title = #1053#1077#1079#1072#1096#1091#1084#1083#1077#1085#1085#1072#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object SeriesResult: TLineSeries
          SeriesColor = clBlue
          Title = #1055#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103' '#1089' '#1074#1099#1093#1086#1076#1072' '#1085#1077#1081#1088#1086#1089#1077#1090#1080
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      inline FrameDiff: TFrame1
        Left = 683
        Top = 4
        Width = 324
        Height = 313
        TabOrder = 1
        ExplicitLeft = 683
        ExplicitTop = 4
        inherited GroupBox2: TGroupBox
          inherited PageControl1: TPageControl
            inherited tbsOptions: TTabSheet
              inherited gbxOption: TGroupBox
                inherited LblLevels: TLabel
                  Width = 31
                  ExplicitWidth = 31
                end
                inherited lblBounds: TLabel
                  Width = 36
                  ExplicitWidth = 36
                end
                inherited lblWeightsConst: TLabel
                  Width = 27
                  ExplicitWidth = 27
                end
                inherited LblSpeed: TLabel
                  Width = 31
                  ExplicitWidth = 31
                end
                inherited lblActivation: TLabel
                  Width = 47
                  ExplicitWidth = 47
                end
                inherited lblRnd1Weights: TLabel
                  Width = 58
                  ExplicitWidth = 58
                end
                inherited lblRnd2Weights: TLabel
                  Width = 58
                  ExplicitWidth = 58
                end
                inherited lblNormValue: TLabel
                  Width = 52
                  ExplicitWidth = 52
                end
                inherited lblNormDev: TLabel
                  Width = 45
                  ExplicitWidth = 45
                end
                inherited lblInitWeights: TLabel
                  Width = 56
                  ExplicitWidth = 56
                end
                inherited Label26: TLabel
                  Width = 56
                  ExplicitWidth = 56
                end
                inherited BitBtnCreate: TBitBtn
                  OnClick = Frame11BitBtnCreateClick
                end
                inherited ButtonLoad: TButton
                  OnClick = Frame11ButtonLoadClick
                end
                inherited edtNormValue: TEdit
                  Text = '0.3'
                end
                inherited edtNormDev: TEdit
                  Text = '0.1'
                end
              end
            end
            inherited tbsTopology: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 24
              ExplicitWidth = 292
              ExplicitHeight = 253
            end
            inherited tbsLearning: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 24
              ExplicitWidth = 292
              ExplicitHeight = 253
            end
          end
        end
      end
      object spbWorkDiff: TBitBtn
        Left = 907
        Top = 358
        Width = 58
        Height = 25
        Caption = #1056#1072#1073#1086#1090#1072
        TabOrder = 2
        OnClick = spbWorkDiffClick
      end
      object edtNoise: TEdit
        Left = 840
        Top = 320
        Width = 57
        Height = 21
        TabOrder = 3
        Text = '0.05'
      end
      object mmoInfoDiff: TMemo
        Left = 0
        Top = 496
        Width = 1001
        Height = 153
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            #1053#1072' '#1101#1090#1086#1081' '#1074#1082#1083#1072#1076#1082#1077' '#1088#1072#1079#1084#1077#1097#1077#1085' '#1087#1088#1080#1084#1077#1088' '#1088#1072#1073#1086#1090#1099' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' '#1089' '#1079#1072#1096#1091#1084#1083#1077#1085#1085#1099#1084' '#1089 +
            #1080#1075#1085#1072#1083#1086#1084'. '#1055#1088#1080' '#1086#1073#1091#1095#1077#1085#1080#1080' ('#1082#1085#1086#1087#1082#1072' "'#1054#1073#1091#1095#1077#1085#1080#1077'") '#1085#1077#1081#1088#1086#1089#1077#1090#1100' '#1087#1086#1076#1089#1090#1088#1072#1080#1074#1072#1077#1090 +
            #1089#1103' '
          
            #1087#1086' '#1088#1072#1079#1085#1086#1089#1090#1080' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1074#1099#1093#1086#1076#1072' '#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1086#1081' '#1085#1077#1079#1072#1096#1091#1084#1083#1077#1085#1085#1086#1075#1086' '#1089#1080#1075#1085#1072#1083#1072 +
            '.'
          
            #1043#1088#1072#1092#1080#1082' '#1086#1073#1091#1095#1077#1085#1080#1103' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' '#1084#1086#1078#1085#1086' '#1087#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1085#1072' '#1074#1082#1083#1072#1076#1082#1077' "Learning"' +
            ' '#1075#1088#1091#1087#1087#1099' NeuroBPNet.'
          
            #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1082#1085#1086#1087#1082#1080' "'#1056#1072#1073#1086#1090#1072'" '#1086#1073#1091#1095#1077#1085#1085#1072#1103' '#1085#1077#1081#1088#1086#1089#1077#1090#1100' '#1073#1077#1088#1077#1090' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1091 +
            #1102' '#1080#1079' '#1079#1072#1096#1091#1084#1083#1077#1085#1085#1086#1075#1086' '#1089#1080#1075#1085#1072#1083#1072'.'
          
            #1042#1072#1088#1100#1080#1088#1091#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1093#1086#1076#1086#1074' "In", '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1083#1086#1077#1074' "Level", '#1082#1086#1083#1080#1095 +
            #1077#1089#1090#1074#1086' '#1085#1077#1081#1088#1086#1085#1086#1074' '#1074' '#1089#1083#1086#1103#1093' '#1080' '#1092#1091#1085#1082#1094#1080#1102' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1084#1086#1078#1085#1086' '#1076#1086#1073#1080#1090#1100#1089#1103' '#1088#1072#1079#1085#1086#1081 +
            ' '#1090#1086#1095#1085#1086#1089#1090#1080' '
          
            #1074#1079#1103#1090#1080#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1086#1081'. '#1057#1077#1090#1100' '#1089' '#1089#1080#1075#1084#1086#1080#1076#1072#1083#1100#1085#1086#1081' '#1092#1091#1085#1082#1094#1080#1077#1081' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1086#1073#1091#1095 +
            #1072#1077#1090#1089#1103' '#1079#1085#1072#1095#1080#1090#1077#1083#1100#1085#1086' '#1084#1077#1076#1083#1077#1085#1085#1077#1081' '#1080' '#1085#1077' '#1074#1089#1077#1075#1076#1072' '#1091#1089#1087#1077#1096#1085#1086'. '#1051#1091#1095#1096#1077' '#1074#1089#1077#1075#1086' '#1080#1089#1087 +
            #1086#1083#1100#1079#1086#1074#1072#1090#1100' '
          
            'Levels = 3 c '#1086#1073#1097#1080#1084' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086#1084' '#1089#1074#1103#1079#1077#1081' (Bounds) '#1086#1082#1086#1083#1086' 500. '#1050#1088#1086#1084#1077' ' +
            #1090#1086#1075#1086' '#1090#1072#1082#1072#1103' '#1089#1077#1090#1100'  '#1088#1072#1073#1086#1090#1072#1077#1090' '#1089' '#1076#1080#1072#1087#1072#1079#1086#1085#1086#1084' '#1074#1093#1086#1076#1085#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1086#1090' 0 '#1076#1086' ' +
            '1 '#1080' '#1076#1072#1085#1085#1086#1084' '
          
            #1089#1083#1091#1095#1072#1077' '#1090#1088#1077#1073#1091#1077#1090' '#1085#1086#1088#1084#1072#1083#1080#1079#1072#1094#1080#1080', '#1085#1086' '#1087#1088#1080' '#1091#1089#1087#1077#1096#1085#1086#1084' '#1086#1073#1091#1095#1077#1085#1080#1080' '#1086#1085#1072' '#1076#1072#1077#1090' '#1083 +
            #1091#1095#1096#1091#1102'  '#1090#1086#1095#1085#1086#1089#1090#1100' '#1085#1072' '#1087#1086#1083#1086#1078#1080#1090#1077#1083#1100#1085#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1103#1093' '#1074#1093#1086#1076#1085#1086#1081' '#1092#1091#1085#1082#1094#1080#1080'.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
    end
    object tbSheetBoolean: TTabSheet
      Caption = #1051#1086#1075#1080#1095#1077#1089#1082#1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080
      ImageIndex = 1
      object btbStartBoolean: TBitBtn
        Left = 311
        Top = 33
        Width = 106
        Height = 32
        Caption = #1055#1091#1089#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btbStartBooleanClick
      end
      object pnlLog: TPanel
        Left = 8
        Top = 9
        Width = 233
        Height = 81
        TabOrder = 1
        object spbAND: TSpeedButton
          Left = 8
          Top = 8
          Width = 65
          Height = 65
          GroupIndex = 1
          Caption = 'AND'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = spbANDClick
        end
        object spbXOR: TSpeedButton
          Left = 84
          Top = 8
          Width = 65
          Height = 65
          GroupIndex = 1
          Down = True
          Caption = 'XOR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = spbXORClick
        end
        object spbOR: TSpeedButton
          Left = 160
          Top = 8
          Width = 65
          Height = 65
          GroupIndex = 1
          Caption = 'OR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = spbORClick
        end
      end
      inline FrameBoolean: TFrame1
        Left = 529
        Top = 6
        Width = 324
        Height = 313
        TabOrder = 2
        ExplicitLeft = 529
        ExplicitTop = 6
        inherited GroupBox2: TGroupBox
          inherited PageControl1: TPageControl
            inherited tbsOptions: TTabSheet
              inherited gbxOption: TGroupBox
                inherited LblLevels: TLabel
                  Width = 31
                  ExplicitWidth = 31
                end
                inherited lblBounds: TLabel
                  Width = 36
                  ExplicitWidth = 36
                end
                inherited lblWeightsConst: TLabel
                  Width = 27
                  ExplicitWidth = 27
                end
                inherited LblSpeed: TLabel
                  Width = 31
                  ExplicitWidth = 31
                end
                inherited lblActivation: TLabel
                  Width = 47
                  ExplicitWidth = 47
                end
                inherited lblRnd1Weights: TLabel
                  Width = 58
                  ExplicitWidth = 58
                end
                inherited lblRnd2Weights: TLabel
                  Width = 58
                  ExplicitWidth = 58
                end
                inherited lblNormValue: TLabel
                  Width = 52
                  ExplicitWidth = 52
                end
                inherited lblNormDev: TLabel
                  Width = 45
                  ExplicitWidth = 45
                end
                inherited lblInitWeights: TLabel
                  Width = 56
                  ExplicitWidth = 56
                end
                inherited Label26: TLabel
                  Width = 56
                  ExplicitWidth = 56
                end
              end
            end
            inherited tbsTopology: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 24
              ExplicitWidth = 292
              ExplicitHeight = 253
            end
            inherited tbsLearning: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 24
              ExplicitWidth = 292
              ExplicitHeight = 253
            end
          end
        end
      end
      object stgResult: TStringGrid
        Left = 4
        Top = 99
        Width = 513
        Height = 161
        DefaultColWidth = 100
        DefaultRowHeight = 30
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentFont = False
        TabOrder = 3
      end
      object mmoInfoBoolean: TMemo
        Left = 3
        Top = 493
        Width = 1001
        Height = 153
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            #1053#1072' '#1101#1090#1086#1081' '#1074#1082#1083#1072#1076#1082#1077' '#1088#1072#1079#1084#1077#1097#1077#1085' '#1087#1088#1080#1084#1077#1088' '#1088#1072#1073#1086#1090#1099' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' '#1089' '#1083#1086#1075#1080#1095#1077#1089#1082#1080#1084#1080' '#1092 +
            #1091#1085#1082#1094#1080#1103#1084#1080'.'
          
            #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1082#1085#1086#1087#1082#1080' "'#1055#1091#1089#1082'" '#1085#1077#1081#1088#1086#1089#1077#1090#1100' '#1086#1073#1091#1095#1072#1077#1090#1089#1103' '#1074#1099#1087#1086#1083#1085#1103#1090#1100' '#1083#1086#1075#1080#1095#1077#1089#1082 +
            #1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080' '#1085#1072#1076' 0 '#1080' 1, '#1087#1086#1089#1083#1077' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1094#1080#1082#1083#1072' '#1086#1073#1091#1095#1077#1085#1080#1103' '#1079#1072#1087#1086#1083#1085#1103#1077#1090#1089 +
            #1103' '#1090#1072#1073#1083#1080#1094#1072' '#1089' '
          
            #1074#1093#1086#1076#1085#1099#1084#1080' '#1088#1072#1073#1086#1095#1080#1084#1080' '#1079#1085#1072#1095#1077#1085#1080#1103#1084#1080', '#1079#1085#1072#1095#1077#1085#1080#1103#1084#1080' '#1074#1099#1093#1086#1076#1072' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' '#1080' '#1086#1096#1080#1073 +
            #1082#1072#1084#1080'..'
          
            #1053#1072' '#1074#1093#1086#1076' '#1089#1077#1090#1080' '#1087#1086#1089#1090#1091#1087#1072#1077#1090' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1080' 0 '#1080' 1. '#1055#1088#1080' '#1086#1073#1091#1095#1077#1085#1080#1080' '#1085#1077#1081#1088#1086#1089#1077#1090#1100' ' +
            #1087#1086#1076#1089#1090#1088#1072#1080#1074#1072#1077#1090#1089#1103' '#1087#1086' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072#1084' '#1086#1076#1085#1086#1081' '#1080#1079' '#1090#1088#1077#1093' (AND, XOR, OR) '#1083#1086#1075#1080#1095 +
            #1077#1089#1082#1080#1093' '
          #1086#1087#1077#1088#1072#1094#1080#1081' '
          #1074#1099#1087#1086#1083#1085#1077#1085#1085#1086#1081' '#1085#1072#1076' '#1074#1093#1086#1076#1085#1086#1081' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1077#1081'.'
          
            #1043#1088#1072#1092#1080#1082' '#1086#1073#1091#1095#1077#1085#1080#1103' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' '#1084#1086#1078#1085#1086' '#1087#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1085#1072' '#1074#1082#1083#1072#1076#1082#1077' "Learning"' +
            ' '#1075#1088#1091#1087#1087#1099' NeuroBPNet.'
          
            #1053#1072' '#1101#1090#1086#1084' '#1087#1088#1080#1084#1077#1088#1077' '#1074#1080#1076#1085#1086' '#1095#1090#1086' '#1086#1076#1085#1086#1089#1083#1086#1081#1085#1072#1103' '#1085#1077#1081#1088#1086#1089#1077#1090#1100' (Levels = 1)  '#1085#1077 +
            ' '#1073#1091#1076#1077#1090' '#1089#1087#1086#1089#1086#1073#1085#1072' '#1086#1073#1091#1095#1080#1090#1089#1103' '#1074#1099#1087#1086#1083#1085#1103#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102' "XOR", '#1074' '#1090#1086' '#1074#1088#1077#1084#1103' '#1082#1072 +
            #1082' '#1089#1077#1090#1080' '#1089' '
          #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086#1084' '#1089#1083#1086#1077#1074' >=2  '#1091#1089#1087#1077#1096#1085#1086' '#1089' '#1101#1090#1080#1084' '#1089#1087#1088#1072#1074#1083#1103#1102#1090#1089#1103'.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
    end
    object tbSheetPNN: TTabSheet
      Caption = #1042#1077#1088#1086#1103#1090#1085#1086#1089#1090#1085#1072#1103' '#1089#1077#1090#1100
      ImageIndex = 2
      object lblPattern0: TLabel
        Left = 24
        Top = 24
        Width = 51
        Height = 13
        Caption = #1055#1072#1090#1090#1077#1088#1085' 0'
      end
      object lblPattern1: TLabel
        Left = 280
        Top = 24
        Width = 51
        Height = 13
        Caption = #1055#1072#1090#1090#1077#1088#1085' 1'
      end
      object lblSigma: TLabel
        Left = 496
        Top = 61
        Width = 35
        Height = 13
        Caption = #1057#1080#1075#1084#1072':'
      end
      object lblClValue: TLabel
        Left = 495
        Top = 110
        Width = 153
        Height = 13
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1094#1080#1088#1091#1077#1084#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077':'
      end
      object lblWinPattern: TLabel
        Left = 496
        Top = 152
        Width = 121
        Height = 13
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1088#1080#1085#1072#1076#1083#1077#1078#1080#1090' '
      end
      object lblValPattern: TLabel
        Left = 496
        Top = 186
        Width = 168
        Height = 13
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1090#1090#1077#1088#1085#1072' - '#1087#1086#1073#1077#1076#1080#1090#1077#1083#1103' '
      end
      object mmoInfoPNN: TMemo
        Left = 3
        Top = 493
        Width = 1001
        Height = 153
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          #1053#1072' '#1101#1090#1086#1081' '#1074#1082#1083#1072#1076#1082#1077' '#1088#1072#1079#1084#1077#1097#1077#1085' '#1087#1088#1080#1084#1077#1088' '#1074#1077#1088#1086#1103#1090#1085#1086#1089#1090#1085#1086#1081' '#1085#1077#1081#1088#1086#1089#1077#1090#1080' (PNN).'
          
            #1055#1088#1080#1084#1077#1088' '#1094#1077#1083#1080#1082#1086#1084' '#1074#1079#1103#1090' '#1080#1079' '#1082#1085#1080#1075#1080' '#1056#1086#1073#1077#1088#1090#1072' '#1050#1072#1083#1083#1072#1085#1072' "'#1054#1089#1085#1086#1074#1085#1099#1077' '#1082#1086#1085#1094#1077#1087#1094#1080#1080 +
            ' '#1085#1077#1081#1088#1086#1085#1085#1099#1093' '#1089#1077#1090#1077#1081'". '
          
            #1060#1086#1088#1084#1080#1088#1091#1102#1090#1089#1103' '#1076#1074#1072' '#1087#1072#1090#1090#1077#1088#1085#1072' '#1089' '#1085#1072#1073#1086#1088#1086#1084' '#1074#1077#1089#1086#1074'. '#1042#1099#1095#1080#1089#1083#1103#1077#1090#1089#1103'  '#1074#1077#1088#1086#1103#1090#1085#1086#1089 +
            #1090#1100' '
          #1087#1088#1080#1085#1072#1076#1083#1077#1078#1085#1086#1089#1090#1080' '#1082#1083#1072#1089#1089#1080#1092#1080#1094#1080#1088#1091#1077#1084#1086#1075#1086' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1086#1076#1085#1086#1084#1091' '#1080#1079' '#1087#1072#1090#1090#1077#1088#1085#1086#1074'.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object mmoPattern0: TMemo
        Left = 16
        Top = 48
        Width = 185
        Height = 185
        Lines.Strings = (
          '-0.2 '
          '-0.5 '
          '-0.6 '
          '-0.7'
          '-0.8 '
          '0.1')
        TabOrder = 1
      end
      object mmoPattern1: TMemo
        Left = 272
        Top = 48
        Width = 185
        Height = 185
        Lines.Strings = (
          '0.35 '
          '0.36 '
          '0.38 '
          '0.365 '
          '0.355 '
          '0.4 '
          '0.5 '
          '0.6'
          '0.7')
        TabOrder = 2
      end
      object btbStartPNN: TBitBtn
        Left = 96
        Top = 272
        Width = 75
        Height = 25
        Caption = #1055#1091#1089#1082
        TabOrder = 3
        OnClick = btbStartPNNClick
      end
      object edtSigma: TEdit
        Left = 544
        Top = 56
        Width = 73
        Height = 21
        TabOrder = 4
        Text = '0.1'
      end
      object edtClValue: TEdit
        Left = 664
        Top = 106
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '0.2'
      end
    end
  end
end
