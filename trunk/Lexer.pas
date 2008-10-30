unit Lexer;




interface

{
  lsStart - при выходе из lexerNext
  lsSearch - работаем(нашли пробел)
  Num - '0'..'9'
  Var - 'a'..'z', 'A'..'Z', '_'
  Oper - '+', '*', '/', '-'
  Sing - '=', '<', '>'
  power - '^'
  bracket - '(', ')'
  BracetFigure - '{', }
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
  TGrammarElementType = (gQuantor, gOper, gIneqSign, gPlusOp, gMelOp, gPower, gVar, gNumber, gEnd, gError, gBracket, gBracetFigure, gExc);
  TCharLexer =(cVar, cNum, cPlusOp, cMelOp, cPower, cSing, cGap, cError, cEnd, cBracket, cBracetFigure, cExc);


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
    gOper: result := 'Oper';
    gIneqSign: result := 'IneqSign';
    gPlusOp: result := 'PlusOp';
    gMelOp: result := 'MelOp';
    gPower: result := 'Power';
    gBracket: result := 'Bracket';
    gBracetFigure: result := 'BracetFigure';
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





procedure initLexer(s : string);
begin
  strlexer := s + '@';
  numP := 2;
  lastchar := strlexer[1];
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
    '(', ')': result := cBracket;
    '{', '}': result := cBracetFigure;
    '!': result := cExc;
    ' ': result := cGap
  else
    if numP >= length(strLexer) then
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
    cError: lexerState := lsError;
    else begin
      lexerState := lsSearch;
      case charLexer(lastChar) of
        cVar: GrammarState := gVar;
        cNum: GrammarState := gNumber;
        cPlusOp: GrammarState := gPlusOp;
        cMelOp: GrammarState := gMelOp;
        cPower: GrammarState := gPower;
        cBracket: GrammarState := gBracket;
        cBracetFigure: GrammarState := gBracetFigure;
        cExc: GrammarState := gExc;
        cSing: GrammarState := gIneqSign;
      end;
      operstr;
    end;
  end;
end;


procedure nextstep;
begin
  case lexerState of
    lsStart: begin
        operstr;
        firststep;
    end;
  end;
  case GrammarState of
    gIneqSign: if charLexer(lastChar) = cSing then begin
        if (length(resultStr) > 1) or (resultStr = '>') or (lastChar = resultStr[1]) then begin
          lexerState := lsError;
          exit;
        end else
          operStr;
      end else begin
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
          if (resultstr = 'var') or (resultstr = 'and') then
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
    gMelOp: begin
        GrammarState := gMelOp;
        lexerState := lsEndOp;
      end;
    gPlusOp: if (resultStr = '-') and (strLexer[numP - 1] = '-') then begin
          if strLexer[numP] = '>' then begin
            resultStr := '-->';
            GrammarState := gOper;
            numP := numP + 2;
            lastChar := strLexer[numP - 1];
            lexerState := lsEndOp;
          end else begin
            lexerState := lsError;
            exit;
          end;
      end else begin
          GrammarState := gPlusOp;
          lexerState := lsEndOp;
      end;
    gPower: begin
        GrammarState := gPower;
        lexerState := lsEndOp;
      end;
    gBracket: begin
        GrammarState := gBracket;
        lexerState := lsEndOp;
      end;
    gBracetFigure: begin
        GrammarState := gBracetFigure;
        lexerState := lsEndOp;
      end;
    gExc: begin
        GrammarState := gExc;
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
    lsError: resultType := gError;
  end;
end;



end.
