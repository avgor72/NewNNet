unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TeEngine, Series, ExtCtrls, TeeProcs, Chart,
  FrameBPNNet, ComCtrls, Grids, VclTee.TeeGDIPlus;

type
  TForm1 = class(TForm)
    PageControl: TPageControl;
    tbSheetDiff: TTabSheet;
    tbSheetBoolean: TTabSheet;
    tbSheetPNN: TTabSheet;
    chrtDiff: TChart;
    SeriesNoiseSignal: TLineSeries;
    SeriesDiff: TLineSeries;
    SeriesResult: TLineSeries;
    FrameDiff: TFrame1;
    spbLearnDiff: TSpeedButton;
    spbWorkDiff: TBitBtn;
    btbStartBoolean: TBitBtn;
    pnlLog: TPanel;
    spbAND: TSpeedButton;
    spbXOR: TSpeedButton;
    spbOR: TSpeedButton;
    edtNoise: TEdit;
    lblNoise: TLabel;
    FrameBoolean: TFrame1;
    stgResult: TStringGrid;
    mmoInfoDiff: TMemo;
    mmoInfoBoolean: TMemo;
    mmoInfoPNN: TMemo;
    mmoPattern0: TMemo;
    mmoPattern1: TMemo;
    lblPattern0: TLabel;
    lblPattern1: TLabel;
    btbStartPNN: TBitBtn;
    edtSigma: TEdit;
    lblSigma: TLabel;
    edtClValue: TEdit;
    lblClValue: TLabel;
    lblWinPattern: TLabel;
    lblValPattern: TLabel;
    procedure spbWorkDiffClick(Sender: TObject);
    procedure btbStartBooleanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spbLearnDiffClick(Sender: TObject);
    procedure Frame11ButtonLoadClick(Sender: TObject);
    procedure spbANDClick(Sender: TObject);
    procedure spbXORClick(Sender: TObject);
    procedure spbORClick(Sender: TObject);
    procedure btbStartPNNClick(Sender: TObject);
    procedure Frame11BitBtnCreateClick(Sender: TObject);
  private
    fNoise : Double;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Math, NNet;


procedure TForm1.btbStartBooleanClick(Sender: TObject);
var
  i : Longword;
  a1, a2, c1 : byte;
begin
  FrameBoolean.Series2.Clear;

  for i := 0 to 10000 do
  begin
    a1 := Random(2);
    a2 := Random(2);
    if spbAND.Down then
      c1 := a1 and a2;
    if spbXOR.Down then
      c1 := a1 xor a2;
    if spbOR.Down then
      c1 := a1 or a2;
    FrameBoolean.NeuroNet.GetData([a1, a2]);
    FrameBoolean.NeuroNet.Calc;
    FrameBoolean.NeuroNet.Correct(c1);
    FrameBoolean.Series2.Add(C1 - FrameBoolean.NeuroNet.OutputNet);
  end;

  i := 1;
  for a1 := 0 to 1 do
    for a2 := 0 to 1 do
    begin
      if spbAND.Down then
        c1 := a1 and a2;
      if spbXOR.Down then
        c1 := a1 xor a2;
      if spbOR.Down then
        c1 := a1 or a2;
      stgResult.Cells[0, i] := IntToStr(a1);
      stgResult.Cells[1, i] := IntToStr(a2);
      stgResult.Cells[2, i] := IntToStr(c1);
      FrameBoolean.NeuroNet.GetData([a1, a2]);
      stgResult.Cells[3, i] := FloatToStrF(FrameBoolean.NeuroNet.Calc, ffGeneral, 6, 6);
      stgResult.Cells[4, i] := FloatToStrF(c1 - FrameBoolean.NeuroNet.OutputNet, ffGeneral, 6, 6);
      Inc(i);
    end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  //BNN := TBeerNeuroNet.
  FrameDiff.NeuroNet.SetTopology([150, 6, 5, 3, 1]);
  FrameDiff.GetPropNNet;
  FrameDiff.SetPropNNet;
  FrameBoolean.NeuroNet.SetTopology([2, 5, 3, 1]);
  FrameBoolean.GetPropNNet;
  FrameBoolean.SetPropNNet;
  stgResult.Cells[0, 0] := 'a1';
  stgResult.Cells[1, 0] := 'a2';
  stgResult.Cells[2, 0] := 'a1 XOR a2';
  stgResult.Cells[3, 0] := 'Out';
  stgResult.Cells[4, 0] := 'Error';
  edtNoise.Text := FloatToStr(0.05);
  edtSigma.Text := FloatToStr(0.1);
  edtClValue.Text := FloatToStr(0.2);
end;


procedure TForm1.spbLearnDiffClick(Sender: TObject);   //learn
var
  i, j, k : word;
  SinArr, DifArr : array of Double;
begin
  fNoise := NNetStrToFloat(edtNoise.Text);
  SetLength(SinArr, 5000);
  SetLength(DifArr, 5000);
  for i  := 0 to High(SinArr) do
    SinArr[i] := Cos(i / 200) * 0.2 + Sin(i / 75) * 0.2;// + Cos(i/30) * 0.02;
  DifArr[0] := 0;                         //производная
  for i := 1 to High(SinArr) - 1 do
    DifArr[i] := ((SinArr[i + 1] - SinArr[i - 1]) / 2) * 150;
  DifArr[High(SinArr)] := ((SinArr[High(SinArr)] - SinArr[High(SinArr) - 1]) / 2) * 150;
  for i := 0 to High(SinArr) do
    SinArr[i] := RandG(SinArr[i], fNoise);  //засрали сигнал
  FrameDiff.Series2.Clear;
  SeriesNoiseSignal.Clear;
  SeriesDiff.Clear;
  SeriesResult.Clear;
  SeriesNoiseSignal.AddArray(SinArr);
  SeriesDiff.AddArray(DifArr);
  for i := 0 to 60000 do
  begin       //собственно обучение
    j := RandomRange(0, High(SinArr) - FrameDiff.NeuroNet.GetInputCount);
    for k := 0 to FrameDiff.NeuroNet.GetInputCount do
      FrameDiff.NeuroNet.Sinaps[0, k] := SinArr[j + k];
    FrameDiff.NeuroNet.Calc;
    FrameDiff.NeuroNet.Correct(DifArr[j + FrameDiff.NeuroNet.GetInputCount]);
    FrameDiff.Series2.Add(DifArr[j + FrameDiff.NeuroNet.GetInputCount] - FrameDiff.NeuroNet.OutputNet);
  end;
  SetLength(SinArr, 0);
  SetLength(DifArr, 0);
end;


procedure TForm1.spbWorkDiffClick(Sender: TObject);   //work
var
  i, k : word;
  SinArr, DifArr : array of Double;
begin
  fNoise := NNetStrToFloat(edtNoise.Text);
  SetLength(SinArr, 5000);
  SetLength(DifArr, 5000);
  for i  := 0 to High(SinArr) do
    SinArr[i] := Sin(i / 200) * 0.2 + Cos(i / 75) * 0.2;
  DifArr[0] := 0;                                 //производная
  for i := 1 to High(SinArr) - 1 do
    DifArr[i] := ((SinArr[i + 1] - SinArr[i - 1]) / 2) * 150;
  DifArr[High(SinArr)] := ((SinArr[High(SinArr)] - SinArr[High(SinArr) - 1]) / 2) * 150;
  for i  := 0 to High(SinArr) do
    SinArr[i] := RandG(SinArr[i], fNoise);  //засрали
  SeriesNoiseSignal.Clear;
  SeriesDiff.Clear;
  SeriesResult.Clear;
  SeriesNoiseSignal.AddArray(SinArr);
  SeriesDiff.AddArray(DifArr);
  for i := 0 to FrameDiff.NeuroNet.GetInputCount do
    SeriesResult.Add(0);
  for i := 0 to High(SinArr) - FrameDiff.NeuroNet.GetInputCount do
  begin
    for k := 0 to FrameDiff.NeuroNet.GetInputCount do
      FrameDiff.NeuroNet.Sinaps[0, k] := SinArr[i + k];
    FrameDiff.NeuroNet.Calc;
    SeriesResult.Add(FrameDiff.NeuroNet.OutputNet)
  end;
  SetLength(SinArr, 0);
  SetLength(DifArr, 0);
end;


procedure TForm1.Frame11ButtonLoadClick(Sender: TObject);
begin
  FrameDiff.ButtonLoadClick(Sender);
end;


procedure TForm1.spbANDClick(Sender: TObject);
begin
  stgResult.Cells[2, 0] := 'a1 AND a2';
end;


procedure TForm1.spbXORClick(Sender: TObject);
begin
  stgResult.Cells[2, 0] := 'a1 XOR a2';
end;


procedure TForm1.spbORClick(Sender: TObject);
begin
  stgResult.Cells[2, 0] := 'a1 OR a2';
end;


procedure TForm1.btbStartPNNClick(Sender: TObject);
var
  MyPNN : TPNN;
  i : LongWord;
begin
  MyPNN := TPNN.Create(2, NNetStrToFloat(edtSigma.Text));

  for i := 0 to mmoPattern0.Lines.Capacity - 1 do
    MyPNN.fArrPattern[0].AddWeight(NNetStrToFloat(mmoPattern0.Lines.Strings[i]));

  for i := 0 to mmoPattern1.Lines.Capacity - 1 do
    MyPNN.fArrPattern[1].AddWeight(NNetStrToFloat(mmoPattern1.Lines.Strings[i]));

  MyPNN.Calc([NNetStrToFloat(edtClValue.Text)]);

  lblWinPattern.Caption := 'Зачение принадлежит ' + IntToStr(MyPNN.OutPattern) + ' паттерну';
  lblValPattern.Caption := 'Значение паттерна-победителя ' + FloatToStr(MyPnn.OutValue);
  MyPNN.Free;
end;


procedure TForm1.Frame11BitBtnCreateClick(Sender: TObject);
begin
  FrameDiff.BitBtnCreateClick(Sender);
end;


end.
