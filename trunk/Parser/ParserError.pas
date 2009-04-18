unit ParserError;

interface
uses
  lexer;

var
  errorFlag : Boolean; // равен True, если нашли ошибку и false если всё в порядке
  ErrorStr : string;


procedure WriteErrorParser(s : string; ResultType : TGrammarElementType; currentTokenData : string);
procedure WriteError(s : string);
procedure initParserError();
procedure CheckForError(MRT, RT : TGrammarElementType; CTD : string);

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


procedure CheckForError(MRT, RT : TGrammarElementType; CTD : string);
begin
  if RT <> MRT then begin
    errorFlag := true;
    WriteErrorParser(TGrammarElementTypetoStr(MRT), RT, CTD);
  end;
end;


end.
