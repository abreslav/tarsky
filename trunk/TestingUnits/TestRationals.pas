unit TestRationals;

interface
uses
  rationals,
  sToPolynom,
  CheckError,
  TestStr;


var
  TempRationalResult,
  TempRationalA, TempRationalB,
  TempRationalTrueResult : TRationalNumber;

implementation

const
  kAdd = 10;
  kSub = 9;
  kMult = 7;
  kDivide = 7;

type
  TestAddData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsAddData = array[1..kAdd] of TestAddData;

  TestSubData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsSubData = array[1..kSub] of TestSubData;

  TestMultData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsMultData = array[1..kMult] of TestMultData;

  TestDivideData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsDivideData = array[1..kDivide] of TestDivideData;







function TestAdd(const TestData : TestAddData) : boolean;  //true если ошибка и false если не ошибка
begin

  TempRationalTrueResult := strToRational(testData[3])^;
  writeError;
  TempRationalA := strToRational(testData[1])^;
  writeError;
  TempRationalB := strToRational(testData[2])^;
  writeError;
  rationals.add(TempRationalResult, TempRationalA, TempRationalB);

  if CompareRationals(TempRationalResult, TempRationalTrueResult) = 0 then
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
begin

  TempRationalTrueResult := strToRational(testData[3])^;
  TempRationalA := strToRational(testData[1])^;
  TempRationalB := strToRational(testData[2])^;
  writeError;
  rationals.subtract(TempRationalResult, TempRationalA, TempRationalB);

  if CompareRationals(TempRationalResult, TempRationalTrueResult) = 0 then
    result := false
  else
    result := true;
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
begin

  TempRationalTrueResult := strToRational(testData[3])^;
  TempRationalA := strToRational(testData[1])^;
  TempRationalB := strToRational(testData[2])^;
  writeError;
  rationals.mult(TempRationalResult, TempRationalA, TempRationalB);

  if CompareRationals(TempRationalResult, TempRationalTrueResult) = 0 then
    result := false
  else
    result := true;
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

function TestDivide(const TestData : TestDivideData) : boolean;  //true если ошибка и false если не ошибка
begin
  InitCheckError;
  TempRationalTrueResult := strToRational(testData[3])^;
  TempRationalA := strToRational(testData[1])^;
  TempRationalB := strToRational(testData[2])^;
  writeError;
  rationals.divide(TempRationalResult, TempRationalA, TempRationalB);


  if not(CheckError.ErrorFlag) and (CompareRationals(TempRationalResult, TempRationalTrueResult) = 0) then
    result := false
  else
    result := true;
end;

procedure TestsDivide(const TestsData : TestsDivideData);
var
  i : integer;
begin
  NameProcedure('Divide');

  for i := low(TestsData) to high(TestsData) do
    if TestDivide(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);

end;









var
  TestsDataAdd : TestsAddData = (
  ('test1', '0 / 1', '0 / 1', '0 / 1'),
  ('test2', '1 / 1', '1 / 2', '3 / 2'),
  ('test3', '1 / 1', '1 / 1', '2 / 1'),
  ('test4', '1 / 1', 'FFFF / 1', '10000 / 1'),
  ('test5', 'BCDEEDCB / 239', 'CFA77AFC / 239', '18C8668C7 / 239'),
  ('test6', '- BCDEEDCB / 239', '- CFA77AFC / 239', '- 18C8668C7 / 239'),
  ('test7', '- 2 / 239', '10001 / 239', 'FFFF / 239'),
  ('test8', '2 / 239', '- 10001 / 239', ' - FFFF / 239'),
  ('test9', '312 / 36981', '- 350035 / 75CD', '-FFFF / 239'),
  ('test10', '312 / 36981', '- 350035 / 75CD', '-8FFF7 / 1401')
  );


  TestsDataSub : TestsSubData = (
  ('test1', '0 / 1', '- 0 / 1', '0 / 1'),
  ('test2', '1 / 1', '- 1 / 1', '2 / 1'),
  ('test3', '1 / 1', '- 1 / 2', '3 / 2'),
  ('test4', '1 / 1', '- FFFF / 1', '10000 / 1'),
  ('test5', 'BCDEEDCB / 239', '- CFA77AFC / 239', '18C8668C7 / 239'),
  ('test6', '- BCDEEDCB / 239', 'CFA77AFC / 239', '- 18C8668C7 / 239'),
  ('test7', '- 2 / 239', '-10001 / 239', 'FFFF / 239'),
  ('test8', '2 / 239', '10001 / 239', ' - FFFF / 239'),
  ('test9', '312 / 36981', '350035 / 75CD', '-8FFF7 / 1401')
  );





  TestsDataMult : TestsMultData = (
  ('test1', '- 234FABD7 / F456A430', '- F456A430 / 234FABD7', '1 / 1'),
  ('test2', '0 / 1', '- 2345ACDA / FAE24352', '0 / 1'),
  ('test3', '239 / 343', '239 / 433', '4F0B1 / DB259'),
  ('test4', '239 / 343', '- 239 / 433', '- 4F0B1 / DB259'),
  ('test5', '- 239 / 343', '239 / 433', '- 4F0B1 / DB259'),
  ('test6', '- 239 / 343', '- 239 / 433', '4F0B1 / DB259'),
  ('test7', '- 286CB / 3B529', '-286CB / 4C5F9', ' 1867D45A61 / 43AA0FBF89')
  );





  TestsDataDivide : TestsDivideData = (
  ('test1', '- 234FABD7 / F456A430', '- 234FABD7 / F456A430', '1 / 1'),
  ('test2', '0 / 1', '- FAE24352 / 2345ACDA', '0 / 1'),
  ('test3', '239 / 343', '433 / 239', '4F0B1 / DB259'),
  ('test4', '239 / 343', '- 433 / 239', '- 4F0B1 / DB259'),
  ('test5', '- 239 / 343', '433 / 239', '- 4F0B1 / DB259'),
  ('test6', '- 239 / 343', '- 433 / 239', '4F0B1 / DB259'),
  ('test7', '- 286CB / 3B529', '- 4C5F9 / 286CB', ' 1867D45A61 / 43AA0FBF89')
  );


begin
  NameUnit('Rationals');

  TestsAdd(TestsDataAdd);
  TestsSub(TestsDataSub);
  TestsMult(TestsDataMult);
  TestsDivide(TestsDataDivide);

end.
