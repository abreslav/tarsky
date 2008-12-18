unit TestingUtils;
interface

uses
  Naturals,
  SysUtils,
  Polynoms,
  Rationals;

function strToNatural(s : string) : TNaturalNumber; function sravneniye(a, b : TNaturalNumber) : integer;           // Выдает -1, если первый аргумент меньше, 0, если равно и 1, если больше
procedure WriteNumber(const a : TNaturalNumber);                // Пишет число БЕЗ writeln
procedure writeLnNumber(const a : TNaturalNumber);              // Пишет число с переводом строчки после написания
procedure writePolynom(const a : TPolynom);                     // Выписывает полином
procedure CopyPolynom(var a : TPolynom; const b : TPolynom);    // Присваивает первому полиному значение второго
procedure Format10to16write(const x: TNaturalNumber);           // Получает TNaturalNumber, выводит в 16ричной сис-ме счисления
function StrToRational(const a : string) : TRationalNumber;     // Из строки делает рациональное число. Вида '-'16ричное число'/'16ричное число или без '-' в начале
function StrToPolynom(const a : string) : TPolynom;             // Из строки вида рациональное' 'рациональное итд (рациональное как в пред. процедуре) делает многочлен начиная со старшего члена
procedure writeratnumber(const a : TRationalNumber);            // Пишет рациональное число
function sravneniye_polynoms(const a, b : TPolynom) : integer;  // 0 если равны и 1 в обратном случае

implementation
procedure Format10to16write(const x: TNaturalNumber);
var
  i: Integer;
begin
  for i := (length(x) - 1) downto 0 do begin
    Write(Format('%04x', [x[i]]));
  end;
end;

procedure writeratnumber(const a : TRationalNumber);
var
  i : integer;
begin
  if a.sign = NSminus then
    write('-');
  writenumber(a.numerator);
  write('/');
  writenumber(a.denominator);
end;

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

procedure writepolynom(const a : TPolynom);
var
  i : integer;
begin
  for i := (length(a) - 1) downto 0 do begin
    writeratnumber(a[i]^);
    write('* X^');
    write(i);
    if i <> 0 then
      write(' + ');
  end;
end;

procedure copypolynom(var a : TPolynom; const b : TPolynom);
var
  i : integer;
begin
  SetLength(a, length(b));
  for i := 0 to (length(b) - 1) do begin
    a[i] := b[i];
  end;
end;

function StrToRational(const a : string) : TRationalNumber;
var
  i : integer;
  stroka, x, y : string;
  h : char;
begin
  if a[1] = '-' then begin
    result.sign := NSminus;
    setlength(stroka, length(a) - 1);
    for i := 1 to length(a) - 1 do begin
      stroka[i] := a[i + 1];
    end;
  end else begin
    stroka := a;
  end;
  i := 1;
  setlength(x, length(stroka));
  while (i <= length(stroka)) and(stroka[i] <> '/') do begin
    x[i] := stroka[i];
    i := i + 1;
  end;
  i := i - 1;
  setlength(x, i);
  i := i + 2;
  setlength(y, length(a));
  while i <= length(stroka) do begin
    //h := stroka[i];
    //stroka[i] := h;
    y[i - length(x) - 1] := stroka[i];
    i := i + 1;
  end;
  setlength(y, length(stroka) - length(x) - 1);
  result.numerator := strtonatural(x);
  result.denominator := strtonatural(y);
end;

function strtopolynom(const a : string) : TPolynom;
var
  i, j, length_p, deg, l_res : integer;
  s, p : string;
begin
  l_res := 0;
  SetLength(Result, l_res);
  deg := 0;
  i := length(a);
  SetLength(s, length(a));
  while i >= 1 do begin
    length_p := 0;
    while (i >= 1) and (a[i] <> ' ') do begin
      s[i] := a[i];
      Length_p := length_p + 1;
      i := i - 1;
    end;
    SetLength(p, length_p);
    for j := 1 to length_p do begin
      p[j] := a[i + j];
    end;
    l_res := l_res + 1;
    SetLength(Result, l_res);
    New(result[deg]);
    Result[deg]^ := StrToRational(p);
    deg := deg + 1;
    i := i - 1;
  end;
end;

function varsravneniye_polynoms(var a, b : TPolynom) : integer;
var
  i : integer;
begin
  if length(a) > length(b) then begin
    for i := (length(a) - 1) to length(b) do begin
      if (length(a[i]^.numerator) <> 1) or (a[i]^.numerator[0] <> 0) then begin
        result := 1;
        exit;
      end;
      setlength(a, length(b));
    end;
  end;
  if length(b) > length(a) then begin
    for i := (length(b) - 1) to length(a) do begin
      if (length(b[i]^.numerator) <> 1) or (b[i]^.numerator[0] <> 0) then begin
        result := 1;
        exit;
      end;
      setlength(b, length(a));
    end;
  end;
  for i := 0 to (length(a) - 1) do begin
    if (a[i]^.sign <> b[i]^.sign) or (a[i]^.numerator <> b[i]^.numerator) or (a[i]^.denominator <> b[i]^.denominator) then begin
      result := 1;
      exit;
    end;
  end;
  result := 0;
end;

function sravneniye_polynoms(const a, b : TPolynom) : integer;
var
  x, y : TPolynom;
begin
  copypolynom(x, a);
  copypolynom(y, b);
  varsravneniye_polynoms(x, y);
end;

end.
