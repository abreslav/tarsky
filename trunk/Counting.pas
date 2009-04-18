unit Counting;

interface

uses
  SysUtils,
  Naturals,
  Rationals,
  sToPolynom,
  Polynoms;


function CountInTRational(const p : TPolynom; const x : TRationalnumber) : TRationalnumber;
function RoundToInt(const a : TRationalNumber) : integer;
function CountResult(const p : TPolynom; const d : TRationalNumber; x : TRationalNumber) : Integer;

implementation

{function power(const a : TRationalNumber; const b : integer) : TRationalnumber;
var
  i : integer;
  help : TRationalNumber;
begin
  result := a;
  for i := 1 to b - 1 do begin
    rationals.mult(help, result, a);
    result := help;
  end;
  if b = 0 then begin
    result.Sign := nsPlus;
    result.Numerator := strtonatural('0001');
    result.Denominator := strtonatural('0001');
  end;
end;
}

function CountInTRational(const p : Tpolynom; const x : TRationalnumber) : TRationalnumber;
var
  i, l : integer;
begin
  l := length(p);
  if l = 0 then
    Exit;
  Result := p[l - 1]^;
  for i := l - 2 downto 0 do begin
    Rationals.Mult(Result, Result, x);
    Rationals.Add(Result, Result, p[i]^);
  end;
end;


function RoundToNat(const a : TRationalNumber) : TNaturalNumber;
var
  help1 : TNaturalNumber;
begin
  naturals.divide(Result, help1, a.numerator, a.denominator);
end;


function RoundToInt(const a : TRationalNumber) : integer;
begin
  result := RoundToNat(a)[0];
  if length(RoundToNat(a)) > 1 then
    result := 1 shl 15 - 1;
  if a.sign = nsMinus then
    result := -result;
end;


function CountResult(const p : TPolynom; const d : TRationalNumber; x : TRationalNumber) : Integer;
var
  y : TRationalNumber;
begin
  Rationals.Divide(y, CountInTRational(p, x), d);
  Result := RoundToInt(y);
end;



end.

