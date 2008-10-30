program LexerTest;
{$APPTYPE CONSOLE}
{$Q+,R+}
uses
  SysUtils,
  Lexer in 'Lexer.pas',
  TestingUtils in 'TestingUtils.pas';

type
  TTokenTypes = array of TGrammarElementType;

procedure testLexer(const text : String; tokenTypes : TTokenTypes; tokenText : array of String);
var
  i : Integer;
  rt : TGrammarElementType;
  str : String;
  types : String;
begin
  initLexer(text);
  str := '';
  types := '';
  for i := Low(tokenTypes) to High(tokenTypes) do begin
    str := str + '|' + lexerNext(rt);
    types := types + '|' + TGrammarElementTypetoStr(tokenTypes[i]);
    if (rt <> tokenTypes[i]) then begin
      WriteLn('Test ''' + text + ''' failed');
      WriteLn('error: ' + TGrammarElementTypetoStr(tokenTypes[i]) + ' exprected but ' + TGrammarElementTypetoStr(rt) + ' found');
      WriteLn('Last output: ''' + str + '''');
    end;
  end;

end;

function tt(const tokens : String) : TTokenTypes;
var
  i : Integer;
begin
  SetLength(result, Length(tokens));
  for i := 1 to Length(tokens) do begin
    case tokens[i] of
      '+', '-' : result[i - 1] := gPlusOp;
      '^' : result[i - 1] := gPower;
      'q' : result[i - 1] := gQuantor;
      'v' : result[i - 1] := gVar;
      'n' : result[i - 1] := gNumber;
      '(', ')' : result[i - 1] := gBracket;
    end;
  end;
end;


var
  resultType : TGrammarElementType;
  ss : array of String;
begin
  testLexer('a+b', tt('v+v'), ss);
  testLexer('(a+b)', tt('(v+v)'), ss);
  testLexer('(', tt('('), ss);
  testLexer('10a', tt('nv'), ss);
  testLexer('a10a', tt('v'), ss);
  testLexer('          a10a                ', tt('v'), ss);
  testLexer('          a 10a                ', tt('vnv'), ss);
  ReadLn;
end.