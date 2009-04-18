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
procedure disposeNatural(var a : TNaturalNumber);



//------------------------------------------------------
implementation
uses
  statistic;

procedure disposeNatural(var a : TNaturalNumber);
begin
  setLength(a, 0);
end;



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
  disposeNatural(x);
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

 //исправляет нули в начале.
procedure toNaturals(var n : TNaturalNumber);
var
  i, l : integer;
begin
  l := 0;
  for i := length(n) - 1 downto 0 do begin
    if n[i] = 0 then
      inc(l)
    else
      break;
  end;

  if l = 0 then
    exit;

  l := length(n) - l;
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



function TNaturatToInt(n : TNaturalNumber) : cardinal;
const
  cWord = 65536; //1 shl 16
begin
  result := n[0];
  if length(n) > 1 then
    result := result + n[1] * cWord;
end;




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
 // k := k mod 16;
  k := k and 15;
  for i := h to l + h do begin
    //f := (a[i] shl k + t) mod (1 shl 16);
    f := (a[i] shl k + t) and 65535;
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

procedure oldAdd(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin
  if length(a) > length(b) then begin
    internaladd(result, a, b);
  end else begin
    internaladd(result, b, a);
  end;
  toNaturals(result);
end;


procedure Add(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  tempA, tempB : TNaturalNumber;
  bA, bB : boolean;
begin
  firstNaturalsAdd;
  
  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyNaturals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyNaturals(tempB, b)
  end else
    tempB := b;
  disposeNatural(result);
  oldAdd(result, tempA, tempB);
  if bA then
    disposeNatural(tempA);
  if bB then
    disposeNatural(tempB);

  closeNaturalsAdd;
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
      //break;
    end;
  end;
  SetLength(result, t + 1);
  if carry = 0 then
    sign := nsPlus
  else
    sign := nsMinus;
end;



procedure oldSubtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
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

procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
var
  tempA, tempB : TNaturalNumber;
  bA, bB : boolean;
begin
  firstNaturalsSubtract;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyNaturals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyNaturals(tempB, b)
  end else
    tempB := b;
  disposeNatural(result);
  oldSubtract(result, sign, tempA, tempB);
  if bA then
    disposeNatural(tempA);
  if bB then
    disposeNatural(tempB);

  closeNaturalsSubtract;
end;
//-------------------------------

{Q-} {R-}

procedure InternalMult(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  i, j, l, p, m : Cardinal;
  //result : TNaturalNumber;
begin
  SetLength(result, length(a) + length(b));
  for i := 0 to length(a) + length(b) - 1 do
    Result[i] := 0;
  for i := 0 to high(b) do begin
    for j := 0 to high(a) do begin
      p := b[i] * a[j] + Result[i + j];
      m := p and ((1 shl 16) - 1);
      Result[i + j] := m ;
      m := (p - m) shr 16;
      l := 1;                             
      while m <> 0 do begin
        p := Result[i + j + l] + m;
        m := p and ((1 shl 16) - 1);
        Result[i + j + l] := m;
        m := (p - m) shr 16;
        l := l + 1;
      end;
    end;
  end;
{  l := 1;
  for i := length(a) + length(b) - 1 downto 0 do
    if ResultTemp[i] <> 0 then begin
      l := i + 1;
      break;
    end;  
  SetLength(resultTemp, l);
  result := resultTemp;}
end;


procedure oldMult(var result : TNaturalNumber; const a, b : TNaturalNumber);
begin
  if length(a) >= length(b) then
    internalMult(result, a, b)
  else
    internalMult(result, b, a);
  toNaturals(result);
end;



procedure Mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  tempA, tempB : TNaturalNumber;
  bA, bB : boolean;
begin
  firstNaturalsMult;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyNaturals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyNaturals(tempB, b)
  end else
    tempB := b;
  disposeNatural(result);
  oldMult(result, tempA, tempB);
  if bA then
    disposeNatural(tempA);
  if bB then
    disposeNatural(tempB);

  closeNaturalsMult;
end;




function maxWord(const a : TNaturalNumber) : Cardinal;
begin
  result := a[length(a) - 1];
end;




function AboutDivide(const a, b : TNaturalNumber; var l : integer) : Cardinal;  //a должно быть больше либо равно b
const
  cWord = 65536;
var
  k, kNew : Cardinal;
begin

  if length(b) = 2 then  begin
    k := b[1] shl 16 + b[0];
    kNew := a[length(a) - 1] shl 16 + a[length(a) - 2];
    k := kNew div k;
    if k <> 0 then begin
      if k < cWord then
        l := length(a) - 2
      else begin
        l := length(a) - 1;
        k := k shr 16;
      end;
      result := k;
      exit;
    end;
  end;

  if length(b) = 1 then begin
    k := b[0];
    if length(a) <= 1 then
      kNew := a[0]
    else
      kNew := a[length(a) - 1] shl 16 + a[length(a) - 2];
    k := kNew div k;
      if length(a) = 1 then begin
        result := k;
        l := 0;
        exit;
      end;

      if k < cWord then
        l := length(a) - 2
      else begin
        l := length(a) - 1;
        k := k shr 16;
      end;
      result := k;
      exit;
  end;




  if length(a) = length(b) then begin
    l := 0;
    if maxWord(a) = maxWord(b) then
      result := 1
    else
      result := maxWord(a) div (maxWord(b) + 1);
  end else begin
    if maxWord(a) > maxWord(b) then begin
      l := length(a) - length(b);
      result := maxWord(a) div (maxWord(b) + 1);
    end else begin
      l := length(a) - length(b) -  1;
      k := maxWord(a) shl 16 + a[length(a) - 2];
      result :=  k div (maxWord(b) + 1);
    end;
  end;




end;

function aboutDivideNatural(const a, b : TNaturalNumber) : TNaturalNumber;
var
  l, k, i : integer;
begin

  k := aboutDivide(a, b, l);
  setLength(result, l + 1);
  for i := 0 to l - 1 do
    result[i] := 0;
  result[l] := k;

end;



procedure shlWordNatural(var a : TNaturalNumber; n : integer);
var
  i : integer;
begin
  if n = 0 then
    exit;
  setLength(a, length(a) + n);
  for i := length(a) - 1 downTo  n do
    a[i] := a[i - n];
  for i := 0 to n - 1 do
    a[i] := 0;
end;




procedure oldDivide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
var
  x : TNaturalNumber;
  temp : TNaturalNumber;
  k, l, i : integer;
  sign : TNumberSign;
begin


  if length(a) >= length(b) then
    setLength(result, length(a) - length(b) + 1)
  else begin
    setLength(result, 1);
    result[0] := 0;
    copyNaturals(module, a);
    exit;
  end;

  for i := 0 to length(result) - 1 do
    result[i] := 0;

  copyNaturals(x, a);

 { while compareNaturals(x, b) <= 0 do begin
    k := AboutDivide(x, b, l);
    setlength(temp, l + 1);
      for i := 0 to l - 1 do
        temp[i] := 0;
    temp[l] := k;
    add(result, result, temp);
    mult(temp, temp, b);
    subtract(x, sign, x, temp);
  end;  }


  while compareNaturals(x, b) <= 0 do begin
    k := AboutDivide(x, b, l);
    setlength(temp, 1);
    temp[0] := k;

    mult(temp, temp, b);

    shlWordNatural(temp, l);
    subtract(x, sign, x, temp);

    setlength(temp, l + 1);
      for i := 0 to l - 1 do
        temp[i] := 0;
    temp[l] := k;
    add(result, result, temp);
  end;









  copyNaturals(module, x);

  toNaturals(result);
  toNaturals(module);
  disposeNatural(x);
end;


procedure Divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
var
  tempA, tempB : TNaturalNumber;
  bA, bB : boolean;
begin
  firstNaturalsDivide;

  bA := false;
  bB := false;
  if (addr(a) = addr(result)) or (addr(a) = addr(module)) then begin
    bA := true;
    copyNaturals(tempA, a);
  end else
    tempA := a;
  if (addr(b) = addr(result)) or (addr(b) = addr(module)) then begin
    bB := true;
    copyNaturals(tempB, b);
  end else
    tempB := b;
  disposeNatural(result);
  disposeNatural(module);
  oldDivide(result, module, tempA, tempB);
  if bA then
    disposeNatural(tempA);
  if bB then
    disposeNatural(tempB);

  closeNaturalsDivide;
end;





//----------------------------------------------------
procedure oldGcd(var result : TNaturalNumber;const a, b : TNaturalNumber);
var
  t, l : TNaturalNumber;
  k : Integer;
  s : TNumberSign;
begin

  CopyNaturals(result, a);
  if CompareNaturals(a, b) = 0 then
    exit;
  if (length(b) = 1) and (b[0] = 0) then begin
    CopyNaturals(result, a);
    exit;
  end;
  if (length(a) = 1) and (a[0] = 0) then begin
    CopyNaturals(result, b);
    exit;
  end;
  CopyNaturals(t, b);
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
      shrNN(l);
      if s = nsplus then
        CopyNaturals(result, l)
      else begin
        CopyNaturals(t, l);
      end;
    end;
  shlNN(result, k);
  toNaturals(result);
end;


procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);
var
  tempA, tempB : TNaturalNumber;
  bA, bB : boolean;
begin
  firstNaturalsGCD;

  bA := false;
  bB := false;
  if addr(a) = addr(result) then begin
    bA := true;
    copyNaturals(tempA, a)
  end else
    tempA := a;
  if addr(b) = addr(result) then begin
    bB := true;
    copyNaturals(tempB, b)
  end else
    tempB := b;
  disposeNatural(result);
  oldGcd(result, tempA, tempB);
  if bA then
    disposeNatural(tempA);
  if bB then
    disposeNatural(tempB);

  closeNaturalsGCD;
end;



end.

