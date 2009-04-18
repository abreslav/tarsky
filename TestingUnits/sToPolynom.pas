unit sToPolynom;

interface





uses
  naturals,
  rationals,
  polynoms,
  minilexer,
  sysutils;


var
  errorFlag : boolean = false;
  errorStr : string = '';



{function intToPRat(K : Integer) : PRationalNumber;}
function strToRational(s : string; l : boolean = true; k : boolean = true) : PRationalNumber;
function strToNatural(s : string) : TNaturalNumber;
function strToPolynom(s : string) : TPolynom;
function strToSign(s : string) : TNumberSign;

function pRationalNumberToStr(RationalNumber : PRationalNumber) : string;
function tPolynomToStr(const Polynom : TPolynom) : string;
procedure writeError;

implementation


const
  cWord = 1 shl 16;


var
  ResultType : TGrammarElementType;
  currentTokenData : string;
  tempPRational : PRationalNumber;



procedure writeError;
begin
  if errorFlag then begin
    writeln(errorStr);
    readln;
    errorStr :='';
  end;
end;



procedure ItisError(s : string);
begin
  errorFlag := true;
  errorStr := errorStr + #13#10 + 'error:' + s;
end;

procedure primerError(s : string);
begin
  errorStr :='error Primer' + '''' + s + '''' + #13#10 + errorStr;
end;

procedure initError;
begin
  errorFlag := false;
end;





/////////////////----------------------фигня-всякая--------------------------------------------------





{function intToPRat(K : Integer) : PRationalNumber;
var
  i : integer;
begin
  new(result);
  if k >= 0 then
    result^.Sign := nsPlus
  else begin
    result^.Sign := nsMinus;
    k := -k;
  end;
  setlength(result^.Denominator, 1);
  result^.Denominator[0] := 1;
  setlength(result^.Numerator, (k div cWord) + 1);
  for i := 0 to (k div cWord) do begin
    result^.Numerator[i] := k mod cWord;
    k := k div cWord;
  end;
end;    }



///----------------------------------------------------------------



///----PolynomToStr-------------------------------------------

function int10ToStr16(k : integer) : string;
begin
  case k of
    0..9: result := intToStr(k);
    10: result := 'A';
    11: result := 'B';
    12: result := 'C';
    13: result := 'D';
    14: result := 'E';
    15: result := 'F';
  end;
end;


function wordToStr16(k : word) : string;
var
  i : integer;
begin
  result := '';
  for i := 1 to 4 do begin
    result := int10ToStr16(k mod 16) + result;
    k := k div 16;
  end;
end;


function tNaturlNumberToStr(NatNumber : TNaturalNumber) : string;
var
  i : integer;
begin
  result := '(';
  for i := 0 to length(NatNumber) - 2 do
    result := result + wordToStr16(NatNumber[i]) + ', ';
  result := result + wordToStr16(NatNumber[length(NatNumber) - 1]) + ')';
end;


function tNumbSignToStr(Sign : TNumberSign) : string;
begin
  case sign of
    nsPlus: result := '+';
    nsMinus: result := '-';
  end;
end;



function pRationalNumberToStr(RationalNumber : PRationalNumber) : string;
begin
  if (RationalNumber^.Numerator <> nil) and (RationalNumber^.Denominator <> nil) then
    result := '['
     + tNumbSignToStr(RationalNumber^.Sign)
     + ' '
     + tNaturlNumberToStr(RationalNumber^.Numerator)
     + '/'
     + tNaturlNumberToStr(RationalNumber^.Denominator)
     + ']';

end;









function tPolynomToStr(const Polynom : TPolynom) : string;
var
  i : integer;
begin
  result := '';
  for i := length(Polynom) - 1 downto  1 do
    if itIsNotRZero(Polynom[i]^) then
      result := result + pRationalNumberToStr(Polynom[i]) + ' * x ^ ' + inttostr(i) + ' + ';
  result := result + pRationalNumberToStr(Polynom[0]) + '';
end;

//-------------------------------------------------------------------------------------------------------------



//-----------------strToNaturals--------------------

function strToSign(s : string) : TNumberSign;
begin
  if s = '-' then
    result := nsMinus
  else
    result := nsPlus;
end;


procedure toNaturalStr(var s : string);
begin
  while (length(s) mod 4) <> 0 do
    s := '0' + s;
end;


function charToInt(c : char) : integer;
begin
  case UpCase(c) of
    'A'..'Z': result := ord(c) - ord('A') + 10;
    '0'..'9': result := ord(c) - ord('0');
    else begin
      result := -1;
      WriteLn('Error in sample string: char ''' + c + ''' is not allowed');
    end;
  end;
end;





function strtonatural(s : string) : TNaturalNumber;
var
  i, j : integer;
  w : word;
begin
  toNaturalStr(s);
  setlength(result, length(s) div 4);
  for i := 0 to (length(s) div 4) - 1 do begin
    w := 0;
    for j := 1 to 4 do begin
      w := w * 16;
      w := w + charToInt(s[4 * i + j]);
    end;
    result[(length(s) div 4) - i - 1] := w;
  end;
  toNaturals(result);
end;


//----------------------------------------------------------




//----------------------------strToRational------------------------

function strToRational(s : string; l : boolean = true; k : boolean = true) : PRationalNumber;
begin

//обработка ошибок
  if l then
    initError;
  if errorFlag then
    exit;
//----------------

  new(result);
  if k then begin
    initlexer(s);
    currentTokenData := LexerNext(ResultType);
  end;

  if ResultType = gPlusOp then begin
      if currentTokenData = '-' then
        result^.Sign := nsMinus
      else
        result^.Sign := nsPlus;
    currentTokenData := LexerNext(ResultType);
  end else
    result^.Sign := nsPlus;

  if ResultType = gNumber then
    result^.Numerator := strToNatural(currentTokenData)
  else begin
    ItisError('not found Numerator');
    if l then
      primerError(s);
    result := nil;
    if l then
      writeError;
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType <> gDiv then begin
    ItisError('not found ''''/'''' ');
    if l then
      primerError(s);
    result := nil;
    if l then
      writeError;
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType = gNumber then
    result^.Denominator := strToNatural(currentTokenData)
  else begin
    ItisError('not found Denominator');
    if l then
      primerError(s);
    result := nil;
    if l then
      writeError;
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  toTRationalsNumber(result^);

end;


//------------------------------------------------------------------------





function readPower : integer;
begin
  result := -1;

  if ErrorFlag then
    exit;

  if ResultType = gEnd then begin
    result := 0;
    exit;
  end;

  if ResultType <> gMult then begin
    ItisError('Not Found Mult');
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType <> gVar then begin
    ItisError('Not Found Var');
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType = gPower then begin

    currentTokenData := LexerNext(ResultType);

    if ResultType <> gNumber then begin
      ItisError('Not Found Power Number');
      exit;
    end else
      result := strToInt(currentTokenData);

    currentTokenData := LexerNext(ResultType);
  end else
    result := 1;

  if (ResultType <> gPlusOp) and (ResultType <> gEnd)  then begin
    ItisError('Not Found Polynom PlusOp');
    exit;
  end;
end;




function strToPolynom(s : string) : TPolynom;
var
  k, i : integer;

begin
  initError;

  tempPRational := strToRational(s, false);
  k := readPower;
  if k < 0 then begin
    ItIsError('stepen error');
    primerError(s);
    result := nil;
    writeError;
    exit;
  end;

  setLength(Result, k + 1);

  for i := 0 to k do
    result[i] := intToPRat(0);

  result[k] := tempPRational;



  while (ResultType <> gEnd) and (ResultType <> gError) do begin
    tempPRational := strToRational('',false, false);
    k := readPower;

    if (k < 0) then begin
      primerError(s);
      result := nil;
      writeError;
      exit;
    end;
    result[k] := tempPRational;
  end;
  toPolynom(result);

  if errorFlag or (ResultType <> gEnd) then begin
    primerError(s);
    result := nil;
    writeError;
  end;
end;





end.
