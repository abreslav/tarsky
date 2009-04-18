unit FullSys;

interface

uses
  Naturals,
  Rationals,
  Polynoms;
  //stopolynom,
 // filestr; //TestingUtils;

type
  PPolynom = ^TPolynom;
  TPolynomSystem = array of PPolynom;
  TCountResults = array of Integer;
  TTable = array of array of Boolean;
  TDerivativeArray = array of Boolean;
  TPolynomPosition = array of Integer;  //pos[3] = 5 -> третий полином по возрастанию на 5 месте в TPolynomSystem

procedure CompleteSystem(var a : TPolynomSystem);                            //построение насыщенной системы

function search(var a : TPolynomSystem; const t : TPolynom; var pos : TPolynomPosition; s : Integer = -1) : Integer;
procedure SetPolynomPositionWhenStarted(var pos : TPolynomPosition; const s : Integer);
procedure sort(var a : TPolynomSystem; l, r : Integer; var pos : TPolynomPosition);
procedure QSort(var a : TPolynomSystem; l, r, h : Integer; var pos : TPolynomPosition);

//procedure CountDegrees(const a : TPolynomSystem; var c : TCountResults);
//function CountPolynoms(var c : TCountResults) : Integer;

implementation
uses
  New_Dispose;

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

procedure CopyPolynomSystemsWhenStarted(var a : TPolynomSystem; const b : TPolynomSystem; var s : Integer);
var
  i, j : Integer;
begin
  SetLength(a, length(b));
  i := 0;
  j := 0;
  while j < length(b) do begin
    if length(b[j]^) > 1 then begin
      New(a[i]);
      CopyPolynoms(a[i]^, b[j]^);
      disposePolynom(b[j]^);
      i := i + 1;
    end;
    j := j + 1;
  end;
  s := i;
  SetLength(a, s);
end;

procedure CopyPolynomSystemsInTheEnd(var a : TPolynomSystem; var mid : TPolynomSystem; var pos : TPolynomPosition; const s : Integer);
var
  i : Integer;
begin
  SetLength(a, s);
  for i := 0 to s - 1 do begin
    New(a[i]);
    CopyPolynoms(a[i]^, mid[pos[i]]^);
    disposePolynom(mid[pos[i]]^);
  end;
  setLength(mid, 0);
  setLength(pos, 0);

end;

//search2
function search2(var a : TPolynomSystem; const t : TPolynom; var pos : TPolynomPosition; s : Integer) : Integer;
var
  l, r, m, c : Integer;
begin
  l := 0;
  r := s - 1;
  if ComparePolynoms(a[pos[l]]^, t) = -1 then begin
    Result := 0;
    Exit;
  end;
  while l < r do begin
    m := (l + r) div 2;
    c := ComparePolynoms(a[pos[m]]^, t);
    if c = -1 then r := m
    else if c = 1 then l := m + 1
    else begin
      Result := -1;
      Exit;
    end;
  end;
  m := (l + r) div 2;
  c := ComparePolynoms(a[pos[m]]^, t);
  if c = -1 then Result := m
  else if c = 0 then Result := -1
  else Result := m + 1;
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

//дихотомический поиск элемента в отсортированном массиве
function search(var a : TPolynomSystem; const t : TPolynom; var pos : TPolynomPosition; s : Integer = -1) : Integer;
var
  l, r, m, c, i : Integer;
begin
  l := 0;



  if (s = -1) or (s = -6) then
    r := length(a) - 1
  else
    r := s - 1;
  if s = -1 then
    SetPolynomPositionWhenStarted(pos, r + 1);
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



//sortsstep
procedure SortStep(var a : TPolynomSystem; s : Integer; var pos : TPolynomPosition);
var
  t, j, m : Integer;
begin
  t := pos[s - 1];



  m := search2(a, a[t]^, pos, s - 1);
  if m = -1 then EXIT;



  for j := s - 2 downto m do
    pos[j + 1] := pos[j];
  pos[m] := t;
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

procedure GetLargeAll(var mid : TPolynomSystem; var pos : TPolynomPosition);
var
  k : Integer;
begin
  k := length(mid);
  SetLength(mid, k * 2 + 1);
  SetLength(pos, k * 2 + 1);

end;

//новый полином добавить
procedure NewPolynomInPS(var p : TPolynom; var mid : TPolynomSystem; var s : Integer; var pos : TPolynomPosition);
begin
  if (length(p) > 1) and (search(mid, p, pos, s) = -1)  then begin
    if length(mid) = s then
      GetLargeAll(mid, pos);

    new(mid[s]);

    copyPolynoms(mid[s]^, p);
    pos[s] := s;
    s := s + 1;
    SortStep(mid, s, pos);
  end;
  disposePolynom(p);
end;


procedure DegreeStep(var mid : TPolynomSystem; var pos : TPolynomPosition; var s : Integer; const current : Integer);
var
  begpos, endpos, i, j, k : integer;
  p, bp, ep: Tpolynom;
begin
  begpos := s;
  for i := 0 to s - 1 do
    if length(mid[pos[i]]^) - 1 >= current + 1 then begin
      begpos := i;
      CopyPolynoms(bp, mid[pos[i]]^);
      Break;
    end;

  endpos := s;
  for i := 0 to s - 1 do
    if length(mid[pos[i]]^) - 1 > current + 1 then begin
      endpos := i;
      CopyPolynoms(ep, mid[pos[i]]^);
      Break;
    end;

  k := s;
  i := begpos;
  while i < endpos do begin
    Derivative(p, mid[pos[i]]^);
    NewPolynomInPS(p, mid, s, pos);
    disposePolynom(p);
    begpos := search(mid, bp, pos, s);
    if endpos = k then begin
      k := s;
      endpos := k;
    end else if endpos < k then
      endpos := search(mid, ep, pos, s);
    i := i + 1;
  end;

  i := endpos;
  while i < s do begin
    j := begpos;
    while j < endpos do begin
      Module(p, mid[pos[i]]^, mid[pos[j]]^);
      NewPolynomInPS(p, mid, s, pos);
      disposePolynom(p);
      begpos := search(mid, bp, pos, s);
      if endpos = k then begin
        k := s;
        endpos := k;
      end else if endpos < k then
        endpos := search(mid, ep, pos, s);
      j := j + 1;
    end;
    i := i + 1;
  end;

  i := begpos;
  while i < endpos do begin
    j := i + 1;
    while j < endpos do begin
      Module(p, mid[pos[j]]^, mid[pos[i]]^);
      NewPolynomInPS(p, mid, s, pos);
      disposePolynom(p);
      if endpos = k then begin
        k := s;
        endpos := k;
      end else if endpos < k then
        endpos := search(mid, ep, pos, s);
    j := j + 1;
    end;
    i := i + 1;
  end;

  disposePolynom(bp);
  disposePolynom(ep);
  disposePolynom(p);
end;

//построение насыщенной системы
procedure CompleteSystem(var a : TPolynomSystem);
var
  pos : TPolynomPosition;
  mid : TPolynomSystem;
  k, s, i : Integer;
  nTemp : integer;
begin
  CopyPolynomSystemsWhenStarted(mid, a, s); //далее разбираемся с mid
  k := s;
  SetPolynomPositionWhenStarted(pos, k); //формируем pos
  QSort(mid, 0, s - 1, h, pos);//сортируем mid
  SetLength(mid, k);

  nTemp := length(mid[pos[s - 1]]^) - 1;
  for i := nTemp downto 1 do
    DegreeStep(mid, pos, s, i);

  CopyPolynomSystemsInTheEnd(a, mid, pos, s);
end;



end.

