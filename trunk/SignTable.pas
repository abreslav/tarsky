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

procedure insertColumn(var table : TSignTable; insertAfter : PSignTableColumn);

implementation

procedure insertColumn(var table : TSignTable; insertAfter : PSignTableColumn);
begin

end;

end.
