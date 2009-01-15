unit PolynomsStek;


interface

uses
  polynoms;



procedure initStek();
procedure push(const P : TPolynom);     // кладём
function pop() : TPolynom;              //вынимаем

implementation
type
  PStek = record
    PArray : array of TPolynom;
    position : integer;
    length : integer;
  end;

var
  stek : PStek;

procedure initStek();
begin
  stek.position := -1;
  stek.length := 10;
  setlength(stek.PArray, stek.length);
end;

procedure expansion();
begin
  inc(stek.position);
  if stek.position >= stek.length then begin
    stek.length := stek.length * 2;
    setlength(stek.PArray, stek.length);
  end;
end;

procedure push(const P : TPolynom);          // кладём
begin
  expansion();
  stek.PArray[stek.position] := P;
end;



function pop() : TPolynom; //вынимаем
begin
  result := stek.PArray[stek.position];
  stek.position := stek.position - 1;
end;


end.
