unit testMult;

interface
uses
  Naturals,
  TestingUtils;
procedure Test_mt(const mult1, mult2, realmult : string);

implementation
procedure Test_mt(const mult1, mult2, realmult : string);
var
  result, a, b, c : TNaturalNumber;
begin
  a := strToNatural(mult1);
  b := strToNatural(mult2);
    mult(result, a, b);
  c := strToNatural(realmult);
  if sravneniye(result, c) = 0 then
    writeln('ok')
  else
    writeln('nea');
end;
end.
 