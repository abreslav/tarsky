unit filestr;

interface

type
  ArrayStr = array of string;



procedure initFile(nameFile : string);    // передаём имя файла, из которого хотим читать текст
function filetostr : string;  // выводит полную строку из файла,#13#10-enter
function fileToArrayStr(gapdiv : boolean = false) : ArrayStr; // выводит массив строк входного файла, а если gapdiv то массив строк разделённых либо пробелами, либо enter-ом..

implementation

var
  buf : array of byte;

procedure initFile(nameFile : string);      // передаём имя файла
var
  len : integer;
  fi : file;
begin
  assignfile(fi, nameFile);
  buf := nil;
  reset(fi, 1);
  len := filesize(fi);
  setlength(buf, len);
  blockread(fi, buf[0], len);
  closefile(fi);
end;

function filetostr : string;
var
  i : integer;
begin
  result := '';
  for i := 0 to length(buf) - 1 do
    result := result + chr(buf[i]);
end;


function quantEnt : integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to length(buf) - 1 do
    if buf[i] = 13 then
      result := result + 1;
end;

function gapgluk(k : integer) : boolean;
begin
  result := false;
  if buf[k] = ord(' ') then
    if (k = 0) or (buf[k - 1] <> ord(' ')) then
      result := true;
end;


function quantGap : integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to length(buf) - 1 do
    if gapgluk(i) then
      result := result + 1;
end;



function fileToArrayStr(gapdiv : boolean = false) : ArrayStr;
var
  i : integer;
  numI : integer;
  qDiv : integer;
begin
  qDiv := quantEnt;
  if gapDiv then
    qDiv  := qDiv + quantGap;
  setlength(result, qDiv + 1);
  NumI := 0;
  for i := 0 to length(buf) - 1 do
    if (buf[i] = 13) or
    (gapDiv and gapGluk(i)) then begin
      numI := numI + 1;
    end else begin
      if (buf[i] <> 10) and ((buf[i] <> ord(' ')) or (not GapDiv))  then
        result[numI] := result[numI] + chr(buf[i]);
    end;
end;

end.
 