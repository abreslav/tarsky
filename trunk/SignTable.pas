
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

procedure InsertColumn(var table : TSignTable; const insertAfter : PSignTableColumn);
procedure InitTable( Var Table : TsignTable; TableHeight : integer);
procedure NextColumn(var Current : PSignTableColumn);
function GetItem(var GColumn : PsignTableColumn; NumberInColumn : integer) : TValueSign;
procedure WriteItem(var WColumn : PsignTableColumn; NumberInColumn : integer; Value : TValueSign);


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



end.
                   
