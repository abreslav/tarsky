unit Naturals;



interface
type
  (*
   * Натуральное число (или ноль), хранимые в системе счисления с
   * основанием 2^32
   * Младшие разряды хранятся в ячейках с младшими номерами
   * ВНИМАНИЕ: Ячейки нумеруются с нуля
   *)
  TNaturalNumber = array of Word;

  (*
   * Знак числа
   *)
  TNumberSign = (nsPlus, nsMinus);

procedure add(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);
function itIsNotZero(const TNumber : TNaturalNumber) : boolean;
function CompareNaturals(const a, b : TNaturalNumber) : Integer;  // Выдает -1, если первый аргумент меньше, 0, если равно и 1, если больше
procedure toNaturals(var n : TNaturalNumber);
procedure ChangeNaturals(var a, b : TNaturalNumber);                          // a <--> b
procedure CopyNaturals(var a : TNaturalNumber; const b : TNaturalNumber);     // a <-- b
procedure ChangeNumberSigns(var a, b : TNumberSign);                          // a <--> b

//------------------------------------------------------
implementation


function max(a, b : integer) : integer;
begin
  if a > b then
    result := a
  else
    result := b;
end;

// a <--> b
procedure ChangeNaturals(var a, b : TNaturalNumber);
var
  x : TNaturalNumber;
begin
  CopyNaturals(x, a);
  CopyNaturals(a, b);
  CopyNaturals(b, x);
end;


//a <-- b
procedure CopyNaturals(var a : TNaturalNumber; const b : TNaturalNumber);
var
  l, i : Integer;
begin
  l := length(b);
  SetLength(a, l);
  for i := 0 to l - 1 do
    a[i] := b[i];
end;


// a <--> b
procedure ChangeNumberSigns(var a, b : TNumberSign);
var
  s : TNumberSign;
begin
  s := a;
  a := b;
  b := s;
end;


procedure toNaturals(var n : TNaturalNumber);
var
  i, l : integer;
begin
  l := length(n);
  for i := length(n) - 1 downto 0 do begin
    if n[i] = 0 then
      l := l - 1
    else
      break;
  end;

  setLength(n, max(l, 1));

end;



//сравнение 2 натуральных
function CompareNaturals(const a, b : TNaturalNumber) : Integer;
var
  l, i : Integer;
begin
  l := length(a) - length(b);
  if l < 0 then
    Result := 1
  else if l > 0 then
    Result := -1
  else begin
    i := length(a);
    while (i > 0) and (a[i - 1] - b[i - 1] = 0) do
      i := i - 1;
    if i = 0 then
      Result := 0
    else
      Result := 2 * ord(a[i - 1] < b[i - 1]) - 1;
  end;
end;


//false - если это ноль
function itIsNotZero(const TNumber : TNaturalNumber) : boolean;
begin
  result := false;
  if TNumber = nil then
    exit;
  if (length(TNumber) = 1) and  (TNumber[0] = 0) then
      exit;
  result := true;
end;

{function sravneniye(a, b : TNaturalNumber) : integer;
var
  i, tempResult : integer;
begin
  tempResult := - CompareNaturals(a, b);

  if length(a) < length(b) then
    setlength(a, length(b));
  if length(b) < length(a) then
    setlength(b, length(a));
  for i := (length(a) - 1) downto 0 do begin
    if a[i] > b[i] then begin
      result := 1;


  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

      exit;
    end;
    if a[i] < b[i] then begin
      result := -1;

  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

      exit;
    end;
  end;
  result := 0;

  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

end;  }

//-------------------------------------------------------------------------


procedure shrNN(var a : TNaturalNumber);
var
  l, i : Integer;
begin
  l := length(a) - 1;
  for i := 0 to l - 1 do
    a[i] := (a[i] shr 1) or ((a[i + 1] and 1) shl 15);
  a[l] := a[l] shr 1;
  if a[l] = 0 then
    SetLength(a, l);
end;

procedure shlNN(var a : TNaturalNumber; k : Integer);
var
  h, l, i, f, t : Integer;
begin
  h := k div 16;
  l := length(a);
  setlength(a, length(a) + h + 1);
  for i := l - 1 downto 0 do
    a[i + h] := a[i];
  for i := 0 to h - 1 do
    a[i] := 0;
  t := 0;
  k := k mod 16;
  for i := h to l + h do begin
    f := (a[i] shl k + t) mod (1 shl 16);
    t := a[i] shr (16 - k);
    a[i] := f;
  end;
  if a[l + h] = 0 then
    setlength(a, l + h);
end;


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
    result[i] := sum mod (1 shl 16);
    carry := ord(sum > High(Word));
  end;
  for i := min to max - 1 do begin
    sum := a[i] + carry;
    result[i] := sum mod (1 shl 16);
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
  toNaturals(result);
end;
//----------------------------------------------------
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
var
  k : Integer;
begin
  if length(a) >= length(b) then begin
    k := - CompareNaturals(a, b);
    if k = 1 then
      internalSub(result, sign, a, b)
    else if k = -1 then begin
      internalSub(result, sign, b, a);
      sign := nsMinus;
    end else begin
      setlength(result, 1);
      result[0] := 0;
    end;
  end else begin
    internalSub(result, sign, b, a);
    sign := nsMinus;
  end;
  toNaturals(result);
end;
//-------------------------------
{Q-} {R-}
procedure InternalMult(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  i, j, l, p, m : Cardinal;
  resultTemp : TNaturalNumber;
begin
  SetLength(resultTemp, length(a) + length(b));
  for i := 0 to length(a) + length(b) - 1 do
    ResultTemp[i] := 0;
  for i := 0 to high(b) do begin
    for j := 0 to high(a) do begin
      p := b[i] * a[j] + ResultTemp[i + j];
      m := p and ((1 shl 16) - 1);
      ResultTemp[i + j] := m ;
      m := (p - m) shr 16;
      l := 1;                             
      while m <> 0 do begin
        p := ResultTemp[i + j + l] + m;
        m := p and ((1 shl 16) - 1);
        ResultTemp[i + j + l] := m;
        m := (p - m) shr 16;
        l := l + 1;
      end;
    end;
  end;
  l := 1;
  for i := length(a) + length(b) - 1 downto 0 do
    if ResultTemp[i] <> 0 then begin
      l := i + 1;
      break;
    end;  
  SetLength(resultTemp, l);
  result := resultTemp;
end;


procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin
  if length(a) >= length(b) then
    internalMult(result, a, b)
  else
    internalMult(result, b, a);
  toNaturals(result);
end;

procedure makeA_B(var a : TNaturalNumber; const b : TNaturalNumber);
var
  i : integer;
begin
  SetLength(a, length(b));
  for i := 0 to (length(b) - 1) do begin
    a[i] := b[i];
  end;
end;

//----------------------------
procedure copy(var a : TNaturalNumber; const b : TNaturalNumber);
var
  i : integer;
begin
  SetLength(a, length(b));
  for i := 0 to (length(a) - 1) do begin
    a[i] := b[i];
  end;
end;

procedure vardivide(var result, module, a : TNaturalNumber; const b : TNaturalNumber);
var
  n : TNaturalNumber;
  x : TNumberSign;
  p : TNaturalNumber;
begin
  if CompareNaturals(a, b) = 1 then begin
    makeA_B(module, a);
    SetLength(result, 1);
    result[0] := 0;
    exit;
  end;
  SetLength(n, 1);
  n[0] := 1;
  if a[0] and 1 = 1 then begin
    shrNN(a);
    vardivide(result, module, a, b);
    shlNN(module, 1);
    shlNN(result, 1);
    makeA_B(p, module);
    add(module, p, n);
  end
  else begin
    shrNN(a);
    vardivide(result, module, a, b);
    shlNN(module, 1);
    shlNN(result, 1);
  end;
  if CompareNaturals(module, b) <= 0 then begin
    makeA_B(p, result);
    add(result, p, n);
    x := NsMinus;
    makeA_B(p, module);
    subtract(module, x, p, b);
  end;
end;

procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
var
  x : TNaturalNumber;
begin
  makeA_B(x, a);
  vardivide(result, module, x, b);
  toNaturals(result);
end;

//----------------------------------------------------
procedure gcd(var result : TNaturalNumber;const a, b : TNaturalNumber);
var
  t, l : TNaturalNumber;
  k : Integer;
  s : TNumberSign;
begin
  copy(result, a);
  if a = b then
    exit;
  if (length(b) = 1) and (b[0] = 0) then begin
    result := a;
    exit;
  end;
  if (length(a) = 1) and (a[0] = 0) then begin
    result := b;
    exit;
  end;
  copy(t, b);
  k := 0;
  while (result[0] and 1) or (t[0] and 1) = 0 do begin
    shrNN(result);
    shrNN(t);
    k := k + 1;
  end;
  while CompareNaturals(result, t) <> 0 do
    if result[0] and 1 = 0 then
      shrNN(result)
    else if t[0] and 1 = 0 then begin
      shrNN(t);
    end else begin
      subtract(l, s, result, t);
      if s = nsplus then
        result := l
      else begin
        t := l;
      end;
    end;
  shlNN(result, k);
  toNaturals(result);
end;



end.

