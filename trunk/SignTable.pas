
unit SignTable;

interface

type
  (*
   * Знак полинома в точке: -, 0 или +
   *)
  TValueSign = (vsMinus, vsZero, vsPlus);
  (*
   * Столбец таблицы знаков полиномов
   *   Next   - указатель на столбец, стоящий спарва следующим за данным
   *   Column - значения столбца
   *   ВНИМАНИЕ: Ячейки этого массива нумеруются с нуля
   *)
  PSignTableColumn = ^TSignTableColumn;
  TSignTableColumn = record
    Next : PSignTableColumn;
    Column : array of TValueSign;
  end;

  (*
   * Таблица знаков полиномов
   *   Height      - высота таблицы
   *   FirstColumn - указатель на первый (самый левый) столбец таблицы
   * Все столюцы таблицы должны иметь выоту Height
   *)
  TSignTable = record
    Height : Integer;
    FirstColumn : PSignTableColumn;
  end;

procedure InsertColumn(var table : TSignTable; const insertAfter : PSignTableColumn);
procedure InitTable( Var Table : TsignTable; TableHeight : integer);
procedure NextColumn(var Current : PSignTableColumn);
function GetItem(var GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);
procedure EasyWrite(var WColumn : PsignTableColumn; NumberInColumn : integer;
                                                 Value : integer);
function EasyGet( var GColumn : PsignTableColumn; NumberInColumn : integer) : integer;
// EasyWrite и EasyGet отличаются от  WriteItem и GetItem тем, что всместо констант
// типа TValueSign у них в качестве третьего параметра целое число, которе лежит в
// диапазоне от -1 до 1 (исключительно для удобства)
implementation



procedure insertColumn(var table : TSignTable; const insertAfter : PSignTableColumn);
var
  i : PSignTableColumn;
begin
  new(i);
  setlength(i.column, table.Height);
  i.next := insertAfter.Next;
  insertAfter.Next := i;
  {i := InsertAfter^.Next;
  new(InsertAfter^.Next);
  setlength(InsertAfter^.Next^.Column, table.Height);
  InsertAfter^.Next^.Next := i;}
end;





procedure InitTable( Var Table : TsignTable; TableHeight : integer);
begin
  Table.Height := TableHeight;
  new(Table.FirstColumn);
  new(Table.FirstColumn^.Next);
  setlength(Table.FirstColumn^.Column, Table.Height);
  setlength(Table.FirstColumn^.Next^.Column, Table.Height);
  Table.FirstColumn^.Next^.Next := Nil;
end;




procedure NextColumn( var Current : PSignTableColumn);
var
  i : PSignTableColumn;
begin
  i := Current^.Next;
  Current := i;
end;




function GetItem (var GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
begin
  result := GColumn^.Column[NumberInColumn];
end;




procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);
begin

  WColumn^.Column[NumberInColumn] := Value;
end;


procedure EasyWrite(var WColumn : PsignTableColumn; NumberInColumn : integer;
                                                 Value : integer);
begin
  case Value of
    -1 : WriteItem(WColumn, NumberInColumn, vsMinus);
    0 : WriteItem(WColumn, NumberInColumn, vsZero);
    1 : WriteItem(WColumn, NumberInColumn, vsPlus);
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




end.
                   
