unit FullSys;

interface

uses
  Naturals,
  Rationals,
  Polynoms;

type
  PPolynom = ^TPolynom;
  TPolynomSystem = array of PPolynom;
  TCountResults = array of Integer;
  TTable = array of array of Boolean;
  TDerivativeArray = array of Boolean;
  TPolynomPosition = array of Integer;  //pos[3] = 5 -> третий полином по возрастанию на 5 месте в TPolynomSystem

procedure CompleteSystem(var a : TPolynomSystem);                            //построение насыщенной системы

function search(var a : TPolynomSystem; const t : TPolynom; var pos : TPolynomPosition) : Integer;  //поиск полинома в отсортированном массиве
procedure SetPolynomPositionWhenStarted(var pos : TPolynomPosition; const s : Integer);
procedure sort(var a : TPolynomSystem; l, r : Integer; var pos : TPolynomPosition);
procedure QSort(var a : TPolynomSystem; l, r, h : Integer; var pos : TPolynomPosition);

implementation

const
  h = 0;

// p1 <--> p2
procedure ChangePolynomPositions(var p1, p2 : Integer);
var
  s : Integer;
begin
  s := p1;
  p1 := p2;
  p2 := s;
end;

//a <-- b

procedure CopyPolynomSystemsWhenStarted(var a : TPolynomSystem; const b : TPolynomSystem);
var
  i : Integer;
begin
  SetLength(a, length(b));
  for i := 0 to length(b) - 1 do begin
    New(a[i]);
    CopyPolynoms(a[i]^, b[i]^);
  end;
end;

procedure CopyPolynomSystemsInTheEnd(var a : TPolynomSystem; const mid : TPolynomSystem; const pos : TPolynomPosition; const s : Integer);
var
  i : Integer;
begin
  SetLength(a, s);
  for i := 0 to s - 1 do begin
    New(a[i]);
    CopyPolynoms(a[i]^, mid[pos[i]]^);
  end;

end;

//дихотомический поиск элемента в отсортированном массиве
function search(var a : TPolynomSystem; const t : TPolynom; var pos : TPolynomPosition) : Integer;
var
  l, r, m, c : Integer;
begin
  l := 0;
  r := length(a) - 1;
  Result := -1;
  while l <= r do begin
    m := (l + r) shr 1;
    c := ComparePolynoms(a[pos[m]]^, t);
    if c = -1 then
      r := m - 1
    else if c = 1 then
      l := m + 1
    else begin
      Result := m;
      exit;
    end;
  end;
end;

//сортировка вставками
procedure sort(var a : TPolynomSystem; l, r : Integer; var pos : TPolynomPosition);
var
  i, j, h : Integer;
  t : Integer;
begin
  for i := l + 1 to r do begin
    t := pos[i];
    h := 0;
    for j := i - 1 downto l do
      if ComparePolynoms(a[pos[j]]^, a[t]^) = -1 then
        pos[j + 1] := pos[j]
      else begin
        pos[j + 1] := t;
        h := 1;
        break;
      end;
    if h = 0 then
      pos[l] := t;
  end;
end;

//сортировка относительно элемента
procedure Partition(var a : TPolynomSystem; l, r : Integer; var m : Integer; var pos : TPolynomPosition);
var
  i, bar : Integer;
begin
  ChangePolynomPositions(pos[m], pos[l]);
  bar := r;
  while ComparePolynoms(a[pos[bar]]^, a[pos[l]]^) = -1 do
    bar := bar - 1;
  if bar = l then
    bar := l - 1;
  for i := bar - 1 downto l do
    if ComparePolynoms(a[pos[i]]^, a[pos[l]]^) <= 0 then begin
      ChangePolynomPositions(pos[bar], pos[i]);
      bar := bar - 1;
    end;
  m := bar + 1;
end;

//сортировка qsort
procedure QSort(var a : TPolynomSystem; l, r, h : Integer; var pos : TPolynomPosition);
var
  m : Integer;
begin
  if r - l <= h then begin
    sort(a, l, r, pos);
    exit;
  end;
  m := random(r - l + 1) + l;
  Partition(a, l, r, m, pos);
  QSort(a, l, m - 1, h, pos);
  QSort(a, m + 1, r, h, pos);
end;

//подсчет колличества степеней полиномов
procedure CountDegrees(const a : TPolynomSystem; var c : TCountResults);
var
  l, m, i, m0, j : Integer;
begin
  l := length(a);
  m := l;
  SetLength(c, m);
  for i := 1 to m - 1 do
    c[i] := 0;
  for i := 0 to l - 1 do begin
    if length(a[i]^) > m then begin
      m0 := m;
      while length(a[i]^) > m do
        m := m + m0;
      for j := m0 to m - 1 do
        c[i] := 0;
    end;
    c[length(a[i]^) - 1] := c[length(a[i]^) - 1] + 1;
  end;
  for i := m - 1 to 0 do
    if c[i] <> 0 then begin
      SetLength(c, i + 1);
      Break;
    end;
end;

//подсчет наибольшего из возможных колличества полиномов
function CountPolynoms(var c : TCountResults) : Integer;
var
  l, i, k, j : Integer;
begin
  l := length(c);
  for i := l - 2 to 0 do begin
    c[i] := c[i] + c[i + 1];
    k := 0;
    for j := i + 1 to l - 1 do
      k := k + c[j];
    c[i] := c[i] + k * c[i + 1];
  end;
  Result := 0;
  for i := 1 to l - 1 do
    Result := Result + c[i];
end;

//формирование таблички и заполнение ее нулями
procedure FalseTable(var f : TTable; k : Integer);
var
  i, j : Integer;
begin
  SetLength(f, k);
  for i := 0 to k - 1 do
    SetLength(f[i], k);
  for i := 0 to k - 1 do
    for j := 0 to k - 1 do
      f[i, j] := false;
end;

//формирование массива и заполнение нулями
procedure FalseArray(var der : TDerivativeArray; k : Integer);
var
  i : Integer;
begin
  SetLength(der, k);
  for i := 0 to k - 1 do
    der[i] := false;
end;

//формирование массива позиций, запись первых нескольких
procedure SetPolynomPositionWhenStarted(var pos : TPolynomPosition; const s : Integer);
var
  i : Integer;
begin
  SetLength(pos, s);
  for i := 0 to s - 1 do
    pos[i] := i;
end;

//проверка насыщенности системы по производной
function IsAllDerivative(const der : TDerivativeArray; const s : Integer) : Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to s - 1 do
    if der[i] = false then begin
      Result := i;
      exit;
    end;
end;

//проверка насыщенности системы по остатку от деленияб в середине процесса
procedure IsAllModule(const f : TTable; const s : Integer; var stitch, column : Integer);
var
  i, j : Integer;
begin
  stitch := -1;
  for i := 0 to s - 1 do
    for j := 0 to i - 1 do begin
      if f[i, j] = false then begin
        stitch := i;
        column := j;
        exit;
      end;
    end;
end;

procedure GetFullModule(var mid : TPolynomSystem; var s : Integer; var modflags : TTable; var pos : TPolynomPosition);
var
  i, j, k : Integer;
  p : TPolynom;
begin
  IsAllModule(modflags, s, i, j);
  while i <> -1 do begin
    k := ComparePolynoms(mid[i]^, mid[j]^);
    if k = 1 then
      ChangePolynomPositions(i, j);  //позиции полиномов  - не причем, требуется обмен Integer
    Module(p, mid[i]^, mid[j]^);
    if search(mid, p, pos) = -1 then begin
      mid[s]^ := p;
      pos[s] := s;
      s := s + 1;
      QSort(mid, 0, s - 1, h, pos);
    end else
      if i < j then begin
        ChangePolynomPositions(i, j);  //позиции полиномов  - не причем, требуется обмен Integer
        modflags[i, j] := true;
      end;
    IsAllModule(modflags, s, i, j);
  end;
end;


//построение насыщенной системы
procedure CompleteSystem(var a : TPolynomSystem);
var
  c : TCountResults;
  modflags : TTable;
  der : TDerivativeArray;
  pos : TPolynomPosition;
  mid : TPolynomSystem;
  full : Boolean;
  k, s, i, j : Integer;
  poly : TPolynom;
begin
  s := length(a);
  CopyPolynomSystemsWhenStarted(mid, a); //далее разбираемся с mid
  CountDegrees(mid, c);                  //считаем колличество каждой степени
  k := CountPolynoms(c);                 //находим наиб. возможное число полиномов
  SetPolynomPositionWhenStarted(pos, k); //формируем pos
  QSort(mid, 0, s - 1, h, pos);//сортируем mid
  SetLength(mid, k);
  FalseArray(der, k);
  FalseTable(modflags, k);
  GetFullModule(mid, s, modflags, pos);
  while not full do begin
    full := true;
    i := IsAllDerivative(der, s);
    while i <> -1 do begin
      Derivative(poly, mid[i]^);
      if (search(mid, poly, pos) = -1) and (length(poly) > 1) then begin
        full := false;
        Break;
      end else
        der[i] := true;
      i := IsAllDerivative(der, s);
    end;
    if full then
      BREAK;
    mid[s]^ := poly;
    pos[s] := s;
    s := s + 1;
    QSort(mid, 0, s - 1, h, pos);
    GetFullModule(mid, s, modflags, pos);
  end;



  CopyPolynomSystemsInTheEnd(a, mid, pos, s);
  //надо перевести из 'mod' в 'a'!!!!


end;



end.
