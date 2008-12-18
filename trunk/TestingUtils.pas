unit TestingUtils;
interface

uses
  Naturals,
  SysUtils,
  Polynoms,
  Rationals;

function StrToNatural(s : string) : TNaturalNumber; function sravneniye(a, b : TNaturalNumber) : integer;           // Выдает -1, если первый аргумент меньше, 0, если равно и 1, если больше
procedure WriteNumber(const a : TNaturalNumber);                // Пишет число БЕЗ writeln
procedure WriteLnNumber(const a : TNaturalNumber);              // Пишет число с переводом строчки после написания
procedure WritePolynom(const a : TPolynom);                     // Выписывает полином
procedure WriteLnPolynom(const a : TPolynom);                   // Выписывает полином и переводит строку
procedure CopyPolynom(var a : TPolynom; const b : TPolynom);    // Присваивает первому полиному значение второго
procedure Format10To16Write(const x: TNaturalNumber);           // Получает TNaturalNumber, выводит в 16ричной сис-ме счисления
function StrToRational(const a : string) : TRationalNumber;     // Из строки делает рациональное число. Вида '-'16ричное число'/'16ричное число или без '-' в начале
function StrToPolynom(const a : string) : TPolynom;             // Из строки вида рациональное' 'рациональное итд (рациональное как в пред. процедуре) делает многочлен начиная со старшего члена
procedure WriteRatNumber(const a : TRationalNumber);            // Пишет рациональное число
function Sravneniye_Polynoms(const a, b : TPolynom) : integer;  // 0 если равны и 1 в обратном случае

implementation
procedure Format10to16write(const x: TNaturalNumber);
var
  i: Integer;
begin
  for i := (length(x) - 1) downto 0 do begin
    Write(Format('%04x', [x[i]]));
  end;
end;

procedure WriteRatNumber(const a : TRationalNumber);
var
  i : Integer;
begin
  if a.sign = nsMinus then
    Write('-');
  WriteNumber(a.numerator);
  Write('/');
  WriteNumber(a.denominator);
end;

function CharToInt(c : Char) : Integer;
begin
  case UpCase(c) of
    'A'..'Z': Result := ord(c) - ord('A') + 10;
    '0'..'9': Result := ord(c) - ord('0');
    else WriteLn('Error in sample string: char ''' + c + ''' is not allowed');
  end;
end;

function StrToNatural(s : string) : TNaturalNumber;
var
  i, j : Integer;
  w : Word;
begin
  SetLength(Result, length(s) div 4);
  for i := 0 to (length(s) div 4) - 1 do begin
    w := 0;
    for j := 1 to 4 do begin
      w := w * 16;
      w := w + CharToInt(s[4 * i + j]);
    end;
    Result[(length(s) div 4) - i - 1] := w;
  end;
end;

function Sravneniye(a, b : TNaturalNumber) : Integer;
var
  i : Integer;
begin
  if length(a) < length(b) then
    SetLength(a, length(b));
  if length(b) < length(a) then
    SetLength(b, length(a));
  for i := (length(a) - 1) downto 0 do begin
    if a[i] > b[i] then begin
      Result := 1;
      Exit;
    end;
    if a[i] < b[i] then begin
      Result := -1;
      Exit;
    end;
  end;
  Result := 0;
end;

procedure WriteNumber(const a : TNaturalNumber);
var
  i : Integer;
begin
  for i := (length(a) - 1) downto 0 do begin
    Write(a[i]);
    Write(' ');
  end;
end;

procedure WriteLnNumber(const a : TNaturalNumber);
begin
  WriteNumber(a);
  WriteLn;
end;

procedure WritePolynom(const a : TPolynom);
var
  i : Integer;
begin
  for i := (length(a) - 1) downto 0 do begin
    WriteRatNumber(a[i]^);
    Write('* X^');
    Write(i);
    if i <> 0 then
      Write(' + ');
  end;
end;

procedure WriteLnPolynom(const a : TPolynom);
begin
  WritePolynom(a);
  WriteLn;
end;

procedure CopyPolynom(var a : TPolynom; const b : TPolynom);
var
  i : Integer;
begin
  SetLength(a, length(b));
  for i := 0 to (length(b) - 1) do begin
    a[i] := b[i];
  end;
end;

function StrToRational(const a : string) : TRationalNumber;
var
  i : Integer;
  stroka, x, y : string;
  h : Char;
begin
  if a[1] = '-' then begin
    Result.sign := nsMinus;
    SetLength(stroka, length(a) - 1);
    for i := 1 to length(a) - 1 do begin
      stroka[i] := a[i + 1];
    end;
  end else begin
    stroka := a;
    Result.sign := nsPlus;
  end;
  i := 1;
  SetLength(x, length(stroka));
  while (i <= length(stroka)) and(stroka[i] <> '/') do begin
    x[i] := stroka[i];
    i := i + 1;
  end;
  i := i - 1;
  SetLength(x, i);
  i := i + 2;
  SetLength(y, length(a));
  while i <= length(stroka) do begin
    //h := stroka[i];
    //stroka[i] := h;
    y[i - length(x) - 1] := stroka[i];
    i := i + 1;
  end;
  SetLength(y, length(stroka) - length(x) - 1);
  Result.numerator := StrToNatural(x);
  Result.denominator := StrToNatural(y);
end;

function StrToPolynom(const a : string) : TPolynom;
var
  i, j, length_p, deg, l_res : Integer;
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
      length_p := length_p + 1;
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

function VarSravneniye_Polynoms(var a, b : TPolynom) : Integer;
var
  i : Integer;
begin
  if length(a) > length(b) then begin
    for i := (length(a) - 1) to length(b) do begin
      if (length(a[i]^.numerator) <> 1) or (a[i]^.numerator[0] <> 0) then begin
        Result := 1;
        Exit;
      end;
      SetLength(a, length(b));
    end;
  end;
  if length(b) > length(a) then begin
    for i := (length(b) - 1) to length(a) do begin
      if (length(b[i]^.numerator) <> 1) or (b[i]^.numerator[0] <> 0) then begin
        Result := 1;
        Exit;
      end;
      SetLength(b, length(a));
    end;
  end;
  for i := 0 to (length(a) - 1) do begin
    if (a[i]^.sign <> b[i]^.sign) or (a[i]^.numerator <> b[i]^.numerator) or (a[i]^.denominator <> b[i]^.denominator) then begin
      Result := 1;
      Exit;
    end;
  end;
  Result := 0;
end;

function Sravneniye_Polynoms(const a, b : TPolynom) : Integer;
var
  x, y : TPolynom;
begin
  CopyPolynom(x, a);
  CopyPolynom(y, b);
  VarSravneniye_Polynoms(x, y);
end;

end.
