unit ParserError;

interface
uses
  lexer;

var
  errorFlag : Boolean; // ����� Treu, ���� ����� ������ � false ���� �� � �������
  ErrorStr : string;


procedure WriteErrorParser(s : string; ResultType : TGrammarElementType; currentTokenData : string);
procedure WriteError(s : string);
procedure initParserError();


implementation

procedure initParserError();
begin
  ErrorFlag := False;
  ErrorStr := '';
end;  


procedure WriteError(s : string);
begin
   ErrorStr := s;
   errorFlag := True;
end;


procedure WriteErrorParser(s : string; ResultType : TGrammarElementType; currentTokenData : string);
begin
  if ResultType = gError then
    WriteError('Error : ' + s + ' expected, but ' + currentTokenData + ' found.')
  else
    WriteError('Error : ' + s + ' expected, but ' + TGrammarElementTypetoStr(ResultType) + ' found.');
end;

end.
