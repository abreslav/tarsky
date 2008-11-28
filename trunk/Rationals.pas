unit Rationals;

interface

uses
  Naturals;

type
  (*
   * Рациональное число со знаком
   *   Numerator   - числитель
   *   Denominator - знаменатель
   * Всегда верно, что НОД(числитель, знаменатель) = 1
   * Если число равно нулю, то числитель равен нулю, а
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




implementation

var
  tempNum1, tempNum2 : TNaturalNumber;
  signNum : TnumberSign = nsPlus;




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
        nsMinus: naturals.subtract(result.Numerator, signNum, tempNum1, tempNum2);
        nsPlus: naturals.add(result.Numerator, tempNum1, tempNum2);
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

end;

procedure mult(var result : TRationalNumber; const a, b : TRationalNumber);
begin
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (a.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Numerator);
  naturals.mult(result.Denominator, a.Denominator, b.Denominator);
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
end;

procedure divide(var result : TRationalNumber; const a, b : TRationalNumber);
begin
  signNum := nsPlus;
  if (a.sign = nsPlus) xor (a.sign = nsPlus) then
    result.sign := nsMinus
  else
    result.sign := nsPlus;
  naturals.mult(result.Numerator, a.Numerator, b.Denominator);
  naturals.mult(result.Denominator, a.Denominator, b.Numerator);
  naturals.gcd(tempNum1, result.Denominator, result.Numerator);
  naturals.divide(result.Denominator, tempNum2, result.Denominator, tempNum1);
  naturals.divide(result.Numerator, tempNum2, result.Numerator, tempNum1);
end;

end.
