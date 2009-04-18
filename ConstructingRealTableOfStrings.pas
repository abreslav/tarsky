unit ConstructingRealTableOfStrings;


interface
uses
  FullSys,
  SignTable,
  Polynoms,
  printing,
  ConstructionSignTable,
  naturals;
type
  Striing = array of PPolynom;
  TTableOfPoly = array of striing;


function MakeTable : TTable;
procedure writealltohtml;

implementation

procedure makeheadline(const PolynomSystem : TPolynomSystem; var table : TTableOfPoly);
var
  i : integer;
begin
  SetLength(table, length(PolynomSystem));
  for i := 0 to (length(table) - 1) do begin
    SetLength(table[i], 1);
    new(table[i][0]);
    table[i][0] := PolynomSystem[i];
  end;
end;

function makepolofsignT(const x : integer) : TPolynom;
begin
  SetLength(result, 1);
  New(result[0]);
  case x of
    1 : begin
      SetLength(result[0].numerator, 1);
      result[0].numerator[0] := 1;
      SetLength(result[0].denominator, 1);
      result[0].denominator[0] := 1;
      result[0].sign := NSPlus;
    end;
    -1 : begin
      SetLength(result[0].numerator, 1);
      result[0].numerator[0] := 1;
      SetLength(result[0].denominator, 1);
      result[0].denominator[0] := 1;
      result[0].sign := NSminus;
    end;
    0 : begin
      SetLength(result[0].numerator, 1);
      result[0].numerator[0] := 0;
      SetLength(result[0].denominator, 1);
      result[0].denominator[0] := 1;
      result[0].sign := NSPlus;
    end;
  end;
end;

function makepolyofsign(const x : integer) : PPolynom;
begin
  new(result);
  result^ := makepolofsignT(x);
end;

procedure addcolumn(var column : PSignTableColumn; var tableblya : TTableOfPoly; const i : integer);
var
  j : integer;
begin
  for j := 0 to (length(tableblya) - 1) do begin

    SetLength(tableblya[j], i);
    new(tableblya[j][i - 1]);
    tableblya[j][i - 1] := makepolyofsign(easyget(column, j));
  end;
end;

function MakePolyTable : TTableOfPoly;
var
  column : PSignTableColumn;
  i : integer;
begin
  column := table.firstcolumn;
  MakeHeadline(PolynomSystem, result);
  i := 2;
  while column <> nil do begin
    addcolumn(column, result, i);
    column := column^.next;
    i := i + 1;
  end;
end;

function MakeTable : TTable;
var
  table1 : TTableOfPoly;
  i : integer;
  j : integer;
begin
  table1 := MakePolyTable;
  SetLength(result, length(table1));
  for i := 0 to length(result) - 1 do begin
    SetLength(result[i], length(table1[i]));
    for j := 0 to length(result[i]) - 1 do begin
      result[i][j] := polytostring(table1[i][j]^);
    end;
  end;
end;


procedure writeAllToHtml;
var
  f : textFile;
begin
  assignFile(f, 'table.html');
  rewrite(f);
  printtofile(maketable(), f);
  closefile(f);
end;

end.
