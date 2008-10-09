program tarsky;

{$APPTYPE CONSOLE}
                           
uses
  SysUtils;


type
  (*
   * Натуральное число (или ноль), хранимые в системе счисления с
   * основанием 2^32
   * Младшие разряды хранятся в ячейках с младшими номерами
   * ВНИМАНИЕ: Ячейки нумеруются с нуля
   *)
  TNaturalNumber = array of Cardinal;
                      
  (*
   * Знак числа
   *)
  TNumberSign = (nsPlus, nsMinus);

procedure add(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);

type
  (*
   * Рациональное число со знаком
   *   Numerator   - числитель
   *   Denominator - знаменатель
   * Всегда верно, что НОД(числитель, знаменатель) = 1
   * Если число равно нулю, то числитель равен нулю, а
   * знаменатель равен единице.
   *)
  TRationalNumber = record
    Sign : TNumberSign;
    Numerator,
    Denominator : TNaturalNumber;
  end;
  PRationalNumber = ^TRationalNumber;

procedure add(var result : TRationalNumber; const a, b : TRationalNumber);
procedure subtract(var result : TRationalNumber; const a, b : TRationalNumber);
procedure mult(var result : TRationalNumber; const a, b : TRationalNumber);
procedure divide(var result : TRationalNumber; const a, b : TRationalNumber);

type
  (*
   * Полином от одной переменной
   * p[k] - коэффициент при x^k
   * ВНИМАНИЕ: Коэффициенты нумеруются с нуля (ячейки массива - тоже)
   *)
  TPolynom = array of PRationalNumber;

procedure add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);

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

type
  (*
   * Знак в неравенсте: >, >=, <, <=, =, <>
   *)
  TInequationSign = (isGreater, isGreaterEqual, isLess, isLessEqual, isEqual, isNotEqual);
  (*
   * Неравенство с нулем в правой части
   *)
  TInequation = record
    Polynom : TPolynom;
    InequationSign : TInequationSign;
  end;
  PInequation = ^TInequation;

  (*
   * "Операция" - обозначает смысл полей в вершине дерева системы утверждений
   *)
  TOperation = (oAnd, oOr, oNot, oInequation);
  (*
   * Вершина дерева системы утверждений
   * Если поле Operation равно
   *  oAnd        : LeftSS и RightSS - аргументы конъюнкции,
   *                Inequation не имеет смысла
   *  oOr         : LeftSS и RightSS - аргументы дизъюнкции,
   *                Inequation не имеет смысла
   *  oNot        : LeftSS - аргумент отрицания,
   *                RightSS, Inequation не имеют смысла (должны быть равны nil)
   *  oInequation : Inequation - неравенство,
   *                LeftSS и RightSS не имеют смысла,
   *                LeftSS должен быть равен nil 
   *)
  PStatementSystem = ^TStatementSystem;
  TStatementSystem = record
    Operation : TOperation;
    LeftSS : PStatementSystem;
  case Integer of
    1: (RightSS : PStatementSystem);
    2: (Inequation : PInequation);
  end;

  (*
   * Квантор: существует, для любого
   *)
  TQuantor = (qExists, qForAll);

  (*
   * Формула с квантором (все полиномы - по одной и той же переменной)
   *)
  TQuanitifedFormula = record
    Quantor : TQuantor;
    StatementSysytem : PStatementSystem;
  end;

begin
  { TODO -oUser -cConsole Main : Insert code here }
end.
