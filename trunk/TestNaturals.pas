unit TestNaturals;

interface
uses
  Naturals,
  sToPolynom,
  TestStr;


var
  TempNaturalResult, TempNaturalResultModule,
  TempNaturalA, TempNaturalB,
  TempNaturalTrueResult, TempNaturalTrueResultModule : TNaturalNumber;


implementation

const
  kMult = 1;
  kAdd = 6;
  kSub = 7;
  kDiv = 6;
  kGCD = 8;

type
  TestAddData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsAddData = array[1..kAdd] of TestAddData;


  TestSubData = array[0..4] of string;// 0: имя, 1: а, 2: b, 3: истинный знак, 4: истинный результат.
  TestsSubData = array[1..kSub] of TestSubData;



  TestMultData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsMultData = array[1..kMult] of TestMultData;


  TestDivideData = array[0..4] of string;// 0: имя, 1: а (делимое), 2: b(делитель), 3: истинный результат, 4: истинный остаток.
  TestsDivideData = array[1..kDiv] of TestDivideData;

  TestGCDData = array[0..3] of string;// 0: имя, 1: а, 2: b, 3: истинный результат.
  TestsGCDData = array[1..kGCD] of TestGCDData;



function TestAdd(const TestData : TestAddData) : boolean;  //true если ошибка и false если не ошибка
begin

  TempNaturalTrueResult := strToNatural(testData[3]);
  TempNaturalA := strToNatural(testData[1]);
  TempNaturalB := strToNatural(testData[2]);
  naturals.add(TempNaturalResult, TempNaturalA, TempNaturalB);

  if CompareNaturals(TempNaturalResult, TempNaturalTrueResult) = 0 then
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
  signTrue, tempSign : TNumberSign;

begin
  signTrue := strToSign(testData[3]);
  TempNaturalTrueResult := strToNatural(testData[4]);

  TempNaturalA := strToNatural(testData[1]);
  TempNaturalB := strToNatural(testData[2]);
  naturals.subtract(TempNaturalResult, tempSign, TempNaturalA, TempNaturalB);

  if (CompareNaturals(TempNaturalResult, TempNaturalTrueResult) = 0) and (tempSign = signTrue) then
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

  TempNaturalTrueResult := strToNatural(testData[3]);
  TempNaturalA := strToNatural(testData[1]);
  TempNaturalB := strToNatural(testData[2]);
  naturals.mult(TempNaturalResult, TempNaturalA, TempNaturalB);

  if CompareNaturals(TempNaturalResult, TempNaturalTrueResult) = 0 then
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

  TempNaturalTrueResultModule := strToNatural(testData[4]);
  TempNaturalTrueResult := strToNatural(testData[3]);
  TempNaturalA := strToNatural(testData[1]);
  TempNaturalB := strToNatural(testData[2]);
  naturals.divide(TempNaturalResult, TempNaturalResultModule, TempNaturalA, TempNaturalB);

  if
  (CompareNaturals(TempNaturalResult, TempNaturalTrueResult) = 0) and
  (CompareNaturals(TempNaturalResultModule, TempNaturalTrueResultModule) = 0) then
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


function TestGCD(const TestData : TestGCDData) : boolean;  //true если ошибка и false если не ошибка
begin

  TempNaturalTrueResult := strToNatural(testData[3]);
  TempNaturalA := strToNatural(testData[1]);
  TempNaturalB := strToNatural(testData[2]);
  naturals.gcd(TempNaturalResult, TempNaturalA, TempNaturalB);

  if CompareNaturals(TempNaturalResult, TempNaturalTrueResult) = 0 then
    result := false
  else
    result := true;
end;

procedure TestsGCD(const TestsData : TestsGCDData);
var
  i : integer;
begin
  NameProcedure('GCD');

  for i := low(TestsData) to high(TestsData) do
    if TestGCD(TestsData[i]) then
      ErrorTest(TestsData[i, 0]);
end;







var



  TestsDataAdd : TestsAddData = (
  ('test1', '00EF00EF', '00790079', '01680168'),
  ('test2', 'E000', 'E000', '0001C000'),
  ('test3', '000E0000', '000E0000', '001C0000'),
  ('test4', 'E000E000', 'E000E000', '0001C001C000'),
  ('test5', 'BCDEEDBC', '0000', 'BCDEEDBC'),
  ('test6', '0000', 'BCDEEDBC', 'BCDEEDBC')
  );

  TestsDataSub : TestsSubData = (
  ('test1', '000100000000', '0001', '+', 'FFFFFFFF'),
  ('test2', '0001', '000100000000', '-', 'FFFFFFFF'),
  ('test3', '000200000000', '0001', '+', '0001FFFFFFFF'),
  ('test4', '0001', '000200000000', '-', '0001FFFFFFFF'),
  ('test5', '00010239', '00010000', '+', '0239'),
  ('test6', '00010000', '00010239', '-', '0239'),
  ('test7', '000100239000', '000100239000', '+', '0000')
  );

  TestsDataMult : TestsMultData = ( ('f1', '1', '0', '0'));

  TestsDataDivide : TestsDivideData = (
  ('test1', '14389039', '14389039', '0001', '0000'),
  ('test2', '14389039', '14389038', '0001', '0001'),
  ('test3', '14389039', '14389040', '0000', '14389039'),
  ('test4', '14389039', '14389039', '0001', '0000'),
  ('test5', '0003B7588FF9', '00034425', '00012345', '00012300'),
  ('test6', '0003B7588FF9', '0001', '0003B7588FF9', '0000')
  );

  TestsDataGCD : TestsGCDData = (
  ('test1', '0009', '0006', '0003'),
  ('test2', '000C0004', '00120006', '00060002'),
  ('test3', '02390000', '0000', '02390000'),
  ('test4', '02390000', '02390013', '0001'),
  ('test5', '023900000000', '02390000', '02390000'),
  ('test6', '02390000', '023900000000', '02390000'),
  ('test7', '00010201', '0101', '0101'),
  ('test8', '0101', '00010201', '0101')
  );



begin
  NameUnit('Naturals');

 // TestsAdd(TestsDataAdd);
  TestsSub(TestsDataSub);
  TestsMult(TestsDataMult);
  TestsDivide(TestsDataDivide);
  TestsGCD(TestsDataGCD);





end.
