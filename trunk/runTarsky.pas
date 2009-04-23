unit runTarsky;

interface

uses
  ConstructionSignTable,
  Statistic,
  filestr,
  StatementSystemParser,
  StatementSystemBuilder,
  ParserError,
  Lexer,
  SysUtils,
  TexRenderer,
  printstatisticsnew,
  Draw,
  ConstructingRealTableOfStrings,
  Formulae,
  ShellAPI;


procedure runAll;

implementation

const
  nameFile = 'inputFormula.txt';

var
  s : string;
  f : file;




function timeToNormalStr(t : TDateTime) : string;
var
  h, m, s, ms : Word;
begin
  decodeTime(t, h, m, s, ms);
  result := intToStr(m) + ':' + intToStr(s) + '.' + intToStr(ms);
end;






{procedure writeFirstInf;
var
  s : string;
begin
  write(f, '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251"/><title>Алгоритм Тарского</title></head>');
  write(f, '<body><h3>Условие задачи</h3><img src="out.gif" align="absmiddle"/><br/><b>Время работы:</b>');
  s := timeToNormalStr(timeAll);
end;   }



procedure initStr;
begin
  initFile(nameFile);
  s := fileToStr;
end;

procedure runAll;
begin
  initStr;

  firstAll;

  firstParser;
  parse(s);
  closeParser;



  if errorFlag then begin
    writeln(ErrorStr);
    writeln(LastStr);
    readln;
    exit;
  end;

  modellingOfSignTable;



  firstFormulae;
  ResultA(tQuantFormulaToBoolean(resultFormula, table));
  closeFormulae;
  closeAll;

  FormulaToTex(resultFormula);

  writeAllToHtml;

  assignFile(f, 'report.html');
  rewrite(f, 1);
  writetofile(f, s);
  CloseFile(f);

  ShellExecute(0, 'open', 'report.html', nil, '.', 0);

  initDraw;
  addPS(firstPolynoms);

  MOUSEandZOOM;          

end;

end.
