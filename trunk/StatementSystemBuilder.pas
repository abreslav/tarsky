unit StatementSystemBuilder;

interface

uses
  SysUtils,
  Lexer,
  StatementSystemStek,
  Polynoms,
  PolynomsStek,
  PolynomParser,
  Formulae;

procedure onFormula(t : integer);
procedure onQuantor(t : integer; CTD : string);
procedure onStaSyst(t : integer);
procedure onIneqSign(t : integer; CTD : string);
procedure onCIneq(t : integer);
procedure onExc(t : integer);
procedure onOper(t : integer; CTD : string);
procedure onExcSign(t : integer);

procedure onOStatement(t : integer);
procedure onCStatement(t : integer);
procedure onOIneq(t : integer);


procedure WriteErrorStr(s : String);

var
  ResultFormula : TQuanitifedFormula;


implementation



procedure WriteErrorStr(s : String);
begin
  WriteLn('ERROR: ', s);
end;


procedure onOStatement(t : integer);
begin
end;

procedure onCStatement(t : integer);
begin
end;

procedure onOIneq(t : integer);
begin
end;




procedure onFormula(t : integer);
begin
  ResultFormula.StatementSysytem := @StatementSystemStek.pop;
end;

procedure onQuantor(t : integer; CTD : string);
begin
  if CTD = 'E' then
    ResultFormula.Quantor := qExists
  else
    ResultFormula.Quantor := qForAll;
end;

procedure onStaSyst(t : integer);
var
  s, sr : TStatementSystem;
begin
  sr := StatementSystemStek.pop;
  s := StatementSystemStek.pop;
  s.RightSS := @sr;
  StatementSystemStek.push(s);
end;

procedure onOper(t : integer; CTD : string);
var
  s : TStatementSystem;
begin
  s.LeftSS := @StatementSystemStek.pop;
  if CTD = 'and' then
    s.Operation := oAnd
  else
    if CTD = 'or' then
      s.Operation := oOr;
  StatementSystemStek.push(s);
end;

procedure onIneqSign(t : integer; CTD : string);
var
  s : TStatementSystem;
begin
  s.Operation := oInequation;
  s.LeftSS := nil;
  New(s.Inequation);
  if CTD = '>' then
    s.Inequation.InequationSign := isGreater
  else
    if CTD = '>=' then
      s.Inequation.InequationSign := isGreaterEqual
    else
      if CTD = '<' then
        s.Inequation.InequationSign := isLess
      else
        if CTD = '<=' then
          s.Inequation.InequationSign := isLessEqual
        else
          if CTD = '=' then
            s.Inequation.InequationSign := isEqual
          else
            if CTD = '<>' then
              s.Inequation.InequationSign := isNotEqual;
  StatementSystemStek.push(s);
end;

procedure onCIneq(t : integer);
var
  s : TStatementSystem;
  p1, p2 : TPolynom;
begin
  s := StatementSystemStek.pop;
  p1 := PolynomsStek.pop;
  p2 := PolynomsStek.pop;
  Polynoms.subtract(s.Inequation^.Polynom, p1, p2);
  StatementSystemStek.push(s);
end;

procedure onExcSign(t : integer);
var
  s : TStatementSystem;
begin
  s.Operation := oNot;
  s.RightSS := nil;
  StatementSystemStek.push(s);
end;

procedure onExc(t : integer);
var
  s, s1 : TStatementSystem;
begin
  s1 := StatementSystemStek.pop;
  s := StatementSystemStek.pop;
  s.LeftSS := @s1;
  StatementSystemStek.push(s);
end;


end.
 