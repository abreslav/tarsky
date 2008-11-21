{
procedure InsertColumn(var table : TSignTable; insertAfter : PSignTableColumn);
procedure InitTable( Var Table : TsignTable; TableHeight : integer);
procedure NextColumn(var Current : PSignTableColumn);
function GetItem(var GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);
}


program SignTableTester;

// процедура NextColumn сомнению не подлежит!!!


{$APPTYPE CONSOLE}
uses
  SysUtils, SignTable;

type
  Tarray = array [1..3, 1..3] of integer;
  TValueArray = array [1..2, 1..2] of TValueSign;

var
  Table, Table2 : TSignTable;
  Current : PSignTableColumn;
  TestArray : Tarray = ((1, 0, -1), (-1, 1, 0), (0, -1, 1));
  TestValueArray : TValueArray = ((vsMinus, vsZero), (vsZero, vsPlus));
  d : tvaluesign;

function TestOfInitTable : integer;
begin
  InitTable(Table, 2);
  result := 0;
  if (length(table.FirstColumn.Column) = 2) and
                        (length(table.FirstColumn.Next.Column) = 2) and          // проверяем размеры и то,
                                (table.FirstColumn.Next.Next = Nil)   then       // что последний указатель - нил

    result := 1;
end;




function TestOfWriteItem : integer;
var
  NumberOfTrueTests : integer;
begin
  result := 0;
  InitTable(Table, 2);    //создаем таблицу 2х2
  Current := Table.FirstColumn;
  WriteItem(Current, 0, TestValueArray[1, 1]);   //
  WriteItem(Current, 1, TestValueArray[1, 2]);   // заполняем
  NextColumn(Current);                           //
  WriteItem(Current, 0, TestValueArray[2, 1]);   //
  WriteItem(Current, 1, TestValueArray[2, 2]);   //
  Current := Table.FirstColumn;
  NumberOfTrueTests := 0;
  if Current^.Column[0] = vsMinus then
    NumberOfTrueTests := NumberOfTrueTests + 1;  //
  if Current^.Column[1] = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;  //
  NextColumn(Current);                           //проверяем
  if Current^.Column[0] = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;  //
  if Current^.Column[1] = vsPlus then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;  //
  if NumberOfTrueTests = 4 then            //
    result := 1                            //
  else                                     // считаем правильные тесты
    result := 0;                           //
end;{TestOfWriteItem}





function TestOfGetItem : integer;
var
  NumberOfTrueTests : integer;
begin
  result := 0;
  InitTable(Table, 2);    //создаем таблицу 2х2
  Current := Table.FirstColumn;
  WriteItem(Current, 0, TestValueArray[1, 1]);   //
  WriteItem(Current, 1, TestValueArray[1, 2]);   // заполняем
  NextColumn(Current);                           //
  WriteItem(Current, 0, TestValueArray[2, 1]);   //
  WriteItem(Current, 1, TestValueArray[2, 2]);   //
  Current := Table.FirstColumn;
  NumberOfTrueTests := 0;
  if getitem(Current, 0) = vsMinus then           //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if getitem(Current, 1) = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  NextColumn(Current);                            // проверяем
  if getitem(Current, 0) = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if getitem(Current, 1) = vsPlus then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if NumberOfTrueTests = 4 then            //
    result := 1                            //
  else                                     // считаем правильные тесты
    result := 0;                           //
end;{TestOfGetItem}






procedure EasyWrite(var WColumn : PsignTableColumn; NumberInColumn : integer;
                                                 Value : integer);
begin
  case Value of
    -1 : WriteItem(WColumn, NumberInColumn, vsMinus);  //вместо жутких констант
    0 : WriteItem(WColumn, NumberInColumn, vsZero);    //можно писать просто
    1 : WriteItem(WColumn, NumberInColumn, vsPlus);    //циферки. удобно.
  end;{case}
end;{Easywrite}


function EasyGet( var GColumn : PsignTableColumn; NumberInColumn : integer) : integer;
begin
  case GetItem(GColumn, NumberInColumn) of
    vsMinus : result := -1;
    vsZero : result := 0;
    vsPlus : result := 1;
  end;{case}
end;



function TestOfEasyWrite : integer;
var
  NumberOfTrueTests : integer;
begin
  result := 0;
  InitTable(table, 2);             //создаем таблицу 2х2
  Current := Table.FirstColumn;      //
  EasyWrite(Current, 0, -1);         //
  EasyWrite(Current, 1, 0);          // заполняем
  NextColumn(Current);               //
  EasyWrite(Current, 0, 0);          //
  EasyWrite(Current, 1, 1);          //
  NumberOfTrueTests := 0;
  Current := Table.FirstColumn;
  if getitem(Current, 0) = vsMinus then           //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if getitem(Current, 1) = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  NextColumn(Current);                            // проверяем
  if getitem(Current, 0) = vsZero then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if getitem(Current, 1) = vsPlus then            //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if NumberOfTrueTests = 4 then            //
    result := 1                            //
  else                                     // считаем правильные тесты
    result := 0;                           //
end;{TestOfEasyWrite}

 function TestOfEasyGet : integer;
var
  NumberOfTrueTests : integer;
begin
  result := 0;
  InitTable(table, 2);             //создаем таблицу 2х2
  Current := Table.FirstColumn;      //
  EasyWrite(Current, 0, -1);         //
  EasyWrite(Current, 1, 0);          // заполняем
  NextColumn(Current);               //
  EasyWrite(Current, 0, 0);          //
  EasyWrite(Current, 1, 1);          //
  NumberOfTrueTests := 0;
  Current := Table.FirstColumn;
  if EasyGet(Current, 0) = -1 then                //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if EasyGet(Current, 1) = 0 then                 //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  NextColumn(Current);                            // проверяем
  if EasyGet(Current, 0) = 0 then                 //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if EasyGet(Current, 1) = 1 then                 //
    NumberOfTrueTests := NumberOfTrueTests + 1;   //
  if NumberOfTrueTests = 4 then            //
    result := 1                            //
  else                                     // считаем правильные тесты
    result := 0;                           //
end;{TestOfEasyGet}


function TestOfInsertColumn : integer;
var
  NumberOfTrueTests : integer;
  i, j, k : integer;
begin
  InitTable(Table, 3);
  Current := Table.FirstColumn;
  EasyWrite(Current, 0, TestArray[1, 1]);
  EasyWrite(Current, 1, TestArray[1, 2]);
  EasyWrite(Current, 2, TestArray[1, 3]);
  NextColumn(Current);
  EasyWrite(Current, 0, TestArray[3, 1]);
  EasyWrite(Current, 1, TestArray[3, 2]);
  EasyWrite(Current, 2, TestArray[3, 3]);
  InsertColumn(Table, Table.FirstColumn);
  Current := Table.FirstColumn;
  NextColumn(Current);
  EasyWrite(Current, 0, TestArray[2, 1]);
  EasyWrite(Current, 1, TestArray[2, 2]);
  EasyWrite(Current, 2, TestArray[2, 3]);
  Current := Table.FirstColumn;
  NumberOfTrueTests := 0;
  k := 1;
  for j := 1 to 3 do begin
    for i := 0 to 2 do
      if EasyGet(Current, i) = TestArray[j, i + 1] then
        NumberOfTrueTests := NumberOfTrueTests + 1;
    NextColumn(current);
  end;
 

  if NumberOfTrueTests = 9 then
    result := 1
  else
    result := 0;
end;







begin

   write('TestOfInitTable' + '     ');
  if TestOfInitTable = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;





  write('TestOfWriteItem' + '     ');
  if TestOfWriteItem = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;



  write('TestOfGetItem' + '       ');
  if TestOfGetItem = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;



  write('TestOfInsertColumn' + '  ');
  if TestOfInsertColumn = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;




 write('TestOfEasyGet' + '       ');
  if TestOfEasyGet = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;




  write('TestOfEasyWrite' + '     ');
  if TestOfEasyWrite = 1 then
    writeln('ok')
  else
    writeln('Error');
  writeln;



  readln;
end.































