unit Polynoms;

interface

uses
  Rationals;

type
  (*
   * ������� �� ����� ����������
   * p[k] - ����������� ��� x^k
   * ��������: ������������ ���������� � ���� (������ ������� - ����)
   *)
  TPolynom = array of PRationalNumber;

procedure add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);

implementation

procedure add(var result : TPolynom; const a, b : TPolynom);
begin

end;

procedure subtract(var result : TPolynom; const a, b : TPolynom);
begin

end;

procedure mult(var result : TPolynom; const a, b : TPolynom);
begin

end;

procedure module(var result : TPolynom; const a, b : TPolynom);
begin

end;

procedure derivative(var result : TPolynom; const a : TPolynom);
begin

end;

end.
