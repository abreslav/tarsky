unit Rationals;

interface

uses
  Naturals;

type
  (*
   * ������������ ����� �� ������
   *   Numerator   - ���������
   *   Denominator - �����������
   * ������ �����, ��� ���(���������, �����������) = 1
   * ���� ����� ����� ����, �� ��������� ����� ����, �
   * ����������� ����� �������.
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
