program Testing;
{$APPTYPE CONSOLE}
uses
  MiniLexer,
  sToPolynom,
  TestStr,
  TestNaturals,
  TestRationals,
  TestPolynoms,
  TestLexer;

begin

  writeln(ResultTestString);
  if errorFlag then
    writeln(errorStr);

  readln;
end.