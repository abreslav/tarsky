unit Polynoms;

interface

uses
  Rationals,
  TestingUtils;
type
  (*
   * Полином от одной переменной
   * p[k] - коэффициент при x^k
   * ВНИМАНИЕ: Коэффициенты нумеруются с нуля (ячейки массива - тоже)
   *)
  TPolynom = array of PRationalNumber;

procedure add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);

implementation

procedure add(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  For i := 0 to minint(length(a), length(b)) do
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

end.
