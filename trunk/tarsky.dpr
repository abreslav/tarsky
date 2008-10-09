program tarsky;

{$APPTYPE CONSOLE}
                           
uses
  SysUtils;


type
  (*
   * ����������� ����� (��� ����), �������� � ������� ��������� �
   * ���������� 2^32
   * ������� ������� �������� � ������� � �������� ��������
   * ��������: ������ ���������� � ����
   *)
  TNaturalNumber = array of Cardinal;
                      
  (*
   * ���� �����
   *)
  TNumberSign = (nsPlus, nsMinus);

procedure add(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure subtract(var result : TNaturalNumber; var sign : TNumberSign; const a, b : TNaturalNumber);
procedure mult(var result : TNaturalNumber; const a, b : TNaturalNumber);
procedure divide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
procedure gcd(var result : TNaturalNumber; const a, b : TNaturalNumber);

type
  (*
   * ������������ ����� �� ������
   *   Numerator   - ���������
   *   Denominator - �����������
   * ������ �����, ��� ���(���������, �����������) = 1
   * ���� ����� ����� ����, �� ��������� ����� ����, �
   * ����������� ����� �������.
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
   * ������� �� ����� ����������
   * p[k] - ����������� ��� x^k
   * ��������: ������������ ���������� � ���� (������ ������� - ����)
   *)
  TPolynom = array of PRationalNumber;

procedure add(var result : TPolynom; const a, b : TPolynom);
procedure subtract(var result : TPolynom; const a, b : TPolynom);
procedure mult(var result : TPolynom; const a, b : TPolynom);
procedure module(var result : TPolynom; const a, b : TPolynom);
procedure derivative(var result : TPolynom; const a : TPolynom);

type
  (*
   * ���� �������� � �����: -, 0 ��� + 
   *)
  TValueSign = (vsMinus, vsZero, vsPlus);
  (*
   * ������� ������� ������ ���������
   *   Next   - ��������� �� �������, ������� ������ ��������� �� ������
   *   Column - �������� �������
   *   ��������: ������ ����� ������� ���������� � ����  
   *)
  PSignTableColumn = ^TSignTableColumn;
  TSignTableColumn = record
    Next : PSignTableColumn;
    Column : array of TValueSign;
  end;

  (*
   * ������� ������ ���������
   *   Height      - ������ �������
   *   FirstColumn - ��������� �� ������ (����� �����) ������� �������
   * ��� ������� ������� ������ ����� ����� Height
   *)
  TSignTable = record
    Height : Integer;
    FirstColumn : PSignTableColumn;
  end;

procedure insertColumn(var table : TSignTable; insertAfter : PSignTableColumn);

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

begin
  { TODO -oUser -cConsole Main : Insert code here }
end.
