{------------------------------------------------------------------------------}
{              Нейросеть обратного распространения TBPNeuroNet                 }
{                 Нейросеть по Стаффорду Биру TBeerNeuroNet                    }
{             (Подробности в книге "Мозг фирмы" Стаффорда Бирра)               }
{                        Вероятностная нейросеть TPNN                          }
{                              alvgor@gmail.com                                }
{------------------------------------------------------------------------------}

unit NNet;

interface

uses
  Classes;

type
  TActivationF = Function(const V : Extended) : Extended of Object;
  TActivType   = (HTan, Sigm, BSigm, ReLu);                // типы активационных функций
  TInitWeights = (ConstValue, Band, RandomGauss);          // иниц. весов: конкретное значение, диапазон, распределение Гаусса
  TSinaps      = array of array of Double;                 //первый слой синапсов - входа сети, в последнем слое единственный синапс - выход


const   // значения по умолчанию
  DefaultTopology : array [0 .. 3] of Word = (15, 5, 3, 1); //15 входов, 5 нейронов в первой слое, 3 - в скрытом, 1 - выходной
  DefaultAlpha               = 1.0;   // коэфф. сигмоидальности
  DefaultMomentum            = 0.7;   // инерция обучения
  DefaultTeachRate           = 0.07;  // скорость обучения
  DefaultActivType           = HTan;  // функция активации
  DefaultConstInitWeights    = 0.0;   // веса по константе
  DefaultRange1InitWeights   = -0.3;  // веса по диапазону
  DefaultRange2InitWeights   = 0.3;   // случайных чисел
  DefaultNormMeanInitWeights = 0.3;   // веса по нормальному распределению
  DefaultDevMeanInitWeights  = 0.1;   //
  DefaultInitWeights         = Band;  //
  DefaultRandGaussShake      = 0.01;  // разброс при встряхивании сети
  DefaultShakePerEpoche      = 10000; // через сколько эпох встряска сети
  DefaultPNNSigma            = 0.1;   // сигма нормального распределения


type
  TNeuron = class(TObject)                    // предок нейронов
  strict protected
    fBounds         : Word;
    fCountWeights   : Word;                   // счетчик весов
    fSigma          : Double;                 // для вычисления поправок
    fBias           : Double;                 // смещение нейрона
    fPrevBiasUpdate : Double;                 // предыдущее изм. смещения
    fNum            : byte;                   // место в слое
    fLevel          : byte;                   // номер слоя коему принадлежит нейрон
    fOutPut         : Double;                 // выходное значение нейрона
    fActivationF    : TActivationF;           // функция активации
    fActivationD    : TActivationF;           // производная активационной функции
    function GetBounds : Word; virtual; abstract;              // количество связей нейрона
    function GetDerive : Extended;            // получить производную
    procedure DeleteWeightsAndPrevUpdate; virtual; abstract;  // очистка весов и предыдущих подстроек
  public
    constructor Create(const N, L : byte);// virtual;// создание нейрона N - номер нейрона в слое, L - номер слоя
    procedure Free;  //
    procedure Load(var Stream : TFileStream); virtual;
    procedure Save(var Stream : TFileStream); virtual;
    procedure SetSigma(const VSum : Double);
    procedure Shake(const V : Double); dynamic; abstract;      // встряхиваем нейрончик
    procedure Calc(var DataArr : TSinaps); dynamic; abstract;  // собственно вычисление
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); virtual; abstract; // заполняет веса случайными числами с распределением Гаусса
    procedure InitWeightsConst(const Value : Double);  virtual; abstract;                // заполняет веса определенным значением
    procedure InitWeightsBand(const ValueLo, ValueHi : Double);  virtual; abstract;      // заполняет веса случайными значениями в дипазоне
    property Bounds : Word read GetBounds;
    property ActivationF : TActivationF write fActivationF;
    property ActivationD : TActivationF write fActivationD;
    property Sigma : Double read fSigma;
  end;


  TNeuronBP = class(TNeuron) // нейрон для сети обратного распространения
  strict protected
    fWeights           : array of Double;                             // массив с весами
    fPrevWeightsUpdate : array of Double;                   // предыдущая коррекция весов
    procedure SetLengthWeightsAndPrevUpdate(const V : Word);
    procedure DeleteWeightsAndPrevUpdate; override;
    function GetBounds : Word; override;                                       // количество связей нейрона
    procedure Shake(const V : Double); override;    // встряхиваем нейрончик
  public
    constructor Create(const V : Word; const N, L : byte); // virtual;  // размерность входа нейрона, номер в слое и номер слоя
    function GetWeight(const i : Word) : Double;           // получить вес
    procedure Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double); // подстройка весов
    procedure Load(var Stream : TFileStream); override;
    procedure Save(var Stream : TFileStream); override;
    procedure Calc(var DataArr : TSinaps); override;        // собственно вычисление
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); override; // заполняет веса случайными числами с распределением Гаусса
    procedure InitWeightsConst(const Value : Double); override;                // заполняет веса определенным значением
    procedure InitWeightsBand(const ValueLo, ValueHi : Double); override;      // заполняет веса случайными значениями в дипазоне
  end;


  TNeuronBeer = class(TNeuron) //нейрон для сети по Стаффорду Биру. видит все предыдущие слои
  strict protected
    fCountArrWeights   : Word;            // длина массива-остова
    fACountWeights     : array of Word;   // остов весов для записи/чтения из файла
    fWeights           : TSinaps;         // двумерный массив весов. нейрон видит выхода всех предшествующих слоев
    fPrevWeightsUpdate : TSinaps;         // и пред. изменений
    procedure SetArrWeightsAndPrevUpdate(const V : array of Word); //создает массивы весов  пред. коррекций
    procedure DeleteWeightsAndPrevUpdate; override;
    function GetBounds : Word; override;                // количество связей нейрона
  public
    constructor Create(const V : array of Word; const N, L : byte); // virtual; //
    function GetWeight(const i, j : Word) : Double;   // получить вес
    procedure Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double); //
    procedure Load(var Stream : TFileStream); override;
    procedure Save(var Stream : TFileStream); override;
    procedure Shake(const V : Double); override;        // встряхиваем нейрончики
    procedure Calc(var DataArr : TSinaps); override;    // собственно вычисление
    procedure InitWeightsNorm(const ValueWeigts, Deviation : Double); override;
    procedure InitWeightsConst(const Value : Double); override;
    procedure InitWeightsBand(const ValueLo, ValueHi : Double); override;
  end;


  TNeuroNet = class(TObject)               // предок сетей
  private
    Neurons : array of array of TNeuron;   // массив нейронов
    fCountFrameWork      : byte;           // длина массива-остова сети
    fAlpha               : Double;         //
    fTeachRate           : Double;         // скорость обучения
    fMomentum            : Double;         // инерция при обучении
    fActivType           : TActivType;     // функция активации
    fRandGaussShake      : Double;         // нормальное распределение для встряхивания
    fInitWeights         : TInitWeights;   // спопособ задания начальных весов
    fConstInitWeights    : Double;
    fRange1InitWeights   : Double;
    fRange2InitWeights   : Double;
    fNormMeanInitWeights : Double;
    fDevMeanInitWeights  : Double;
    fEpoche              : LongWord;
    fShakePerEpoche      : Word;      //встряхивание сети через  несколько эпох
    fIsShakeOn           : Boolean;   //встряхивать или не встряхивать
    function TanhF(const V : Extended)  : Extended; //гиперболический тангенс
    function TanhD(const V : Extended)  : Extended; //и его производная
    function SigmaF(const V : Extended) : Extended; //сигмоидальная функция и
    function SigmaD(const V : Extended) : Extended; //её производная
    function BSigmaF(const V : Extended) : Extended; //биполярная сигмоидальная функция и
    function BSigmaD(const V : Extended) : Extended; //её производная
    function ReLuF(const V : Extended) : Extended; //ReLu функция и
    function ReLuD(const V : Extended) : Extended; //её производная
    procedure DeleteNeurons;
    procedure DeleteSinaps;
    procedure SetActivType(const V : TActivType);  // устанавливает функцию активации
    procedure SetInitWeights(const V : TInitWeights);
    procedure SetAlpha(const V : Double);
    procedure SetTeachRate(const V : Double);
    procedure SetMomentum(const V : Double);
    function GetNeuron(const i, j : Word): TNeuron; dynamic; // доступ к полям нейронов!!!
    function GetBounds : Word;              // количество связей в сети
    function GetOutputNet : Double;      // получает выход сети
  public
    Sinaps    : TSinaps;             // двумерный массив синапсов
    FrameWork : array of Word;       // остов сети - значение в первой ячейке массива кол-во входов, далее кол-во нейронов по слоям
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
    property InitWeights         : TInitWeights read fInitWeights         write SetInitWeights; //способ установки весов
    property  Bounds : Word read GetBounds;  // количество связей в сети
    property OutputNet : Double read GetOutputNet;
    procedure SetTopology(const V : array of Word); virtual;//устанавливает топологию по остову
    constructor Create(const V : array of Word);
    function GetInputCount : Word;           //получаем размерность входа сети
    procedure GetData(const V : array of Double); //заполняет входой слой синапсов данными
    function  Calc : Double;
    procedure Load(var Stream : TFileStream);
    procedure Save(var Stream : TFileStream);
    procedure Shake;                         // встряска сети
    procedure Free;
  end;


  TBPNeuroNet = class(TNeuroNet)  // сеть обратного распространения
  private
    Neurons : array of array of TNeuronBP;  //массив нейронов. перекрыли поле родителя
    function  GetNeuron(const i, j : Word): TNeuron; override;
  public
    procedure SetTopology(const V : array of Word); override; // устанавливает новую топологию по массиву-остову
    procedure Correct(const Goal : Double);  // подстраивает веса по выходному значению сети и целевому значению Goal
  end;


  TBeerNeuroNet = class(TNeuroNet)  // нейросеть по Стаффорду Биру
  private
    Neurons : array of array of TNeuronBeer;  //массив нейронов. перекрыли поле родителя
    function GetNeuron(const i, j : Word): TNeuron; override;
  public
    procedure SetTopology(const V : array of Word); override;
    procedure Correct(const Goal : Double);  // подстраивает веса по выходному значению сети и целевому значению Goal
  end;


  TPattern = class(TObject) // паттерн вероятностной сети PNN
  private
    fSigma        : Double; // сигма для нормального распределения
    fCountWeights : Word;   //
    fOutput       : Double;
    procedure SetSigma(const V : Double);
    function GetSigma : Double;
  public
    fWeights : array of Double;
    constructor Create;
    procedure AddWeight(const Weight : Double); // добавляет один вес в паттерн
    procedure SetArrWeights(const ArrWeights : array of Double); // массив весов устанавливает в паттерн, старые веса в нил
    procedure ClearWeights; // очищает все веса в паттерне
    property Sigma  : Double read GetSigma write SetSigma ; //
    property Output : Double read FOutput; // значение выхода паттерна
    function Calc(const InArr : array of Double): Double; //
    procedure Free;
    procedure Load(var Stream : TFileStream);
    procedure Save(var Stream : TFileStream);
  end;


  TPNN = class(TObject) // вероятностная сеть
  private
    fOutPattern   : Word;   // номер паттерна-победителя
    fOutValue     : Double; // и его выходное значение
    fCountPattern : Word;   // счетчик паттернов
  public
    fArrPattern : array of TPattern;  // массив образцов (паттернов)
    constructor Create(const CountPattern : Word; const Sigma : Double);
    procedure Free;
    procedure AddPattern;  // добавляет паттерн в конец массива
    procedure SetSigmaToPattern(const SigmaVal: Double; const NumPattern : Word); // устанавливает паттерну персональную сигму
    procedure SetSigmaAllPattern(const SigmaVal: Double); // устанавливает всем паттернам сигму
    function Calc(const InArr : array of Double): Word;   // возвращает номер победившего паттерна
    procedure Load(var Stream: TFileStream);
    procedure Save(var Stream: TFileStream);
    procedure Mirrors(const P1, P2 : Word);     //зеркалит два паттерна
    procedure MirrorsOne(const P1 : Word);      //зеркалит паттерн на самое себя
    property OutPattern: Word read FOutPattern; //номер победителя
    property OutValue: Double read FOutValue;   //значение выхода победителя
  end;


implementation

uses
  Math, SysUtils;

//////////////////////////////////TNeuron///////////////////////////////////////

constructor TNeuron.Create(const N, L : byte);  // создание нейрона N - номер нейрона в слое, L - номер слоя
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


function TNeuron.GetDerive : Extended;  // получить производную
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

constructor TNeuronBP.Create(const V : Word; const N, L : byte); //размерность входа нейрона, номер в слое и номер слоя
var
  i : Word;
begin
  inherited Create(N, L);
  fCountWeights := V - 1; // длина массива весов по итерациям
  SetLengthWeightsAndPrevUpdate(fCountWeights + 1);
end;


procedure TNeuronBP.SetLengthWeightsAndPrevUpdate(const V : Word);
var
  i : Word;
begin
  SetLength(fWeights, V);           // создали массивы весов
  SetLength(fPrevWeightsUpdate, V); // и предыдущих коррекций
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
    Sum := Sum + fWeights[i] * DataArr[fLevel ,i];  //свой слой
  fOutPut := fActivationF(Sum);
  DataArr[fLevel + 1, fNum] := fOutPut // записали в следующий слой синапсов
end;


procedure TNeuronBP.Adjust(const fSinaps : TSinaps; const fTeachRate, fMomentum : Double);  //
var
  i  : Word;
  dW : Double;
begin
  for i := 0 to fCountWeights do begin
    dW := fSigma * fTeachRate * fSinaps[fLevel, i] + fMomentum * fPrevWeightsUpdate[i];  //вычисление коррекции
    fWeights[i] := fWeights[i] + dW;
    fPrevWeightsUpdate[i] := dW;
  end;
  dW := fSigma * fTeachRate + fMomentum * fPrevBiasUpdate;
  fBias := fBias + dW;
  fPrevBiasUpdate := dW;
end;


procedure TNeuronBP.InitWeightsNorm(const ValueWeigts, Deviation : Double);//иниц. весов случайными по распределению Гаусса
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := RandG(ValueWeigts, Deviation);
end;


procedure TNeuronBP.InitWeightsConst(const Value : Double); //иниц. константой
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := Value;
end;


procedure TNeuronBP.InitWeightsBand(const ValueLo, ValueHi : Double); //иниц. случайными в диапазоне
var
  i : Word;
begin
  for i := 0 to fCountWeights do
    fWeights[i] := RandomRange(Ceil(ValueLo * 10000), Ceil(ValueHi * 10000)) / 10000;
end;


function TNeuronBP.GetBounds : Word;           //количество связей нейрона
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


procedure TNeuronBP.Shake(const V : Double);     //встряхиваем нейрончик
var
  k : Word;
begin
  for k := 0 to fCountWeights do
    fWeights[k] := RandG(fWeights[k], V);
  fBias := RandG(fBias, V);
end;


function TNeuronBP.GetWeight(const i : Word) : Double;    // получить вес
begin
  Result := fWeights[i]
end;

////////////////////////////////TNeuroNet/////////////////////////////////////

function TNeuroNet.TanhF(const V : Extended) : Extended;  //гиперболический тангенс
begin
  Result := TanH(V * Alpha)
end;


function TNeuroNet.TanhD(const V : Extended) : Extended; //и его производная
begin
  Result := Alpha * (1 - Sqr(TanH(V)))
end;


function TNeuroNet.SigmaF(const V : Extended) : Extended; //сигмоидальная функция
begin
  Result := 1 / (1 + Exp(-Alpha * V))
end;


function TNeuroNet.SigmaD(const V : Extended) : Extended; //и ее производная
begin
  Result := Alpha * V * (1 - V)
end;


function TNeuroNet.BSigmaF(const V : Extended) : Extended; //биполярная сигмоидальная функция и
begin
  Result := 2 / (1 + Exp(-Alpha * V)) - 1
end;


function TNeuroNet.BSigmaD(const V : Extended) : Extended; //её производная
begin
  Result := (1 + Alpha * V) * (1 - Alpha * V) * 0.5
end;


function TNeuroNet.ReLuF(const V : Extended) : Extended; //ReLu функция и
begin
  Result := Log10(1 + Exp(Alpha * V));
end;


function TNeuroNet.ReLuD(const V : Extended) : Extended; //её производная
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
  for i := 0 to fCountFrameWork - 1 do              // массив синапсов в ширину по слоям
    SetLength(Sinaps[i], 0);
  Sinaps := nil;
end;


procedure TNeuroNet.SetActivType(const V : TActivType); //устанавливает функцию активации
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


procedure TNeuroNet.SetInitWeights(const V : TInitWeights); //инициирует веса в нейронах
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


function TNeuroNet.GetBounds : Word;              // количество связей в сети
var
  i, j : Word;
begin
  if Sinaps = nil then
    Exit(0);
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      Result := Result + GetNeuron(i, j).Bounds;
end;


function TNeuroNet.GetOutputNet : Double;      // получает выход сети
begin
  Result := Sinaps[fCountFrameWork, 0]
end;


procedure TNeuroNet.SetTopology(const V : array of Word);//первая ячейка массива V - количество входов, далее количество нейронов в каждом слое
var
  i, j : Word;
begin
  SetLength(FrameWork, High(V) + 1);      // длина остова сети
  fCountFrameWork := High(FrameWork);
  for i := 0 to fCountFrameWork do        // ширины остова по слоям
    FrameWork[i] := V[i];
  SetLength(Sinaps, fCountFrameWork + 1); // длины массива синапсов
  SetLength(Sinaps[0], V[0]);             // размерность входа
  for i := 1 to fCountFrameWork do
  begin                                   // массив синапсов в ширину по слоям
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


function TNeuroNet.GetInputCount: Word; // размерность входа
begin
  Result := FrameWork[0] - 1
end;


procedure TNeuroNet.GetData(const V : array of Double); //заполняет входой слой синапсов данными
var
  i : Word;
begin
  for i := 0 to Min(GetInputCount, High(V)) do  //по минимальному из массивов. вне диапазона игнорируются
    Sinaps[0, i] := V[i];
end;


function TNeuroNet.Calc : Double;
var
  i, j : Word;
begin
  for i := 0 to fCountFrameWork - 1 do
    for j := 0 to FrameWork[i + 1] - 1 do
      GetNeuron(i, j).Calc(Sinaps);
  Result := GetOutputNet  //единственный синапс в последнем слое хранит результ работы сети
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


procedure TNeuroNet.Shake;                         // встряска сети
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

procedure TBPNeuroNet.SetTopology(const V : array of Word); // устанавливает новую топологию по массиву-остову
var
  i, j : Word;
begin
  inherited SetTopology(V);
  SetLength(Neurons, fCountFrameWork);       //кол-во слоев
  for i := 1 to fCountFrameWork do
  begin
    SetLength(Neurons[i - 1], FrameWork[i]); //кол-во нейронов в слое
    for j := 0 to FrameWork[i] - 1 do
      Neurons[i - 1, j] := TNeuronBP.Create(FrameWork[i - 1], j, i - 1); // собственно сотворение нейрончика
  end;
end;


procedure TBPNeuroNet.Correct(const Goal: Double); //подстраивает веса по выходному значению сети и целевому значению Goal
var
  i, j, k : Word;
  Sum : Double;
begin
  Neurons[fCountFrameWork - 1, 0].SetSigma(Goal - GetOutPutNet); //ошибка последнего слоя
  if fCountFrameWork - 1 > 0 then                 // в сети не один слой
    for i := fCountFrameWork - 2 downto 0 do      // ошибки слоёв без выходного. обратный проход ко входу
      for j := 0 to FrameWork[i + 1] - 1 do
      begin                                       // перебираем слой
        Sum := 0;
        for k := 0 to FrameWork[i + 2] - 1 do     // перебираем предыдущий слой
          Sum := Sum + GetNeuron(i + 1, k).Sigma * Neurons[i + 1, k].GetWeight(j); //сигма и соответствующий вес предыдущего слоя ??????
        GetNeuron(i, j).SetSigma(Sum);            // установили ошибку нейрона
      end;
  for i := 0 to fCountFrameWork - 1 do            // прямой проход. подстройка весов
    for j := 0 to FrameWork[i + 1] - 1 do
      Neurons[i, j].Adjust(Sinaps, TeachRate, Momentum);
  Inc(fEpoche);
  if fIsShakeOn then                              //пришла эпоха встряхивания
    if (fEpoche mod fShakePerEpoche) = 0 then
      Shake
end;


function TBPNeuroNet.GetNeuron(const i, j : Word): TNeuron;
begin
  Result := (Neurons[i, j] as TNeuronBP)
end;

////////////////////////////////TNeuronBeer/////////////////////////////////////

constructor TNeuronBeer.Create(const V: array of Word; const N, L: byte); // массив весов и пред. настроек и место в сети
var
  i, j : Word;
begin
  inherited Create(N, L);
  SetArrWeightsAndPrevUpdate(V);
  InitWeightsConst(DefaultConstInitWeights); // заполнили веса нулями
  for i := 0 to High(fPrevWeightsUpdate) do   // предыдущие приращения в ноль
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
  DataArr[fLevel + 1, fNum] := fOutPut      // в следующий слой синапсов
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


function TNeuronBeer.GetBounds : word; //количество связей нейрона
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
  fCountArrWeights := fLevel;                          // до своего слоя
  SetLength(fWeights, fCountArrWeights + 1);           // длины
  SetLength(fPrevWeightsUpdate, fCountArrWeights + 1); // массивов весов и Updates
  SetLength(fACountWeights, fCountArrWeights + 1);     // остов массива нейронов тоже по ячейкам
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


procedure TNeuronBeer.Shake(const V : Double); // встряхиваем нейрончики
var
  i, j : Word;
begin
  for i := 0 to High(fWeights) do
    for j := 0 to High(fWeights[i]) do
      fWeights[i, j] := RandG(fWeights[i, j], V);
  fBias := RandG(fBias, V);
end;


function TNeuronBeer.GetWeight(const i, j : Word) : Double; // получить вес
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
    for i := fCountFrameWork - 2 downto 0 do // слои без выходного обратный проход распространяем ошибку
      for j := 0 to FrameWork[i + 1] - 1 do
      begin // перебираем нейрончики в слое
        Sum := 0;
        for k := i + 1 to fCountFrameWork - 1 do //все предыдущие слои включая выходной
          for m := 0 to FrameWork[k + 1] - 1 do
            Sum := Sum + GetNeuron(k, m).Sigma * Neurons[k, m].GetWeight(i + 1, j);
        GetNeuron(i, j).SetSigma(Sum);
      end;
  for i := 0 to fCountFrameWork - 1 do    //прямой проход подстройка весов
    for j := 0 to FrameWork[i + 1] - 1 do
      Neurons[i, j].Adjust(Sinaps, TeachRate, Momentum);
  Inc(fEpoche);
  if fIsShakeOn then
    if (fEpoche mod fShakePerEpoche) = 0 then  //пришла эпоха встряхивания
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


procedure TPNN.AddPattern;  // добавляет паттерн в конец массива
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


procedure TPNN.Mirrors(const P1, P2 : Word);   //зеркалит два паттерна
var
  i : Word;
begin
  for i := 0 to fArrPattern[P1].fCountWeights do
    fArrPattern[P2].AddWeight(-fArrPattern[P1].fWeights[i]);
  fArrPattern[P1].SetArrWeights(fArrPattern[P2].fWeights);
  for i := 0 to fArrPattern[P1].fCountWeights do
    fArrPattern[P1].fWeights[i] := -fArrPattern[P1].fWeights[i]
end;


procedure TPNN.MirrorsOne(const P1 : Word);  //зеркалит паттерн на самое себя
var
  i, j : Word;
begin
  j := fArrPattern[P1].fCountWeights;
  for i := 0 to j do
    fArrPattern[P1].AddWeight(-fArrPattern[P1].fWeights[i]);
end;


end.
