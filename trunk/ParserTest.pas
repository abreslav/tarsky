unit ParserTest;

interface

uses
  SysUtils,
  Lexer,
  StatementSystemStek,
  Polynoms,
  PolynomsStek,
  PolynomParser,
  PolynomsBuilderS,
  Formulae;

procedure onFormula(t : integer);
procedure onQuantor(t : integer; CTD : string);
procedure onIneqSign(t : integer; CTD : string);
procedure onCIneq(t : integer);
procedure onExc(t : integer);
procedure onOper(t : integer; CTD : string);
procedure onExcSign(t : integer);
procedure onOStatement(t : integer);
procedure onCStatement(t : integer);
procedure onOIneq(t : integer);

procedure onStaSyst(t : integer);

procedure WriteErrorStr(s : String);

var
  CTD : string;
  ResultString : string = '';



implementation

procedure WriteErrorStr(s : String);
begin
  ResultString := ResultString + s + #13#10;
end;


procedure onStaSyst(t : integer);
begin
end;




procedure WriteIdents(t : integer);
var
  i : Integer;
begin
  for i := 1 to 2 * t do
    ResultString := ResultString + ' ';
end;

procedure onFormula(t : integer);
begin
  WriteIdents(t + 1);
  ResultString := ResultString + '</statement system>' + #13#10;
  WriteIdents(t);
  ResultString := ResultString + '</formula>' + #13#10;
end;

procedure onQuantor(t : integer; CTD : string);
begin
  WriteIdents(t);
  ResultString := ResultString + '<formula>' + #13#10;
  WriteIdents(t + 1);
  ResultString := ResultString + CTD + #13#10;
  WriteIdents(t + 1);
  ResultString := ResultString + '<statement system>' + #13#10;
end;

procedure onOStatement(t : integer);
begin
  WriteIdents(t);
  ResultString := ResultString + '<statement>' + #13#10;
end;

procedure onCStatement(t : integer);
begin
  WriteIdents(t);
  ResultString := ResultString + '</statement>' + #13#10;
end;

procedure onOper(t : integer; CTD : string);
begin
  WriteIdents(t);
  ResultString := ResultString + CTD + #13#10;
end;

procedure onOIneq(t : integer);
begin
  WriteIdents(t);
  ResultString := ResultString + '<inequation>' + #13#10;
    WriteIdents(t + 1);
  ResultString := ResultString + '<polynom>' + #13#10;
  InitBuilderS(t + 2);
end;

procedure onIneqSign(t : integer; CTD : string);
begin
  ResultString := ResultString + resultBuilderS;
  WriteIdents(t + 1);
  ResultString := ResultString + '</polynom>' + #13#10;
  WriteIdents(t);
  ResultString := ResultString + '<sign "' + CTD + '" > ' + #13#10;
  WriteIdents(t + 1);
  ResultString := ResultString + '<polynom>' + #13#10;
  InitBuilderS(t + 2);
end;

procedure onCIneq(t : integer);
begin
  ResultString := ResultString + resultBuilderS;
  WriteIdents(t + 1);
  ResultString := ResultString + '</polynom>' + #13#10;
  WriteIdents(t);
  ResultString := ResultString + '</inequation>' + #13#10;
end;

procedure onExc(t : integer);
begin
  WriteIdents(t + 1);
  ResultString := ResultString + '</statement>' + #13#10;
end;

procedure onExcSign(t : integer);
begin
  WriteIdents(t);
  ResultString := ResultString + 'not' + #13#10;
  WriteIdents(t + 1);
  ResultString := ResultString + '<statement>' + #13#10;
end;

end.
