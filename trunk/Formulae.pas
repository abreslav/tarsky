unit Formulae;

interface

uses
  Polynoms;

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

implementation

end.
