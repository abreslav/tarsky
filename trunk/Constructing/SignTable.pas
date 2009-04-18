
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
    Column : array of byte;
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
function GetItem(const GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);
procedure EasyWrite(var WColumn : PsignTableColumn; NumberInColumn : integer;
                                                 Value : integer);
function EasyGet(const GColumn : PsignTableColumn; NumberInColumn : integer) : integer;
// EasyWrite и EasyGet отличаются от  WriteItem и GetItem тем, что всместо констант
// типа TValueSign у них в качестве третьего параметра целое число, которе лежит в
// диапазоне от -1 до 1 (исключительно для удобства)
implementation

///////////////////////////////////////////////////////////////////////


function GetSignFromByte(const count : integer; const OurByte : byte) : TValueSign;
var
  TwoBits : Byte;
begin
  TwoBits := OurByte shl ((count - 1) * 2);
  TwoBits := twobits shr 6;
  case twobits of
    0 : result := vsZero;
    1 : result := vsPlus;
    3 : result := vsMinus;
  end;
end;


procedure PutSignToByte(const count : integer; const Value : TValueSign; var OurByte : byte);
var
  TwoBits : Byte;
  Mask : Byte;
begin
  case Value of
    vsZero : TwoBits := 0;
    vsPlus : TwoBits := 1;
    vsMinus : TwoBits := 3;
  end;
  TwoBits := TwoBits shl ((4 - count) * 2);
  Mask := 3 shl ((4 - count) * 2);
  Mask := not Mask;
  OurByte := OurByte and Mask;
  OurByte := OurByte + Twobits;
end;





/////////////////////////////////////////////////////////////////////////

procedure insertColumn(var table : TSignTable; const insertAfter : PSignTableColumn);
var
  i : PSignTableColumn;
begin
  new(i);
  setlength(i.column, (Table.Height div 4) + 1);
  i.next := insertAfter.Next;
  insertAfter.Next := i;
end;





procedure InitTable( Var Table : TsignTable; TableHeight : integer);
begin
  Table.Height := TableHeight;
  new(Table.FirstColumn);
  new(Table.FirstColumn^.Next);
  setlength(Table.FirstColumn^.Column, (Table.Height div 4) + 1);
  setlength(Table.FirstColumn^.Next^.Column, (Table.Height div 4) + 1);
  Table.FirstColumn^.Next^.Next := Nil;
end;




procedure NextColumn( var Current : PSignTableColumn);
var
  i : PSignTableColumn;
begin
  i := Current^.Next;
  Current := i;
end;




function GetItem (const GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
begin
  result := GetSignFromByte((NumberInColumn mod 4) + 1, GColumn^.Column[(NumberInColumn div 4) ]);
end;




procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);
begin
  PutSignToByte((NumberInColumn mod 4) + 1, Value, WColumn^.Column[(NumberInColumn div 4) ]);
end;


procedure EasyWrite(var WColumn : PsignTableColumn; NumberInColumn : integer;
                                                 Value : integer);
begin
  if NumberInColumn < 0 then
    writeln('fatal error');
  case Value of
    -1 : WriteItem(WColumn, NumberInColumn, vsMinus);
    0 : WriteItem(WColumn, NumberInColumn, vsZero);
    1 : WriteItem(WColumn, NumberInColumn, vsPlus);
  end;{case}
end;{Easywrite}



function EasyGet(const GColumn : PsignTableColumn; NumberInColumn : integer) : integer;
begin
  if NumberInColumn < 0 then
    writeln('fatal error?');
  case GetItem(GColumn, NumberInColumn) of
    vsMinus : result := -1;
    vsZero : result := 0;
    vsPlus : result := 1;
  end;{case}
end;




end.
                   
