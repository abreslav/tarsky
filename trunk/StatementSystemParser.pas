unit StatementSystemParser;



interface

uses
  SysUtils,
  Lexer,
  StatementSystemStek,
  Polynoms,
  PolynomsStek,
  PolynomParser,
  Formulae,
  ParserError,
//  ParserTest,
  StatementSystemBuilder
  ;







type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom, rIneq, rStaSyst, rStatement, rFormula);






var
  ResultType : TGrammarElementType;
  currentTokenData : string;
  inputstr : string;

procedure parse(text : string);

implementation


procedure ReadStaSyst(t : Integer); forward;


procedure ReadInequation(t : Integer);
begin
  onOIneq(t);
  ReadPolynomParser(t + 1, currentTokenData, ResultType);

  if errorFlag = true then
    Exit;

  currentTokenData := PolynomParser.ReadCurrentTokenData(ResultType);
  CheckForError(gIneqSign, ResultType, currentTokenData);
  onIneqSign(t, currentTokenData);
  currentTokenData := LexerNext(ResultType);
  ReadPolynomParser(t + 1, currentTokenData, ResultType);

  if errorFlag = true then
    Exit;

  currentTokenData := PolynomParser.ReadCurrentTokenData(ResultType);
  onCIneq(t);
end;


procedure ReadStatement(t : Integer);
begin
  case ResultType of

    gBracketSquareOpen : begin
      currentTokenData := LexerNext(ResultType);
      ReadStaSyst(t + 1);

      if errorFlag = true then
        Exit;

      CheckForError(gBracketSquareClose, ResultType, currentTokenData);
      currentTokenData := LexerNext(ResultType);
    end;

    gBracketOpen, gNumber, gVar, gPlusOp : begin
      ReadInequation(t + 1);

      if errorFlag = true then
        Exit;

    end;

    gExc : begin
      onExcSign(t);
      currentTokenData := LexerNext(ResultType);
      ReadStatement(t + 1);

      if errorFlag = true then
        Exit;

      onExc(t);
    end;

  else begin
      WriteErrorParser('open square bracket, number, var, ! or open bracket', ResultType, CurrentTokenData);
      errorFlag := true;
    end;
  end;
end;


procedure ReadStaSyst(t : Integer);
begin
  onOStatement(t + 1);
  ReadStatement(t + 1);

  if errorFlag = true then
    Exit;

  onCStatement(t + 1);
  if ResultType = gOper then begin
    onOper(t, currentTokenData);
    currentTokenData := LexerNext(ResultType);
    ReadStaSyst(t + 1);

    if errorFlag = true then
      Exit;

    onStaSyst(t);
  end;
end;


procedure ReadFormula(t : Integer);
begin
  initStek;

  currentTokenData := LexerNext(ResultType);
  CheckForError(gQuantor, ResultType, currentTokenData);

  onQuantor(t, currentTokenData);

  currentTokenData := LexerNext(ResultType);
  CheckForError(gVar, ResultType, currentTokenData);
  currentTokenData := LexerNext(ResultType);
  CheckForError(gBracketFigureOpen, ResultType, currentTokenData);
  currentTokenData := LexerNext(ResultType);

  ReadStaSyst(t + 1);
  
  onFormula(t);

  if errorFlag = true then
    Exit;
  CheckForError(gBracketFigureClose, ResultType, currentTokenData);
  currentTokenData := LexerNext(ResultType);
  CheckForError(gEnd, ResultType, currentTokenData);
end;



procedure parse(text : string);
begin
  StatementSystemStek.initStek;
  PolynomsStek.initStek;
  InitLexer(text);
  initParserError;
  ReadFormula(0);
end;


end.
