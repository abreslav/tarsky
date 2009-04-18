unit Unit1;

interface

uses
  signTable, ConstructionSignTable,  SysUtils;

Type
  TArray = array of string;


function SignTableToStr(table : TSignTable; i : integer) : string;
function SignTableToArrayStr(table : TSignTable) : TArray;
procedure printSystem;

implementation



{var
  table : TSignTable;}


function intToFormatStr(i : integer) : string;
begin
  result := intToStr(i);
  while length(Result) <= 3 do
    result := ' ' + result;
end;


function SignTableToStr(table : TSignTable; i : integer) : string;
var
  j : integer;
  a : PSignTableColumn;
begin
  result := '';
  a := table.FirstColumn;
  j := 1;
  While a  <> nil do begin
    result := result + intToFormatStr(easyget(a, i));
    a := a^.next;
  end;
end;

function SignTableToArrayStr(table : TSignTable) : TArray;
var
  i : integer;
  a : PSignTableColumn;
begin
  setlength(Result, table.Height);
  For i := 0 to table.Height - 1 do
    result[i] := SignTableToStr(table, i);
end;



procedure printSystem;
var
  Ar : TArray;
  i : integer;
begin
  Ar := SignTableToArrayStr(table);
  for i := 0 to length(Ar) - 1 do
    writeln(Ar[i]);
  writeln;
  readln;
end;


end.
