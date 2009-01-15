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

procedure add(var result : TRationalNumber; const a, b : TRationalNumber);
procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber);
procedure mult(var result : TRationalNumber; const a, b : TRationalNumber);
procedure divide(var result : TRationalNumber; const a, b : TRationalNumber);

function itIsNotRZero(const TRNumber : TRationalNumber) : boolean;  //false - если ноль
procedure toTRationalsNumber(var a : TRationalNumber);
function CompareRationals(const a, b : TRationalNumber) : Integer;
procedure ChangeRationals(var a, b : TRationalNumber);
procedure CopyRationals(var a : TRationalNumber; const b : TRationalNumber);  // a <-- b

implementation

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
  a. sign := b.sign;
  CopyNaturals(a.numerator, b.numerator);
  CopyNaturals(a.denominator, b.denominator);
end;


//false - если ноль
function itIsNotRZero(const TRNumber : TRationalNumber) : boolean;
begin
  if itIsNotZero(TRNumber.Numerator) then
    result := true
  else
    result := false;
end;



procedure toTRationalsNumber(var a : TRationalNumber);
begin
  if not itIsNotZero(a.Numerator) then
    a.sign := nsPlus;
end;

procedure add(var result : TRationalNumber; const a, b : TRationalNumber);
begin
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
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
  result.sign := signNum;
  toTRationalsNumber(result);
end;




procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber);
begin
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
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
  result.sign := signNum;
  toTRationalsNumber(result);
end;



procedure mult(var result : TRationalNumber; const a, b : TRationalNumber);
begin
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (b.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Numerator);
  naturals.mult(result.Denominator, a.Denominator, b.Denominator);
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
  toTRationalsNumber(result);
end;



procedure divide(var result : TRationalNumber; const a, b : TRationalNumber);
begin
  if  not(itIsNotRZero(b)) then begin
    writeErrorRationals('Divide');
    exit;
  end;
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (b.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Denominator);
  naturals.mult(result.Denominator, a.Denominator, b.Numerator);
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
  toTRationalsNumber(result);

end;

end.
