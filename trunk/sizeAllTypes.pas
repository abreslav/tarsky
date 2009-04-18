unit sizeAllTypes;

interface
uses
  FullSys, polynoms, naturals, rationals;

function TNaturalNumberSize(n : TNaturalNumber) : integer;
function TRationalNumberSize(r : TRationalNumber) : integer;
function TPolynomSize(p : TPolynom) : integer;
function TPolynomSystemSize( t : TPolynomSystem) : integer;

implementation


function TNaturalNumberSize(n : TNaturalNumber) : integer;
begin
  result := length(n) * sizeOf(word);
end;

function TRationalNumberSize(r : TRationalNumber) : integer;
begin
  result := sizeOf(TRationalNumber) + sizeOf(r.sign)
   + TNaturalNumberSize(r.Numerator)
   + TNaturalNumberSize(r.Denominator);
end;

function TPolynomSize(p : TPolynom) : integer;
var
  i : integer;
begin
  result := length(p) * sizeOf(PRationalNumber);
  for i := 0 to length(p) - 1 do
    result := result + TRationalNumberSize(p[i]^);
end;





function TPolynomSystemSize( t : TPolynomSystem) : integer;
var
  i : integer;
begin
  result := length(t) * sizeOf(PPolynom);
  for i := 0 to length(t) - 1 do
    result := result + TPolynomSize(t[i]^);


end;



end.
