unit FormulaToString;

interface

uses
  SysUtils,
  Formulae,
  StatementSystemParser,
  StatementSystemBuilder,
  Rationals,
  Polynoms,
  sToPolynom,
  PolynomsBuilderP,
  Naturals;


function FormulaToStr(const formula : TQuanitifedFormula) : string;


implementation


{function NaturalToStr(const natnum : TNaturalNumber) : string;
var
  i : Integer;
begin
  for i := Low(natnum) to High(natnum) do
    Result := Result + tNaturlNumberToStr(natnum);
end;

function RationalToStr(const ratnum : TRationalNumber) : string;
begin
  Result := '(';
  if ratnum.Sign = nsMinus then
    Result := Result + '-';
  Result := Result + NaturalToStr(ratnum.Numerator) + '/'  + NaturalToStr(ratnum.Denominator) + ')';
end;

function PolynomToStr(const polynom : TPolynom) : string;
var
  i : Integer;
begin;
  for i := High(polynom) downto Low(polynom) + 2 do
    Result := Result + RationalToStr(polynom[i]^) + ' * x ^ ' + IntToStr(i) + ' + ';
  if High(polynom) > Low(polynom) then
    Result := Result + RationalToStr(polynom[Low(polynom) + 1]^) + ' * x + ';
  Result := Result + RationalToStr(polynom[Low(polynom)]^)
end;}

function InequationToStr(const Ineq : TInequation) : string;
begin
  Result := tPolynomToStr(Ineq.Polynom);
  case Ineq.InequationSign of
    isGreater : Result := Result + ' > ';
    isGreaterEqual : Result := Result + ' >= ';
    isLess : Result := Result + ' < ';
    isLessEqual : Result := Result + ' <= ';
    isEqual : Result := Result + ' = ';
    isNotEqual : Result := Result + ' <> ';
  end;
  Result := Result + '0';
end;

function StaSystToStr(const StaSyst : TStatementSystem) : string;
begin
  case StaSyst.Operation of
    oInequation : Result := '[' + InequationToStr(StaSyst.Inequation^) + ']';
    oNot : Result := '!' + '[' + StaSystToStr(StaSyst.LeftSS^) + ']';
    oAnd : Result := '[' + StaSystToStr(StaSyst.LeftSS^) + ' and ' + StaSystToStr(StaSyst.RightSS^) + ']';
    oOr : Result := '[' + StaSystToStr(StaSyst.LeftSS^) + ' or ' + StaSystToStr(StaSyst.RightSS^) + ']';
  end;
end;

function FormulaToStr(const formula : TQuanitifedFormula) : string;
begin
  if formula.Quantor = qExists then
    Result := Result + 'E x '
  else
    Result := Result + 'A x ';
  Result := Result + '{' + StaSystToStr(formula.StatementSysytem^) + '}';
end;


end.


