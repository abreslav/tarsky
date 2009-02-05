unit Polynoms;

interface

uses
  Rationals, Naturals, CheckError;
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
function itIsNotZeroConst(TPolynom : TPolynom) : boolean;
procedure ChangePolynoms(var a, b : TPolynom);                              // a <--> b
procedure PolynomDivRat(var P : TPolynom; k : PRationalNumber);
implementation

{const
  cWord = 1 shl 16; }

procedure PolynomDivRat(var P : TPolynom; k : PRationalNumber);
var
  i : integer;
  TempPolynom : TRationalNumber;
begin
  for i := 0 to length(P) - 1 do begin
    TempPolynom := P[i]^;
    rationals.divide(P[i]^, TempPolynom, k^);
  end;
end;

//true - если оно пустое
function IsItEmptyPoly(const poly: TPolynom):boolean;
begin
  result := false;
  if length(poly) = 0 then result := true;
end;

//true - если ноль
function IsItNilPoly(poly: TPolynom):boolean;
var
  I: Integer;
begin
  result := false;
  for i := length(poly) - 1 downto 0 do begin
    if itisnotrzero(poly[i]^) then exit;
  end;
  result := true;
end;

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
    new(a[i]);
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
  for i := 0 to high(a) do
    toTRationalsNumber(a[i]^);
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
  if(IsItEmptyPoly(a)) or (IsItEmptyPoly(b)) then begin
     WriteErrorPolynoms('add');
     exit;
  end;
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

 if(IsItEmptyPoly(a)) or (IsItEmptyPoly(b)) then begin
     WriteErrorPolynoms('subtract');
     exit;
  end;
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


function initzero() : PrationalNumber;
begin
  result := intToPRat(0);
end;


procedure mult(var result : TPolynom; const a, b : TPolynom);
var
  i, j : integer;
  m : TRationalNumber;
begin
  if(IsItEmptyPoly(a)) or (IsItEmptyPoly(b)) then begin
    WriteErrorPolynoms ('mult');
    exit;
  end;
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


function deg(const a : Tpolynom) : integer;
begin
  {if length(a) = 0 then begin
    result := -1;
    exit;
  end;
  if (length(a) = 1) and (length(a[0]^.numerator) = 1) and (a[0]^.numerator[0] = 0) then begin
    result := -1;
    exit;
  end;}
  result := length(a) - 1;
  {if (length(a) = 1) and not itisnotRzero(a[0]^) then
    result := -1;}
end;


function MaxKoef(const a : Tpolynom) : TrationalNumber;
begin
  result := a[deg(a)]^;
end;

procedure makepolynom(var result : Tpolynom; const Koef : TRationalNumber; const D : Integer);
var
  i : integer;
begin
  setlength(result, D + 1);
  for i := 0 to deg(result) - 1 do begin
    new(result[i]);
    result[i] := initzero;
  end;
  new(result[deg(result)]);
  rationals.CopyRationals(result[deg(result)]^, Koef);
end;


procedure step(var a : Tpolynom; const b : Tpolynom);
var
  sos1, sos2 : TPolynom;
  help : TRationalNumber;
begin
  rationals.divide(help, MaxKoef(a), MaxKoef(b));
  MakePolynom(sos1, help, Deg(a) - Deg(b));
  Polynoms.mult(sos2, sos1, b);
  Polynoms.subtract(sos1, a, sos2);
  polynoms.CopyPolynoms(a, sos1);
end;




procedure module(var result : TPolynom; const a, b : TPolynom);
begin
  if length(b) = 1 then begin
    setlength(result, 1);
    result[0] := initzero();
    exit;
  end;
  copypolynoms(result, a);
  while deg(result) >= deg(b) do begin
    step(result, b);
  end;
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





procedure derivative(var result : TPolynom; const a : TPolynom);
var
  i : integer;
begin
  if IsItEmptyPoly(a) then begin
    WriteErrorPolynoms('derevative');
     exit;
  end;
  if length(a) = 1 then begin
    SetLength(result, 1);
    result[0] := initZero;
    exit;
  end;
  setlength(result, (length(a) - 1));
  for i := 0 to (length(result) - 1) do begin
    new(result[i]);
    rationals.mult(result[i]^, a[i + 1]^, IntToPRat(i + 1)^);
  end;
end;



end.
