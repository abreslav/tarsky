unit TestAdd;

interface
uses
  Naturals,
  TestingUtils;

procedure  Test_Add(const add_1, add_2, real_summ : string);

implementation

procedure check_add(var add_1, add_2, real_summ : TNaturalNumber);
var
  summ : TNaturalNumber;
begin
  add(summ, add_1, add_2);
  if sravneniye(summ, real_summ) <> 0 then begin
    writeln('FALSE');
    writenumber(add_1);
    write(' + ');
    writenumber(add_2);
    write(' = ');
    writelnnumber(summ);
  end;
end;

procedure Test_Add(const add_1, add_2, real_summ : string);
var
  a, b, c : TNaturalNumber;
begin
  a := strtonatural(add_1);
  b := strtonatural(add_2);
  c := strtonatural(real_summ);
  check_add(a, b, c);
end;

end.
