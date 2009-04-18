unit TestConstrTable;

interface
uses
  filestr,
  signTable,
  ConstructionSignTable,
  StatementSystemParser,
  SysUtils,
  ParserError,
  FullSys,
  Lexer,
  unit1,
  polynoms,
  sToPolynom,
  TestStr;




procedure Test;

implementation

type
  tLine = array of integer;
  tTable = array of tLine;

const
  nConstr = 4;
  folder = 'ConstractingTest\';



function FileToPolynom(fileName : string) : TPolynomSystem;
var
  a : ArrayStr;
  i : Integer;
begin
  initfile(fileName);
  a := fileToArrayStr;
  SetLength(result, length(a));
  for i := 0 to length(a) - 1 do begin
    New(result[i]);
    result[i]^ := strtopolynom(a[i]);
  end;
end;

function ComparePolynomSystems(var a, b : TPolynomSystem) : boolean;
var
  i : Integer;
  p1, p2 : TPolynomPosition;
begin
  result := (length(a) = length(b));
  if not result then
    exit;
  SetPolynomPositionWhenStarted(p1, length(a));
  QSort(a, 0, length(a) - 1, 0, p1);
  SetPolynomPositionWhenStarted(p2, length(b));
  QSort(b, 0, length(b) - 1, 0, p2);
  for i := 0 to length(a) - 1 do
    if comparepolynoms(a[p1[i]]^, b[p2[i]]^) <> 0 then begin
      result := false;
      exit;
    end;
end;




procedure testFullSys(numbTest : integer);
var
  a : TPolynomSystem;
  s : string;
begin
  s := folder + intToStr(numbTest) + '_ps.txt';
  initFile(s);
  a := FileToPolynom(s);
  if not ComparePolynomSystems(a, PolynomSystem) then
    ErrorTest('FullSys' + intToStr(numbTest) + ' test');
end;


function charToInt(c : Char) : integer;
begin
  case c of
    '+': result := 1;
    '-': result := -1;
    '0': result := 0
  else
    result := -5;
  end;
end;

procedure readTable_andRunTarskiy(numbTest : integer; var TableFile : tTable);
var
  strLine : ArrayStr;
  kLine, k : integer;
  i, j, l : integer;
  s : string;
  ar : TArray;
begin
  s := folder + intTostr(numbTest) + '.txt';
  initFile(s);
  strLine := fileToArrayStr;


  ///////////////////////////////////
  s := strLine[0];
  parse(s);
  if errorFlag then begin
    writeln(ErrorStr);
    writeln(LastStr);
    readln;
    exit;
  end;
  modellingOfSignTable;
  
  {Ar := SignTableToArrayStr(table);
  for i := 0 to length(PolynomSystem) - 1 do
    writeln(tPolynomToStr(PolynomSystem[i]^));
  writeln;
  for i := 0 to length(Ar) - 1 do
    writeln(Ar[i]);
  readln;  }

  ///////////////////////////////////



  kLine := length(strLine) - 1;
  k := 0;
  for i := 1 to length(strLine[1]) do
    if charToInt(strLine[1, i]) <> -5 then
      inc(k);

  setLength(TableFile, kLine);
  for i := 1 to kLine do begin
    setLength(TableFile[i - 1], k);
    l := 0;
    for j := 1 to length(strLine[i]) do
      if charToInt(strLine[i, j]) <> -5 then begin
        if l >= k then begin
          writeln('Error Convert File to Table');
          readln;
          exit;
        end;
        TableFile[i - 1, l] := charToInt(strLine[i, j]);
        inc(l);
      end;
  end;
end;


function TestConstract(numberTest : integer) : boolean;

var
  TableFile : tTable;
  Column : PSignTableColumn;
  i, l : integer;
begin

  result := true;

  readTable_andRunTarskiy(numberTest, TableFile);

  testFullSys(numberTest);


  if table.Height <> length(TableFile) then
    exit;

  Column := table.FirstColumn;

  l := 0;
  while column <> nil do begin
    if l >= length(TableFile[0]) then
      exit;
    for i := 0 to length(TableFile) - 1 do begin
      if TableFile[i, l] <> easyGet(column, i) then
        exit;
    end;
    inc(l);
    column := column.Next;
  end;
  if l <> length(TableFile[0]) then
    exit;

  result := false;
end;


procedure TestConstracting;
var
  i : integer;
begin
  NameProcedure('ConstractSignTable');
  for i := 1 to nConstr do
    if TestConstract(i) then
       ErrorTest(intToStr(i) + ' test');
end;



procedure writeTable(const TableFile : tTable);
var
  i, j : integer;
begin
  for i := 0 to length(TableFile) - 1 do begin
    for j := 0 to length(TableFile[i]) - 1 do begin
      write(TableFile[i, j]);
      write(' ');
    end;
    writeln;
  end;
  readln;
end;

procedure Test;
const
  s = '1.txt';
var
  TableFile : tTable;
begin
  readTable_andRunTarskiy(1, TableFile);
  writeTable(TableFile);
end;









begin
  NameUnit('ConstractingSignTable');
  TestConstracting;


end.
