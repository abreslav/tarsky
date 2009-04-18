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

var
  TempSS1, TempSS2, TempSS3 : TStatementSystem;


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
  New(ResultFormula.StatementSystem);
  ResultFormula.StatementSystem^ := StatementSystemStek.pop;
end;

procedure onQuantor(t : integer; CTD : string);
begin
  if CTD = 'E' then
    ResultFormula.Quantor := qExists
  else
    ResultFormula.Quantor := qForAll;
end;

procedure onStaSyst(t : integer);
begin
  TempSS1 := StatementSystemStek.pop;
  TempSS2 := StatementSystemStek.pop;
  New(TempSS2.RightSS);
  TempSS2.RightSS^ := TempSS1;
  StatementSystemStek.push(TempSS2);

end;

procedure onOper(t : integer; CTD : string);
begin
  if CTD <> '-->' then begin
    New(TempSS1.LeftSS);
    TempSS1.LeftSS^ := StatementSystemStek.pop;
    if CTD = 'and' then
      TempSS1.Operation := oAnd
    else
      if CTD = 'or' then
        TempSS1.Operation := oOr;
    StatementSystemStek.push(TempSS1);
  end else begin
    TempSS1.Operation := oOr;
    New(TempSS1.LeftSS);
    New(TempSS1.LeftSS^.LeftSS);
    TempSS1.LeftSS^.LeftSS^ := StatementSystemStek.pop;
    TempSS1.LeftSS^.RightSS := nil;
    TempSS1.LeftSS^.Operation := oNot;
    StatementSystemStek.push(TempSS1);
  end;
end;

procedure onIneqSign(t : integer; CTD : string);
begin
  TempSS1.Operation := oInequation;
  TempSS1.LeftSS := nil;
  New(TempSS1.Inequation);
  if CTD = '>' then
    TempSS1.Inequation.InequationSign := isGreater
  else
    if CTD = '>=' then
      TempSS1.Inequation.InequationSign := isGreaterEqual
    else
      if CTD = '<' then
        TempSS1.Inequation.InequationSign := isLess
      else
        if CTD = '<=' then
          TempSS1.Inequation.InequationSign := isLessEqual
        else
          if CTD = '=' then
            TempSS1.Inequation.InequationSign := isEqual
          else
            if CTD = '<>' then
              TempSS1.Inequation.InequationSign := isNotEqual;
  StatementSystemStek.push(TempSS1);
end;

procedure onCIneq(t : integer);
var
  p1, p2 : TPolynom;
begin
  TempSS1 := StatementSystemStek.pop;
  p1 := PolynomsStek.Pop;
  p2 := PolynomsStek.Pop;
  Polynoms.subtract(TempSS1.Inequation^.Polynom, p2, p1);
  PolynomsStek.push(TempSS1.Inequation^.Polynom);
  StatementSystemStek.push(TempSS1);
  disposePolynom(p1);
  disposePolynom(p2);
end;

procedure onExcSign(t : integer);
begin
  tempSS1.Operation := oNot;
  tempSS1.RightSS := nil;
  StatementSystemStek.push(tempSS1);
end;

procedure onExc(t : integer);
begin
  tempSS2 := StatementSystemStek.pop;
  tempSS1 := StatementSystemStek.pop;
  New(tempSS1.LeftSS);
  tempSS1.LeftSS^ := tempSS2;
  StatementSystemStek.push(tempSS1);
end;


end.
