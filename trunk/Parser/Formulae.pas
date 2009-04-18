unit Formulae;

interface

uses
  Polynoms, Rationals, naturals, SysUtils, PolynomsStek, fullSys, signTable, ConstructionSignTable;

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
  
  //��� ��� �������� ���!

  (*
   * �������: ����������, ��� ������
   *)
  TQuantor = (qExists, qForAll);

  (*
   * ������� � ��������� (��� �������� - �� ����� � ��� �� ����������)
   *)
  TQuanitifedFormula = record
    Quantor : TQuantor;
    StatementSystem : PStatementSystem;
  end;


function tQuantFormulaToBoolean(var TFormula : TQuanitifedFormula; var table : TSignTable) : boolean;  // ��������� ����������� TFormula
//function tQuantFormulaToStr(const TFormula : TQuanitifedFormula; k : boolean = false) : string; //TFormula � ������, � ���� boolean = true, �� � FullPArray ���������� ��� ���������� �� TFormul-�

implementation

{var
  formulaErrorFlag : boolean;  }









function tInequatTValueSign(InequationSign : TInequationSign; sign : TValueSign) : boolean;
begin
  case sign of
    vsMinus:
      case InequationSign of
        isLess, isLessEqual, isNotEqual: Result := true;
        isGreater, isGreaterEqual, isEqual: result := false;
      end;
    vsPlus:
      case InequationSign of
        isGreater, isGreaterEqual, isNotEqual: result := true;
        isLess, isLessEqual, isEqual: Result := false;
      end;
    vsZero:
      case InequationSign of
        isGreaterEqual, isLessEqual, isEqual: result := true;
        isGreater, isLess, isNotEqual: result := false;
      end;
  end;
end;


function TRatToSign(r : TRationalNumber) : TValueSign;
begin
  if not itIsNotRZero(r) then
    result := vsZero
  else begin
    if r.Sign = nsPlus then
      result := vsPlus
    else
      result := vsMinus;
  end;
end;


function intToSign(i : integer) : TValueSign;
begin
  case i of
    -1: result := vsMinus;
    1: result := vsPlus;
    0: result := vsZero;
  end;
end;



function pIneguationToBoolean(var Inequation : PInequation;var tableColumn : PSignTableColumn) : boolean;
var
  i : integer;
  pos : TPolynomPosition;
  p : TPolynom;
  sign : TValueSign;
begin
  p := inequation.Polynom;
  if length(p) = 1 then begin
    result := tInequatTValueSign(Inequation^.InequationSign, TRatToSign(p[0]^));
    exit;
  end;


    i := search(PolynomSystem, p, pos);                 //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    sign := intToSign(easyGet(tableColumn, i));


  result := tInequatTValueSign(Inequation^.InequationSign, sign);     //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end;


function pStatSystToBoolean(PStatSys : PStatementSystem; var tableColumn : PSignTableColumn) : boolean;
begin
  case pStatSys^.Operation of
    oAnd: result := pStatSystToBoolean(PStatSys^.LeftSS, tableColumn) and pStatSystToBoolean(PStatSys^.RightSS, tableColumn);
    oOr: result := pStatSystToBoolean(PStatSys^.LeftSS, tableColumn) or pStatSystToBoolean(PStatSys^.RightSS, tableColumn);
    oNot: result := not (pStatSystToBoolean(PStatSys^.LeftSS, tableColumn));
    oInequation: result := pIneguationToBoolean(pStatSys^.Inequation, tableColumn);
  end;
end;




function tQuantFormulaToBoolean(var TFormula : TQuanitifedFormula; var table : TSignTable) : boolean;
var
  tablePColumn : PSignTableColumn;
  tableNil : TSignTableColumn;
begin
  result := false;
  tablePColumn := table.FirstColumn;

  if tablePColumn = nil then begin
    case TFormula.Quantor of
      qExists: begin
          if pStatSystToBoolean(TFormula.StatementSystem, tablePColumn) then
            result := true
          else
            result := false;
      end;

      qForAll: begin
          if pStatSystToBoolean(TFormula.StatementSystem, tablePColumn) then
            result := true
          else
            result := false;
      end;
    end;//case
    exit;
  end;


  case TFormula.Quantor of



    qExists:
      while tablePColumn <> nil do begin
        if pStatSystToBoolean(TFormula.StatementSystem, tablePColumn) then begin
          result := true;
          exit;
        end;
        tablePColumn := tablePColumn^.Next;
      end;



    qForAll: begin
      result := true;
      while tablePColumn <> nil do begin
        if  not(pStatSystToBoolean(TFormula.StatementSystem, tablePColumn)) then begin
          result := false;
          exit;
        end;
        tablePColumn := tablePColumn^.Next;
      end;
    end;



  end;
end;


end.

