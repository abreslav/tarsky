unit ConstructionSignTable;

interface
uses
  signTable,
  FullSys,
  PolynomsStek,
  naturals,
  rationals,
  sToPolynom,
  //Draw,
  Polynoms;


type

  aIndex = array of integer;
  
var
  table : TSignTable; //���� �������
  PolynomSystem : TPolynomSystem; //���������� �������
  FirstPolynoms : TPolynomSystem; //��������� ����������
  indPolynom : aIndex; // ����� ��������� �����������
  
procedure modellingOfSignTable;
function firstPolynomIndex(k : integer) : boolean;

implementation
uses
  statistic,
  unit1,
  FullSysTest,
  sizeAllTypes;

type
  PTableColumn = ^TTableColumn;
  TTableColumn = record
    Next : PTableColumn;
    Column : PSignTableColumn;
  end;



var


  PListColumn : PTableColumn; //������ �������� - ��� ���������� � ����� ����������
  flagNil : boolean; //���� � ���, ��� ���������� ������� �� ������ �� ������ ����������.
  k : integer; //����� ������������ �����������. ������������ � + 1
  pos : TPolynomPosition;  //������ ������



function firstPolynomIndex(k : integer) : boolean;
var
  i : integer;
begin
  result := false;
  for i := 0 to length(indPolynom) - 1 do
    if k = indPolynom[i] then begin
      result := true;
      exit;
    end;
end;



function  polynomNaPlus(const P : tPolynom) : integer;
begin
  if not(itIsNotRZero(p[0]^)) and (length(p) = 1) then
    result := 0
  else
    case p[length(p) - 1]^.sign of
      nsPlus: result := 1;
      nsminus: result := -1;
    end;
end;



function  polinomNaMinus(const p : tPolynom) : integer;
begin
  if (length(p) - 1) mod 2 = 0 then
    result := polynomNaPlus(p)
  else
    result := - polynomNaPlus(p);
end;


function signTRat(t : TRationalNumber) : integer;
begin
  if not itIsNotRZero(t) then
    result := 0
  else
    result := signToInt(t.sign);
end;










procedure toTPolynomSystem;
var
  i, j, l : integer;
  tempSystem : TPolynomSystem;
  k : boolean;
begin



  setLength(tempSystem, length(PolynomSystem));
  l := 0;
  for i := 0 to length(PolynomSystem) - 1 do
    if length(PolynomSystem[i]^) >= 2 then begin
      k := true;
      for j := 0 to l - 1 do
        if comparePolynoms(tempSystem[j]^, PolynomSystem[i]^) = 0 then
          k := false;
      if k then begin
        TempSystem[l] := PolynomSystem[i];
        inc(l);
      end;
    end;
  setLength(PolynomSystem, l);

  for i := 0 to l - 1  do
    PolynomSystem[i] := tempSystem[i];
end;






procedure copyPolynomSystem(var a : TPolynomSystem; const b : TPolynomSystem);
var
  i : integer;
begin
  setLength(a, length(b));
  for i := 0 to length(b) - 1 do begin
    new(a[i]);
    copyPolynoms(a[i]^, b[i]^);
  end;
end;



procedure constractingIndexPolynom(const a : TPolynomSystem); //��������� ������ ����, �� ������� ����� �������� ����������
var
  i : integer;
begin
  setLength(indPolynom, length(a));
  for i := 0 to length(a) - 1 do
    indPolynom[i] := search(PolynomSystem, a[i]^, pos, -6);
end;


procedure maxDepPolynom(const a : TPolynomSystem);
var
  i : integer;
  result : integer;
begin
  result := 1;
  for i := 0 to length(a) - 1 do begin
    if result < length(a[i]^) then
      result := length(A[i]^);
  end;
  StepMax(result - 1);
end;




procedure initPolynomSystem;
var
  i, l : integer;
  a : TPolynomSystem;
begin
  l := numbersPolynoms;          // ������ ��������� ���������� �� �����
  setLength(polynomSystem, l);
  for i := 0 to l - 1 do begin
   new(polynomSystem[i]);
   polynomSystem[i]^ := pop;
  end;
  copyPolynomSystem(firstPolynoms, PolynomSystem);  //���������� ��������� ����������
  maxDepPolynom(firstPolynoms); // ���������� ������������ �������

  toTPolynomSystem;   //// ������ ������� ������� - ��� �������� � ����������� �����������
  if length(PolynomSystem) = 0 then begin   // ���� ��� ����� �� ����� ��� ����������� ����������, �� �������
    flagNil := true;
    exit;
  end;


  copyPolynomSystem(a, PolynomSystem);  //���������� ������������� ����������

  firstFullSys;
  CompleteSystem(polynomSystem); //������ ���������� �������
  closeFullSys;



  lengthPS(length(POlynomSystem));  // ���������� �-�� ����������� � ���������� �������


  setlength(pos, length(polynomSystem));          //������������ pos
  for i := 0 to length(pos) - 1 do
    pos[i] := i;


  constractingIndexPolynom(a); //������ ������ ���� �������� ����������� � �������� �������
  if length(polynomSystem) = 0 then begin
    flagNil := true;
    exit;
  end;

  k := -1;
  InitTable(table, length(polynomSystem));
end;

function between(a, b : integer) : integer;// �������, ��� ����� ����� � � �
begin
  if (a = 0) and (b = 0) then begin
    writeln('Fatal Error');
    readln;
    result := 17;
    exit;
  end;
  if a = 0 then
    result := b
  else begin
    if b = 0 then
      result := a
    else begin
      if a * b = 1 then
        result := a
      else
        result := 0;
    end; //b = 0
  end; //a = 0
end;




procedure fillNextColumn(var insertAfter : PSignTableColumn);//���� ���� ������� � ����� ���� ��������� ���������, � ��������� ��� �� k + 1 ������������
var
  i : integer;
  nextColumn : PSignTableColumn;
  l : integer;
begin
  nextColumn := insertAfter.Next;
  insertColumn(table, insertAfter);
  for i := 0 to k + 1 do begin
    l := between(EasyGet(insertAfter, i), EasyGet(nextColumn, i)); //��, ��� ������ ���� ����� � ����� �������
    EasyWrite(insertAfter.next, i, l);
  end;
end;







procedure disposePList;
var
  tempC : PTableColumn;
begin
  while PListColumn <> nil do begin
    tempC := PListColumn.next;
    dispose(PListColumn);
    PListColumn := tempC;
  end;
end;


procedure initFirst_end_Column;  //��������� �������� ����������� �� + - ��������������
var
  i : integer;
  nextColumn : PSignTableColumn;
begin
  nextColumn := table.FirstColumn;
  for i := 0 to length(PolynomSystem) - 1 do
    EasyWrite(nextColumn, i, polinomNaMinus(PolynomSystem[i]^));
  nextColumn := nextColumn^.next;
  for i := 0 to length(PolynomSystem) - 1 do
    EasyWrite(nextColumn, i, polynomNaPlus(PolynomSystem[i]^));
end;




procedure constractPListColumn; // ��� �� � + 1 � ��������� ������  �� �������� � 0 � � + 1 ������  {*PListColumn*}
var
  nextColumn, t : PSignTableColumn;
  tempC : PTableColumn;
begin
  disposePList;
  nextColumn := table.FirstColumn;
  while nextColumn.next <> nil do begin
    t := nextColumn.next;
    if between(EasyGet(nextColumn, k + 1), EasyGet(nextColumn.next, k + 1)) = 0 then begin
      fillNextColumn(nextColumn);
      new(tempC);
      tempC^.Next := PListColumn;
      tempC^.Column := nextColumn.Next;
      PListColumn := tempC;
    end;
    nextColumn := t;
  end;
end;








procedure fillTheSquare; // ��������� �+1 ������...
var
  i : integer;
  p : TPolynom;
  l : integer;
  tempC : PTableColumn;
  xTemp, pTemp : TRationalNumber;
begin
  constractPListColumn;
  if PListColumn = nil then
    exit;


  if length(PolynomSystem[k + 1]^) = 2 then begin  // ���� �� �+1 ������ ����� �������� ���������, �� ...
    rationals.divide(xTemp, PolynomSystem[k + 1]^[0]^, PolynomSystem[k + 1]^[1]^, 1);
    notSign(xTemp.sign);

    for i := k + 2 to length(PolynomSystem) - 1 do begin
      tempC := PListColumn;
      CountInTRational(pTemp, PolynomSystem[i]^, xTemp, 0);
      l := signTRat(pTemp);
      disposeRational(pTemp);
      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, l);
        tempC := tempC^.Next;
      end;
    end;
    disposeRational(xTemp);

    exit;
  end;


  for i := k + 2 to length(PolynomSystem) - 1 do begin    //���� ��������� �� ��������
    tempC := PListColumn;
    module(p, PolynomSystem[i]^, PolynomSystem[k + 1]^);




    if length(p) <> 1 then begin

      l := search(PolynomSystem, p, pos, -6);
      if l = -1 then begin
        writeln(tpolynomToStr(PolynomSystem[i]^));
        writeln(tpolynomToStr(PolynomSystem[k + 1]^));
        writeln(tpolynomToStr(p));
      end;

      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, EasyGet(tempC^.Column, l));
        tempC := tempC^.Next;
      end;
    end else begin
      l := polynomNaPlus(p);
      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, l);
        tempC := tempC^.Next;
      end;
    end;  // if length(p) <> 1

    disposePolynom(p);
  end; //for

end;



function indPolynomZero(const Column : PSignTableColumn) : boolean; //���������, ���� �� ������ � ���� ������� � �������� �����������.
var
  i : integer;
begin
  result := false;
  for i := 0 to length(indPolynom) - 1 do
    if easyGet(Column, indPolynom[i]) = 0 then begin
      result := true;
      exit;
    end;
end;



procedure AddNew; //��������� ������� ����� 2-�� ����������������� ���������, � ������� �������� ���������� ����� ������
var
  Column, nextColumn : PSignTableColumn;
begin
  k := length(PolynomSystem) - 2;
  Column := table.FirstColumn;
  while Column <> nil do begin
    nextColumn := Column.Next;
    if indPolynomZero(column) and indPolynomZero(nextColumn) then
      fillNextColumn(column);
    Column := nextColumn;
  end;
end;






function numberColumTable : integer;
var
  c : PSignTableColumn;
begin
  result := 0;
  c := table.FirstColumn;
  while c <> nil do begin
    inc(result);
    c := c^.Next;
  end;
end;


procedure modellingOfSignTable;
begin
  initPolynomSystem;
  if flagNil then
    exit;

  firstSignTable;
  initFirst_end_Column;

  while k < length(PolynomSystem) - 1 do begin

    fillTheSquare;
    inc(k);
  end;


  numRoot(numberColumTable - 2);

  AddNew;

  numColumn(numberColumTable);

  closeSignTable;
end;








begin
  flagNil := false;

end.
