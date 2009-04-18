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

procedure Add(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
procedure subtract(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
procedure mult(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
procedure module(var result : TPolynom; const a, b : TPolynom; abbrev : Integer = 1);
procedure derivative(var result : TPolynom; const a : TPolynom; abbrev : Integer = 1);
function initzero() : PRationalNumber;
function ComparePolynoms(const a, b : TPolynom) : Integer;//(-1) -> a > b; 0 -> a = b; 1 -> a < b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
procedure toPolynom(var a : TPolynom; abbrev : integer = 1);
function itIsNotZeroConst(const TPolynom : TPolynom) : boolean;
procedure ChangePolynoms(var a, b : TPolynom);                              // a <--> b
procedure PolynomDivRat(var P : TPolynom; const k : PRationalNumber);
procedure disposePolynom(var a : TPolynom);

procedure notSign(var s : TNumberSign);
function signToInt(s : TNumberSign) : integer;
procedure CountInTRational(var result : TRationalnumber; const p : Tpolynom; const x : TRationalnumber; abbrev : integer = 1);

implementation
uses
  statistic;












procedure disposePolynom(var a : TPolynom);
var
  i : integer;
begin
  for i := 0 to length(a) - 1 do begin
    disposeRational(a[i]^);
    dispose(a[i]);
  end;
  setlength(a, 0);
end;


function CompareMemPolynom(const newR : TPolynom; const a : TPolynom) : boolean;
begin
  result := false;
  if length(newR) = 0 then
    exit;
  if length(newR) <> length(a) then
    exit;
  if addr(a[0]) = addr(newR[0]) then
    result := true;
end;



procedure PolynomDivRat(var P : TPolynom; const k : PRationalNumber);
var
  i : integer;
begin
  for i := 0 to length(P) - 1 do begin
    rationals.divide(P[i]^, P[i]^, k^);
  end;
end;




function signToInt(s : TNumberSign) : integer;
begin
  case s of
    nsPlus: result := 1;
    nsMinus: result := -1;
  end;
end;





//true - если оно пустое
function IsItEmptyPoly(const poly: TPolynom):boolean;
begin
  result := false;
  if length(poly) = 0 then
    result := true;
end;

//true - если ноль
function IsItNilPoly(const poly: TPolynom):boolean;
var
  I: Integer;
begin
  result := false;
  for i := length(poly) - 1 downto 0 do begin
    if itisnotrzero(poly[i]^) then
      exit;
  end;
  result := true;
end;

function  minint(a, b : integer) : integer;
begin
  If a < b then
    result := a
  else
    result := b;
end;

function  maxint(a, b : integer) : integer;
begin
  If a > b then
    result := a
  else
    result := b;
end;


function itIsNotZeroConst(const TPolynom : TPolynom) : boolean;
begin
  if (length(TPolynom) <> 1) or itIsNotRZero(TPolynom[0]^) then
    result := true
  else
    result := false;
end;

//a <-- b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
var
  l, i : Integer;
begin
  a := nil;
  l := length(b);
  SetLength(a, l);
  for i := 0 to l - 1 do begin
    new(a[i]);
    CopyRationals(a[i]^, b[i]^);
  end;
end;


procedure toPolynom(var a : TPolynom; abbrev : integer = 1);
var
  i, k : integer;
begin
  k := length(a) - 1;
  while (k > 0) and not(itIsNotRZero(a[k]^)) do
    k := k - 1;
  for i := k + 1 to length(a) - 1 do begin
    disposeRational(a[i]^);
    dispose(a[i]);
  end;

  setLength(a, k + 1);
  for i := 0 to high(a) do
    toTRationalsNumber(a[i]^, abbrev);
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
  disposePolynom(a);
  CopyPolynoms(a, b);
  disposePolynom(b);
  CopyPolynoms(b, x);
  disposePolynom(x);
end;

procedure oldAdd(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
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
    Rationals.Add(result[i]^, a[i]^, b[i]^, 0);
  end;
  if Length(a) > length(b) then
    for i := length(b) to Length(a) - 1 do
      result[i]^ := a[i]^
  else
    for i := length(a) to Length(b) - 1 do
      result[i]^ := b[i]^;

  toPolynom(result, abbrev);
end;

procedure add(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
var
  tempA, tempB : TPolynom;
  bA, bB : boolean;
begin
  firstPolynomsAdd;

  bA := false;
  bB := false;
  if CompareMemPolynom(result, a) then begin
    bA := true;
    copyPolynoms(tempA, a)
  end else
    tempA := a;
  if CompareMemPolynom(result, b) then begin
    bB := true;
    copyPolynoms(tempB, b)
  end else
    tempB := b;

  if bA or bB then
    disposePolynom(result)
  else
    setLength(result, 0);

  oldAdd(result, tempA, tempB, abbrev);
  if bA then
    disposePolynom(tempA);
  if bB then
    disposePolynom(tempB);

  closePolynomsAdd;
end;


procedure oldSubtract(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
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
    Rationals.Subtract(result[i]^, a[i]^, b[i]^, 0);
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
  toPolynom(result, abbrev);
end;


procedure subtract(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
var
  tempA, tempB : TPolynom;
  bA, bB : boolean;
begin
  firstPolynomsSubtract;

  bA := false;
  bB := false;
  if CompareMemPolynom(result, a) then begin
    bA := true;
    copyPolynoms(tempA, a)
  end else
    tempA := a;
  if CompareMemPolynom(result, b) then begin
    bB := true;
    copyPolynoms(tempB, b)
  end else
    tempB := b;

  if bA or bB then
    disposePolynom(result)
  else
    setLength(result, 0);

  oldSubtract(result, tempA, tempB, abbrev);
  if bA then
    disposePolynom(tempA);
  if bB then
    disposePolynom(tempB);

  closePolynomsSubtract;
end;


function initzero() : PrationalNumber;
begin
  result := intToPRat(0);
end;


procedure oldMult(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
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
    result[i] := initzero;

  for i := 0 to length(a) - 1 do begin
    for j := 0 to length(b) - 1 do begin
      rationals.mult(m, a[i]^, b[j]^, 0);
      rationals.add(result[i + j]^, result[i + j]^, m, 0);
    end;
  end;
  toPolynom(result, abbrev);
  disposeRational(m);
end;


procedure mult(var result : TPolynom; const a, b : TPolynom; abbrev : integer = 1);
var
  tempA, tempB : TPolynom;
  bA, bB : boolean;
begin
  firstPolynomsMult;

  bA := false;
  bB := false;
  if CompareMemPolynom(result, a) then begin
    bA := true;
    copyPolynoms(tempA, a)
  end else
    tempA := a;
  if CompareMemPolynom(result, b) then begin
    bB := true;
    copyPolynoms(tempB, b)
  end else
    tempB := b;

  if bA or bB then
    disposePolynom(result)
  else
    setLength(result, 0);

  oldMult(result, tempA, tempB, abbrev);
  if bA then
    disposePolynom(tempA);
  if bB then
    disposePolynom(tempB);

  closePolynomsMult;
end;




function deg(const a : Tpolynom) : integer;
begin
  result := length(a) - 1;
end;


function MaxKoef(const a : Tpolynom) : TRationalNumber;
begin
  result := a[deg(a)]^;
end;

procedure makepolynom(var result : Tpolynom; const Koef : TRationalNumber; D : Integer);
var
  i : integer;
begin

  setlength(result, D + 1);
  for i := 0 to deg(result) - 1 do begin
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

  rationals.divide(help, MaxKoef(a), MaxKoef(b), 0);

  MakePolynom(sos1, help, Deg(a) - Deg(b));

  Polynoms.mult(sos2, sos1, b, 0);


  disposePolynom(sos1);
  Polynoms.subtract(sos1, a, sos2, 0);

  disposePolynom(a);
  polynoms.CopyPolynoms(a, sos1);

  disposePolynom(sos1);
  disposePolynom(sos2);
  disposeRational(help);

end;



procedure CountInTRational(var result : TRationalnumber; const p : Tpolynom; const x : TRationalnumber; abbrev : integer = 1);
var
  i, l : integer;
  tempT : TRationalnumber;
begin
  l := length(p);
  if l = 0 then
    Exit;
  Result := p[l - 1]^;
  for i := l - 2 downto 0 do begin
    Rationals.Mult(tempT, Result, x, 0);
    disposeRational(result);
    Rationals.Add(Result, tempT, p[i]^, 0);
    disposeRational(tempT);
  end;
  toTRationalsNumber(result, abbrev);
end;



procedure notSign(var s : TNumberSign);
begin
  if s = nsPlus then
    s := nsMinus
  else
    s := nsPlus;
end;





procedure oldModule(var result : TPolynom; const a, b : TPolynom; abbrev : Integer = 1);
var
  xTemp, yTemp : TRationalnumber;
begin

  if length(b) = 1 then begin
    setlength(result, 1);
    result[0] := initzero();
    exit;
  end;


  if length(b) = 2 then begin
    rationals.divide(xTemp, b[0]^, b[1]^, 0);
    notSign(xTemp.sign);
    setLength(result, 1);
    new(result[0]);
    CountInTRational(result[0]^, a, xTemp, 0);
    disposeRational(xTemp);
    exit;
  end;


  copyPolynoms(result, a);
  while deg(result) >= deg(b) do begin
    step(result, b);
  end;

    toPolynom(result, abbrev);
end;



procedure module(var result : TPolynom; const a, b : TPolynom; abbrev : Integer = 1);
var
  tempA, tempB : TPolynom;
  bA, bB : boolean;
begin
  firstPolynomsModule;

  bA := false;
  bB := false;
  if CompareMemPolynom(result, a) then begin
    bA := true;
    copyPolynoms(tempA, a)
  end else
    tempA := a;
  if CompareMemPolynom(result, b) then begin
    bB := true;
    copyPolynoms(tempB, b)
  end else
    tempB := b;

  if bA or bB then
    disposePolynom(result)
  else
    setLength(result, 0);

  oldModule(result, tempA, tempB, abbrev);
  if bA then
    disposePolynom(tempA);
  if bB then
    disposePolynom(tempB);

  closePolynomsModule;
end;








procedure oldDerivative(var result : TPolynom; const a : TPolynom; abbrev : Integer = 1);
var
  i : integer;
  p : PRationalNumber;
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
    p := IntToPRat(i + 1);
    rationals.mult(result[i]^, a[i + 1]^, p^, 0);
    disposeRational(p^);
    dispose(p);
  end;
  toPolynom(result, abbrev);
end;

procedure derivative(var result : TPolynom; const a : TPolynom; abbrev : Integer = 1);
var
  tempA : TPolynom;
  bA : boolean;
begin
  firstPolynomsDerivative;

  bA := false;
  if CompareMemPolynom(result, a) then begin
    bA := true;
    copyPolynoms(tempA, a)
  end else
    tempA := a;

  if bA then
    disposePolynom(result)
  else
    setLength(result, 0);

  oldDerivative(result, tempA, abbrev);
  if bA then
    disposePolynom(tempA);

  closePolynomsDerivative;
end;



end.

