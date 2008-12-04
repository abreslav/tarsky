program Div_Polynom_test;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Polynoms,
  testingutils;
procedure testdivp(const delim, delit, ostat : TPolynom);
var
  ostat_real : TPolynom;
begin
  module(ostat_real, delim, delit);
  if sravneniye_polynoms(ostat_real, ostat) = 1 then begin
    writeln;
    writepolynom(delim);
    write('    mod    ');
    writepolynom(delit);
    write('    =    ');
    writepolynom(ostat_real);
  end;
end;

procedure test_modP(const a, b, c : string);
begin
  testdivp(strtopolynom(a), strtopolynom(b), strtopolynom(c));
end;
begin
  // Insert user code here
end.