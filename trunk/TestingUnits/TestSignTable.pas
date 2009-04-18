unit TestSignTable;

interface
uses
  SysUtils,
  testStr,
  signTable;

implementation

type
  Tarray = array [1..3, 1..3] of integer;
  TValueArray = array [1..2, 1..2] of TValueSign;

var
  Table, Table2 : TSignTable;
  Current : PSignTableColumn;
  TestArray : Tarray = ((1, 0, -1), (-1, 1, 0), (0, -1, 1));
  TestValueArray : TValueArray = ((vsMinus, vsZero), (vsZero, vsPlus));
  d : tvaluesign;

procedure TestOfInitTable;
begin
  InitTable(Table, 2);
  NameProcedure('InitTable');
  if not((length(table.FirstColumn.Column) = 2) and
                        (length(table.FirstColumn.Next.Column) = 2) and          // проверяем размеры и то,
                                (table.FirstColumn.Next.Next = Nil))   then       // что последний указатель - нил

    ErrorTest();
end;




procedure TestOfWriteItem;
var
  NumberOfTrueTests : integer;
begin
  NameProcedure('WriteItem');
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
  if not(NumberOfTrueTests = 4) then             //
    ErrorTest();                                 // считаем правильные тесты
end;{TestOfWriteItem}





procedure TestOfGetItem;
var
  NumberOfTrueTests : integer;
begin
  NameProcedure('GetItem');
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
  if not(NumberOfTrueTests = 4) then             //
    ErrorTest();                                 // считаем правильные тесты
end;{TestOfGetItem}




procedure TestOfEasyWriter;
var
  NumberOfTrueTests : integer;
begin
  NameProcedure('EasyWrite');
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
  if not(NumberOfTrueTests = 4) then             //
    ErrorTest();                                 // считаем правильные тесты
end;{TestOfEasyWrite}



procedure TestOfEasyGet;
var
  NumberOfTrueTests : integer;
begin
  NameProcedure('EasyGet');
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
  if not(NumberOfTrueTests = 4) then             //
    ErrorTest();                                 // считаем правильные тесты
end;{TestOfEasyGet}


procedure TestOfInsertColumn1;
var
  NumberOfTrueTests : integer;
  i, j, k : integer;
begin
  NameProcedure('InsertColumn 1');
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
  for j := 1 to 3 do begin
    for i := 0 to 2 do
      if EasyGet(Current, i) = TestArray[j, i + 1] then
        NumberOfTrueTests := NumberOfTrueTests + 1;
    NextColumn(current);
  end;


  if not(NumberOfTrueTests = 9) then             //
    ErrorTest();                                 // считаем правильные тесты
end;



procedure TestOfInsertColumn2;
var
  NumberOfTrueTests : integer;
  i, j : integer;
begin
  NameProcedure('InsertColumn 2');
  InitTable(Table, 3);
  Current := Table.FirstColumn; // куррент - первый
  EasyWrite(Current, 0, TestArray[1, 1]); //
  EasyWrite(Current, 1, TestArray[1, 2]); // заполняем
  EasyWrite(Current, 2, TestArray[1, 3]); //
  NextColumn(Current);        // куррент - второй
  EasyWrite(Current, 0, TestArray[2, 1]);  //
  EasyWrite(Current, 1, TestArray[2, 2]);  // заполняем
  EasyWrite(Current, 2, TestArray[2, 3]);  //
  InsertColumn(Table, Current);  // вставляем после второго
  NextColumn(Current);   // куррент - третий
  EasyWrite(Current, 0, TestArray[3, 1]);  //
  EasyWrite(Current, 1, TestArray[3, 2]);  // заполняем
  EasyWrite(Current, 2, TestArray[3, 3]);  //
  Current := Table.FirstColumn;  // куррент - первый
  NumberOfTrueTests := 0;
  for j := 1 to 3 do begin
    for i := 0 to 2 do
      if EasyGet(Current, i) = TestArray[j, i + 1] then
        NumberOfTrueTests := NumberOfTrueTests + 1;
    NextColumn(current);
  end;


  if not(NumberOfTrueTests = 9) then             //
    ErrorTest();                                 // считаем правильные тесты
end;


begin
  NameUnit('signTable');
  TestOfInitTable;
  TestOfWriteItem;
  TestOfGetItem;
  TestOfEasyWriter;
  TestOfEasyGet;
  TestOfInsertColumn1;
  TestOfInsertColumn2;

end.
 