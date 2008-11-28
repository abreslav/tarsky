unit TestingLexer;


interface

uses
  FileStr, lexer, SysUtils;

function lexerTest : string;

implementation


const
  testFolder = 'lexertests\';

function testLexerNumb(NumberTest : integer) : boolean;
var
  inputStr : string;
  AOutStr, AOutType : ArrayStr;
  i : integer;
  TEl : TGrammarElementType;
  StrTemp : string;
begin
  result := false;
  initFile(testFolder + intToStr(NumberTest) + '_text.txt');
  inputStr := fileToStr();
  initFile(testFolder + intToStr(NumberTest) + '_str.txt');
  AOutStr := fileToArrayStr();
  initFile(testFolder + intToStr(NumberTest) + '_type.txt');
  AOutType := fileToArrayStr();
  initLexer(inputStr);
  for i := 0 to length(AOutStr) - 1 do begin
    StrTemp := lexerNext(Tel);
    if AOutStr[i] <> StrTemp then
      exit;
    StrTemp := TGrammarElementTypetoStr(TEl);
    if StrTemp <> AOutType[i] then
      exit;
  end;
  result := true;
end;

function lexerTest : string;
var
  i : integer;
  ANameTest : ArrayStr;
  s : string;
begin
  initFile(testFolder + '\NamesTestLexer.txt');
  ANameTest := fileToArrayStr;
  s := '';
  for i := 0 to length(ANameTest) - 1 do
    if not(testLexerNumb(i + 1)) then begin
      if s = '' then
        s := 'Error Test:'  + ANameTest[i]
      else
        s := s  + ', ' + ANameTest[i];
    end;
  if s = '' then
    result := 'Ok'
  else
    result := s;
end;



end.
