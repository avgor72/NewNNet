unit FrameBPNNet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, Buttons,
  Spin, ComCtrls,
  NNet, VclTee.TeeGDIPlus;

type
  TFrame1 = class(TFrame)
    GroupBox2: TGroupBox;
    PageControl1: TPageControl;
    tbsOptions: TTabSheet;
    gbxOption: TGroupBox;
    LblIn: TLabel;
    Lbl1: TLabel;
    Lbl2: TLabel;
    Lbl3: TLabel;
    Lbl4: TLabel;
    Lbl5: TLabel;
    Lbl6: TLabel;
    Lbl7: TLabel;
    Lbl8: TLabel;
    Lbl9: TLabel;
    LblOut: TLabel;
    LblLevels: TLabel;
    lblBounds: TLabel;
    lblWeightsConst: TLabel;
    LblMoment: TLabel;
    LblSpeed: TLabel;
    Bevel3: TBevel;
    SpeedButtonShake: TSpeedButton;
    Bevel1: TBevel;
    SEInLevel: TSpinEdit;
    SE1Level: TSpinEdit;
    SE2Level: TSpinEdit;
    SE3Level: TSpinEdit;
    SE4Level: TSpinEdit;
    SE5Level: TSpinEdit;
    SE6Level: TSpinEdit;
    SE7Level: TSpinEdit;
    SE8Level: TSpinEdit;
    SE9Level: TSpinEdit;
    SpinEditLevels: TSpinEdit;
    BitBtnCreate: TBitBtn;
    BitBtnCancel: TBitBtn;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    edtWeightsConst: TEdit;
    EditMoment: TEdit;
    EditSpeed: TEdit;
    tbsTopology: TTabSheet;
    PaintBox1: TPaintBox;
    tbsLearning: TTabSheet;
    Chart2: TChart;
    Series2: TLineSeries;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    cbxActivation: TComboBox;
    lblActivation: TLabel;
    edtAlpha: TEdit;
    lblAlpha: TLabel;
    cbxInitWeights: TComboBox;
    lblRnd1Weights: TLabel;
    edtRnd1Weights: TEdit;
    lblRnd2Weights: TLabel;
    edtRnd2Weights: TEdit;
    lblNormValue: TLabel;
    edtNormValue: TEdit;
    lblNormDev: TLabel;
    edtNormDev: TEdit;
    lblInitWeights: TLabel;
    CheckBoxIsShakeOn: TCheckBox;
    LblDeviation: TLabel;
    EditDeviation: TEdit;
    LblEpoche: TLabel;
    SpinEditPerEpoche: TSpinEdit;
    procedure BitBtnCreateClick(Sender: TObject);
    procedure SpinEditLevelsChange(Sender: TObject);
    procedure SEInLevelChange(Sender: TObject);
    procedure SpeedButtonShakeClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure cbxInitWeightsChange(Sender: TObject);
    procedure EditMomentChange(Sender: TObject);
    procedure EditSpeedChange(Sender: TObject);
    procedure gbxOptionExit(Sender: TObject);
  private
    { Private declarations }
    ArrTopology : array of Word;
  public
    NeuroNet : TBPNeuroNet;
   //   NeuroNet : TBeerNeuroNet;
//    procedure InitialisationFrame(Param1, Param2: Integer); virtual;
  //  procedure 
    procedure GetPropNNet; // считывает настройки сети
    procedure SetPropNNet; // устанавливает настройки сети
    procedure DrawingNNet;
  end;

  function NNetStrToFloat(const AStr : string) : Double;

implementation

{$R *.dfm}

uses
  StrUtils;


function NNetStrToFloat(const AStr : string) : Double;
begin
  try
    Result := StrToFloat(AStr)
  except
    on EConvertError do
      case FormatSettings.DecimalSeparator of
        '.' :
          if Pos(',', Astr) > 0 then
            Result := StrToFloat(ReplaceStr(AStr, ',', FormatSettings.DecimalSeparator));
        ',' :
          if Pos('.', Astr) > 0 then
            Result := StrToFloat(ReplaceStr(AStr, '.', FormatSettings.DecimalSeparator));
      end;
  end;
end;

procedure TFrame1.BitBtnCreateClick(Sender: TObject);
begin
  SpinEditLevelsChange(Self);
  if Assigned(NeuroNet) then
    NeuroNet.Free;
  NeuroNet := TBPNeuroNet.Create(ArrTopology);
 // NeuroNet := TBeerNeuroNet.Create(ArrTopology);
  SetPropNNet;
end;

procedure TFrame1.DrawingNNet; //отрисовка топологии сети
var
  S : byte;
  Level, W, x, y, i, j : word;
begin
  if NeuroNet = nil then
    Exit;
  PaintBox1.Canvas.Brush.Color := clSilver;         // фон
  PaintBox1.Canvas.Rectangle(PaintBox1.ClientRect);
  S := NeuroNet.CountFrameWork + 1;                 //  длина
  Level := (PaintBox1.BoundsRect.Right - PaintBox1.BoundsRect.Left) div S;
  for i := 1 to S do
  begin
    W := (PaintBox1.BoundsRect.Bottom - PaintBox1.BoundsRect.Top) div NeuroNet.FrameWork[i - 1] + 1;
    for j := 1 to NeuroNet.FrameWork[i - 1] + 1 do
    begin
      x := Level * i - Level div 2;
      y := W * j - W div 2;
      if i = 1 then
      begin
        PaintBox1.Canvas.Brush.Color := clBlue;
        PaintBox1.Canvas.Ellipse(x - 3, y - 3, x + 3, y + 3);
        Continue;
      end
      else
      begin
        PaintBox1.Canvas.Brush.Color := clRed;
        PaintBox1.Canvas.Pie(x - 8, y - 8, x + 8, y + 8, x , y + 8,  x, y - 8);
        if i = S then
        begin
          PaintBox1.Canvas.Brush.Color := clBlue;
          PaintBox1.Canvas.Ellipse(x + 8, y - 3, x + 14, y + 3);
        end;
      end;
    end;
  end;
end;

procedure TFrame1.SEInLevelChange(Sender: TObject);
begin
  ArrTopology[(Sender as TSpinEdit).Tag] := (Sender as TSpinEdit).Value;
end;

procedure TFrame1.SpeedButtonShakeClick(Sender: TObject);
begin
  NeuroNet.Shake
end;

procedure TFrame1.SpinEditLevelsChange(Sender: TObject);
var
  i : byte;
begin
  SetLength(ArrTopology, SpinEditLevels.Value + 1);
  ArrTopology[0] := SEInLevel.Value;    //входа
  ArrTopology[High(ArrTopology)] := 1;  //выход
  for i := 1 to gbxOption.ControlCount - 1 do
    if (gbxOption.Controls[i] is TSpinEdit) or (gbxOption.Controls[i] is TLabel) then
      if gbxOption.Controls[i].Tag >= SpinEditLevels.Value then
        gbxOption.Controls[i].Enabled := False
      else
      begin
        gbxOption.Controls[i].Enabled := True;
        if (gbxOption.Controls[i] is TSpinEdit) and (gbxOption.Controls[i].Tag <= High(ArrTopology[gbxOption.Controls[i].Tag])) and (gbxOption.Controls[i].Tag > 0) then
          ArrTopology[gbxOption.Controls[i].Tag] := (gbxOption.Controls[i] as TSpinEdit).Value
      end;
end;

procedure TFrame1.ButtonLoadClick(Sender: TObject);      // load
var
  S : TFileStream;
begin
  if OpenDialog1.Execute then
  begin
    S := TFileStream.Create(OpenDialog1.FileName, fmOpenRead, fmShareExclusive);
    try
      if not Assigned(NeuroNet) then
        NeuroNet := TBPNeuroNet.Create(ArrTopology);
      NeuroNet.Load(S);
      DrawingNNet;
      GetPropNNet;
    finally
      FreeAndNil(S);
    end;
  end
end;

procedure TFrame1.ButtonSaveClick(Sender: TObject);
var
  S : TFileStream;
begin
  if SaveDialog1.Execute then
  begin
    S := TFileStream.Create(SaveDialog1.FileName, fmCreate, fmShareExclusive);
    try
      NeuroNet.Save(S);
    finally
      FreeAndNil(S);
    end;
  end;
end;

procedure TFrame1.PaintBox1Paint(Sender: TObject);
begin
  DrawingNNet;
end;

procedure TFrame1.AfterConstruction;
begin
  NeuroNet := TBPNeuroNet.Create(DefaultTopology);  //создали по умолчанию
  GetPropNNet;
end;

procedure TFrame1.BeforeDestruction;
begin
  NeuroNet.Free;
  NeuroNet := nil
end;

procedure TFrame1.GetPropNNet; // считывает фактические настройки сети из самой сети на панель
var
  i : byte;
begin
  EditMoment.Text := FloatToStr(NeuroNet.Momentum);
  EditSpeed.Text := FloatToStr(NeuroNet.TeachRate);
  edtAlpha.Text := FloatToStr(NeuroNet.Alpha);
  case NeuroNet.ActivType of
    HTan  : cbxActivation.ItemIndex := 0;
    Sigm  : cbxActivation.ItemIndex := 1;
    BSigm : cbxActivation.ItemIndex := 2;
    ReLu  : cbxActivation.ItemIndex := 3;
  end;
  lblBounds.Caption := 'Bounds: ' + IntToStr(NeuroNet.Bounds);
  SetLength(ArrTopology, High(NeuroNet.Sinaps) + 1);
  for i := 0 to High(NeuroNet.Sinaps) do
    ArrTopology[i] := High(NeuroNet.Sinaps[i]) + 1;    ////////////////////////////////////////////////
  SEInLevel.Value  := ArrTopology[0];
  for i := 1 to gbxOption.ControlCount - 1 do
    if (gbxOption.Controls[i] is TSpinEdit) and (gbxOption.Controls[i].Tag > 0) then
      if High(NeuroNet.Sinaps) - 1 >= gbxOption.Controls[i].Tag then
        (gbxOption.Controls[i] as TSpinEdit).Value := ArrTopology[gbxOption.Controls[i].Tag];
  SpinEditLevels.Value := High(ArrTopology);
  edtWeightsConst.Text := FloatToStr(NeuroNet.ConstInitWeights);
  edtRnd1Weights.Text := FloatToStr(NeuroNet.Range1InitWeights);
  edtRnd2Weights.Text := FloatToStr(NeuroNet.Range2InitWeights);
  edtNormValue.Text := FloatToStr(NeuroNet.NormMeanInitWeights);
  edtNormDev.Text := FloatToStr(NeuroNet.DevMeanInitWeights);
  case NeuroNet.InitWeights  of
    ConstValue  : cbxInitWeights.ItemIndex := 0;
    Band        : cbxInitWeights.ItemIndex := 1;
    RandomGauss : cbxInitWeights.ItemIndex := 2;
  end;
  cbxInitWeightsChange(Self);
  SpinEditPerEpoche.Value := NeuroNet.ShakePerEpoche;
  CheckBoxIsShakeOn.Checked := NeuroNet.IsShakeOn;
  EditDeviation.Text := FloatToStr(NeuroNet.RandGaussShake);
end;

procedure TFrame1.SetPropNNet; // устанавливает настройки сети кроме топологии
begin
  NeuroNet.Momentum  := NNetStrToFloat(EditMoment.Text);  //динамически менять
  NeuroNet.TeachRate := NNetStrToFloat(EditSpeed.Text);  //
  NeuroNet.Alpha     := NNetStrToFloat(edtAlpha.Text);
  case cbxActivation.ItemIndex of
    0 : NeuroNet.ActivType := HTan;
    1 : NeuroNet.ActivType := Sigm;
    2 : NeuroNet.ActivType := BSigm;
    3 : NeuroNet.ActivType := ReLu;
  end;
  SpinEditLevelsChange(Self);
  lblBounds.Caption := 'Bounds: ' + IntToStr(NeuroNet.Bounds);
  NeuroNet.ConstInitWeights    := NNetStrToFloat(edtWeightsConst.Text);
  NeuroNet.Range1InitWeights   := NNetStrToFloat(edtRnd1Weights.Text);
  NeuroNet.Range2InitWeights   := NNetStrToFloat(edtRnd2Weights.Text);
  NeuroNet.NormMeanInitWeights := NNetStrToFloat(edtNormValue.Text);
  NeuroNet.DevMeanInitWeights  := NNetStrToFloat(edtNormDev.Text);   //
  case cbxInitWeights.ItemIndex of
    0 : NeuroNet.InitWeights := ConstValue;
    1 : NeuroNet.InitWeights := Band;
    2 : NeuroNet.InitWeights := RandomGauss;
  end;
  NeuroNet.ShakePerEpoche := SpinEditPerEpoche.Value;
  NeuroNet.IsShakeOn      := CheckBoxIsShakeOn.Checked;
  NeuroNet.RandGaussShake := NNetStrToFloat(EditDeviation.Text);
end;

procedure TFrame1.BitBtnCancelClick(Sender: TObject);
begin
  GetPropNNet;
end;

procedure TFrame1.cbxInitWeightsChange(Sender: TObject);
begin
  case cbxInitWeights.ItemIndex of
    0 : begin
      lblWeightsConst.Font.Style := [fsBold];
      lblRnd1Weights.Font.Style := [];
      lblRnd2Weights.Font.Style := [];
      lblNormValue.Font.Style := [];
      lblNormDev.Font.Style := [];
    end;
    1 : begin
      lblWeightsConst.Font.Style := [];
      lblRnd1Weights.Font.Style := [fsBold];
      lblRnd2Weights.Font.Style := [fsBold];
      lblNormValue.Font.Style := [];
      lblNormDev.Font.Style := [];
    end;
    2 : begin
      lblWeightsConst.Font.Style := [];
      lblRnd1Weights.Font.Style := [];
      lblRnd2Weights.Font.Style := [];
      lblNormValue.Font.Style := [fsBold];
      lblNormDev.Font.Style := [fsBold];
    end;
  end;
end;

procedure TFrame1.EditMomentChange(Sender: TObject);
begin
  NeuroNet.Momentum := NNetStrToFloat(EditMoment.Text);  //динамически меняем
end;

procedure TFrame1.EditSpeedChange(Sender: TObject);
begin
  NeuroNet.TeachRate := NNetStrToFloat(EditSpeed.Text);  //динамически меняем
end;

procedure TFrame1.gbxOptionExit(Sender: TObject);
begin
//  GetPropNNet;
end;


end.
