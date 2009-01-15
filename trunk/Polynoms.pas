 unit Polynoms;

interface

uses
  Rationals, Naturals;
type
  (*
   * Полином от одной переменной
   * p[k] - коэффициент при x^k
   * ВНИМАНИЕ: Коэффициенты нумеруются с нуля (ячейки массива - тоже)
   *)
  TPolynom = array of PRationalNumber;

procedure Add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);
function initzero() : PRationalNumber;
function ComparePolynoms(const a, b : TPolynom) : Integer;//(-1) -> a > b; 0 -> a = b; 1 -> a < b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
procedure toPolynom(var a : TPolynom);
procedure ChangePolynoms(var a, b : TPolynom);                                // a <--> b
implementation




const
  cWord = 1 shl 16;


function  minint(a, b : integer) : integer;
begin
  If a < b then result := a
  else
    result := b;
end;

function  maxint(a, b : integer) : integer;
begin
  If a > b then result := a
  else
    result := b;
end;









function itIsNotZeroConst(TPolynom : TPolynom) : boolean;
begin
  if (length(TPolynom) = 1) and itIsNotRZero(TPolynom[0]^) then
    result := true
  else
    result := false;
end;






//a <-- b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
var
  l, i : Integer;
begin
  l := length(b);
  SetLength(a, l);
  for i := 0 to l - 1 do begin
    New(a[i]);
    CopyRationals(a[i]^, b[i]^);
  end;
end;


procedure toPolynom(var a : TPolynom);
var
  i : integer;
begin
  i := length(a) - 1;
  while (i > 0) and not(itIsNotRZero(a[i]^)) do
    i := i - 1;
  setLength(a, i + 1);
end;






//сравнение 2 полиномов
function ComparePolynoms(const a, b : TPolynom) : Integer;
var
  l, i : Integer;
begin
  l := length(a) - length(b);
  if l < 0 then
    Result := 1
  else if l > 0 then
    Result := -1
  else begin
    i := length(a);
    while (i > 0) and (CompareRationals(a[i - 1]^, b[i - 1]^) = 0) do
      i := i - 1;
    if i = 0 then
      Result := 0
    else
      Result := CompareRationals(a[i - 1]^, b[i - 1]^);
  end;
end;

//a <--> b
procedure ChangePolynoms(var a, b : TPolynom);
var
  x : TPolynom;
begin
  CopyPolynoms(x, a);
  CopyPolynoms(a, b);
  CopyPolynoms(b, x);
end;

procedure add(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  setlength(result, maxint(length(a), length(b)));
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to  minint(length(a) - 1, length(b) - 1) do begin
    Rationals.Add(result[i]^, a[i]^, b[i]^);
  end;
  if Length(a) > length(b) then
    for i := length(b) to Length(a) - 1 do
      result[i]^ := a[i]^
  else
    for i := length(a) to Length(b) - 1 do
      result[i]^ := b[i]^;
  toPolynom(result);
end;


procedure subtract(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  setlength(result, maxint(length(a), length(b)));
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to  minint(length(a) - 1, length(b) - 1) do begin
    Rationals.Subtract(result[i]^, a[i]^, b[i]^);
  end;
  if Length(a) > length(b) then
    for i := length(b) to Length(a) - 1 do
      result[i]^ := a[i]^
  else
    for i := length(a) to Length(b) - 1 do begin
      result[i]^ := b[i]^;
      if result[i]^.Sign = nsPlus then
        result[i]^.Sign := nsMinus
      else
        result[i]^.Sign := nsPlus
    end;
  toPolynom(result);
end;

procedure mult(var result : TPolynom; const a, b : TPolynom);
var
  i, j : integer;
  m : TRationalNumber;
begin
  setlength(result, length(a) + length(b) - 1);
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to length(result) - 1 do
    result[i] := initzero;
  for i := 0 to length(a) - 1 do begin
    for j := 0 to length(b) - 1 do begin
      rationals.mult(m, a[i]^, b[j]^);
      rationals.add(result[i + j]^, result[i + j]^, m);
    end;
  end;
  toPolynom(result);
end;

















procedure varmodule(var result, a, b : TPolynom);
var
  maxdeg_first, maxdeg_second : integer;
  x : TPolynom;
begin
  maxdeg_first := length(a) - 1;
  maxdeg_second := length(b) - 1;
  if maxdeg_first < maxdeg_second then begin
    CopyPolynoms(result, a);
    exit;
  end;
  CopyPolynoms(x, a);
  subtract(a, x, b);
  varmodule(result, a, b);
end;


procedure module(var result : TPolynom; const a, b : TPolynom);
var
  x, y : TPolynom;
begin
  CopyPolynoms(x, a);
  CopyPolynoms(y, b);
  varmodule(result, x, y);
end;


{function intToPRat(K : Integer) : PRationalNumber;
var
  i : integer;
begin
  new(result);
  if k >= 0 then
    result^.Sign := nsPlus
  else begin
    result^.Sign := nsMinus;
    k := -k;
  end;
  setlength(result^.Denominator, 1);
  result^.Denominator[0] := 1;
  setlength(result^.Numerator, (k div cWord) + 1);
  for i := 0 to (k div cWord) do begin
    result^.Numerator[i] := k mod cWord;
    k := k div cWord;
  end;
end;}

function initzero() : PrationalNumber;
begin
  result := intToPRat(0);
end;




procedure derivative(var result : TPolynom; const a : TPolynom);
var
  i : integer;
begin
  if length(a) = 0 then begin
    SetLength(result, 0);
    exit;
  end;
  setlength(result, (length(a) - 1));
  for i := 0 to (length(result) - 1) do begin
    new(result[i]);
    rationals.mult(result[i]^, a[i + 1]^, IntToPRat(i)^);
  end;
end;



end.






