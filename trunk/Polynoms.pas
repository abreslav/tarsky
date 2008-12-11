 unit Polynoms;

interface

uses
  Rationals, Naturals;
type
  (*
   * ������� �� ����� ����������
   * p[k] - ����������� ��� x^k
   * ��������: ������������ ���������� � ���� (������ ������� - ����)
   *)
  TPolynom = array of PRationalNumber;

procedure Add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);
function initzero() : PRationalNumber;
function toPolynoms(step, koef : integer) : TPolynom;
function ComparePolynoms(const a, b : TPolynom) : Integer;//(-1) -> a > b; 0 -> a = b; 1 -> a < b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
implementation

var
  zero : PRationalNumber;


const
  cWord = 1 shl 16;


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



function itIsNotZero(PNumber : TNaturalNumber) : boolean;
var
  i : integer;
begin
  result := false;
  if PNumber = nil then
    exit;
  if (length(PNumber) = 1) and  (PNumber[0] = 0) then
      exit;
  result := true;
end;

function itIsNotRZero(PRNumber : PRationalNumber) : boolean;
begin
  if (PRNumber <> nil) and itIsNotZero(PRNumber^.Numerator) then
    result := true
  else
    result := false;
end;



function itIsNotZeroConst(TPolynom : TPolynom) : boolean;
begin
  if (length(TPolynom) = 1) and itIsNotRZero(TPolynom[0]) then
    result := true
  else
    result := false;
end;


procedure DeleteNils(var a : Tpolynom);
var
  i : integer;
begin                                  
  while (length(a) > 1) and (not itIsNotRZero(a[length(a) - 1])) do begin
    setlength(a, length(a) - 1);
  end;
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

// a <-- b
procedure CopyRationals(var a : TRationalNumber; const b : TRationalNumber);
begin
  a. sign := b.sign;
  CopyNaturals(a.numerator, b.numerator);
  CopyNaturals(a.denominator, b.denominator);
end;

//a <-- b
procedure CopyPolynoms(var a : TPolynom; const b : TPolynom);
var
  l, i : Integer;
begin
  l := length(b);
  SetLength(a, l);
  for i := 0 to l - 1 do
    CopyRationals(a[i]^, b[i]^);
end;

//��������� 2 �����������
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
    while (a[i - 1] - b[i - 1] = 0) and (i >= 0) do
      i := i - 1;
    if i < 0 then
      Result := 0
    else
      Result := 2 * ord(a[i] < b[i]) - 1;
  end;
end;


//������������� 2 ������������ �����
function CompareRationals(const a, b : TRationalNumber) : Integer;
var
  x, y : TNaturalNumber;
  s : Integer;
begin
  Naturals.Mult(x, a.numerator, b.denominator);
  Naturals.Mult(y, b.numerator, a.denominator);
  s := ord(b.sign) - ord(a.sign);
  if s <> 0 then
    Result := s
  else
    Result := CompareNaturals(y, x) * ord(a.sign);
end;

//��������� 2 ���������
function ComparePolynoms(const a, b : TPolynom) : Integer;
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
    while (CompareRationals(a[i - 1]^, b[i - 1]^) = 0) and (i >= 0) do
      i := i - 1;
    if i < 0 then
      Result := 0
    else
      Result := CompareRationals(a[i]^, b[i]^);
  end;
end;



procedure add(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  setlength(result, maxint(length(a), length(b)));
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to  minint(length(a) - 1, length(b) - 1) do begin
    Rationals.Add(result[i]^, a[i]^, b[i]^);
  end;
  if Length(a) > length(b) then
    for i := length(b) to Length(a) - 1 do
      result[i]^ := a[i]^
  else
    for i := length(a) to Length(b) - 1 do
      result[i]^ := b[i]^;
  DeleteNils(result);
end;


procedure subtract(var result : TPolynom; const a, b : TPolynom);
var
  i : integer;
begin
  setlength(result, maxint(length(a), length(b)));
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to  minint(length(a) - 1, length(b) - 1) do begin
    Rationals.Subtract(result[i]^, a[i]^, b[i]^);
  end;
  if Length(a) > length(b) then
    for i := length(b) to Length(a) - 1 do
      result[i]^ := a[i]^
  else
    for i := length(a) to Length(b) - 1 do begin
      result[i]^ := b[i]^;
      if result[i]^.Sign = nsPlus then
        result[i]^.Sign := nsMinus
      else
        result[i]^.Sign := nsPlus
    end;
  DeleteNils(result);
end;



procedure varmodule(var result, a, b : TPolynom);
var
  maxdeg_first, maxdeg_second : integer;
  x : TPolynom;
begin
  maxdeg_first := length(a) - 1;
  maxdeg_second := length(b) - 1;
  if maxdeg_first < maxdeg_second then begin
    CopyPolynoms(result, a);
    exit;
  end;
  CopyPolynoms(x, a);
  subtract(a, x, b);
  varmodule(result, a, b);
end;

procedure module(var result : TPolynom; const a, b : TPolynom);
var
  x, y : TPolynom;
begin
  CopyPolynoms(x, a);
  CopyPolynoms(y, b);
  varmodule(result, x, y);
end;

function intToPRat(K : Integer) : PRationalNumber;
var
  i : integer;
begin
  new(result);
  if k >= 0 then
    result^.Sign := nsPlus
  else begin
    result^.Sign := nsMinus;
    k := -k;
  end;
  setlength(result^.Denominator, 1);
  result^.Denominator[0] := 1;
  setlength(result^.Numerator, (k div cWord) + 1);
  for i := 0 to (k div cWord) do begin
    result^.Numerator[i] := k mod cWord;
    k := k div cWord;
  end;
end;


function initzero() : PrationalNumber;
begin
  result := intToPRat(0);
end;


function toPolynoms(step, koef : integer) : TPolynom;
var
  i : integer;
begin
  setlength(result, step + 1);
  for i := 0 to step - 1 do
    result[i] := initzero;
  result[i] := intToPRat(koef);
end;





procedure mult(var result : TPolynom; const a, b : TPolynom);
var
  i, j : integer;
  m : TRationalNumber;
begin
  setlength(result, length(a) + length(b) - 1);
  for i := 0 to length(result) - 1 do
    new(result[i]);
  for i := 0 to length(result) - 1 do
    result[i] := initzero;
  for i := 0 to length(a) - 1 do begin
    for j := 0 to length(b) - 1 do begin
      rationals.mult(m, a[i]^, b[j]^);
      rationals.add(result[i + j]^, result[i + j]^, m);
    end;
  end;
  DeleteNils(result);
end;

procedure derivative(var result : TPolynom; const a : TPolynom);
begin
end;


end.






