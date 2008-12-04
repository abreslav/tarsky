program PolynomsTester;
{$APPTYPE CONSOLE}
uses SysUtils, Naturals, Rationals, Polynoms, TestingUtils;

var
  a, b, Arrayresult : Polynoms.Tpolynom;
  a2, b2, Arrayresult2 : Polynoms.Tpolynom;
  a3, b3, Arrayresult3 : Polynoms.Tpolynom;
  x, y, z : TNaturalNumber;
  help1, help2 : TNaturalNumber;

function PolynomsMultTester : boolean;
var
  NumberOfTrueTests : integer;
begin
  setlength(a, 2);
  setlength(b, 2);
  new(a[0]);
  new(a[1]);
  new(b[0]);
  new(b[1]);
  a[0]^.sign := nsPlus;
  a[0]^.Numerator := strtonatural('0007');
  a[0]^.Denominator := strtonatural('0001');
  a[1]^.sign := nsPlus;
  a[1]^.Numerator := strtonatural('0012');
  a[1]^.Denominator := strtonatural('0003');
  b[0]^.sign := nsPlus;
  b[0]^.Numerator := strtonatural('0011');
  b[0]^.Denominator := strtonatural('0004');
  b[1]^.sign := nsplus;
  b[1]^.Numerator := strtonatural('0003');
  b[1]^.Denominator := strtonatural('0006');
  Polynoms.Mult(Arrayresult, a, b);
  NumberOfTrueTests := 0;

  Naturals.Mult(help1, Arrayresult[0]^.numerator, strtonatural('0004'));
  Naturals.Mult(help2, Arrayresult[0]^.denominator, strtonatural('0077'));
  if sravneniye(help1, help2) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;

  Naturals.Mult(help1, Arrayresult[1]^.numerator, strtonatural('0001'));
  Naturals.Mult(help2, Arrayresult[1]^.denominator, strtonatural('001D'));
  if sravneniye(help1, help2) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;

  Naturals.Mult(help1, Arrayresult[2]^.numerator, strtonatural('0001'));
  Naturals.Mult(help2, Arrayresult[2]^.denominator, strtonatural('0003'));
  if sravneniye(help1, help2) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;




  setlength(a2, 1);
  setlength(b2, 2);
  new(a2[0]);
  new(b2[0]);
  new(b2[1]);
  a2[0]^.sign := nsPlus;
  a2[0]^.Numerator := strtonatural('0007');
  a2[0]^.Denominator := strtonatural('0001');
  b2[0]^.sign := nsPlus;
  b2[0]^.Numerator := strtonatural('0011');
  b2[0]^.Denominator := strtonatural('0004');
  b2[1]^.sign := nsplus;
  b2[1]^.Numerator := strtonatural('0003');
  b2[1]^.Denominator := strtonatural('0006');
  Polynoms.Mult(Arrayresult2, a2, b2);

  Naturals.Mult(help1, Arrayresult2[0]^.numerator, strtonatural('0004'));
  Naturals.Mult(help2, Arrayresult2[0]^.denominator, strtonatural('0077'));
  if sravneniye(help1, help2) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;

  Naturals.Mult(help1, Arrayresult2[1]^.numerator, strtonatural('0002'));
  Naturals.Mult(help2, Arrayresult2[1]^.denominator, strtonatural('0007'));
  if sravneniye(help1, help2) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;


  

  setlength(a3, 1);
  setlength(b3, 2);
  new(a3[0]);
  new(b3[0]);
  new(b3[1]);
  a3[0]^.sign := nsPlus;
  a3[0]^.Numerator := strtonatural('0000');
  a3[0]^.Denominator := strtonatural('0001');
  b3[0]^.sign := nsPlus;
  b3[0]^.Numerator := strtonatural('0011');
  b3[0]^.Denominator := strtonatural('0004');
  b3[1]^.sign := nsplus;
  b3[1]^.Numerator := strtonatural('0003');
  b3[1]^.Denominator := strtonatural('0006');
  Polynoms.Mult(Arrayresult3, a3, b3);
  if sravneniye(Arrayresult3[0]^.numerator, strtonatural('0000') ) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;

  if sravneniye(Arrayresult3[1]^.numerator, strtonatural('0000') ) = 0 then
    NumberOfTrueTests := NumberOfTrueTests + 1;

  if NumberOfTrueTests = 7 then
    result := true
  else
    result := false;

end;

begin
  if PolynomsMultTester then
    write('ok');
  readln;
end.
