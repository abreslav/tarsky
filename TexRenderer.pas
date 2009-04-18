unit TexRenderer;

interface

uses
  ShellAPI,
  MiniLexer,
  sToPolynom,
  PolynomsBuilderS,
  CheckError,
  naturals,
  rationals,
  polynoms,
  signTable,
  FullSys,
  ConstructionSignTable,
  StatementSystemParser,
  StatementSystemStek,
  StatementSystemBuilder,
  PolynomsStek,
  PolynomsBuilderP,
  Lexer,
  Formulae,
  ParserError,
  PolynomParser,
  SysUtils,
  Unit1,
  sizeAllTypes,
  New_Dispose,  ConstructingRealTableOfStrings,
  OldCode;

procedure FormulaToTex(const formula : TQuanitifedFormula);

implementation

procedure RotateStr(var s : String);
var
  i : Integer;
  c : Char;
begin
  for i := 1 to Length(s) div 2 do begin
    c := s[i];
    s[i] := s[Length(s) - i + 1];
    s[Length(s) - i + 1] := c;
  end;
end;


function NaturalToStr(const nat : TNaturalNumber) : String;
var
  n, m, o : TNaturalNumber;
begin
  CopyNaturals(m, nat);
  SetLength(n, 1);
  n[0] := 10;
  Result := '}';
  while itIsNotZero(m) do begin
    naturals.divide(m, o, m, n);
    Result := Result + IntToStr(o[0]);
  end;
  Result := Result + '{';
  RotateStr(Result);
end;

function RationalWOSignToTex(const rat : TRationalNumber) : String;
begin
  if (length(rat.Denominator) > 1) or (rat.Denominator[0] <> 1) then
    Result := '{\frac' + NaturalToStr(rat.Numerator) + NaturalToStr(rat.Denominator)+ '}'
  else
    Result := '{' + NaturalToStr(rat.Numerator) + '}';
end;

function RatSignToTeX(const sign : TNumberSign) : String;
begin
  if sign = nsPlus then
    Result := '+'
  else
    Result := '-';
end;

procedure AddResult(var Result : String; sign : Byte; rat : TRationalNumber; i : Integer);
begin
  if itIsNotRZero(rat) then begin
    if (sign = 1) and (rat.sign = nsPlus) then
      Result := Result + '+';
    if rat.sign = nsMinus then
      Result := Result + '-';
    if not((length(rat.Denominator) = 1) and (rat.Denominator[0] = 1) and (length(rat.Numerator) = 1) and (rat.Numerator[0] = 1)) then
      Result := Result + RationalWOSignToTex(rat)
    else
      if i = 0 then
        Result := Result + IntToStr(1);
    if i > 1 then
      Result := Result + 'x^{' + IntToStr(i) + '}'
    else
      if i = 1 then
        Result := Result + 'x';
  end;
end;


function PolynomToTeX(const poly : TPolynom) : String;
var
  i, j : Integer;
begin
  Result := '{';
  if itIsNotZeroConst(poly) then begin
    i := high(poly);
    AddResult(Result, 0, poly[i]^, i);
    if i > 0 then
      for j := i - 1 downto 0 do
        AddResult(Result, 1, poly[j]^, j);
  end else
    Result := Result + '0';
  Result := result + '}';
end;

function IneqSignToTeX(const sign : TInequationSign) : String;
begin
  case sign of
    isGreater : Result := '\ >\ ';
    isGreaterEqual : Result := '\ \ge\ ';
    isLess : Result := '\ <\ ';
    isLessEqual : Result := '\ \le\ ';
    isEqual : Result := '\ =\ ';
    isNotEqual : Result := '\ \ne\ ';
  end;
end;

function IneqToTeX(const ineq : TInequation) : String;
begin
  Result := '{' + PolynomToTeX(ineq.Polynom) + IneqSignToTeX(ineq.InequationSign) + '0}';
end;

function StaSystToTex(const StaSyst : TStatementSystem) : String;
begin
  case staSyst.Operation of
    oAnd : result := '\left\{ \begin{array}{l}' + #13#10 + StaSystToTex(staSyst.LeftSS^) + '\\' + #13#10 + StaSystToTex(staSyst.RightSS^) + #13#10 + '\end{array} \right.';
    oOr : result := '\left\[ \begin{array}{l}' + #13#10 + StaSystToTex(staSyst.LeftSS^) + '\\' + #13#10 + StaSystToTex(staSyst.RightSS^) + #13#10 + '\end{array} \right.';
    oNot : begin
//      if (staSyst.LeftSS^.Operation = oInequation) or (staSyst.LeftSS^.Operation = oNot) then
//        result := '{\neg\ \left(' + StaSystToTex(staSyst.LeftSS^) + '\right)}'
//      else
        result := '{\neg\ ' + StaSystToTex(staSyst.LeftSS^) + '}';
    end;
    oInequation : Result := IneqToTeX(staSyst.Inequation^);
  end;
end;

function FormulaeToTex(const formula : TQuanitifedFormula) : String;
var
  c : Byte;
begin
  case formula.Quantor of
    qExists : Result := '\exists ';
    qForAll : Result := '\forall ';
  end;
//  if (Formula.StatementSystem <> nil) and ((Formula.StatementSystem^.Operation = oInequation) or (Formula.StatementSystem^.Operation = oNot)) then
//    Result := Result + ' x\ \left\{' + StaSystToTex(formula.StatementSystem^) + '\right\}'
//  else
    Result := Result + 'x\ :\ ' + {' \left\{' + }StaSystToTex(formula.StatementSystem^);// + '\right\}';
end;

procedure FormulaToTex(const formula : TQuanitifedFormula);
var
  s : String;
  f : File;
begin
  s := FormulaeToTex(formula);//'\documentclass{article}' + #13#10 + '\begin{document}' + #13#10 + '$$' + FormulaeToTex(formula) + '$$' + #13#10 + '\end{document}';
  //WriteLn(s);
  //s := 'kafds';
  AssignFile(f, 'output.tex');
  Rewrite(f, 1);
  BlockWrite(f, s[1], length(s));
  CloseFile(f);
  ShellExecute(0, 'open', 'm.bat', 'output.tex out.gif', '.', 0);
end;

end.
