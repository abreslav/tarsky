program Parser;
{$APPTYPE CONSOLE}



uses
  ParserTest in 'ParserTest.pas',
  StatementSystemBuilder in 'StatementSystemBuilder.pas',
  StatementSystemParser in 'StatementSystemParser.pas',
  StatementSystemStek in 'StatementSystemStek.pas',
  sToPolynom in 'sToPolynom.pas',
  Polynoms in 'Polynoms.pas',
  PolynomsBuilderS in 'PolynomsBuilderS.pas';

begin
  parse('E x {x < 3}');
  WriteLn(ResultString);
  ReadLn;
end.
