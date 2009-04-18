unit Counting;

interface

uses
  SysUtils,
  Naturals,
  Rationals,
  sToPolynom,
  Polynoms;


function CountInTRational(const p : Tpolynom; const x : TRationalnumber) : TRationalnumber;
function power(const a : TRationalNumber; const b : integer) : TRationalnumber;
function RoundToNat(const a : TRationalNumber) : TNaturalNumber;
function RoundToInt(const a : TRationalNumber) : integer;

implementation

function power(const a : TRationalNumber; const b : integer) : TRationalnumber;
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


function CountInTRational(const p : Tpolynom; const x : TRationalnumber) : TRationalnumber;
var
  i : integer;
  help1, help2 : TRationalNumber;
begin
  result := polynoms.initzero()^;
  for i := 0 to length(p) - 1  do begin
    rationals.mult(help1, p[i]^, power(x, i));
    rationals.add(help2, result, help1);
    result := help2;
  end;
end;


function RoundToNat(const a : TRationalNumber) : TNaturalNumber;
var
  b : TrationalNumber;
  help1, help2 : TNaturalNumber;
begin
  b := a;
  naturals.divide(result, help1, a.numerator, a.denominator);
end;


function RoundToInt(const a : TRationalNumber) : integer;
begin
  result := RoundToNat(a)[0];
end;






end.

