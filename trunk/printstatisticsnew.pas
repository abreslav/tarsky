unit printstatisticsnew;

interface
uses
  SysUtils,
  Statistic;

procedure writetofile(var f: file; initialText : String);

implementation

function maketimeint(t : TDateTime) : integer;
var
  h, m, s, ml : word;
begin
  DecodeTime(t, h, m, s, ml);
  result := ml + 1000 * (s + 60 * (m + 60 * h));
end;

function timeToNormalStr(t : TDateTime) : string;
var
  h, m, s, ms : Word;
begin
  decodeTime(t, h, m, s, ms);
  result := intToStr(m) + ':' + intToStr(s) + '.' + intToStr(ms);
end;

function charofnum(n : integer) : char;
begin
  case n of
    1 : result := '1';
    2 : result := '2';
    3 : result := '3';
    4 : result := '4';
    5 : result := '5';
    6 : result := '6';
    7 : result := '7';
    8 : result := '8';
    9 : result := '9';
    0 : result := '0';
  end;
end;

function inttostring(const n1 : integer) : string;
var
  i : integer;
  n : integer;
begin
  if n1 = 0 then begin
    result := '0';
    exit;
  end;
  n := n1;
  result := '';
  i := 1;
  while n > 0 do begin
    result := charofnum(n mod 10) + result;
    n := n div 10;
    if i mod 3 = 0 then
      result := ' ' + result;
    i := i + 1;
  end;
end;

{function intToString(const n1 : integer) : string;
begin
  result := intToStr(n1);
end;}

procedure writestring(var f : file; s : string);
begin
  blockwrite(f, s[1], length(s));
end;

procedure writeStringLn(var f : File; s : String);
begin
  writeString(f, s);
  writeString(f, #13#10);
end;

function maketimestring(t : TDateTime) : string;
begin
  result := inttostring(maketimeint(t));
end;

procedure writelistitem(var f : file; s : string; k : string);
begin
  writestringln(f, '<li>');
  writestring(f, s);
  writestring(f, k);
  writestringln(f, '</li>');
end;

procedure writeseclist(var f : file);
begin
  writestringln(f, '<UL>');
  writelistitem(f, '<b>Время работы парсера</b>: ', timetoNormalStr(timeparser));
  writelistitem(f, '<b>Время работы построения насыщенной системы</b>: ', timetoNormalStr(timeconstractingfullsys));
  writelistitem(f, '<b>Время работы построения таблицы знаков</b>: ', timetoNormalStr(timeconstractingsigntable));
  writelistitem(f, '<b>Время работы проверки формулы</b>: ', timetoNormalStr(timeformulae));
  writestringln(f, '</UL>');
end;

procedure writelist(var f : file);
begin
  writestringln(f, '<UL>');
  writelistitem(f, '<b>Максимальная степень полинома</b>: ', inttostring(maxstep));
  writelistitem(f, '<b>Размер насыщенной системы</b>: ', inttostring(lengthpolynomsystem));
  writelistitem(f, '<b>Количество столбцов в таблице знаков</b>: ', inttostring(numbercolumn));
  writelistitem(f, '<b>Количество различных корней</b>: ', inttostring(numberroot));
  writestringln(f, '</UL>');
end;

procedure writenottable(var f : file);
begin
  writestring(f, '</br><b>Ответ</b>: ');
  if resultanswer = true then
    writestringln(f, 'TRUE')
  else
    writestringln(f, 'FALSE');
  writestringln(f, '</br><b>Время работы</b>: ');
  writestring(f, timeToNormalStr(timeall));
  writestringln(f, '<h3>Количественные характеристики</h3>');
  writelist(f);
  writestringln(f, '<h3>Время работы основных частей, м:с.мс</h3>');
  writeseclist(f);
  writestring(f, '<a href="table.html">Таблица знаков для полиномов насыщенной системы</a>');
end;

procedure writestart(var f : file; initialText : String);
begin
  reset(f, 1);
  writestringln(f, '<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251"/><title>Алгоритм Тарского</title></head>');
  writestringln(f, '<body>');
  writestringln(f, '<h3>Формула:</h3>');
  writestringln(f, '<table border="1" cellspacing="0" cellpadding="10"><tr>');
  writestringln(f, '<td>');
  writestringln(f, '<IMG src="out.gif">');
  writestringln(f, '</td>');
  writestringln(f, '<td>');
  writestringln(f, '<pre>'+ initialText + '</pre>');
  writestringln(f, '</td>');
  writestringln(f, '</tr></table>');
  writenottable(f);
  writestringln(f, '<h3>Время работы операций</h3>');
  writestringln(f, '<table border="1" cellspacing="0" cellpadding="2">');
end;

procedure writestringtable(var f : file; s1, s2, s3 : string);
begin
  writestringln(f, '<tr><td align="center">');
  writestring(f, '<b>' + s1  + '</b>');
  writestringln(f, '</td><td align="center">');
  writestring(f, '<b>' + s2 + '</b>');
  writestringln(f, '</td><td align="center">');
  writestring(f, '<b>' + s3 + '</b>');
  writestringln(f, '</td></tr>');
end;

procedure writeend(var f : file);
begin
  writestring(f, '</table>');

  writestringln(f, '</body></HMTL>');
end;

procedure writetofile(var f: file; initialText : String);
begin
  writestart(f, initialText);
  writestringtable(f, 'Операция', 'Количество', 'Время, мс');
  writestringtable(f, 'Сложение рациональных', inttostring(runrationalsadd), inttostring(maketimeint(timerationalsadd)));
  writestringtable(f, 'Вычитание рациональных', inttostring(runrationalssubtract), inttostring(maketimeint(timerationalssubtract)));
  writestringtable(f, 'Умножение рациональных', inttostring(runrationalsmult), inttostring(maketimeint(timerationalsmult)));
  writestringtable(f, 'Деление рациональных', inttostring(runrationalsdivide), inttostring(maketimeint(timerationalsdivide)));
  writestringtable(f, 'Сложение полиномов', inttostring(runpolynomsadd), inttostring(maketimeint(timepolynomsadd)));
  writestringtable(f, 'Вычитание полиномов', inttostring(runpolynomssubtract), inttostring(maketimeint(timepolynomssubtract)));
  writestringtable(f, 'Умножение полиномов', inttostring(runpolynomsmult), inttostring(maketimeint(timepolynomsmult)));
  writestringtable(f, 'Деление полиномов', inttostring(runpolynomsmodule), inttostring(maketimeint(timepolynomsmodule)));
  writestringtable(f, 'Дифференцирование полиномов', inttostring(runpolynomsderivative), inttostring(maketimeint(timepolynomsderivative)));
  writeend(f);
end;

{function timeToNormalStr(t : TDateTime) : string;
var
  h, m, s, ms : Word;
begin
  decodeTime(t, h, m, s, ms);
  result := intToStr(m) + ':' + intToStr(s) + '.' + intToStr(ms);
end;              }

end.
