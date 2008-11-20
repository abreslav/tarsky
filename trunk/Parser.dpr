                    program Project9;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  Lexer;

type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom, rIneq, rStaSyst, rStatement, rFormula);

var
  ResultType : TGrammarElementType;
  fl : integer = 0;
  ln : string;


procedure WriteIndentAndNames(s : tString; t : Integer);forward;
procedure ReadSum(t : Integer);forward;
procedure ReadStaSyst(t : Integer);forward;

procedure ReadPower(t : Integer);
begin
  if ResultType = gVar then begin
    WriteIndentAndNames(rVar, t);
    ln := LexerNext(ResultType);
    if ResultType = gPower then begin
      ln := LexerNext(resultType);
      if ResultType = gNumber then begin
        WriteIndentAndNames(rNumber, t);
        ln := LexerNext(ResultType);
      end else begin
        Writeln('Error : number expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
        fl := 1;
        exit;
      end;
    end;
  end else begin
    Writeln('Error : var expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    fl := 1;
  end;
end;




Procedure ReadFactor(t : Integer);
begin
  case ResultType of
    gNumber : begin
      WriteIndentAndNames(rNumber, t);
      ln := LexerNext(ResultType);
    end;
    gBracketOpen : begin
      ln := LexerNext(ResultType);
      WriteIndentAndNames(rSum, t + 1);
      if fl = 1 then
        exit;
      if resultType <> gBracketClose then begin
        Writeln('Error : close bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
        fl := 1;
        exit;
      end;
      ln := LexerNext(ResultType);
    end;
    gVar : begin
      WriteIndentAndNames(rPower, t + 1);
      if fl = 1 then
        Exit;
    end;
  else begin
      Writeln('Error : number, open bracket or var expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
      fl := 1;
    end;
  end;
end;




Procedure ReadMult(t : Integer);
begin
  WriteIndentAndNames(rFactor, t + 1);
  if fl = 1 then
    Exit;
  while ResultType = gMelOp do begin
    ln := LexerNext(ResultType);
    WriteIndentAndNames(rFactor, t + 1);
    if fl = 1 then
      Exit;
  end;
end;




Procedure ReadSum(t : Integer);
begin
  WriteIndentAndNames(rMult, t + 1);
  if fl = 1 then
    Exit;
  while ResultType = gPlusOp do begin
    ln := LexerNext(ResultType);
    WriteIndentAndNames(rMult, t + 1);
    if fl = 1 then
      Exit;
  end;
end;




procedure ReadPolynom(t : Integer);
begin
  WriteIndentAndNames(rSum, t + 1);
end;




procedure ReadInequation(t : Integer);
begin
  WriteIndentAndNames(rPolynom, t + 1);
  if fl = 1 then
    Exit;
  if ResultType <> gIneqSign then begin
    Writeln('Error : inequation sign expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    fl := 1;
    Exit;
  end;
  ln := LexerNext(ResultType);
  WriteIndentAndNames(rPolynom, t + 1);
  if fl = 1 then
    Exit;
end;



procedure ReadStatement(t : Integer);
begin
  case ResultType of
    gBracketSquareOpen : begin
      ln := LexerNext(ResultType);
      WriteIndentAndNames(rStaSyst, t + 1);
      if fl = 1 then
        Exit;
      if resultType <> gBracketSquareClose then begin
        Writeln('Error : close square bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
        fl := 1;
        exit;
      end;
      ln := LexerNext(ResultType);
    end;
    gBracketOpen, gNumber, gVar : begin
      WriteIndentAndNames(rIneq, t + 1);
      if fl = 1 then
        Exit;
    end;
    gExc : begin
      ln := LexerNext(ResultType);
      WriteIndentAndNames(rStatement, t + 1);
      if fl = 1 then
        Exit;
    end;
  else begin
      Writeln('Error : ! or open bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
      fl := 1;
    end;
  end;
end;



procedure ReadStaSyst(t : Integer);
begin
  WriteIndentAndNames(rStatement, t + 1);
  if fl = 1 then
    Exit;
  while ResultType = gOper do begin
    ln := LexerNext(ResultType);
    WriteIndentAndNames(rStatement, t + 1);
    if fl = 1 then
      Exit;
  end;
end;




procedure ReadFormula(t : Integer);
begin
  if ResultType <> gQuantor then begin
    Writeln('Error : quantor expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    Exit;
  end;
  ln := LexerNext(ResultType);
  if ResultType <> gVar then begin
    Writeln('Error : var expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    Exit;
  end;
  ln := LexerNext(ResultType);
  if ResultType <> gBracketFigureOpen then begin
    Writeln('Error : open figure bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    Exit;
  end;
  ln := LexerNext(ResultType);
  WriteIndentAndNames(rStaSyst, t + 1);
  if ResultType <> gBracketFigureClose then begin
    Writeln('Error : close figure bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    Exit;
  end;
  ln := LexerNext(ResultType);
  if ResultType <> gEnd then begin
    Writeln('Error : end expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
    Exit;
  end;
end;



procedure parse(text : string);
begin
  InitLexer(text);
  ln := LexerNext(ResultType);
  WriteIndentAndNames(rFormula, 0);
end;




procedure WriteIndentAndNames(s : tString; t : Integer);
var
  i : Integer;
begin
  for i := 1 to 2 * t do
    Write(' ');
  case s of
    rPolynom : begin
      Writeln('< polynom >');
      ReadPolynom(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /polynom >');
    end;
    rMult : begin
      Writeln('< mult >');
      ReadMult(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /mult >');
    end;
    rPower : begin
      Writeln('< power >');
      ReadPower(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /power >');
    end;
    rFactor : begin
      Writeln('< factor >');
      ReadFactor(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /factor >');
    end;
    rSum : begin
      Writeln('< sum >');
      ReadSum(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /sum >');
    end;
    rIneq : begin
      Writeln('< inequation >');
      ReadInequation(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /inequation >');
    end;
    rStaSyst : begin
      Writeln('< statement system >');
      ReadStaSyst(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /statement system >');
    end;
    rStatement : begin
      Writeln('< statement >');
      ReadStatement(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /statement >');
    end;
    rFormula : begin
      Writeln('< formula >');
      ReadFormula(t + 1);
      for i := 1 to 2 * t do
        Write(' ');
      Writeln('< /formula >');
    end;
    rNumber : Writeln('number ', ln);
    rVar : Writeln('var ', ln);
  end;
end;



begin;
  parse('E c {(465 + g ^ 3) * 4 + 756/t * 54 + r^64*4/8 <= 3 and j = 2}');
  Readln;
end.
