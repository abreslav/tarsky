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

procedure add(var result : TRationalNumber; const a, b : TRationalNumber);
begin

end;

procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber);
begin

end;

procedure mult(var result : TRationalNumber; const a, b : TRationalNumber);
begin

end;

procedure divide(var result : TRationalNumber; const a, b : TRationalNumber);
begin

end;

end.
