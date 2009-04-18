unit FullSysTest;



interface
uses
  polynoms, FullSys, sToPolynom, ConstructionSignTable;

function FullSysChack : boolean;




implementation

function FullSysChack : boolean;
var
  t : TPolynom;
  pos : TPolynomPosition;
  i, j : integer;
begin
  SetPolynomPositionWhenStarted(pos, LEngth(PolynomSystem));
  for i := 0 to length(PolynomSystem) - 1 do begin
    derivative(t, PolynomSystem[i]^);
    if length(t) <> 1 then begin
      if search(PolynomSystem, t, pos, -6) = -1 then begin
        writeln(tpolynomToStr(PolynomSystem[i]^));
        writeln(tpolynomToStr(t));
        result := false;
        exit;
      end;
    end;
  end;

  for i := 0 to length(PolynomSystem) - 1 do begin
    for  j := 0 to i do begin
      module(t, PolynomSystem[i]^, PolynomSystem[j]^);
      if length(t) <> 1 then begin
        if search(PolynomSystem, t, pos, -6) = -1 then begin
          writeln(tpolynomToStr(PolynomSystem[i]^));
          writeln(tpolynomToStr(PolynomSystem[j]^));
          writeln(tpolynomToStr(t));
          result := false;
          exit;
        end;
      end;
    end;
  end;
  result := true;
end;


end.
 