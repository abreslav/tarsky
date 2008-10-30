unit TestingUtils;

interface

uses
  Naturals;

function strToNatural(s : string) : TNaturalNumber;

implementation

function chartoInt(c : char) : integer;
begin
  if c in['A'..'Z'] then
    result := ord(c) - ord('A') + 10
  else
    result := ord(c) - ord('0');
end;

function strtonatural(s : string) : TNaturalNumber;
var
  i, j : integer;
  w : word;
begin
  setlength(result, length(s) div 4);
  for i := 0 to (length(s) div 4) - 1 do begin
    w := 0;
    for j := 1 to 4 do begin
      w := w * 16;
      w := w + charToInt(s[4 * i + j]);
    end;
    result[i] := w;
  end;
end;


end.
