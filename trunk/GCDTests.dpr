program GCDTests;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  TestGCD, Naturals;

var
  a, b, c : string;
  s : TNumberSign;
begin
  Test_GCD('0009', '0006', '0003');
  Test_GCD('000C0004', '00120006', '00060002');
  Test_GCD('02390000', '0000', '02390000');
  Test_GCD('02390000', '02390013', '0001');
  Test_GCD('023900000000', '02390000', '02390000');
  Test_GCD('02390000', '023900000000', '02390000');
  Test_GCD('00010201', '0101', '0101');
  Test_GCD('0101', '00010201', '0101');
  ReadLn;
end.