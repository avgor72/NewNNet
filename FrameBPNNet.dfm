object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 324
  Height = 313
  TabOrder = 0
  object GroupBox2: TGroupBox
    Left = 7
    Top = 3
    Width = 314
    Height = 305
    Caption = 'NeuroBPNet'
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 8
      Top = 16
      Width = 300
      Height = 281
      ActivePage = tbsOptions
      TabOrder = 0
      object tbsOptions: TTabSheet
        Caption = 'Net'
        object gbxOption: TGroupBox
          Left = 2
          Top = 1
          Width = 289
          Height = 244
          Caption = 'Options'
          TabOrder = 0
          OnExit = gbxOptionExit
          object LblIn: TLabel
            Left = 3
            Top = 22
            Width = 12
            Height = 13
            Caption = 'In'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Lbl1: TLabel
            Tag = 1
            Left = 3
            Top = 43
            Width = 6
            Height = 13
            Caption = '1'
          end
          object Lbl2: TLabel
            Tag = 2
            Left = 3
            Top = 64
            Width = 9
            Height = 13
            Caption = '2 '
          end
          object Lbl3: TLabel
            Tag = 3
            Left = 3
            Top = 84
            Width = 6
            Height = 13
            Caption = '3'
          end
          object Lbl4: TLabel
            Tag = 4
            Left = 3
            Top = 103
            Width = 6
            Height = 13
            Caption = '4'
          end
          object Lbl5: TLabel
            Tag = 5
            Left = 3
            Top = 124
            Width = 6
            Height = 13
            Caption = '5'
          end
          object Lbl6: TLabel
            Tag = 6
            Left = 3
            Top = 143
            Width = 6
            Height = 13
            Caption = '6'
          end
          object Lbl7: TLabel
            Tag = 7
            Left = 3
            Top = 162
            Width = 6
            Height = 13
            Caption = '7'
          end
          object Lbl8: TLabel
            Tag = 8
            Left = 3
            Top = 181
            Width = 6
            Height = 13
            Caption = '8'
          end
          object Lbl9: TLabel
            Tag = 9
            Left = 3
            Top = 200
            Width = 6
            Height = 13
            Caption = '9'
          end
          object LblOut: TLabel
            Left = 5
            Top = 220
            Width = 36
            Height = 13
            Caption = 'Out   1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LblLevels: TLabel
            Left = 73
            Top = 15
            Width = 30
            Height = 13
            Caption = 'Levels'
          end
          object lblBounds: TLabel
            Left = 72
            Top = 84
            Width = 35
            Height = 13
            Caption = 'Bounds'
          end
          object lblWeightsConst: TLabel
            Left = 184
            Top = 98
            Width = 28
            Height = 13
            Caption = 'Const'
          end
          object LblMoment: TLabel
            Left = 70
            Top = 37
            Width = 38
            Height = 13
            Caption = 'Moment'
          end
          object LblSpeed: TLabel
            Left = 71
            Top = 62
            Width = 30
            Height = 13
            Caption = 'Speed'
          end
          object Bevel3: TBevel
            Left = 64
            Top = 11
            Width = 1
            Height = 222
            Shape = bsLeftLine
          end
          object SpeedButtonShake: TSpeedButton
            Left = 134
            Top = 151
            Width = 41
            Height = 22
            Caption = 'Shake'
            OnClick = SpeedButtonShakeClick
          end
          object Bevel1: TBevel
            Left = 180
            Top = 15
            Width = 3
            Height = 186
            Shape = bsLeftLine
          end
          object lblActivation: TLabel
            Left = 184
            Top = 10
            Width = 48
            Height = 13
            Caption = 'Activation'
          end
          object lblAlpha: TLabel
            Left = 248
            Top = 10
            Width = 27
            Height = 13
            Caption = 'Alpha'
          end
          object lblRnd1Weights: TLabel
            Left = 183
            Top = 122
            Width = 56
            Height = 13
            Caption = 'RndRange1'
          end
          object lblRnd2Weights: TLabel
            Left = 183
            Top = 145
            Width = 56
            Height = 13
            Caption = 'RndRange2'
          end
          object lblNormValue: TLabel
            Left = 183
            Top = 166
            Width = 51
            Height = 13
            Caption = 'NormValue'
          end
          object lblNormDev: TLabel
            Left = 183
            Top = 189
            Width = 44
            Height = 13
            Caption = 'NormDev'
          end
          object lblInitWeights: TLabel
            Left = 189
            Top = 52
            Width = 58
            Height = 13
            Caption = 'Init Weights'
          end
          object LblDeviation: TLabel
            Left = 72
            Top = 125
            Width = 45
            Height = 13
            Caption = 'Deviation'
          end
          object LblEpoche: TLabel
            Left = 68
            Top = 166
            Width = 54
            Height = 13
            Caption = 'Per Epoche'
          end
          object SEInLevel: TSpinEdit
            Left = 17
            Top = 19
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 1000
            MinValue = 1
            ParentFont = False
            TabOrder = 0
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE1Level: TSpinEdit
            Tag = 1
            Left = 17
            Top = 39
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 1
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE2Level: TSpinEdit
            Tag = 2
            Left = 17
            Top = 59
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 2
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE3Level: TSpinEdit
            Tag = 3
            Left = 17
            Top = 79
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 3
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE4Level: TSpinEdit
            Tag = 4
            Left = 17
            Top = 99
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 4
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE5Level: TSpinEdit
            Tag = 5
            Left = 17
            Top = 120
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 5
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE6Level: TSpinEdit
            Tag = 6
            Left = 17
            Top = 140
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 6
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE7Level: TSpinEdit
            Tag = 7
            Left = 17
            Top = 160
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 7
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE8Level: TSpinEdit
            Tag = 8
            Left = 17
            Top = 178
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 8
            Value = 8
            OnChange = SEInLevelChange
          end
          object SE9Level: TSpinEdit
            Tag = 9
            Left = 17
            Top = 197
            Width = 44
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            MaxValue = 20
            MinValue = 1
            ParentFont = False
            TabOrder = 9
            Value = 8
            OnChange = SEInLevelChange
          end
          object SpinEditLevels: TSpinEdit
            Left = 113
            Top = 10
            Width = 40
            Height = 22
            MaxValue = 10
            MinValue = 1
            TabOrder = 10
            Value = 10
            OnChange = SpinEditLevelsChange
          end
          object BitBtnCreate: TBitBtn
            Left = 69
            Top = 214
            Width = 68
            Height = 25
            Caption = 'Create'
            Kind = bkOK
            NumGlyphs = 2
            TabOrder = 11
            OnClick = BitBtnCreateClick
          end
          object BitBtnCancel: TBitBtn
            Left = 139
            Top = 214
            Width = 68
            Height = 25
            Kind = bkCancel
            NumGlyphs = 2
            TabOrder = 12
            OnClick = BitBtnCancelClick
          end
          object ButtonSave: TButton
            Left = 248
            Top = 214
            Width = 38
            Height = 25
            Caption = 'Save'
            TabOrder = 13
            OnClick = ButtonSaveClick
          end
          object ButtonLoad: TButton
            Left = 209
            Top = 214
            Width = 38
            Height = 25
            Caption = 'Load'
            TabOrder = 14
            OnClick = ButtonLoadClick
          end
          object edtWeightsConst: TEdit
            Left = 243
            Top = 95
            Width = 39
            Height = 21
            TabOrder = 15
            Text = '0.01'
          end
          object EditMoment: TEdit
            Left = 112
            Top = 34
            Width = 52
            Height = 21
            TabOrder = 16
            Text = '0.001'
            OnChange = EditMomentChange
          end
          object EditSpeed: TEdit
            Left = 112
            Top = 58
            Width = 52
            Height = 21
            TabOrder = 17
            Text = '0.01'
            OnChange = EditSpeedChange
          end
          object cbxActivation: TComboBox
            Left = 184
            Top = 25
            Width = 65
            Height = 21
            ItemIndex = 0
            TabOrder = 18
            Text = 'HTang'
            Items.Strings = (
              'HTang'
              'Sigma'
              'BSigma'
              'ReLu')
          end
          object edtAlpha: TEdit
            Left = 250
            Top = 25
            Width = 36
            Height = 21
            TabOrder = 19
            Text = '0.5'
          end
          object cbxInitWeights: TComboBox
            Left = 190
            Top = 68
            Width = 81
            Height = 21
            ItemIndex = 0
            TabOrder = 20
            Text = 'Constanta'
            OnChange = cbxInitWeightsChange
            Items.Strings = (
              'Constanta'
              'RndRange'
              'Normal')
          end
          object edtRnd1Weights: TEdit
            Left = 243
            Top = 119
            Width = 39
            Height = 21
            TabOrder = 21
            Text = '0.01'
          end
          object edtRnd2Weights: TEdit
            Left = 243
            Top = 142
            Width = 39
            Height = 21
            TabOrder = 22
            Text = '0.01'
          end
          object edtNormValue: TEdit
            Left = 243
            Top = 163
            Width = 39
            Height = 21
            TabOrder = 23
            Text = '0.01'
          end
          object edtNormDev: TEdit
            Left = 243
            Top = 186
            Width = 39
            Height = 21
            TabOrder = 24
            Text = '0.01'
          end
          object CheckBoxIsShakeOn: TCheckBox
            Left = 73
            Top = 103
            Width = 68
            Height = 17
            Caption = 'Shake On'
            TabOrder = 25
          end
          object EditDeviation: TEdit
            Left = 127
            Top = 120
            Width = 48
            Height = 21
            TabOrder = 26
            Text = '0.01'
          end
          object SpinEditPerEpoche: TSpinEdit
            Left = 69
            Top = 184
            Width = 57
            Height = 22
            Increment = 100
            MaxValue = 10000
            MinValue = 100
            TabOrder = 27
            Value = 1000
            OnChange = SpinEditLevelsChange
          end
        end
      end
      object tbsTopology: TTabSheet
        Caption = 'Topology'
        ImageIndex = 1
        object PaintBox1: TPaintBox
          Left = 1
          Top = 5
          Width = 284
          Height = 243
          OnPaint = PaintBox1Paint
        end
      end
      object tbsLearning: TTabSheet
        Caption = 'Learning'
        ImageIndex = 2
        object Chart2: TChart
          Left = 0
          Top = 1
          Width = 290
          Height = 247
          BackWall.Brush.Style = bsClear
          Legend.Visible = False
          Title.Text.Strings = (
            'TChart')
          Title.Visible = False
          View3D = False
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series2: TLineSeries
            SeriesColor = clRed
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 192
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    Left = 224
    Top = 16
  end
end
