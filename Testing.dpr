program Testing;
{$APPTYPE CONSOLE}
uses
  CheckError in 'Arithmetics\CheckError.pas',
  MiniLexer in 'TestingUnits\MiniLexer.pas',
  sToPolynom in 'TestingUnits\sToPolynom.pas',
  TestStr in 'TestingUnits\TestStr.pas',
  TestNaturals in 'TestingUnits\TestNaturals.pas',
  TestRationals in 'TestingUnits\TestRationals.pas',
  TestPolynoms in 'TestingUnits\TestPolynoms.pas',
  naturals in 'Arithmetics\naturals.pas',
  rationals in 'Arithmetics\rationals.pas',
  polynoms in 'Arithmetics\polynoms.pas',
  FileStr in 'TestingUnits\FileStr.pas',
  signTable in 'Constructing\SignTable.pas',
  TestLexer in 'TestingUnits\TestLexer.pas',
  Statistic in 'TestingUnits\Statistic.pas',
  TestConstrTable in 'TestConstrTable.pas',


  FullSys in 'Constructing\FullSys.pas',
  ConstructionSignTable in 'Constructing\ConstructionSignTable.pas',
  StatementSystemParser in 'Parser\StatementSystemParser.pas',
  StatementSystemStek in 'Parser\StatementSystemStek.pas',
  StatementSystemBuilder in 'Parser\StatementSystemBuilder.pas',
  PolynomsStek in 'Parser\PolynomsStek.pas',
  PolynomsBuilderP in 'Parser\PolynomsBuilderP.pas',
  Lexer in 'Parser\Lexer.pas',
  Formulae in 'Parser\Formulae.pas',
  ParserError in 'Parser\ParserError.pas',
  PolynomParser in 'Parser\PolynomParser.pas';

begin
  InitCheckError;
  writeln(ResultTestString);
  if CheckError.errorStr <> '' then
    writeln(CheckError.errorStr);

  if sToPolynom.errorFlag then
    writeln(sToPolynom.errorStr);
  readln;
end.