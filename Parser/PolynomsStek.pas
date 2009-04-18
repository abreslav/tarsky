unit PolynomsStek;


interface

uses
  polynoms;



procedure initStek();
procedure push(const P : TPolynom);     // кладём
function pop() : TPolynom;              //вынимаем
function numbersPolynoms : integer;



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
  CopyPolynoms(stek.PArray[stek.position], P);
end;



function pop() : TPolynom; //вынимаем
begin
  CopyPolynoms(result, stek.PArray[stek.position]);
  disposePolynom(stek.PArray[stek.position]);
  stek.position := stek.position - 1;
end;

function numbersPolynoms : integer;
begin
  result :=  stek.position + 1;
end;


end.
