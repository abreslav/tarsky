unit Rationals;

interface

uses
  Naturals, checkError;

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

function itIsNotRZero(PRNumber : TRationalNumber) : boolean;
function MinusNil(var a:TRationalNumber):boolean;
procedure NoMinusNils(var a:TRationalNumber);
function CompareRationals(const a, b : TRationalNumber) : Integer;



implementation

var
  tempNum1, tempNum2 : TNaturalNumber;
  signNum : TnumberSign = nsPlus;


//сравненивание 2 рациональных чисел
function CompareRationals(const a, b : TRationalNumber) : Integer;
var
  x, y : TNaturalNumber;
  s : Integer;
begin
  Naturals.Mult(x, a.numerator, b.denominator);
  Naturals.Mult(y, b.numerator, a.denominator);
  s := ord(b.sign) - ord(a.sign);
  if s <> 0 then
    Result := s
  else
    Result := CompareNaturals(y, x) * (2 * ord(a.sign) - 1);
end;


function itIsNotRZero(PRNumber : TRationalNumber) : boolean;
begin
  if itIsNotZero(PRNumber.Numerator) then
    result := true
  else
    result := false;
end;

function MinusNil(var a:TRationalNumber):boolean;
var
  i, j: Integer;
begin
  result := true;
  if a.sign = nsPlus then begin
    result := false;
    exit;
  end;
  if length(a.numerator) = 0 then exit;
  i := length(a.numerator) - 1;
  for j := i downto 0 do begin
    if a.numerator[i] <> 0 then i := - 10;
  end;
  if i <> -10 then exit;
  result := false;
end;

procedure NoMinusNils(var a:TRationalNumber);
begin
  if MinusNil(a) then a.sign := nsPlus;
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
  NoMinusNils(result);
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
  NoMinusNils(result);
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
  NoMinusNils(result);
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
  NoMinusNils(result);

end;

end.
