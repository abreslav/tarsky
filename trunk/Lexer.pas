unit Lexer;




interface

{
  lsStart - при выходе из lexerNext
  lsSearch - работаем(нашли пробел)
  Num - '0'..'9'
  Var - 'a'..'z', 'A'..'Z', '_'
  Oper - not, and, or, xor
  PlusOp - '+', '-'
  MultOp - '*', '/'
  Sing - '=', '<', '>'
  power - '^'
  bracket - '(', ')'
  BracketFigure - '{', }
 { cGap - пробел
  Exc - '!'
  cNum - нашли цифру
  lsNum - предыдущий символ - цифра
  @- конец строки
  end - ура! @}



uses
  SysUtils;

type
  TLexerState = (lsStart, lsSearch, lsEndOp, lsEnd, lsError);
  TGrammarElementType = (gQuantor, gIneqSign, gPlusOp, gMelOp, gOper, gPower, gVar, gNumber, gEnd, gError, gBracketOpen, gBracketClose, gBracketFigureOpen, gBracketFigureClose, gBracketSquareOpen, gBracketSquareClose, gExc);
  TCharLexer =(cVar, cNum, cPlusOp, cMelOp, cPower, cSing, cGap, cError, cEnd, cBracketOpen, cBracketClose, cBracketFigureOpen, cBracketFigureClose, cBracketSquareOpen, cBracketSquareClose, cExc);


procedure initLexer(s : string);
function lexerNext(var ResultType : TGrammarElementType) : string;
function TGrammarElementTypetoStr(gr : TGrammarElementType) : string;


implementation

var
  lastChar : char;
  strLexer : string;
  numP : integer;
  lexerState : TLexerState;
  resultStr : string;
  GrammarState : TGrammarElementType;

function TGrammarElementTypetoStr(gr : TGrammarElementType) : string;
begin
  case gr of
    gQuantor: result := 'Quantor';
    gIneqSign: result := 'IneqSign';
    gPlusOp: result := 'PlusOp';
    gMelOp: result := 'MelOp';
    gOper: result := 'Oper';
    gPower: result := 'Power';
    gBracketOpen: result := 'BracketOpen';
    gBracketClose: result := 'BracketClose';
    gBracketFigureOpen: result := 'BracketFigureOpen';
    gBracketFigureClose: result := 'BracketFigureClose';
    gBracketSquareOpen: result := 'BracketSquareOpen';
    gBracketSquareClose: result := 'BracketSquareClose';
    gExc: result := 'Exc';
    gVar: result := 'Var';
    gNumber: result := 'Number';
    gEnd: result := 'End';
    gError: result := 'Error';
  end;
end;

procedure operStr;
begin
  resultStr := resultStr + lastChar;
  lastChar := strLexer[numP];
  inc(numP);
end;



function implikation() : boolean;
begin
  if (resultStr = '-') and (strLexer[numP - 1] = '-') and (strLexer[numP] = '>') then begin
    resultStr := '-->';
    GrammarState := gOper;
    numP := numP + 2;
    lastChar := strLexer[numP - 1];
    lexerState := lsEndOp;
    result := true;
  end else
    result := false;
end;




procedure initLexer(s : string);
begin
  strlexer := '@' + s + '@';
  numP := 3;
  lastchar := strlexer[2];
  lexerstate := lsStart;
end;

function charLexer(c : char) : TCharLexer ; //Горорит, что за фигню в него ввели
begin
  case c of
    'a'..'z', 'A'..'Z', '_': result := cVar;
    '0'..'9': result := cNum;
    '+', '-': result := cPlusOp;
    '*', '/': result := cMelOp;
    '=', '<', '>': result := cSing;
    '^': result := cPower;
    '(': result := cBracketOpen;
    ')': result := cBracketClose;
    '{': result := cBracketFigureOpen;
    '}': result := cBracketFigureClose;
    '[': result := cBracketSquareOpen;
    ']': result := cBracketSquareClose;
    '!': result := cExc;
    ' ': result := cGap;
    #13: if strLexer[numP] = #10 then
      result := cGap
    else
      result := cError;
    #10: if strLexer[numP - 2] = #13 then
      result := cGap
    else
      result := cError;
  else
    if numP > length(strLexer) then
      result := cEnd
    else
       result := cError;
  end;
end;


procedure firststep;
begin
  resultStr := '';
  case charLexer(lastChar) of
    cEnd: lexerState := lsEnd;
    cGap: lexerState := lsStart;
    cError: begin
      lexerState := lsError;
      operstr;
    end;
    else begin
      lexerState := lsSearch;
      case charLexer(lastChar) of
        cVar: GrammarState := gVar;
        cNum: GrammarState := gNumber;
        cPlusOp: GrammarState := gPlusOp;
        cSing: GrammarState := gIneqSign;
        cMelOp: begin
          GrammarState := gMelOp;
          lexerState := lsEndOp;
        end;
        cPower: begin
          GrammarState := gPower;
          lexerState := lsEndOp;
        end;
        cBracketOpen: begin
          GrammarState := gBracketOpen;
          lexerState := lsEndOp;
        end;
        cBracketClose: begin
          GrammarState := gBracketClose;
          lexerState := lsEndOp;
        end;
        cBracketFigureOpen: begin
          GrammarState := gBracketFigureOpen;
          lexerState := lsEndOp;
        end;
        cBracketFigureClose: begin
          GrammarState := gBracketFigureClose;
          lexerState := lsEndOp;
        end;
        cBracketSquareOpen: begin
          GrammarState := gBracketSquareOpen;
          lexerState := lsEndOp;
        end;
        cBracketSquareClose: begin
          GrammarState := gBracketSquareClose;
          lexerState := lsEndOp;
        end;
        cExc: begin
          GrammarState := gExc;
          lexerState := lsEndOp;
        end;
      end;
      operstr;
    end;
  end;
end;


procedure nextstep;
var
  TempS : string;
begin
  case lexerState of
    lsStart: begin
        operstr;
        firststep;
        exit;
    end;
  end;
  case GrammarState of
    gIneqSign: if (charLexer(lastChar) <> cSing) or (length(resultStr) > 1)  then begin
        GrammarState := gIneqSign;
        lexerState := lsEndOp;
      end else begin
      TempS := resultstr + lastChar;
      if (TempS = '<=') or (TempS = '>=') or (TempS = '<>') then
        operStr
      else
        GrammarState := gIneqSign;
        lexerState := lsEndOp;
      end;
    gVar: if (charLexer(lastChar) = cVar) or (charLexer(lastChar) = cNum) then
        operStr
      else begin
        if (resultStr = 'E') or (resultStr = 'A') then begin
          GrammarState := gQuantor;
          lexerState := lsEndOp;
        end else begin
          resultstr := ansilowercase(resultstr);
          if
            (resultstr = 'not') or (resultstr = 'and')
             or (resultstr = 'or') or (resultstr = 'xor')
            then
            GrammarState := gOper
          else
            GrammarState := gVar;
        lexerState := lsEndOp;
        end;
      end;
    gNumber: if charLexer(lastChar) = cNum then
        operStr
      else begin
        GrammarState := gNumber;
        lexerState := lsEndOp;
      end;
    gPlusOp: if not implikation() then begin
          GrammarState := gPlusOp;
          lexerState := lsEndOp;
      end;
    end;
end;



function lexerNext(var ResultType : TGrammarElementType) : string;
begin

  result := '';
  lexerState := lsStart;
  firstStep;
  while (lexerState = lsStart) or (lexerState = lsSearch) do
    nextStep;
  case lexerState of
    lsEndOp: begin
      resultType := GrammarState;
      result := resultStr;
    end;
    lsEnd: resultType := gEnd;
    lsError: begin
      resultType := gError;
      result := resultStr;
    end;  
  end;
end;



end.
