unit TestingUtils;

interface

uses
  Naturals;

function strToNatural(s : string) : TNaturalNumber;

implementation

function chartoInt(c : char) : integer;
begin
  case UpCase(c) of
    'A'..'Z': result := ord(c) - ord('A') + 10;
    '0'..'9': result := ord(c) - ord('0');
    else WriteLn('Error in sample string: char ''' + c + ''' is not allowed');
  end;
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
