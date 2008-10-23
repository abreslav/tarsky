unit Polynoms;

interface

uses
  Rationals;

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
