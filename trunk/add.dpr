program p;

{$APPTYPE CONSOLE}
{$Q+,R+}

type
  TNaturalNumber = array of Word;

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

var
 a, b, c : TNaturalNumber;
 i : Integer;
begin
 setlength(a, 2);
 setlength(b, 3);
 a[0] := 100;
 a[1] := 10;
 b[0] := 200;
 b[1] := 20;
 b[2] := 2;
 add(c, a, b);
 for i := length(c) - 1 downto 0 do
   WriteLn(c[i]);
 ReadLn;
end.
