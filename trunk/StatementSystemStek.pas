unit StatementSystemStek;


interface

uses
  Formulae;



procedure initStek();
procedure push(const SS : TStatementSystem);     // кладём
function pop() : TStatementSystem;              //вынимаем

implementation
type
  SSStek = record
    SSArray : array of TStatementSystem;
    position : integer;
    length : integer;
  end;

var
  stek : SSStek;

procedure initStek();
begin
  stek.position := -1;
  stek.length := 2;
  setlength(stek.SSArray, stek.length);
end;

procedure expansion();
begin
  inc(stek.position);
  if stek.position >= stek.length then begin
    stek.length := stek.length * 2;
    setlength(stek.SSArray, stek.length);
  end;
end;

procedure push(const SS : TStatementSystem);          // кладём
begin
  expansion();
  stek.SSArray[stek.position] := SS;
end;



function pop() : TStatementSystem; //вынимаем
begin
  result := stek.SSArray[stek.position];
  stek.position := stek.position - 1;
end;


end.
