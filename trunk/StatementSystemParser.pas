unit StatementSystemParser;



interface

uses
  SysUtils,
  Lexer,
  StatementSystemStek,
  Polynoms,
  PolynomsStek,
  PolynomParser,
  ParserTest,
//  StatementSystemBuilder,
  Formulae
  ;







type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom, rIneq, rStaSyst, rStatement, rFormula);






var
  ResultType : TGrammarElementType;
  errorFlag : integer = 0;
  currentTokenData : string;
  inputstr : string;

procedure parse(text : string);

implementation


procedure WriteError(s : string); forward;
procedure ReadStaSyst(t : Integer); forward;
procedure CheckForError(GType : TGrammarElementType); forward;





procedure ReadInequation(t : Integer);
begin
  onOIneq(t);
  ReadPolynomParser(t + 1, currentTokenData, ResultType);
  currentTokenData := PolynomParser.ReadCurrentTokenData(ResultType);
  CheckForError(gIneqSign);
  onIneqSign(t, currentTokenData);
  currentTokenData := LexerNext(ResultType);
  ReadPolynomParser(t + 1, currentTokenData, ResultType);
  currentTokenData := PolynomParser.ReadCurrentTokenData(ResultType);
  onCIneq(t);
end;


procedure ReadStatement(t : Integer);
begin
  case ResultType of

    gBracketSquareOpen : begin
      currentTokenData := LexerNext(ResultType);
      ReadStaSyst(t + 1);
      CheckForError(gBracketSquareClose);
      currentTokenData := LexerNext(ResultType);
    end;

    gBracketOpen, gNumber, gVar : begin
      ReadInequation(t + 1);
    end;

    gExc : begin
      onExcSign(t);
      currentTokenData := LexerNext(ResultType);
      ReadStatement(t + 1);
      onExc(t);
    end;

  else begin
      WriteError('open square bracket, number, var, ! or open bracket');
      errorFlag := 1;
    end;
  end;
end;


procedure ReadStaSyst(t : Integer);
begin
  onOStatement(t + 1);
  ReadStatement(t + 1);
  onCStatement(t + 1);
  if ResultType = gOper then begin
    onOper(t, currentTokenData);
    currentTokenData := LexerNext(ResultType);
    ReadStaSyst(t + 1);
    onStaSyst(t);
  end;
end;


procedure ReadFormula(t : Integer);
begin
  initStek;

  currentTokenData := LexerNext(ResultType);

  onQuantor(t, currentTokenData);
  
  currentTokenData := LexerNext(ResultType);
  CheckForError(gVar);
  currentTokenData := LexerNext(ResultType);
  CheckForError(gBracketFigureOpen);
  currentTokenData := LexerNext(ResultType);

  ReadStaSyst(t + 1);
  
  onFormula(t);

  if errorFlag = 1 then
    Exit;
  CheckForError(gBracketFigureClose);
  currentTokenData := LexerNext(ResultType);
  CheckForError(gEnd);
end;



procedure parse(text : string);
begin
  StatementSystemStek.initStek;
  PolynomsStek.initStek;
  InitLexer(text);
  ReadFormula(0);
end;




procedure WriteError(s : string);
begin
  if ResultType = gError then
    WriteErrorStr('Error : ' + s + ' expected, but ' + currentTokenData + ' found.')
  else
    WriteErrorStr('Error : ' + s + ' expected, but ' + TGrammarElementTypetoStr(ResultType) + ' found.');
  errorFlag := 1;
  Exit;
end;



procedure CheckForError(GType : TGrammarElementType);
begin
  if ResultType <> GType then
    case GType of
      gQuantor : WriteError('quantor');
      gIneqSign : WriteError('inequation sign');
      gVar : WriteError('var');
      gNumber : WriteError('number');
      gEnd : WriteError('end');
      gBracketClose : WriteError('close bracket');
      gBracketFigureOpen : WriteError('open figure bracket');
      gBracketFigureClose : WriteError('close figure bracket');
      gBracketSquareClose : WriteError('close square bracket');
      gExc : WriteError('!');
    end;
end;



end.
