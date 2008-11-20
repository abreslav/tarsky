unit TestSub;

interface
uses
  Naturals,
  TestingUtils;

procedure  Test_Sub(const num_1, num_2, real_sub : string; real_sign : TNumberSign);

implementation

procedure check_sub(var num_1, num_2, real_sub : TNaturalNumber; real_sign : TNumberSign);
var
  sub : TNaturalNumber;
  s : TNumberSign;
begin
  subtract(sub, s, num_1, num_2);
  if (sravneniye(sub, real_sub) <> 0) or (s <> real_sign) then begin
    writeln('FALSE');
    writenumber(num_1);
    write(' - ');
    writenumber(num_2);
    write(' = ');
    write(ord(s));
    Write(' ( not ');
    write(ord(real_sign));
    Write(') ');
    writenumber(sub);
    Write('( not ');
    writenumber(real_sub);
    WriteLn(')');
  end else
    WriteLn('ok');
end;

procedure Test_sub(const num_1, num_2, real_sub : string; real_sign : TNumberSign);
var
  a, b, c : TNaturalNumber;
begin
  a := strtonatural(num_1);
  b := strtonatural(num_2);
  c := strtonatural(real_sub);
  check_sub(a, b, c, real_sign);
end;

end.
