{------------------------------------------------------------------------------}
{              ��������� ��������� ��������������� TBPNeuroNet                 }
{                 ��������� �� ��������� ���� TBeerNeuroNet                    }
{             (����������� � ����� "���� �����" ��������� �����)               }
{                        ������������� ��������� TPNN                          }
{                              alvgor@gmail.com                                }
{------------------------------------------------------------------------------}

unit NNet;

interface

uses
  Classes;

type
  TActivationF = Function(const V : Extended) : Extended of Object;
  TActivType   = (HTan, Sigm, BSigm, ReLu);                // ���� ������������� �������
  TInitWeights = (ConstValue, Band, RandomGauss);          // ����. �����: ���������� ��������, ��������, ������������� ������
  TSinaps      = array of array of Double;                 //������ ���� �������� - ����� ����, � ��������� ���� ������������ ������ - �����


const   // �������� �� ���������
  DefaultTopology : array [0 .. 3] of Word = (15, 5, 3, 1); //15 ������, 5 �������� � ������ ����, 3 - � �������, 1 - ��������
  DefaultAlpha               = 1.0;   // �����. ���������������
  DefaultMomentum            = 0.7;   // ������� ��������
  DefaultTeachRate           = 0.07;  // �������� ��������
  DefaultActivType           = HTan;  // ������� ���������
  DefaultConstInitWeights    = 0.0;   // ���� �� ���������
  DefaultRange1InitWeights   = -0.3;  // ���� �� ���������
  DefaultRange2InitWeights   = 0.3;   // ��������� �����
  DefaultNormMeanInitWeights = 0.3;   // ���� �� ����������� �������������
  DefaultDevMeanInitWeights  = 0.1;   //
  DefaultInitWeights         = Band;  //
  DefaultRandGaussShake      = 0.01;  // ������� ��� ������������ ����
  DefaultShakePerEpoche      = 10000; // ����� ������� ���� �������� ����
  DefaultPNNSigma            = 0.1;   // ����� ����������� �������������


type
  TNeuron = class(TObject)                    // ������ ��������
  strict protected
    fBounds         : Word;
    fCountWeights   : Word;                   // ������� �����
    fSigma          : Double;                 // ��� ���������� ��������
    fBias           : Double;                 // �������� �������
    fPrevBiasUpdate : Double;                 // ���������� ���. ��������
    fNum            : byte;                   // ����� � ����
    fLevel          : byte;                   // ����� ���� ����� ����������� ������
    fOutPut         : Double;                 // �������� �������� �������
    fActivationF    : TActivationF;           // ������� ���������
    fActivationD    : TActivationF;           // ����������� ������������� �������
    function GetBounds : Word; virtual; abstract;              // ���������� ������ �������
    function GetDerive : Extended;            // �������� �����������
    procedure DeleteWeightsAndPrevUpdate; virtual; abstract;  // ������� ����� � ���������� ���������
  public
    constructor Create(const N, L : byte);// virtual;// �������� ������� N - ����� ������� � ����, L - ����� ����
    procedure Free;  //
    procedure Load(var Stream : TFileStream); virtual;
    procedure Save(var Stream : TFileStream); virtual;
    procedure SetSigma(const VSum : Double);
    procedure Shake(const V : Double); dynamic; abstract;      // ����������� ���������
    procedure Calc(var DataArr : TSinaps); dynamic; abstract;  // ���������� ����������
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); virtual; abstract; // ��������� ���� ���������� ������� � �������������� ������
    procedure InitWeightsConst(const Value : Double);  virtual; abstract;                // ��������� ���� ������������ ���������
    procedure InitWeightsBand(const ValueLo, ValueHi : Double);  virtual; abstract;      // ��������� ���� ���������� ���������� � ��������
    property Bounds : Word read GetBounds;
    property ActivationF : TActivationF write fActivationF;
    property ActivationD : TActivationF write fActivationD;
    property Sigma : Double read fSigma;
  end;


  TNeuronBP = class(TNeuron) // ������ ��� ���� ��������� ���������������
  strict protected
    fWeights           : array of Double;                             // ������ � ������
    fPrevWeightsUpdate : array of Double;                   // ���������� ��������� �����
    procedure SetLengthWeightsAndPrevUpdate(const V : Word);
    procedure DeleteWeightsAndPrevUpdate; override;
    function GetBounds : Word; override;                                       // ���������� ������ �������
    procedure Shake(const V : Double); override;    // ����������� ���������
  public
    constructor Create(const V : Word; const N, L : byte); // virtual;  // ����������� ����� �������, ����� � ���� � ����� ����
    function GetWeight(const i : Word) : Double;           // �������� ���
    procedure Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double); // ���������� �����
    procedure Load(var Stream : TFileStream); override;
    procedure Save(var Stream : TFileStream); override;
    procedure Calc(var DataArr : TSinaps); override;        // ���������� ����������
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); override; // ��������� ���� ���������� ������� � �������������� ������
    procedure InitWeightsConst(const Value : Double); override;                // ��������� ���� ������������ ���������
    procedure InitWeightsBand(const ValueLo, ValueHi : Double); override;      // ��������� ���� ���������� ���������� � ��������
  end;


  TNeuronBeer = class(TNeuron) //������ ��� ���� �� ��������� ����. ����� ��� ���������� ����
  strict protected
    fCountArrWeights   : Word;            // ����� �������-������
    fACountWeights     : array of Word;   // ����� ����� ��� ������/������ �� �����
    fWeights           : TSinaps;         // ��������� ������ �����. ������ ����� ������ ���� �������������� �����
    fPrevWeightsUpdate : TSinaps;         // � ����. ���������
    procedure SetArrWeightsAndPrevUpdate(const V : array of Word); //������� ������� �����  ����. ���������
    procedure DeleteWeightsAndPrevUpdate; override;
    function GetBounds : Word; override;                // ���������� ������ �������
  public
    constructor Create(const V : array of Word; const N, L : byte); // virtual; //
    function GetWeight(const i, j : Word) : Double;   // �������� ���
    procedure Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double); //
    procedure Load(var Stream : TFileStream); override;
    procedure Save(var Stream : TFileStream); override;
    procedure Shake(const V : Double); override;        // ����������� ����������
    procedure Calc(var DataArr : TSinaps); override;    // ���������� ����������
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); override;
    procedure InitWeightsConst(const Value : Double); override;
    procedure InitWeightsBand(const ValueLo, ValueHi : Double); override;
  end;


  TNeuroNet = class(TObject)               // ������ �����
  private
    Neurons : array of array of TNeuron;   // ������ ��������
    fCountFrameWork      : byte;           // ����� �������-������ ����
    fAlpha               : Double;         //
    fTeachRate           : Double;         // �������� ��������
    fMomentum            : Double;         // ������� ��� ��������
    fActivType           : TActivType;     // ������� ���������
    fRandGaussShake      : Double;         // ���������� ������������� ��� ������������
    fInitWeights         : TInitWeights;   // �������� ������� ��������� �����
    fConstInitWeights    : Double;
    fRange1InitWeights   : Double;
    fRange2InitWeights   : Double;
    fNormMeanInitWeights : Double;
    fDevMeanInitWeights  : Double;
    fEpoche              : LongWord;
    fShakePerEpoche      : Word;      //������������ ���� �����  ��������� ����
    fIsShakeOn           : Boolean;   //����������� ��� �� �����������
    function TanhF(const V : Extended)  : Extended; //��������������� �������
    function TanhD(const V : Extended)  : Extended; //� ��� �����������
    function SigmaF(const V : Extended) : Extended; //������������� ������� �
    function SigmaD(const V : Extended) : Extended; //� �����������
    function BSigmaF(const V : Extended) : Extended; //���������� ������������� ������� �
    function BSigmaD(const V : Extended) : Extended; //� �����������
    function ReLuF(const V : Extended) : Extended; //ReLu ������� �
    function ReLuD(const V : Extended) : Extended; //� �����������
    procedure DeleteNeurons;
    procedure DeleteSinaps;
    procedure SetActivType(const V : TActivType);  // ������������� ������� ���������
    procedure SetInitWeights(const V : TInitWeights);
    procedure SetAlpha(const V : Double);
    procedure SetTeachRate(const V : Double);
    procedure SetMomentum(const V : Double);
    function GetNeuron(const i, j : Word): TNeuron; dynamic; // ������ � ����� ��������!!!
    function GetBounds : Word;              // ���������� ������ � ����
    function GetOutputNet : Double;      // �������� ����� ����
  public
    Sinaps    : TSinaps;             // ��������� ������ ��������
    FrameWork : array of Word;       // ����� ���� - �������� � ������ ������ ������� ���-�� ������, ����� ���-�� �������� �� �����
    property Alpha               : Double       read fAlpha               write SetAlpha;
    property TeachRate           : Double       read fTeachRate           write SetTeachRate;
    property Momentum            : Double       read fMomentum            write SetMomentum;
    property ConstInitWeights    : Double       read fConstInitWeights    write fConstInitWeights;
    property Range1InitWeights   : Double       read fRange1InitWeights   write fRange1InitWeights;
    property Range2InitWeights   : Double       read fRange2InitWeights   write fRange2InitWeights ;
    property NormMeanInitWeights : Double       read fNormMeanInitWeights write fNormMeanInitWeights;
    property DevMeanInitWeights  : Double       read fDevMeanInitWeights  write fDevMeanInitWeights;
    property ShakePerEpoche      : Word         read fShakePerEpoche      write fShakePerEpoche;
    property IsShakeOn           : boolean      read fIsShakeOn           write fIsShakeOn;
    property RandGaussShake      : Double       read fRandGaussShake      write fRandGaussShake;
    property CountFrameWork      : byte         read fCountFrameWork;
    property ActivType           : TActivType   read fActivType           write SetActivType;
    property InitWeights         : TInitWeights read fInitWeights         write SetInitWeights; //������ ��������� �����
    property  Bounds : Word read GetBounds;  // ���������� ������ � ����
    property OutputNet : Double read GetOutputNet;
    procedure SetTopology(const V : array of Word); virtual;//������������� ��������� �� ������
    constructor Create(const V : array of Word);
    function GetInputCount : Word;           //�������� ����������� ����� ����
    procedure GetData(const V : array of Double); //��������� ������ ���� �������� �������
    function  Calc : Double;
    procedure Load(var Stream : TFileStream);
    procedure Save(var Stream : TFileStream);
    procedure Shake;                         // �������� ����
    procedure Free;
  end;


  TBPNeuroNet = class(TNeuroNet)  // ���� ��������� ���������������
  private
    Neurons : array of array of TNeuronBP;  //������ ��������. ��������� ���� ��������
    function  GetNeuron(const i, j : Word): TNeuron; override;
  public
    procedure SetTopology(const V : array of Word); override; // ������������� ����� ��������� �� �������-������
    procedure Correct(const Goal : Double);  // ������������ ���� �� ��������� �������� ���� � �������� �������� Goal
  end;


  TBeerNeuroNet = class(TNeuroNet)  // ��������� �� ��������� ����
  private
    Neurons : array of array of TNeuronBeer;  //������ ��������. ��������� ���� ��������
    function GetNeuron(const i, j : Word): TNeuron; override;
  public
    procedure SetTopology(const V : array of Word); override;
    procedure Correct(const Goal : Double);  // ������������ ���� �� ��������� �������� ���� � �������� �������� Goal
  end;


  TPattern = class(TObject) // ������� ������������� ���� PNN
  private
    fSigma        : Double; // ����� ��� ����������� �������������
    fCountWeights : Word;   //
    fOutput       : Double;
    procedure SetSigma(const V : Double);
    function GetSigma : Double;
  public
    fWeights : array of Double;
    constructor Create;
    procedure AddWeight(const Weight : Double); // ��������� ���� ��� � �������
    procedure SetArrWeights(const ArrWeights : array of Double); // ������ ����� ������������� � �������, ������ ���� � ���
    procedure ClearWeights; // ������� ��� ���� � ��������
    property Sigma  : Double read GetSigma write SetSigma ; //
    property Output : Double read FOutput; // �������� ������ ��������
    function Calc(const InArr : array of Double): Double; //
    procedure Free;
    procedure Load(var Stream : TFileStream);
    procedure Save(var Stream : TFileStream);
  end;


  TPNN = class(TObject) // ������������� ����
  private
    fOutPattern   : Word;   // ����� ��������-����������
    fOutValue     : Double; // � ��� �������� ��������
    fCountPattern : Word;   // ������� ���������
  public
    fArrPattern : array of TPattern;  // ������ �������� (���������)
    constructor Create(const CountPattern : Word; const Sigma : Double);
    procedure Free;
    procedure AddPattern;  // ��������� ������� � ����� �������
    procedure SetSigmaToPattern(const SigmaVal: Double; const NumPattern : Word); // ������������� �������� ������������ �����
    procedure SetSigmaAllPattern(const SigmaVal: Double); // ������������� ���� ��������� �����
    function Calc(const InArr : array of Double): Word;   // ���������� ����� ����������� ��������
    procedure Load(var Stream: TFileStream);
    procedure Save(var Stream: TFileStream);
    procedure Mirrors(const P1, P2 : Word);     //�������� ��� ��������
    procedure MirrorsOne(const P1 : Word);      //�������� ������� �� ����� ����
    property OutPattern: Word read FOutPattern; //����� ����������
    property OutValue: Double read FOutValue;   //�������� ������ ����������
  end;


implementation

uses
  Math, SysUtils;

//////////////////////////////////TNeuron///////////////////////////////////////

constructor TNeuron.Create(const N, L : byte);  // �������� ������� N - ����� ������� � ����, L - ����� ����
begin
  inherited Create;
  fNum   := N;
  fLevel := L;
  fBias  := 1;
  fPrevBiasUpdate := 0;
end;


procedure TNeuron.Free;
begin
  DeleteWeightsAndPrevUpdate;
  ActivationF := nil;
  ActivationD := nil;
  inherited Free;
end;


function TNeuron.GetDerive : Extended;  // �������� �����������
begin
  Result := fActivationD(fOutPut);
end;


procedure TNeuron.SetSigma(const VSum : Double);
begin
  fSigma := VSum * GetDerive;
end;


procedure TNeuron.Load(var Stream: TFileStream);
begin
  Stream.ReadBuffer(fNum,   SizeOf(fNum));
  Stream.ReadBuffer(fLevel, SizeOf(fLevel));
  Stream.ReadBuffer(fBias,  SizeOf(fBias));
  Stream.ReadBuffer(fPrevBiasUpdate, SizeOf(fPrevBiasUpdate));
end;


procedure TNeuron.Save(var Stream: TFileStream);
begin
  Stream.WriteBuffer(fNum,   SizeOf(fNum));
  Stream.WriteBuffer(fLevel, SizeOf(fLevel));
  Stream.WriteBuffer(fBias,  SizeOf(fBias));
  Stream.WriteBuffer(fPrevBiasUpdate, SizeOf(fPrevBiasUpdate));
end;

//////////////////////////////////TNeuronBP/////////////////////////////////////

constructor TNeuronBP.Create(const V : Word; const N, L : byte); //����������� ����� �������, ����� � ���� � ����� ����
var
  i : Word;
begin
  inherited Create(N, L);
  fCountWeights := V - 1; // ����� ������� ����� �� ���������
  SetLengthWeightsAndPrevUpdate(fCountWeights + 1);
end;


procedure TNeuronBP.SetLengthWeightsAndPrevUpdate(const V : Word);
var
  i : Word;
begin
  SetLength(fWeights, V);           // ������� ������� �����
  SetLength(fPrevWeightsUpdate, V); // � ���������� ���������
  for i := 0 to High(fWeights) do begin
    fWeights[i] := 0;
    fPrevWeightsUpdate[i] := 0
  end;
end;


procedure TNeuronBP.DeleteWeightsAndPrevUpdate;
begin
  fWeights := nil;
  fPrevWeightsUpdate := nil;
end;


procedure TNeuronBP.Calc(var DataArr : TSinaps);
var
  i   : Word;
  Sum : Double;
begin
  Sum := fBias;
  for i := 0 to fCountWeights do
    Sum := Sum + fWeights[i] * DataArr[fLevel ,i];  //���� ����
  fOutPut := fActivationF(Sum);
  DataArr[fLevel + 1, fNum] := fOutPut // �������� � ��������� ���� ��������
end;


procedure TNeuronBP.Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double);  //
var
  i  : Word;
  dW : Double;
begin
  for i := 0 to fCountWeights do begin
    dW := fSigma * fTeachRate * fSinaps[fLevel, i] + fMomentum * fPrevWeightsUpdate[i];  //���������� ���������
    fWeights[i] := fWeights[i] + dW;
    fPrevWeightsUpdate[i] := dW;
  end;
  dW := fSigma * fTeachRate + fMomentum * fPrevBiasUpdate;
  fBias := fBias + dW;
  fPrevBiasUpdate := dW;
end;


procedure TNeuronBP.InitWeightsNorm(const ValueWeigts, Deviation : Double);//����. ����� ���������� �� ������������� ������
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := RandG(ValueWeigts, Deviation);
end;


procedure TNeuronBP.InitWeightsConst(const Value : Double); //����. ����������
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := Value;
end;


procedure TNeuronBP.InitWeightsBand(const ValueLo, ValueHi : Double); //����. ���������� � ���������
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := RandomRange(Ceil(ValueLo * 10000), Ceil(ValueHi * 10000)) / 10000;
end;


function TNeuronBP.GetBounds : Word;           //���������� ������ �������
begin
  Result := fCountWeights
end;


procedure TNeuronBP.Load(var Stream : TFileStream);
var
  i : Word;
begin
  inherited Load(Stream);
  Stream.ReadBuffer(fCountWeights, SizeOf(fCountWeights));
  SetLengthWeightsAndPrevUpdate(fCountWeights + 1);
  for i := 0 to fCountWeights do begin
    Stream.ReadBuffer(fWeights[i], SizeOf(Double));
    Stream.ReadBuffer(fPrevWeightsUpdate[i], SizeOf(Double));
  end;
end;


procedure TNeuronBP.Save(var Stream : TFileStream);
var
  i : Word;
begin
  inherited Save(Stream);
  Stream.WriteBuffer(fCountWeights, SizeOf(fCountWeights));
  for i := 0 to fCountWeights do begin
    Stream.WriteBuffer(fWeights[i], SizeOf(Double));
    Stream.WriteBuffer(fPrevWeightsUpdate[i], SizeOf(Double));
  end;
end;


procedure TNeuronBP.Shake(const V : Double);     //����������� ���������
var
  k : Word;
begin
  for k := 0 to fCountWeights do
    fWeights[k] := RandG(fWeights[k], V);
  fBias := RandG(fBias, V);
end;


function TNeuronBP.GetWeight(const i : Word) : Double;    // �������� ���
begin
  Result := fWeights[i]
end;

////////////////////////////////TNeuroNet/////////////////////////////////////

function TNeuroNet.TanhF(const V : Extended) : Extended;  //��������������� �������
begin
  Result := TanH(V * Alpha)
end;


function TNeuroNet.TanhD(const V : Extended) : Extended; //� ��� �����������
begin
  Result := Alpha * (1 - Sqr(TanH(V)))
end;


function TNeuroNet.SigmaF(const V : Extended) : Extended; //������������� �������
begin
  Result := 1 / (1 + Exp(-Alpha * V))
end;


function TNeuroNet.SigmaD(const V : Extended) : Extended; //� �� �����������
begin
  Result := Alpha * V * (1 - V)
end;


function TNeuroNet.BSigmaF(const V : Extended) : Extended; //���������� ������������� ������� �
begin
  Result := 2 / (1 + Exp(-Alpha * V)) - 1
end;


function TNeuroNet.BSigmaD(const V : Extended) : Extended; //� �����������
begin
  Result := (1 + Alpha * V) * (1 - Alpha * V) * 0.5
end;


function TNeuroNet.ReLuF(const V : Extended) : Extended; //ReLu ������� �
begin
  Result := Log10(1 + Exp(Alpha * V));
end;


function TNeuroNet.ReLuD(const V : Extended) : Extended; //� �����������
begin
  Result := 1/(1 + Exp(-Alpha * V));
end;


procedure TNeuroNet.DeleteNeurons;
var
  i, j : Word;
begin
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      GetNeuron(i, j).Free;
  Neurons := nil;
end;


procedure TNeuroNet.DeleteSinaps;
var
  i : Word;
begin
  for i := 0 to fCountFrameWork - 1 do              // ������ �������� � ������ �� �����
    SetLength(Sinaps[i], 0);
  Sinaps := nil;
end;


procedure TNeuroNet.SetActivType(const V : TActivType); //������������� ������� ���������
var
  i, j : Word;
begin
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      case V of
        HTan : begin
          GetNeuron(i, j).ActivationF := TanhF;
          GetNeuron(i, j).ActivationD := TanhD;
        end;
        Sigm : begin
          GetNeuron(i, j).ActivationF := SigmaF;
          GetNeuron(i, j).ActivationD := SigmaD;
        end;
        BSigm : begin
          GetNeuron(i, j).ActivationF := BSigmaF;
          GetNeuron(i, j).ActivationD := BSigmaD;
        end;
      end;
end;


procedure TNeuroNet.SetInitWeights(const V : TInitWeights); //���������� ���� � ��������
var
  i, j : Word;
begin
  fInitWeights := V;
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      case fInitWeights of
        ConstValue  : GetNeuron(i, j).InitWeightsConst(fConstInitWeights);
        Band        : GetNeuron(i, j).InitWeightsBand(fRange1InitWeights, fRange2InitWeights);
        RandomGauss : GetNeuron(i, j).InitWeightsNorm(fNormMeanInitWeights, fDevMeanInitWeights);
      end;
end;


procedure TNeuroNet.SetAlpha(const V : Double);
begin
  if InRange(V, 0.001, 10) then
    FAlpha := V
  else
    FAlpha := DefaultAlpha;
end;


procedure TNeuroNet.SetTeachRate(const V : Double);
begin
  if InRange(V, 0.001, 1) then
    FTeachRate := V
  else
    FTeachRate := DefaultTeachRate
end;


procedure TNeuroNet.SetMomentum(const V : Double);
begin
  if InRange(V, 0.001, 1) then
    FMomentum := V
  else
    FMomentum := DefaultMomentum
end;


function TNeuroNet.GetNeuron(const i, j : Word): TNeuron;
begin
  Result := Neurons[i, j]
end;


function TNeuroNet.GetBounds : Word;              // ���������� ������ � ����
var
  i, j : Word;
begin
  if Sinaps = nil then
    Exit(0);
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      Result := Result + GetNeuron(i, j).Bounds;
end;


function TNeuroNet.GetOutputNet : Double;      // �������� ����� ����
begin
  Result := Sinaps[fCountFrameWork, 0]
end;


procedure TNeuroNet.SetTopology(const V : array of Word);//������ ������ ������� V - ���������� ������, ����� ���������� �������� � ������ ����
var
  i, j : Word;
begin
  SetLength(FrameWork, High(V) + 1);      // ����� ������ ����
  fCountFrameWork := High(FrameWork);
  for i := 0 to fCountFrameWork do        // ������ ������ �� �����
    FrameWork[i] := V[i];
  SetLength(Sinaps, fCountFrameWork + 1); // ����� ������� ��������
  SetLength(Sinaps[0], V[0]);             // ����������� �����
  for i := 1 to fCountFrameWork do
  begin                                   // ������ �������� � ������ �� �����
    SetLength(Sinaps[i], FrameWork[i]);
    for j := 0 to FrameWork[i] - 1 do
      Sinaps[i, j] := 0.0
  end;
end;


constructor TNeuroNet.Create(const V : array of Word);
begin
  inherited Create;
  SetTopology(V);
  fEpoche := 0;
  Alpha               := DefaultAlpha;
  Momentum            := DefaultMomentum;
  TeachRate           := DefaultTeachRate;
  ActivType           := DefaultActivType;
  ConstInitWeights    := DefaultConstInitWeights;
  Range1InitWeights   := DefaultRange1InitWeights;
  Range2InitWeights   := DefaultRange2InitWeights;
  NormMeanInitWeights := DefaultNormMeanInitWeights;
  DevMeanInitWeights  := DefaultDevMeanInitWeights;
  InitWeights         := DefaultInitWeights;
  ShakePerEpoche      := DefaultShakePerEpoche;
  IsShakeOn           := False;
  RandGaussShake      := DefaultRandGaussShake;
end;


function TNeuroNet.GetInputCount: Word; // ����������� �����
begin
  Result := FrameWork[0] - 1
end;


procedure TNeuroNet.GetData(const V : array of Double); //��������� ������ ���� �������� �������
var
  i : Word;
begin
  for i := 0 to Min(GetInputCount, High(V)) do  //�� ������������ �� ��������. ��� ��������� ������������
    Sinaps[0, i] := V[i];
end;


function TNeuroNet.Calc : Double;
var
  i, j : Word;
begin
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      GetNeuron(i, j).Calc(Sinaps);
  Result := GetOutputNet  //������������ ������ � ��������� ���� ������ ������� ������ ����
end;


procedure TNeuroNet.Load(var Stream: TFileStream);
var
  i, j : Word;
begin
  DeleteNeurons;
  DeleteSinaps;
  Stream.ReadBuffer(fCountFrameWork, SizeOf(fAlpha));
  Stream.ReadBuffer(fAlpha, SizeOf(fAlpha));
  Stream.ReadBuffer(fTeachRate, SizeOf(fTeachRate));
  Stream.ReadBuffer(fMomentum, SizeOf(fMomentum));
  Stream.ReadBuffer(fActivType, SizeOf(fActivType));
  Stream.ReadBuffer(fRandGaussShake, SizeOf(fRandGaussShake));
  Stream.ReadBuffer(fInitWeights, SizeOf(fInitWeights));
  Stream.ReadBuffer(fConstInitWeights, SizeOf(fConstInitWeights));
  Stream.ReadBuffer(fRange1InitWeights, SizeOf(fRange1InitWeights));
  Stream.ReadBuffer(fRange2InitWeights, SizeOf(fRange2InitWeights));
  Stream.ReadBuffer(fNormMeanInitWeights, SizeOf(fNormMeanInitWeights));
  Stream.ReadBuffer(fDevMeanInitWeights, SizeOf(fDevMeanInitWeights));
  Stream.ReadBuffer(fEpoche, SizeOf(fEpoche));
  Stream.ReadBuffer(fShakePerEpoche, SizeOf(fShakePerEpoche));
  Stream.ReadBuffer(fIsShakeOn, SizeOf(fIsShakeOn));
  SetLength(FrameWork, fCountFrameWork + 1);
  for i := 0 to fCountFrameWork do
    Stream.ReadBuffer(FrameWork[i], SizeOf(Word));
  SetTopology(FrameWork);
  for i := 1 to fCountFrameWork do
    for j := 0 to FrameWork[i] - 1 do
      GetNeuron(i - 1, j).Load(Stream);
  SetActivType(fActivType);
end;


procedure TNeuroNet.Save(var Stream: TFileStream);
var
  i, j : Word;
begin
  Stream.WriteBuffer(fCountFrameWork, SizeOf(fAlpha));
  Stream.WriteBuffer(fAlpha, SizeOf(fAlpha));
  Stream.WriteBuffer(fTeachRate, SizeOf(fTeachRate));
  Stream.WriteBuffer(fMomentum, SizeOf(fMomentum));
  Stream.WriteBuffer(fActivType, SizeOf(fActivType));
  Stream.WriteBuffer(fRandGaussShake, SizeOf(fRandGaussShake));
  Stream.WriteBuffer(fInitWeights, SizeOf(fInitWeights));
  Stream.WriteBuffer(fConstInitWeights, SizeOf(fConstInitWeights));
  Stream.WriteBuffer(fRange1InitWeights, SizeOf(fRange1InitWeights));
  Stream.WriteBuffer(fRange2InitWeights, SizeOf(fRange2InitWeights));
  Stream.WriteBuffer(fNormMeanInitWeights, SizeOf(fNormMeanInitWeights));
  Stream.WriteBuffer(fDevMeanInitWeights, SizeOf(fDevMeanInitWeights));
  Stream.WriteBuffer(fEpoche, SizeOf(fEpoche));
  Stream.WriteBuffer(fShakePerEpoche, SizeOf(fShakePerEpoche));
  Stream.WriteBuffer(fIsShakeOn, SizeOf(fIsShakeOn));
  for i := 0 to fCountFrameWork do
    Stream.WriteBuffer(FrameWork[i], SizeOf(Word));
  for i := 1 to fCountFrameWork do
    for j := 0 to FrameWork[i] - 1 do
      GetNeuron(i - 1, j).Save(Stream);
end;


procedure TNeuroNet.Shake;                         // �������� ����
var
  i, j : Word;
begin
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      GetNeuron(i, j).Shake(RandGaussShake);
end;


procedure TNeuroNet.Free;
begin
  DeleteNeurons;
  DeleteSinaps;
  inherited Free;
end;

////////////////////////////////TBPNeuroNet/////////////////////////////////////

procedure TBPNeuroNet.SetTopology(const V : array of Word); // ������������� ����� ��������� �� �������-������
var
  i, j : Word;
begin
  inherited SetTopology(V);
  SetLength(Neurons, fCountFrameWork);       //���-�� �����
  for i := 1 to fCountFrameWork do
  begin
    SetLength(Neurons[i - 1], FrameWork[i]); //���-�� �������� � ����
    for j := 0 to FrameWork[i] - 1 do
      Neurons[i - 1, j] := TNeuronBP.Create(FrameWork[i - 1], j, i - 1); // ���������� ���������� ����������
  end;
end;


procedure TBPNeuroNet.Correct(const Goal: Double); //������������ ���� �� ��������� �������� ���� � �������� �������� Goal
var
  i, j, k : Word;
  Sum : Double;
begin
  Neurons[fCountFrameWork - 1, 0].SetSigma(Goal - GetOutPutNet); //������ ���������� ����
  if fCountFrameWork - 1 > 0 then                 // � ���� �� ���� ����
    for i := fCountFrameWork - 2 downto 0 do      // ������ ���� ��� ���������. �������� ������ �� �����
      for j := 0 to FrameWork[i + 1] - 1 do
      begin                                       // ���������� ����
        Sum := 0;
        for k := 0 to FrameWork[i + 2] - 1 do     // ���������� ���������� ����
          Sum := Sum + GetNeuron(i + 1, k).Sigma * Neurons[i + 1, k].GetWeight(j); //����� � ��������������� ��� ����������� ���� ??????
        GetNeuron(i, j).SetSigma(Sum);            // ���������� ������ �������
      end;
  for i := 0 to fCountFrameWork - 1 do            // ������ ������. ���������� �����
    for j := 0 to FrameWork[i + 1] - 1 do
      Neurons[i, j].Adjust(Sinaps, TeachRate, Momentum);
  Inc(fEpoche);
  if fIsShakeOn then                              //������ ����� ������������
    if (fEpoche mod fShakePerEpoche) = 0 then
      Shake
end;


function TBPNeuroNet.GetNeuron(const i, j : Word): TNeuron;
begin
  Result := (Neurons[i, j] as TNeuronBP)
end;

////////////////////////////////TNeuronBeer/////////////////////////////////////

constructor TNeuronBeer.Create(const V: array of Word; const N, L: byte); // ������ ����� � ����. �������� � ����� � ����
var
  i, j : Word;
begin
  inherited Create(N, L);
  SetArrWeightsAndPrevUpdate(V);
  InitWeightsConst(DefaultConstInitWeights); // ��������� ���� ������
  for i := 0 to High(fPrevWeightsUpdate) do   // ���������� ���������� � ����
    for j := 0 to High(fPrevWeightsUpdate[i]) do
      fPrevWeightsUpdate[i, j] := 0.0;
end;


procedure TNeuronBeer.DeleteWeightsAndPrevUpdate;
begin
  fWeights := nil;
  fPrevWeightsUpdate := nil;
end;


procedure TNeuronBeer.Calc(var DataArr : TSinaps);
var
  Sum : Double;
  i, j : Word;
begin
  Sum := fBias;
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      Sum := Sum + fWeights[i, j] * DataArr[i, j];
  fOutPut := fActivationF(Sum);
  DataArr[fLevel + 1, fNum] := fOutPut      // � ��������� ���� ��������
end;


procedure TNeuronBeer.Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double); //
var
  i, j : Word;
  dW : Double;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
    begin
      dW := fSigma * fTeachRate * fSinaps[i, j] + fMomentum * fPrevWeightsUpdate[i, j];
      fWeights[i, j] := fWeights[i, j] + dW;
      fPrevWeightsUpdate[i, j] := dW;
    end;
  dW := fSigma * fTeachRate + fMomentum * fPrevBiasUpdate;
  fBias := fBias + dW;
  fPrevBiasUpdate := dW;
end;


procedure TNeuronBeer.InitWeightsBand(const ValueLo, ValueHi: Double);
var
  i, j : Word;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      fWeights[i, j] := RandomRange(Ceil(ValueLo * 10000), Ceil(ValueHi * 10000)) / 10000;
end;


procedure TNeuronBeer.InitWeightsConst(const Value: Double);
var
  i, j : Word;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      fWeights[i, j] := Value
end;


procedure TNeuronBeer.InitWeightsNorm(const ValueWeigts, Deviation: Double);
var
  i, j : Word;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      fWeights[i, j] := RandG(ValueWeigts, Deviation);
end;


function TNeuronBeer.GetBounds : word; //���������� ������ �������
var
  i : Word;
begin
  Result := 0;
  for i := 0 to High(fWeights) do
    Result := Result + High(fWeights[i]) + 1;
end;


procedure TNeuronBeer.Load(var Stream: TFileStream);
var
  i, j : Word;
begin
  inherited Load(Stream);
  Stream.ReadBuffer(fCountArrWeights, SizeOf(fCountArrWeights));
  SetLength(fACountWeights, fCountArrWeights + 1);
  for i := 0 to fCountArrWeights do
    Stream.ReadBuffer(fACountWeights[i], SizeOf(Word));
  SetArrWeightsAndPrevUpdate(fACountWeights);
  for i := 0 to High(fACountWeights) do
    for j := 0 to fACountWeights[i] - 1 do
    begin
      Stream.ReadBuffer(fWeights[i, j], SizeOf(Double));
      Stream.ReadBuffer(fPrevWeightsUpdate[i, j], SizeOf(Double));
    end;
end;


procedure TNeuronBeer.Save(var Stream: TFileStream);
var
  i, j : Word;
begin
  inherited Save(Stream);
  Stream.WriteBuffer(fCountArrWeights, SizeOf(fCountArrWeights));
  for i := 0 to fCountArrWeights do
    Stream.WriteBuffer(fACountWeights[i], SizeOf(Word));
  for i := 0 to High(fACountWeights) do
    for j := 0 to fACountWeights[i] - 1 do
    begin
      Stream.WriteBuffer(fWeights[i, j], SizeOf(Double));
      Stream.WriteBuffer(fPrevWeightsUpdate[i, j], SizeOf(Double));
    end;
end;


procedure TNeuronBeer.SetArrWeightsAndPrevUpdate(const V: array of Word);
var
  i, j : Word;
begin
  fCountArrWeights := fLevel;                          // �� ������ ����
  SetLength(fWeights, fCountArrWeights + 1);           // �����
  SetLength(fPrevWeightsUpdate, fCountArrWeights + 1); // �������� ����� � Updates
  SetLength(fACountWeights, fCountArrWeights + 1);     // ����� ������� �������� ���� �� �������
  for i := 0 to fCountArrWeights do
  begin
    SetLength(fWeights[i], V[i]);
    SetLength(fPrevWeightsUpdate[i], V[i]);
    fACountWeights[i] := V[i];
    for j := 0 to fACountWeights[i] - 1 do
    begin
      fWeights[i, j] := 0;
      fPrevWeightsUpdate[i, j] := 0;
    end;
  end;
end;


procedure TNeuronBeer.Shake(const V : Double); // ����������� ����������
var
  i, j : Word;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      fWeights[i, j] := RandG(fWeights[i, j], V);
  fBias := RandG(fBias, V);
end;


function TNeuronBeer.GetWeight(const i, j : Word) : Double; // �������� ���
begin
  Result := fWeights[i, j]
end;

////////////////////////////////TBeerNeuroNet///////////////////////////////////

procedure TBeerNeuroNet.SetTopology(const V: array of Word);
var
  i, j : Word;
begin
  inherited SetTopology(V);
  SetLength(Neurons, fCountFrameWork);
  for i := 1 to fCountFrameWork do
  begin
    SetLength(Neurons[i - 1], FrameWork[i]);
    for j := 0 to FrameWork[i] - 1 do
      Neurons[i - 1, j] := TNeuronBeer.Create(FrameWork, j, i - 1);
  end;
end;


procedure TBeerNeuroNet.Correct(const Goal : Double);
var
  i, j, k, m : Word;
  Sum : Double;
begin
  Neurons[fCountFrameWork - 1, 0].SetSigma(Goal - GetOutPutNet);
  if fCountFrameWork - 1 > 0 then
    for i := fCountFrameWork - 2 downto 0 do // ���� ��� ��������� �������� ������ �������������� ������
      for j := 0 to FrameWork[i + 1] - 1 do
      begin // ���������� ���������� � ����
        Sum := 0;
        for k := i + 1 to fCountFrameWork - 1 do //��� ���������� ���� ������� ��������
          for m := 0 to FrameWork[k + 1] - 1 do
            Sum := Sum + GetNeuron(k, m).Sigma * Neurons[k, m].GetWeight(i + 1, j);
        GetNeuron(i, j).SetSigma(Sum);
      end;
  for i := 0 to fCountFrameWork - 1 do    //������ ������ ���������� �����
    for j := 0 to FrameWork[i + 1] - 1 do
      Neurons[i, j].Adjust(Sinaps, TeachRate, Momentum);
  Inc(fEpoche);
  if fIsShakeOn then
    if (fEpoche mod fShakePerEpoche) = 0 then  //������ ����� ������������
      Shake
end;


function TBeerNeuroNet.GetNeuron(const i, j : Word): TNeuron;
begin
  Result := (Neurons[i, j] as TNeuronBeer)
end;

///////////////////////////////////TPattern/////////////////////////////////////

constructor TPattern.Create;
begin
 inherited Create;
 fCountWeights := 0;
 SetLength(fWeights, fCountWeights);
 SetSigma(DefaultPNNSigma);
end;


procedure TPattern.SetSigma(const V : Double);
begin
  fSigma := Sqr(V);
end;


function TPattern.GetSigma : Double;
begin
  Result := Sqrt(fSigma)
end;


procedure TPattern.AddWeight(const Weight : Double);
begin
  SetLength(fWeights, High(fWeights) + 2);
  fWeights[High(fWeights)] := Weight;
  fCountWeights := High(fWeights);
end;


procedure TPattern.SetArrWeights(const ArrWeights : array of Double);
var
  i : Word;
begin
  fWeights := nil;
  SetLength(fWeights, High(ArrWeights) + 1);
  for i := 0 to High(fWeights) do
    fWeights[i] := ArrWeights[i];
  fCountWeights := High(fWeights);
end;


procedure TPattern.ClearWeights;
begin
  fWeights := nil;
  fCountWeights := 0;
end;


function TPattern.Calc(const InArr : array of Double): Double;
var
  i, j : Word;
begin
  Result := 0;
  for i := 0 to High(InArr) do
    for j := 0 to fCountWeights do
      Result := Result + Exp(-Sqr(fWeights[j] - InArr[i]) / fSigma);
  fOutPut := Result;
end;


procedure TPattern.Free;
begin
  ClearWeights;
  inherited Free;
end;


procedure TPattern.Load(var Stream: TFileStream);
var
  i : Word;
begin
  Stream.ReadBuffer(fSigma, SizeOf(fSigma));
  Stream.ReadBuffer(fCountWeights, SizeOf(fCountWeights));
  SetLength(fWeights, fCountWeights + 1);
  for i := 0 to fCountWeights do
    Stream.ReadBuffer(fWeights[i], SizeOf(Double));
end;


procedure TPattern.Save(var Stream: TFileStream);
var
  i : Word;
begin
  Stream.WriteBuffer(fSigma, SizeOf(fSigma));
  Stream.WriteBuffer(fCountWeights, SizeOf(fCountWeights));
  for i := 0 to fCountWeights do
    Stream.WriteBuffer(fWeights[i], SizeOf(Double));
end;

/////////////////////////////////////TPNN///////////////////////////////////////

constructor TPNN.Create(const CountPattern : Word; const Sigma : Double);
var
  i : Word;
begin
  inherited Create;
  SetLength(fArrPattern, CountPattern);
  fCountPattern := High(fArrPattern);
  for i := 0 to fCountPattern do
  begin
    fArrPattern[i] := TPattern.Create;
    fArrPattern[i].Sigma := Sigma;
  end;
end;


procedure TPNN.Free;
var
  i : Word;
begin
  if Assigned(fArrPattern) then
  begin
    for i := 0 to fCountPattern do
      if Assigned(fArrPattern[i]) then
        FreeAndNil(fArrPattern[i]);
    SetLength(fArrPattern, 0);
  end;
  inherited Free;
end;


procedure TPNN.AddPattern;  // ��������� ������� � ����� �������
begin
  SetLength(fArrPattern, High(fArrPattern) + 2);
  fArrPattern[High(fArrPattern)] := TPattern.Create;
  fCountPattern := High(fArrPattern);
end;


procedure TPNN.SetSigmaToPattern(const SigmaVal: Double; const NumPattern : Word);
begin
  fArrPattern[NumPattern].Sigma := SigmaVal;
end;


procedure TPNN.SetSigmaAllPattern(const SigmaVal: Double);
var
  i : Word;
begin
  for i := 0 to fCountPattern do
    SetSigmaToPattern(SigmaVal, i);
end;


function TPNN.Calc(const InArr : array of Double): Word;
var
  i : Word;
  MaxValue : Double;
begin
  MaxValue := MinDouble;
  fOutPattern := 0;
  for i := 0 to fCountPattern do
  begin
    fArrPattern[i].Calc(InArr);
    if MaxValue < fArrPattern[i].Output then
    begin
      fOutPattern := i;
      MaxValue := fArrPattern[i].Output;
    end;
  end;
  Result := fOutPattern;
  fOutValue := MaxValue;
end;


procedure TPNN.Load(var Stream: TFileStream);
var
  i : Word;
begin
  Stream.ReadBuffer(fCountPattern, SizeOf(fCountPattern));
  SetLength(fArrPattern, fCountPattern + 1);
  for i := 0 to fCountPattern do
  begin
    fArrPattern[i] := TPattern.Create();
    fArrPattern[i].Load(Stream);
  end;
end;


procedure TPNN.Save(var Stream: TFileStream);
var
  i : Word;
begin
  Stream.WriteBuffer(fCountPattern, SizeOf(fCountPattern));
  for i := 0 to fCountPattern do
    fArrPattern[i].Save(Stream);
end;


procedure TPNN.Mirrors(const P1, P2 : Word);   //�������� ��� ��������
var
  i : Word;
begin
  for i := 0 to fArrPattern[P1].fCountWeights do
    fArrPattern[P2].AddWeight(-fArrPattern[P1].fWeights[i]);
  fArrPattern[P1].SetArrWeights(fArrPattern[P2].fWeights);
  for i := 0 to fArrPattern[P1].fCountWeights do
    fArrPattern[P1].fWeights[i] := -fArrPattern[P1].fWeights[i]
end;


procedure TPNN.MirrorsOne(const P1 : Word);  //�������� ������� �� ����� ����
var
  i, j : Word;
begin
  j := fArrPattern[P1].fCountWeights;
  for i := 0 to j do
    fArrPattern[P1].AddWeight(-fArrPattern[P1].fWeights[i]);
end;


end.
