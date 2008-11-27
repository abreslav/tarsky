unit TestingUtils;

interface

uses
  Naturals;

function strToNatural(s : string) : TNaturalNumber;
function sravneniye(a, b : TNaturalNumber) : integer;           // Выдает -1, если первый аргумент меньше, 0, если равно и 1, если больше
procedure WriteNumber(const a : TNaturalNumber);                // Пишет число БЕЗ writeln
procedure writeLnNumber(const a : TNaturalNumber);              // Пишет число с переводом строчки после написания
function  minint(a, b : integer) : integer;
function  maxint(a, b : integer) : integer;
{function sravneniyeRation(const a, b : TRationalNumber) : integer; }
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
    result[(length(s) div 4) - i - 1] := w;
  end;
end;

function sravneniye(a, b : TNaturalNumber) : integer;
var
  i : integer;
begin
  if length(a) < length(b) then
    setlength(a, length(b));
  if length(b) < length(a) then
    setlength(b, length(a));
  for i := (length(a) - 1) downto 0 do begin
    if a[i] > b[i] then begin
      result := 1;
      exit;
    end;
    if a[i] < b[i] then begin
      result := -1;
      exit;
    end;
  end;
  result := 0;
end;

{ function sravneniyeRation(a, b : TRationalNumber) : integer;
begin
  If (sravneniye(a.numerator, b.numerator) = 0) and (sravneniye(a.Denominator, b.Denominator) = 0)
    then
      result := 0
    else
      result := 1;
end; }

procedure writenumber(const a : TNaturalNumber);
var
  i : integer;
begin
  for i := (length(a) - 1) downto 0 do begin
    write(a[i]);
    write(' ');
  end;
end;

procedure writelnnumber(const a : TNaturalNumber);
begin
  writenumber(a);
  writeln;
end;

function  minint(a, b : integer) : integer;
begin
  If a < b then result := a
  else
    result := b;
end;

function  maxint(a, b : integer) : integer;
begin
  If a > b then result := a
  else
    result := b;
end;
end.

