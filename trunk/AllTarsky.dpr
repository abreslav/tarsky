program AllTarsky;
{$APPTYPE CONSOLE}
uses
  MiniLexer in 'TestingUnits\MiniLexer.pas',
  sToPolynom in 'TestingUnits\sToPolynom.pas',
  CheckError in 'Arithmetics\CheckError.pas',
  naturals in 'Arithmetics\naturals.pas',
  rationals in 'Arithmetics\rationals.pas',
  polynoms in 'Arithmetics\polynoms.pas',
  signTable in 'Constructing\SignTable.pas',
  FullSys in 'Constructing\FullSys.pas',
  ConstructionSignTable in 'Constructing\ConstructionSignTable.pas',
  StatementSystemParser in 'Parser\StatementSystemParser.pas',
  StatementSystemStek in 'Parser\StatementSystemStek.pas',
  StatementSystemBuilder in 'Parser\StatementSystemBuilder.pas',
  PolynomsStek in 'Parser\PolynomsStek.pas',
  PolynomsBuilderS in 'Parser\PolynomsBuilderS.pas',
  PolynomsBuilderP in 'Parser\PolynomsBuilderP.pas',
  Lexer in 'Parser\Lexer.pas',
  Formulae in 'Parser\Formulae.pas',
  ParserError in 'Parser\ParserError.pas',
  PolynomParser in 'Parser\PolynomParser.pas',
  SysUtils,
//  Unit1,
  Statistic in 'TestingUnits\Statistic.pas',
  ConstructingRealTableOfStrings in 'ConstructingRealTableOfStrings.pas',
  filestr in 'TestingUnits\filestr.pas',
  runTarsky in 'runTarsky.pas',
  TexRenderer in 'TexRenderer.pas',
  printstatisticsnew in 'printstatisticsnew.pas';

begin
  runAll;

  writeln(resultAnswer);
  readln;
end.