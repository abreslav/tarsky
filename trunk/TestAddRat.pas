unit TestAddRat;

interface
uses
  Naturals,
  Rationals,
  TestingUtils;

procedure  Test_Add_rat(var ok: Integer; const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_summ_numerator, real_summ_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);
procedure          Test_Subtract_rat(var ok: Integer;const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_raznost_numerator, real_raznost_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);
procedure  Test_Mult_rat(var ok: Integer;const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_mult_numerator, real_mult_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);

implementation

uses
  SysUtils;
{procedure Format10to16write(const x: TNaturalNumber);
var
  i: Integer;
begin
  for i := (length(x) - 1) downto 0 do begin
    Write(Format('%04x', [x[i]]));
  end;
end;         }
procedure writeratnumber(const a : TRationalNumber);
var
  i : integer;
begin
  write('(');
  if a.sign = nsPlus then
    write('+ ')
  else
    write('- ');
  Format10to16write(a.numerator);
  write('/');
  Format10to16write(a.denominator);
  write(')');
end;

procedure check_add_rat(var ok: Integer;var add_1, add_2, real_summ : TRationalNumber);
var
  summ : TRationalNumber;
  mult1, mult2 :TNaturalNumber;
begin
  add(summ, add_1, add_2);
  if (sravneniye(summ.numerator, real_summ.numerator) <> 0)
    or (summ.sign <> real_summ.sign)
    or (sravneniye(summ.denominator, real_summ.denominator) <> 0)then begin
    writeln('FALSE');
    writeratnumber(add_1);
    write(' + ');
    writeratnumber(add_2);
    write(' = ');
    writeratnumber(summ);
    writeln;
    ok := ok + 1;
  end;
end;

procedure Test_Add_rat(var ok: Integer; const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_summ_numerator, real_summ_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);
var
  a, b, c : TRationalNumber;
  x: Integer;
begin
  x := 0;
  a.numerator := strtonatural(add_1_numerator);
  b.numerator := strtonatural(add_2_numerator);
  a.denominator := strtonatural(add_1_denominator);
  b.denominator := strtonatural(add_2_denominator);
  c.numerator := strtonatural(real_summ_numerator);
  c.denominator := strtonatural(real_summ_denominator);
  a.sign := add_1_sign;
  b.sign := add_2_sign;
  c.sign := add_3_sign;
  check_add_rat(x, a, b, c);
  if x <> 0 then ok := ok + 1;
end;
  procedure check_subtract_rat(var ok: Integer; const add_1, add_2, real_raznost : TRationalNumber);
var
  raznost : TRationalNumber;
begin
  subtract(raznost, add_1, add_2);
  if (raznost.sign <> real_raznost.sign) or
     (sravneniye(raznost.numerator, real_raznost.numerator) <>0) or
     (sravneniye(raznost.denominator, real_raznost.denominator) <>0) then begin
    writeln('FALSE');
    writeratnumber(add_1);
    write(' - ');
    writeratnumber(add_2);
    write(' = ');
    writeratnumber(raznost);
    writeln;
    ok := ok + 1;
  end;
end;
  procedure Test_Subtract_rat(var ok: Integer;const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_raznost_numerator, real_raznost_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);
var
  a, b, c : TRationalNumber;
  x: Integer;
begin
  x := 0;
  a.numerator := strtonatural(add_1_numerator);
  b.numerator := strtonatural(add_2_numerator);
  a.denominator := strtonatural(add_1_denominator);
  b.denominator := strtonatural(add_2_denominator);
  c.numerator := strtonatural(real_raznost_numerator);
  c.denominator := strtonatural(real_raznost_denominator);
  a.sign := add_1_sign;
  b.sign := add_2_sign;
  c.sign := add_3_sign;
  check_subtract_rat(x, a, b, c);
  if x <> 0 then ok := ok + 1;
end;
 procedure check_mult_rat(var ok: Integer; const add_1, add_2, real_mult : TRationalNumber);
var
  mult1 : TRationalNumber;
begin
  mult(mult1, add_1, add_2);
  if (mult1.sign <> real_mult.sign) or
     (sravneniye(mult1.numerator, real_mult.numerator) <>0) or
     (sravneniye(mult1.denominator, real_mult.denominator) <>0) then begin
    writeln('FALSE');
    writeratnumber(add_1);
    write(' * ');
    writeratnumber(add_2);
    write(' = ');
    writeratnumber(mult1);
    Write('  (');
    writeratnumber(real_mult);
    Write(')');
    writeln;
    ok := ok + 1;
  end;
end;
procedure Test_Mult_rat(var ok: Integer; const add_1_numerator, add_2_numerator, add_1_Denominator, add_2_denominator, real_mult_numerator, real_mult_denominator : string; add_1_sign, add_2_sign, add_3_sign: TNumberSign);
var
  a, b, c : TRationalNumber;
  x: Integer;
begin
  x := 0;
  a.numerator := strtonatural(add_1_numerator);
  b.numerator := strtonatural(add_2_numerator);
  a.denominator := strtonatural(add_1_denominator);
  b.denominator := strtonatural(add_2_denominator);
  c.numerator := strtonatural(real_mult_numerator);
  c.denominator := strtonatural(real_mult_denominator);
  a.sign := add_1_sign;
  b.sign := add_2_sign;
  c.sign := add_3_sign;
  check_mult_rat(x, a, b, c);
  if x <> 0 then ok := ok + 1;
end;
end.
