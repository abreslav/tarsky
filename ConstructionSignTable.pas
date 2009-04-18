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
  table : TSignTable; //наша таблица
  PolynomSystem : TPolynomSystem; //насыщенная система
  FirstPolynoms : TPolynomSystem; //начальные многочлены
  indPolynom : aIndex; // места начальных многочленов
  
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


  PListColumn : PTableColumn; //список столбцов - оно темповское и часто изменяется
  flagNil : boolean; //флаг о том, что насыщенная система не выдала не одного многочлена.
  k : integer; //число обработанных многочленов. обрабатываем к + 1
  pos : TPolynomPosition;  //Просто массив



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



procedure constractingIndexPolynom(const a : TPolynomSystem); //формируем список мест, на которых стоят исходные многочлены
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
  l := numbersPolynoms;          // читаем начальные многочлены из стека
  setLength(polynomSystem, l);
  for i := 0 to l - 1 do begin
   new(polynomSystem[i]);
   polynomSystem[i]^ := pop;
  end;
  copyPolynomSystem(firstPolynoms, PolynomSystem);  //запоминаем начальные многочлены
  maxDepPolynom(firstPolynoms); // запоминаем максимальную степень

  toTPolynomSystem;   //// делаем систему хорошей - без констант и совпадающих многочленов
  if length(PolynomSystem) = 0 then begin   // если нам ввели не более чем константные многочлены, то выходим
    flagNil := true;
    exit;
  end;


  copyPolynomSystem(a, PolynomSystem);  //запоминаем промежуточные многочлены

  firstFullSys;
  CompleteSystem(polynomSystem); //создаём насыщенную систему
  closeFullSys;



  lengthPS(length(POlynomSystem));  // запоминаем к-во многочленов в насыщенной системе


  setlength(pos, length(polynomSystem));          //Формирование pos
  for i := 0 to length(pos) - 1 do
    pos[i] := i;


  constractingIndexPolynom(a); //создаём массив мест исходных многочленов в нынешней системе
  if length(polynomSystem) = 0 then begin
    flagNil := true;
    exit;
  end;

  k := -1;
  InitTable(table, length(polynomSystem));
end;

function between(a, b : integer) : integer;// говорит, что стоит между а и б
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




procedure fillNextColumn(var insertAfter : PSignTableColumn);//берём этот столбец и после него вставляем следующий, и заполняем его до k + 1 включительно
var
  i : integer;
  nextColumn : PSignTableColumn;
  l : integer;
begin
  nextColumn := insertAfter.Next;
  insertColumn(table, insertAfter);
  for i := 0 to k + 1 do begin
    l := between(EasyGet(insertAfter, i), EasyGet(nextColumn, i)); //то, что должно быть между в новом столбце
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


procedure initFirst_end_Column;  //заполняем значения многочленов на + - бесконечностях
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




procedure constractPListColumn; // идём по к + 1 и формируем список  из столбцов с 0 в к + 1 строке  {*PListColumn*}
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








procedure fillTheSquare; // заполняем к+1 строку...
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


  if length(PolynomSystem[k + 1]^) = 2 then begin  // если на к+1 строке стоял линейный многочлен, то ...
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


  for i := k + 2 to length(PolynomSystem) - 1 do begin    //если многочлен не линейный
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



function indPolynomZero(const Column : PSignTableColumn) : boolean; //проверяем, есть ли корень в этом столбце у исходных многочленах.
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



procedure AddNew; //добавляем столбцы между 2-мя последовательными столбцами, в которых исходные многочлены имели корень
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
