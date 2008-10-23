unit SignTable;

interface

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

implementation

procedure insertColumn(var table : TSignTable; insertAfter : PSignTableColumn);
begin

end;

end.
