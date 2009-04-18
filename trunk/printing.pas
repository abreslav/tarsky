unit printing;

interface
uses
  polynoms,
  naturals,
  ConstructionSignTable,
  rationals;

type
  TTable = array of array of string;

  function polytostring(const p : TPolynom) : string;
  procedure printtofile(const a : TTable; var f : textfile);

implementation

procedure printpolynom(const s : string; var f : textfile);
var
  i : integer;
begin
  for i := 1 to (length(s)) do begin
    write(f, s[i]);
  end;
end;

procedure printstring(const a : TTable; var f : textfile; num : integer);
var
  i : integer;
begin
  for i := 1 to length(a[num - 1]) do begin
    write(f, '<td align="center">');
    printpolynom(a[num - 1][i - 1], f);
    writeln(f, '</td>');
  end;
end;

procedure printtofile(const a : TTable; var f : textfile);
var
  i : integer;
begin
  writeln(f, '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251"/><title>Алгоритм Тарского</title></head>');
  writeln(f, '<body><h3>Таблица знаков для полиномов насыщенной системы:</h3>');
  writeln(f, '<table border="1" style="border-color:black;" cellspacing="0" cellpadding="4">');
  for i := 1 to length(a) do begin
    if firstPolynomIndex(i - 1) then
      writeln(f, '<tr style="color: #000040; background: #C4C4B6;">')
    else
      writeln(f, '<tr>');
    printstring(a, f, i);
    writeln(f, '</tr>');
  end;
  write(f, '</table></body></HTML>');
end;

function naturaltointeger(const n : TNaturalNumber) : integer;    // Натуральное маленькое
begin
  result := n[0];
end;

function inttonat(const n : integer) : TNaturalNumber;
begin
  setlength(result, 1);
  result[0] := n;
end;

function natmod10(n : TNaturalNumber) : integer;
var
  nafignado : TNaturalNumber;
  resultnatural : TNaturalNumber;
begin
  naturals.divide(nafignado, resultnatural, n, inttonat(10));
  result := naturaltointeger(resultnatural);
end;

function natdiv10(n : TNaturalNumber) : TNaturalNumber;
var
  nafignado : TNaturalNumber;
begin
  naturals.divide(result, nafignado, n, inttonat(10));
end;

function inttochar(n : integer) : char;
begin
  case n of
    0 : result := '0';
    1 : result := '1';
    2 : result := '2';
    3 : result := '3';
    4 : result := '4';
    5 : result := '5';
    6 : result := '6';
    7 : result := '7';
    8 : result := '8';
    9 : result := '9';
  end;
end;

procedure reverse(var s : string);
var
  i : integer;
  c : char;
begin
  for i := 1 to length(s) div 2 do begin
    c := s[i];
    s[i] := s[length(s) - i + 1];
    s[length(s) - i + 1] := c;
  end;
end;

function naturaltostring(n : TNaturalNumber) : string;
var
  i : integer;
begin
  setlength(result, 0);
  i := 1;
  while (n[0] > 0) or (length(n) > 1) do begin
    setlength(result, length(result) + 1);
    result[i] := inttochar(natmod10(n));
    n := natdiv10(n);
    i := i + 1;
  end;
  reverse(result);
end;

function rationaltostring(const r : TRationalnumber) : string;
begin
  if (r.denominator[0] = 1) and (length(r.denominator) = 1) then begin
    if (r.Numerator[0] = 1) and (length(r.numerator) = 1) then begin
      if r.sign = nsminus then
        result := '- '
      else
        result := '';
      exit;
    end;
    result := naturaltostring(r.numerator);
    if r.sign = nsminus then
      result := '- ' + result;
    exit;
  end;
  result := naturaltostring(r.numerator) + '/';
  result := result + naturaltostring(r.denominator);
  if r.sign = NSminus then begin
    result := '- ' + result;
  end;
end;

function integertostring(const a : integer) : string;
var
  n : TNaturalNumber;
begin
  setlength(n, 1);
  n[0] := a;
  result := naturaltostring(n);
end;

function mononomtostring(const koeff : TRationalNumber; const degree : integer) : string;
begin
  if (length(koeff.numerator) = 1) and (koeff.numerator[0] = 0) then begin
    result := '';
    exit;
  end;

  if degree = 0 then begin
    result := rationaltostring(koeff);
    exit;
  end;

  if degree = 1 then begin
    if ((length(koeff.numerator) = 1) and (length(koeff.denominator) = 1) and (koeff.numerator[0] = 1) and (koeff.Denominator[0] = 1)) then begin
      result := rationaltostring(koeff);
      result := result + 'x';
      exit;
    end;
    result := rationaltostring(koeff);
    result := result + ' * x';
    exit;
  end;

  if ((length(koeff.numerator) = 1) and (length(koeff.denominator) = 1) and (koeff.numerator[0] = 1) and (koeff.Denominator[0] = 1)) then begin
    result := rationaltostring(koeff);
    result := result + 'x^';
    result := result + integertostring(degree);
    exit;
  end;
  result := rationaltostring(koeff);
  result := result + ' * x^';
  result := result + integertostring(degree);
end;

function polytostring(const p : TPolynom) : string;
var
  i : integer;
begin
  if (length(p) = 1) and (length(p[0]^.denominator) = 1) and (p[0]^.denominator[0] = 1) and (length(p[0]^.numerator) = 1) and ((p[0]^.numerator[0] = 1) or (p[0]^.numerator[0] = 0)) then begin
    case p[0]^.numerator[0] of
      0 : begin
        result := '0';
        exit;
      end;
      1 : begin
        if p[0]^.sign = NSPlus then begin
          result := '+';
          exit;
        end
        else begin
          result := '-';
          exit;
        end;
      end;
    end;
  end;

  i := length(p) - 1;
  result := mononomtostring(p[i]^, i);
  if length(p) = 1 then begin
    exit;
  end;

  for i := length(p) - 2 downto 0 do begin
    case p[i]^.sign of
      NSMinus : begin
        if mononomtostring(p[i]^, i) <> '' then
          result := result + ' ' + mononomtostring(p[i]^, i);
      end;
      NSPlus : begin
        if mononomtostring(p[i]^, i) <> '' then
          result := result + ' + ' + mononomtostring(p[i]^, i);
      end;
    end;
  end;
  if ((length(p[0]^.numerator) = 1) and (length(p[0]^.denominator) = 1) and (p[0]^.numerator[0] = 1) and (p[0]^.Denominator[0] = 1)) then begin
    result := result + '1';
  end;
end;

end.
