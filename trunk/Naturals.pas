unit Naturals;

interface

type
  (*
   * Натуральное число (или ноль), хранимые в системе счисления с
   * основанием 2^32
   * Младшие разряды хранятся в ячейках с младшими номерами
   * ВНИМАНИЕ: Ячейки нумеруются с нуля
   *)
  TNaturalNumber = array of Cardinal;

  (*
   * Знак числа
   *)
  TNumberSign = (nsPlus, nsMinus);

procedure add(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);

implementation

procedure internalAdd(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  max, min, i, sum : Integer;
  carry : 0..1;
begin
  max := Length(a);
  min := Length(b);
  SetLength(result, max + 1);
  carry := 0;
  for i := 0 to min - 1 do begin
    sum := a[i] + b[i] + carry;
    result[i] := sum;
    carry := ord(sum > High(Word));
  end;
  for i := min to max - 1 do begin
    sum := a[i] + carry;
    result[i] := sum;
    carry := ord(sum > High(Word));
  end;
  if carry = 0 then
    setlength(result, max)
  else
    result[max] := 1;
end;

procedure add(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin
  if length(a) > length(b) then begin
    internaladd(result, a, b);
  end else begin
    internaladd(result, b, a);
  end;
end;

procedure internalsub(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
var
  max, min, i, sub, t : Integer;
  carry : 0..1;
begin
  max := Length(a);
  min := Length(b);
  SetLength(result, max);
  carry := 0;
  t := 0;
  for i := 0 to min - 1 do begin
    sub := a[i] - b[i] - carry;
    result[i] := (sub + 1 shl 16) mod (1 shl 16);
    carry := ord(sub < 0);
    if (sub + 1 shl 16) mod (1 shl 16) > 0 then
      t := i;
  end;
  for i := min to max - 1 do begin
    sub := a[i] - carry;
    result[i] := (sub + 1 shl 16) mod (1 shl 16);
    if (sub + 1 shl 16) mod (1 shl 16) > 0 then
      t := i;
    if sub >= 0 then begin
      carry := 0;
      break;
    end;
  end;
  SetLength(result, t + 1);
  if carry = 0 then
    sign := nsPlus
  else
    sign := nsMinus;
end;

procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
begin
  if length(a) > length(b) then begin
    internalSub(result, sign, a, b);
  end else begin
    internalSub(result, sign, b, a);
    sign := nsMinus;
  end;
end;

procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin

end;

procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
begin

end;

procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin

end;

end.
