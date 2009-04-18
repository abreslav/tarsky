unit MiniLexer;




interface

{
  lsStart - при выходе из lexerNext
  lsSearch - работаем(нашли пробел)
  Num - '0'..'9','A'..'F'
  Var - 'a'..'z', 'A'..'Z', '_'
  power - '^'
  bracket - '(', ')'
  div '/'
  comma ','
  PlusOp '-', '+'

 { cGap - пробел
  cNum - нашли цифру
  lsNum - предыдущий символ - цифра
  @- конец строки
  end - ура! @}


  {переменная должна начинаться с маленькой буквы, иначе это цифра, но Ab это цифра 000А и переменная b}



uses
  SysUtils;

type
  TLexerState = (lsStart, lsSearch, lsEndOp, lsEnd, lsError);
  TGrammarElementType = (gPower, gVar, gNumber, gEnd, gError, gDiv, gComma, gPlusOp, gMult);
  TCharLexer =(cVar, cNumber, cGap, cError, cEnd, cDiv, cComma, cPower, cMult, CPlusOp);


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
    gDiv: result := 'Div';
    gComma: result := 'Comma';
    gPower: result := 'Power';
    gVar: result := 'Var';
    gNumber: result := 'Number';
    gMult: result := 'Mult';
    gEnd: result := 'End';
    gError: result := 'Error';
    gPlusOp: result := 'PlusOp';
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
  strlexer := '@' + s + '@';
  numP := 3;
  lastchar := strlexer[2];
  lexerstate := lsStart;
end;

function charLexer(c : char) : TCharLexer ; //Горорит, что за фигню в него ввели
begin
  case c of
    'a'..'z', '_', 'G'..'Z': result := cVar;
    '0'..'9', 'A'..'F': result := cNumber;
    '/': result := cDiv;
    ' ': result := cGap;
    '^': result := cPower;
    ',': result := cComma;
    '-', '+': result := cPlusOp;
    '*': result := cMult;
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
        cNumber: GrammarState := gNumber;
        cDiv: begin
          GrammarState := gDiv;
          lexerState := lsEndOp;
        end;
        cPlusOp: begin
          GrammarState := gPlusOp;
          lexerState := lsEndOp;
        end;
        cPower: begin
          GrammarState := gPower;
          lexerState := lsEndOp;
        end;
        cMult: begin
          GrammarState := gMult;
          lexerState := lsEndOp;
        end;
        cComma: begin
          GrammarState := gComma;
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
    gVar: if (charLexer(lastChar) = cVar) or (charLexer(lastChar) = cNumber) then
        operStr
      else begin
        resultstr := resultstr;
        GrammarState := gVar;
        lexerState := lsEndOp;
      end;
    gNumber: if charLexer(lastChar) = cNumber then
        operStr
      else begin
        GrammarState := gNumber;
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

