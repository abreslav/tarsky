unit TestPolynoms;

interface
uses
  polynoms,
  sToPolynom,
  TestStr;


var
  TempPolynomResult,
  TempPolynomA, TempPolynomB,
  TempPolynomTrueResult : TPolynom;

implementation

const
  kAdd = 12;
  kSub = 8;
  kMult = 9;
  kModule = 2;
  kDerivative = 4;

{procedure Add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);}

type
  TestAddData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsAddData = array[1..kAdd] of TestAddData;

  TestSubData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsSubData = array[1..kSub] of TestSubData;

  TestMultData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsMultData = array[1..kMult] of TestMultData;

  TestModuleData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsModuleData = array[1..kModule] of TestModuleData;


  TestDerivativeData = array[0..2] of string;// 0: имя, 1: а, 2: истинный результат.
  TestsDerivativeData = array[1..kDerivative] of TestDerivativeData;




function TestAdd(const TestData : TestAddData) : boolean;  //true если ошибка и false если не ошибка
var
  kl : integer;
begin

  TempPolynomTrueResult := strToPolynom(testData[3]);
  TempPolynomA := strToPolynom(testData[1]);
  TempPolynomB := strToPolynom(testData[2]);
  polynoms.add(TempPolynomResult, TempPolynomA, TempPolynomB);
  kl := ComparePolynoms(TempPolynomResult, TempPolynomTrueResult);
  if kl = 0 then
    result := false
  else
    result := true;
end;

procedure TestsAdd(const TestsData : TestsAddData);
var
  i : integer;
begin
  NameProcedure('Add');

  for i := low(TestsData) to high(TestsData) do
    if TestAdd(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;


function TestSub(const TestData : TestSubData) : boolean;  //true если ошибка и false если не ошибка
var
  kl : integer;
begin

  TempPolynomTrueResult := strToPolynom(testData[3]);
  TempPolynomA := strToPolynom(testData[1]);
  TempPolynomB := strToPolynom(testData[2]);
  polynoms.subtract(TempPolynomResult, TempPolynomA, TempPolynomB);
  kl := ComparePolynoms(TempPolynomResult, TempPolynomTrueResult);
  if kl = 0 then
    result := false
  else begin
    result := true;
    writeln(tPolynomToStr(TempPolynomA));
    writeln(tPolynomToStr(TempPolynomB));
    writeln(tPolynomToStr(TempPolynomTrueResult));
    writeln(tPolynomToStr(TempPolynomResult));
    writeln;
  end;
end;

procedure TestsSub(const TestsData : TestsSubData);
var
  i : integer;
begin
  NameProcedure('Subtract');

  for i := low(TestsData) to high(TestsData) do
    if TestSub(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;

function TestMult(const TestData : TestMultData) : boolean;  //true если ошибка и false если не ошибка
var
  kl : integer;
begin

  TempPolynomTrueResult := strToPolynom(testData[3]);
  TempPolynomA := strToPolynom(testData[1]);
  TempPolynomB := strToPolynom(testData[2]);
  polynoms.mult(TempPolynomResult, TempPolynomA, TempPolynomB);
  kl := ComparePolynoms(TempPolynomResult, TempPolynomTrueResult);
  if kl = 0 then
    result := false
  else begin
    result := true;
    writeln(tPolynomToStr(TempPolynomA));
    writeln(tPolynomToStr(TempPolynomB));
    writeln(tPolynomToStr(TempPolynomTrueResult));
    writeln(tPolynomToStr(TempPolynomResult));
    writeln;
  end;
end;

procedure TestsMult(const TestsData : TestsMultData);
var
  i : integer;
begin
  NameProcedure('Mult');

  for i := low(TestsData) to high(TestsData) do
    if TestMult(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;

function TestModule(const TestData : TestModuleData) : boolean;  //true если ошибка и false если не ошибка
var
  kl : integer;
begin

  TempPolynomTrueResult := strToPolynom(testData[3]);
  TempPolynomA := strToPolynom(testData[1]);
  TempPolynomB := strToPolynom(testData[2]);
  polynoms.Module(TempPolynomResult, TempPolynomA, TempPolynomB);
  kl := ComparePolynoms(TempPolynomResult, TempPolynomTrueResult);
  if kl = 0 then
    result := false
  else
    result := true;
end;

procedure TestsModule(const TestsData : TestsModuleData);
var
  i : integer;
begin
  NameProcedure('Module');

  for i := low(TestsData) to high(TestsData) do
    if TestModule(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;

function TestDerivative(const TestData : TestDerivativeData) : boolean;  //true если ошибка и false если не ошибка
var
  kl : integer;
begin

  TempPolynomTrueResult := strToPolynom(testData[2]);
  TempPolynomA := strToPolynom(testData[1]);
  polynoms.derivative(TempPolynomResult, TempPolynomA);
  kl := ComparePolynoms(TempPolynomResult, TempPolynomTrueResult);
  if kl = 0 then
    result := false
  else begin
    result := true;
    writeln(tPolynomToStr(TempPolynomA));
    writeln(tPolynomToStr(TempPolynomTrueResult));
    writeln(tPolynomToStr(TempPolynomResult));
    writeln;
  end;
end;

procedure TestsDerivative(const TestsData : TestsDerivativeData);
var
  i : integer;
begin
  NameProcedure('Derivative');

  for i := low(TestsData) to high(TestsData) do
    if TestDerivative(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;





var
  TestsDataAdd : TestsAddData = (
  ('test1', '0 / 1 ', '3 / 1 * x + 1 / 2', '3 / 1 * x + 1 / 2'),
  ('test2', '1 / 1 * x + 12 / 7', '0 / 1', '1 / 1 * x + 12 / 7'),
  ('test3', '1 / 2', '2 / 3', '7 / 6'),
  ('test4', '5/2*x^3 + 2/1*x + 5/6', '1/2*x^3 + 3/2*x^2 ', '3/1*x^3 + 3/2*x^2 + 2/1*x + 5/6'),
  ('test5', 'BCDEEDCB / 239', 'CFA77AFC / 239', '18C8668C7 / 239'),
  ('test6', '- BCDEEDCB / 239', '- CFA77AFC / 239', '- 18C8668C7 / 239'),
  ('test7', '- 2 / 239', '10001 / 239', 'FFFF / 239'),
  ('test8', '2 / 239', '- 10001 / 239', ' - FFFF / 239'),
  ('test9', '312 / 36981 * x ^ 7 + BCDEEDCB / 239 * x^0', '- 350035 /75CD*x^7 + CFA77AFC/239', '-8FFF7/1401*x^7 + 18C8668C7 / 239'),
  ('test10', '786/65 * X^10 - 324/CDA6*X^9 + 367/CDAFF*X^5 -0/239*X^3', '-786/65*X^10 + 324/CDA6*X^9 -367/CDAFF*X^5', '0/1'),
  ('test11', '326/987*X^8 - 345 / AED*X^2 -2/239', '-76D/76*X^9 + CDAF/AF3*X^3 -3/239*X^0', '-76D/76*X^9 + 326/987*X^8+ CDAF/AF3*X^3 - 345 / AED*X^2 - 5/239'),
  ('test12', '786/65 * X^10 - 324/CDA6*X^9 + 367/CDAFF*X^5 + 7/239*X^4 -0/239*X^3', '-786/65*X^10 + 324/CDA6*X^9 -367/CDAFF*X^5 + 5/239*X^4', 'C/239*X^4 - 0/1')
  );


  TestsDataSub : TestsSubData = (
  ('test1', '1 /1 * x ^ 3 + 2/3 * x^1 + 1 /1', '2/1 *x^2 + 1/1 * x ', '1 / 1 * x ^ 3  - 2/1 * x  ^ 2 - 1 / 3 * x + 1 / 1'),
  ('test2', '1 / 1 * x ^ 5', '0 / 1', '1 / 1 * x ^ 5'),
  ('test3', '1 / 1 * x ^ 5', '1 / 1 * x ^ 5', '0 / 1'),
  ('test4', '1 / 1 * x ^ 5', ' - 1 / 1 * x ^ 5', '2 / 1 * x ^ 5'),
  ('test5', '0 / 1', '1 / 1 * x ^ 5', ' - 1 / 1 * x ^ 5'),
  ('test6', '0/1', '12/33 * x^5 + 32/89 * x^4 - 12/5 * x^1 - 1/1', '-12/33 * x^5 - 32/89 * x^4 + 12/5 * x^1 + 1/1'),
  ('test7', '-1/3 * x^2 + 1/2 * x^1', '0/1', '-1/3 * x^2 + 1/2 * x^1'),
  ('test8', '2/3', '-8/3', 'A/3')
  );





  TestsDataMult : TestsMultData = (
  ('test1', '1 / 1 * x ^ 5', '1 / 1 * x ^ 5', '1 / 1 * x ^ 10'),
  ('test2', '1 / 3 * x ^ 7', '1 / 3 * x ^ 7 + 1 / 1 * x ^ 5', '1 / 9 * x ^ 14 + 1 / 3 * x ^ 12'),
  ('test3', '1 / 3 * x ^ 7 + 1 / 1 * x ^ 5', ' 0 / 1', '0 / 1'),
  ('test4', '0 / 1' , '1 / 3 * x ^ 7 + 1 / 1 * x ^ 5', '0 / 1'),
  ('test5', '1 / 3 * x ^ 7 + 1 / 1 * x ^ 5', ' - 1 / 3 * x ^ 7 - 1 / 1 * x ^ 5', '-1/9 * x ^ 14 - 2/3 * x ^ 12 - 1 / 1 * x ^ 10 '),
  ('test6', '1/1 * x ^ 1 + 5/1', '1/1 * x ^ 1 - 5/1', '1 / 1 * x ^ 2 - 19 / 1 '),
  ('test7', '0/1', '0/1', '0/1'),
  ('test8', '1/1 * x^11', '-1/1 * x^12', '-1/1 * x^23'),
  ('test9', '1/1 * x^5 + 1/1 * x^4 + 1/1 * x^3 + 1/1 * x^2 + 1/1 * x^1 + 1/1', '1/1 * x^1 - 1 / 1', '1/1 * x^6 - 1/1')
  );





  TestsDataModule : TestsModuleData = (
  ('test1', '1/1 * x^3 + 1/1', '1/1 * x^1 + 1/1', '0/1'),
  ('test2', '1/1 * x^3 + 1/1', '-1/1 * x^1 - 1/1', '0/1')
  );

  TestsDataDerivative : TestsDerivativeData = (
  ('test1', '0/1', '0/1'),
  ('test2', '-239/895', '0/1'),
  ('test3', '-4/1 * x^10', '-28 / 1 * x^9'),
  ('test4', '239/1 * x^2 + 32/11 * x^1 - 43/76', '472 / 1 * x^1 + 32/11')
  );

begin
  NameUnit('polynom');

  TestsAdd(TestsDataAdd);
  TestsSub(TestsDataSub);
  TestsMult(TestsDataMult);
  //TestsModule(TestsDataModule);
  TestsDerivative(TestsDataDerivative);


end.
