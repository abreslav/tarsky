unit Rationals;

interface

uses
  Naturals, checkError;

type
  (*
   * –ациональное число со знаком
   *   Numerator   - числитель
   *   Denominator - знаменатель
   * ¬сегда верно, что Ќќƒ(числитель, знаменатель) = 1
   * ≈сли число равно нулю, то числитель равен нулю, а
   * знаменатель равен единице.
   *)
  TRationalNumber = record
    Sign : TNumberSign;
    Numerator,
    Denominator : TNaturalNumber;
  end;
  PRationalNumber = ^TRationalNumber;

procedure add(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
procedure mult(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
procedure divide(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);

function itIsNotRZero(const TRNumber : TRationalNumber) : boolean;  //false - если ноль
procedure toTRationalsNumber(var a : TRationalNumber; abbrev : integer = 0);
function CompareRationals(const a, b : TRationalNumber) : Integer;
procedure ChangeRationals(var a, b : TRationalNumber);
procedure CopyRationals(var a : TRationalNumber; const b : TRationalNumber);  // a <-- b
function intToPRat(K : Integer) : PRationalNumber;
procedure disposeRational(var a : TRationalNumber);

implementation
uses
  statistic;


var
  tempNum1, tempNum2 : TNaturalNumber;
  signNum : TnumberSign = nsPlus;





//сравненивание 2 рациональных чисел
function CompareRationals(const a, b : TRationalNumber) : Integer;  //(-1) -> a > b; 0 -> a = b; 1 -> a < b
var
  x, y : TNaturalNumber;
  s : Integer;
begin
  Naturals.Mult(x, a.numerator, b.denominator);
  Naturals.Mult(y, b.numerator, a.denominator);
  s := ord(a.sign) - ord(b.sign);
  if s <> 0 then
    Result := s
  else
    Result := CompareNaturals(x, y) * ((-2) * ord(a.sign) + 1);
  disposeNatural(x);
  disposeNatural(y);
end;

//a <--> b
procedure ChangeRationals(var a, b : TRationalNumber);
begin
  ChangeNumberSigns(a.sign, b.sign);
  ChangeNaturals(a.numerator, b.numerator);
  ChangeNaturals(a.denominator, b.denominator);
end;


// a <-- b
procedure CopyRationals(var a : TRationalNumber; const b : TRationalNumber);
begin
  a.sign := b.sign;
  CopyNaturals(a.numerator, b.numerator);
  CopyNaturals(a.denominator, b.denominator);
end;


procedure disposeRational(var a : TRationalNumber);
begin
  disposeNatural(a.Numerator);
  disposeNatural(a.Denominator);
end;




function intToPRat(K : Integer) : PRationalNumber;
const
  cWord = 1 shl 16;
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
end;

//false - если ноль
function itIsNotRZero(const TRNumber : TRationalNumber) : boolean;
begin
  if itIsNotZero(TRNumber.Numerator) then
    result := true
  else
    result := false;
end;






procedure toTRationalsNumber(var a : TRationalNumber; abbrev : integer = 0);
var
  temp, temp2 : TNaturalNumber;
begin
  if not itIsNotZero(a.Numerator) then
    a.sign := nsPlus;
  if abbrev = 1 then begin
    naturals.gcd(temp, a.Denominator, a.Numerator);
    if (length(temp) = 1) and (temp[0] = 1) then
      exit;
    naturals.divide(a.Denominator, temp2, a.Denominator, temp);
    naturals.divide(a.Numerator, temp2, a.Numerator, temp);
  end;

end;

procedure oldAdd(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
begin
  disposeNatural(tempNum1);
  disposeNatural(tempNum2);
  signNum := nsPlus;
  naturals.mult(tempNum1, a.Numerator, b.Denominator);
  naturals.mult(tempnum2, a.Denominator, b.Numerator);
  case a.sign of
    nsPlus:
    case b.sign of
      nsPlus: naturals.add(result.Numerator, tempNum1, tempNum2);
      nsMinus: naturals.subtract(result.Numerator, signNum, tempNum1, tempNum2);
    end;
    nsMinus: begin
      case b.sign of
        nsPlus: naturals.subtract(result.Numerator, signNum, tempNum1, tempNum2);
        nsMinus: naturals.add(result.Numerator, tempNum1, tempNum2);
      end;
      if signNum = nsPlus then
        signNum := nsMinus
      else
        signNum := nsPlus;
    end;
  end;
  naturals.mult(result.Denominator, a.Denominator, b.Denominator);
  result.sign := signNum;

  toTRationalsNumber(result, abbrev);
end;

procedure add(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
var
  tempA, tempB : TRationalNumber;
  bA, bB : boolean;
begin
  firstRationalsAdd;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyRationals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyRationals(tempB, b)
  end else
    tempB := b;
  disposeRational(result);
  oldAdd(result, tempA, tempB, abbrev);
  if bA then
    disposeRational(tempA);
  if bB then
    disposeRational(tempB);

  closeRationalsAdd;
end;




procedure oldSubtract(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
begin
  disposeNatural(tempNum1);
  disposeNatural(tempNum2);
  signNum := nsPlus;
  naturals.mult(tempNum1, a.Numerator, b.Denominator);
  naturals.mult(tempnum2, a.Denominator, b.Numerator);
  case a.sign of
    nsPlus:
    case b.sign of
      nsMinus: naturals.add(result.Numerator, tempNum1, tempNum2);
      nsPlus: naturals.subtract(result.Numerator, signNum, tempNum1, tempNum2);
    end;
    nsMinus: begin
      case b.sign of
        nsMinus: begin
          naturals.subtract(result.Numerator, signNum, tempNum1, tempNum2);
          if signNum = nsPlus then
            signNum := nsMinus
          else
            signNum := nsPlus;
        end;
        nsPlus: begin
          naturals.add(result.Numerator, tempNum1, tempNum2);
          signNum := nsMinus;
        end;
      end;
    end;
  end;
  naturals.mult(result.Denominator, a.Denominator, b.Denominator);
  result.sign := signNum;

  toTRationalsNumber(result, abbrev);
end;

procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
var
  tempA, tempB : TRationalNumber;
  bA, bB : boolean;
begin
  firstRationalsSubtract;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyRationals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyRationals(tempB, b)
  end else
    tempB := b;
  disposeRational(result);
  oldSubtract(result, tempA, tempB, abbrev);
  if bA then
    disposeRational(tempA);
  if bB then
    disposeRational(tempB);

  closeRationalsSubtract;
end;


procedure oldMult(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
begin
  disposeNatural(tempNum1);
  disposeNatural(tempNum2);
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (b.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Numerator);
  naturals.mult(result.Denominator, a.Denominator, b.Denominator);

  toTRationalsNumber(result, abbrev);
end;

procedure mult(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
var
  tempA, tempB : TRationalNumber;
  bA, bB : boolean;
begin
  firstRationalsMult;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyRationals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyRationals(tempB, b)
  end else
    tempB := b;
  disposeRational(result);
  oldMult(result, tempA, tempB, abbrev);
  if bA then
    disposeRational(tempA);
  if bB then
    disposeRational(tempB);

  closeRationalsMult;
end;



procedure oldDivide(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
begin
  if  not(itIsNotRZero(b)) then begin
    writeErrorRationals('Divide');
    exit;
  end;
  disposeNatural(tempNum1);
  disposeNatural(tempNum2);
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (b.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Denominator);
  naturals.mult(result.Denominator, a.Denominator, b.Numerator);

  toTRationalsNumber(result, abbrev);
end;

procedure divide(var result : TRationalNumber; const a, b : TRationalNumber; abbrev : integer = 1);
var
  tempA, tempB : TRationalNumber;
  bA, bB : boolean;
begin
  firstRationalsDivide;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyRationals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyRationals(tempB, b)
  end else
    tempB := b;
  disposeRational(result);
  oldDivide(result, tempA, tempB, abbrev);
  if bA then
    disposeRational(tempA);
  if bB then
    disposeRational(tempB);
    
  closeRationalsDivide;
end;


end.
