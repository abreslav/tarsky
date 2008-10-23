unit Formulae;

interface

uses
  Polynoms;

type
  (*
   * ���� � ����������: >, >=, <, <=, =, <>
   *)
  TInequationSign = (isGreater, isGreaterEqual, isLess, isLessEqual, isEqual, isNotEqual);
  (*
   * ����������� � ����� � ������ �����
   *)
  TInequation = record
    Polynom : TPolynom;
    InequationSign : TInequationSign;
  end;
  PInequation = ^TInequation;

  (*
   * "��������" - ���������� ����� ����� � ������� ������ ������� �����������
   *)
  TOperation = (oAnd, oOr, oNot, oInequation);
  (*
   * ������� ������ ������� �����������
   * ���� ���� Operation �����
   *  oAnd        : LeftSS � RightSS - ��������� ����������,
   *                Inequation �� ����� ������
   *  oOr         : LeftSS � RightSS - ��������� ����������,
   *                Inequation �� ����� ������
   *  oNot        : LeftSS - �������� ���������,
   *                RightSS, Inequation �� ����� ������ (������ ���� ����� nil)
   *  oInequation : Inequation - �����������,
   *                LeftSS � RightSS �� ����� ������,
   *                LeftSS ������ ���� ����� nil
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
   * �������: ����������, ��� ������
   *)
  TQuantor = (qExists, qForAll);

  (*
   * ������� � ��������� (��� �������� - �� ����� � ��� �� ����������)
   *)
  TQuanitifedFormula = record
    Quantor : TQuantor;
    StatementSysytem : PStatementSystem;
  end;

implementation

end.
