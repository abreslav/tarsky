unit StatementSystemBuilder;

interface

uses
  SysUtils,
  Lexer,
  StatementSystemStek,
  Polynoms,
  ParserError,
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


procedure CheckForError(MRT, RT : TGrammarElementType; CTD : string);


procedure onOStatement(t : integer);
procedure onCStatement(t : integer);
procedure onOIneq(t : integer);




var
  ResultFormula : TQuanitifedFormula;


implementation



procedure onOStatement(t : integer);
begin
end;

procedure onCStatement(t : integer);
begin
end;

procedure onOIneq(t : integer);
begin
end;





procedure CheckForError(MRT, RT : TGrammarElementType; CTD : string);
begin
  if RT <> MRT then begin
    errorFlag := true;
    WriteErrorParser(TGrammarElementTypetoStr(MRT), RT, CTD);
  end;
end;





procedure onFormula(t : integer);
begin
  New(ResultFormula.StatementSysytem);
  ResultFormula.StatementSysytem^ := StatementSystemStek.pop;
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
  New(s.RightSS);
  s.RightSS^ := sr;
  StatementSystemStek.push(s);
end;

procedure onOper(t : integer; CTD : string);
var
  s : TStatementSystem;
begin
  if CTD <> '-->' then begin
    New(s.LeftSS);
    s.LeftSS^ := StatementSystemStek.pop;
    if CTD = 'and' then
      s.Operation := oAnd
    else
      if CTD = 'or' then
        s.Operation := oOr;
    StatementSystemStek.push(s);
  end else begin
    s.Operation := oOr;
    New(s.LeftSS);
    New(s.LeftSS^.LeftSS);
    s.LeftSS^.LeftSS^ := StatementSystemStek.pop;
    s.LeftSS^.RightSS := nil;
    s.LeftSS^.Operation := oNot;
    StatementSystemStek.push(s);
  end;
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
  p1 := PolynomsStek.Pop;
  p2 := PolynomsStek.Pop;
  Polynoms.subtract(s.Inequation^.Polynom, p2, p1);
  PolynomsStek.push(s.Inequation^.Polynom);
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
  New(s.LeftSS);
  s.LeftSS^ := s1;
  StatementSystemStek.push(s);
end;


end.
