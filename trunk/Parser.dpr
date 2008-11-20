program Parser;
{$APPTYPE CONSOLE}

uses
  SysUtils, Lexer;

type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom);

var
  ResultType : TGrammarElementType;
  fl : integer = 0;
  ln : string;


procedure WriteIndentAndNames(s : tString; t : Integer);forward;
procedure ReadSum(t : Integer);forward;


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
    gBracket : begin
      ln := LexerNext(ResultType);
      WriteIndentAndNames(rSum, t + 1);
      if fl = 1 then
        exit;
      if resultType <> gBracket then begin                    //()//
        Writeln('Error : bracket expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
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
      Writeln('Error : number, bracket or var expected, but ', TGrammarElementTypetoStr(ResultType), ' found');
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



 
procedure parse(text : string);
begin
  InitLexer(text);
  ln := LexerNext(ResultType);
  WriteIndentAndNames(rPolynom, 0);
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
    rNumber : Writeln('number ', ln);
    rVar : Writeln('var ', ln);
  end;
end;



begin;
  parse('(465 + g ^ 3) * 4 + 756/t * 54 + r^64/64*f^3*4/8');
  Readln;
end.
