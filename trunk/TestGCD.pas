unit TestGCD;

interface
uses
  Naturals,
  TestingUtils;

procedure  Test_GCD(const num_1, num_2, real_GCD : string);

implementation

procedure check_GCD(var num_1, num_2, real_GCD : TNaturalNumber);
var
  GCDR : TNaturalNumber;
begin
  GCD(GCDR, num_1, num_2);
  if sravneniye(GCDR, real_GCD) <> 0 then begin
    write('FALSE ');
    write('(');
    writenumber(num_1);
    write(', ');
    writenumber(num_2);
    write(')');
    write(' = ');
    writenumber(GCDR);
    Write('( not ');
    writenumber(real_GCD);
    WriteLn(')');
  end else
    WriteLn('ok');
end;

procedure Test_GCD(const num_1, num_2, real_GCD : string);
var
  a, b, c : TNaturalNumber;
begin
  a := strtonatural(num_1);
  b := strtonatural(num_2);
  c := strtonatural(real_GCD);
  check_GCD(a, b, c);
end;

end.
