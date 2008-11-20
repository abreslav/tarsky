program Test_Div;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Naturals,
  TestingUtils;

procedure check_division(const delimoe, delitel, chastnoe, ostatok : TNaturalNumber);
var
  chastnoe_real, ostatok_real : TNaturalNumber;
begin
  divide(chastnoe_real, ostatok_real, delimoe, delitel);
  if not ((sravneniye(chastnoe, chastnoe_real) = 0) and (sravneniye(ostatok_real, ostatok) = 0)) then begin
    write('FALSE');
    writeln;
    WriteNumber(delimoe);
    write(' div ');
    WriteNumber(delitel);
    write(' = ');
    WriteNumber(chastnoe);
    write(' and ');
    WriteNumber(ostatok);
    writeln;
  end;
end;

procedure check_div(const a, b, c, d : string);
var
  x, y, z, t : TNaturalNumber;
begin
  x := strtonatural(a);
  y := strtonatural(b);
  z := strtonatural(c);
  t := strtonatural(d);
  check_division(x, y, z, t);
end;

begin
  check_div('14389039', '14389039', '0001', '0000');
  check_div('14389039', '14389038', '0001', '0001');
  check_div('14389039', '14389040', '0000', '14389039');
  check_div('14389039', '14389039', '0001', '0000');
  check_div('0003B7588FF9', '00034425', '00012345', '00012300');
  check_div('0003B7588FF9', '0001', '0003B7588FF9', '0000');
  readln;
end.