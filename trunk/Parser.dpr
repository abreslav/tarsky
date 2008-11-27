program Parser;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  Lexer;

type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom, rIneq, rStaSyst, rStatement, rFormula);

var
  ResultType : TGrammarElementType;
  errorFlag : integer = 0;
  currentTokenData : string;
  ResultString : string;
  inputstr : string;


procedure WriteIndentAndNames(s : tString; t : Integer); forward;
procedure WriteError(s : string); forward;
procedure ReadSum(t : Integer); forward;
procedure ReadStaSyst(t : Integer); forward;

procedure ReadPower(t : Integer);
begin
  if ResultType = gVar then begin
    WriteIndentAndNames(rVar, t);
    currentTokenData := LexerNext(ResultType);
    if ResultType = gPower then begin
      currentTokenData := LexerNext(resultType);
      if ResultType = gNumber then begin
        WriteIndentAndNames(rNumber, t);
        currentTokenData := LexerNext(ResultType);
      end else begin
        WriteError('number');
        errorFlag := 1;
        exit;
      end;
    end;
  end else begin
    WriteError('var');
    errorFlag := 1;
  end;
end;




Procedure ReadFactor(t : Integer);
begin
  case ResultType of
    gNumber : begin
      WriteIndentAndNames(rNumber, t);
      currentTokenData := LexerNext(ResultType);
    end;
    gBracketOpen : begin
      currentTokenData := LexerNext(ResultType);
      WriteIndentAndNames(rSum, t + 1);
      if resultType <> gBracketClose then begin
        WriteError('close bracket');
        errorFlag := 1;
        exit;
      end;
      currentTokenData := LexerNext(ResultType);
    end;
    gVar : begin
      WriteIndentAndNames(rPower, t + 1);
    end;
    gPlusOp : begin
      currentTokenData := LexerNext(ResultType);
      WriteIndentAndNames(rFactor, t + 1);
    end;
  else begin
      WriteError('number, open bracket or var');
      errorFlag := 1;
    end;
  end;
end;




Procedure ReadMult(t : Integer);
begin
  WriteIndentAndNames(rFactor, t + 1);
  while ResultType = gMelOp do begin
    currentTokenData := LexerNext(ResultType);
    WriteIndentAndNames(rFactor, t + 1);
  end;
end;




Procedure ReadSum(t : Integer);
begin
  WriteIndentAndNames(rMult, t + 1);
  while ResultType = gPlusOp do begin
    currentTokenData := LexerNext(ResultType);
    WriteIndentAndNames(rMult, t + 1);
  end;
end;




procedure ReadPolynom(t : Integer);
begin
  WriteIndentAndNames(rSum, t + 1);
end;




procedure ReadInequation(t : Integer);
begin
  WriteIndentAndNames(rPolynom, t + 1);
  if ResultType <> gIneqSign then begin
    WriteError('inequation sign');
    errorFlag := 1;
    Exit;
  end;
  currentTokenData := LexerNext(ResultType);
  WriteIndentAndNames(rPolynom, t + 1);
end;



procedure ReadStatement(t : Integer);
begin
  case ResultType of
    gBracketSquareOpen : begin
      currentTokenData := LexerNext(ResultType);
      WriteIndentAndNames(rStaSyst, t + 1);
      if resultType <> gBracketSquareClose then begin
        WriteError('close square bracket');
        errorFlag := 1;
        exit;
      end;
      currentTokenData := LexerNext(ResultType);
    end;
    gBracketOpen, gNumber, gVar : begin
      WriteIndentAndNames(rIneq, t + 1);
    end;
    gExc : begin
      currentTokenData := LexerNext(ResultType);
      WriteIndentAndNames(rStatement, t + 1);
    end;
  else begin
      WriteError('! or open bracket');
      errorFlag := 1;
    end;
  end;
end;



procedure ReadStaSyst(t : Integer);
begin
  WriteIndentAndNames(rStatement, t + 1);
  while ResultType = gOper do begin
    currentTokenData := LexerNext(ResultType);
    WriteIndentAndNames(rStatement, t + 1);
  end;
end;




procedure ReadFormula(t : Integer);
begin
  if ResultType <> gQuantor then begin
    WriteError('quantor');
    Exit;
  end;
  currentTokenData := LexerNext(ResultType);
  if ResultType <> gVar then begin
    WriteError('var');
    Exit;
  end;
  currentTokenData := LexerNext(ResultType);
  if ResultType <> gBracketFigureOpen then begin
    WriteError('open figure bracket');
    Exit;
  end;
  currentTokenData := LexerNext(ResultType);
  WriteIndentAndNames(rStaSyst, t + 1);
  if errorFlag = 1 then
    Exit;
  if ResultType <> gBracketFigureClose then begin
    WriteError('close figure bracket');
    Exit;
  end;
  currentTokenData := LexerNext(ResultType);
  if ResultType <> gEnd then begin
    WriteError('end');
    Exit;
  end;
end;



procedure parse(text : string);
begin
  InitLexer(text);
  currentTokenData := LexerNext(ResultType);
  WriteIndentAndNames(rFormula, 0);
end;



procedure WriteError(s : string);
begin
  if ResultType = gError then
    ResultString := ResultString + 'Error : ' + s + ' expected, but ' + currentTokenData + ' found.' + #13#10
  else
    ResultString := ResultString + 'Error : ' + s + ' expected, but ' + TGrammarElementTypetoStr(ResultType) + ' found.' + #13#10;
end;





procedure WriteIndentAndNames(s : tString; t : Integer);
var
  i : Integer;
begin
  for i := 1 to 2 * t do
    ResultString := ResultString + ' ';
  case s of
    rPolynom : begin
      ResultString := ResultString + '< polunom >' + #13#10;
      ReadPolynom(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /polunom >' + #13#10;
    end;
    rMult : begin
      ResultString := ResultString + '< mult >' + #13#10;
      ReadMult(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /mult >' + #13#10;
    end;
    rPower : begin
      ResultString := ResultString + '< power >' + #13#10;
      ReadPower(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /power >' + #13#10;
    end;
    rFactor : begin
      ResultString := ResultString + '< factor >' + #13#10;
      ReadFactor(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< / factor >' + #13#10;
    end;
    rSum : begin
      ResultString := ResultString + '< sum >' + #13#10;
      ReadSum(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /sum >' + #13#10;
    end;
    rIneq : begin
      ResultString := ResultString + '< inequation >' + #13#10;
      ReadInequation(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /inequation >' + #13#10;
    end;
    rStaSyst : begin
      ResultString := ResultString + '< statement system >' + #13#10;
      ReadStaSyst(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /statement system >' + #13#10;
    end;
    rStatement : begin
      ResultString := ResultString + '< statement >' + #13#10;
      ReadStatement(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /statement >' + #13#10;
    end;
    rFormula : begin
      ResultString := ResultString + '< formula >' + #13#10;
      ReadFormula(t + 1);
      if errorFlag = 1 then
        Exit;
      for i := 1 to 2 * t do
        ResultString := ResultString + ' ';
      ResultString := ResultString + '< /formula >' + #13#10;
    end;
    rNumber : ResultString := ResultString + 'number ' + currentTokenData + #13#10;
    rVar : ResultString := ResultString + 'var ' + currentTokenData + #13#10;
  end;
end;




begin;
  inputstr := 'E c {(465 + g ^ 3) * 4 + 756/t * 54 + r^64*4/8 <= 3 and j = 2}';
  ResultString := '';
  parse(inputstr);
  Writeln(ResultString);
  Readln;
end.
