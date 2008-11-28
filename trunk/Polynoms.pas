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
{procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);
  }
implementation

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
end;



























{procedure add(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  For i := 0 to minint(length(a) - 1, length(b) - 1) do
    add(result[i], a[i], b[i]);
  If length(a) > length(b) then
    For i := minint(length(a), length(b)) + 1 to length(a)
      add(result[i], a[i], 0);
  else
    For i := minint(length(a), length(b)) + 1 to length(b)
      add(result[i], b[i], 0);
end;


procedure subtract(var result : TPolynom; const a, b : TPolynom);
var
  i, j : integer;
begin
  If length(a) = length(b) then begin
    i := length(a);
    while sravnenieRation(a[i], b[i]) = 0 then
      i := i - 1;
    for j := i  downto 0 do
      subtract(result[i], a[j], b[j]);
    end
  else
  For i := 0 to minint(length(a), length(b)) do
    subtract(result[i], a[i], b[i]);
  else
    For i := 0 to minint(length(a), length(b)) do
      subtract(result[i], a[i], b[i]);
    If length(a) > length(b) then
      For i := minint(length(a), length(b)) + 1 to length(a)
        subtract(result[i], a[i], 0);
    else
      If length(a) < length(b) then
        For i := minint(length(a), length(b)) + 1 to length (b)
          subtract(result[i], 0, b[i]);
end;


procedure mult(var result : TPolynom; const a, b : TPolynom);
var
  x, y : TRationalNumber;
  i, j : integer;
begin
  For i := 0 to length(a) + length(b) do begin
    result[i].numerator := strToNatural('0000');
    result[i].denominator := strToNatural('0001');
  For i := 0 to length(a) do
    for j := 0 to length(b) do begin
      mult(x, a[i], b[j]);
      y := result[i + j];
      add(result[i + j], x, y);
    end;

end;

procedure module(var result : TPolynom; const a, b : TPolynom);
begin

end;

procedure derivative(var result : TPolynom; const a : TPolynom);
begin
  For i := 1 to high(a) do
    mult(result[i - 1], strToNatural(i), a[i]);
end;
    }
end.






