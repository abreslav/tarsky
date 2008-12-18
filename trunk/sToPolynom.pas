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
  errorStr : string;




function strToRational(s : string; k : boolean = true) : PRationalNumber;
function strToNatural(s : string) : TNaturalNumber;
function strToPolynom(s : string) : TPolynom;
function strToSign(s : string) : TNumberSign;

function pRationalNumberToStr(RationalNumber : PRationalNumber) : string;
function tPolynomToStr(const Polynom : TPolynom) : string;

implementation


const
  cWord = 1 shl 16;


var
  ResultType : TGrammarElementType;
  currentTokenData : string;
  tempPRational : PRationalNumber;



procedure ItisError(s : string);
begin
  errorFlag := true;
  errorStr := 'error:' + s;
end;




/////////////////----------------------фигня-всякая--------------------------------------------------

function itIsNotZero(PNumber : TNaturalNumber) : boolean;
var
  i : integer;
begin
  result := false;
  if PNumber = nil then
    exit;
  if (length(PNumber) = 1) and  (PNumber[0] = 0) then
      exit;
  result := true;
end;

function itIsNotRZero(PRNumber : PRationalNumber) : boolean;
begin
  if (PRNumber <> nil) and itIsNotZero(PRNumber^.Numerator) then
    result := true
  else
    result := false;
end;


function intToPRat(K : Integer) : PRationalNumber;
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
end;



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
    if itIsNotRZero(Polynom[i]) then
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


procedure toNatural(var s : string);
begin
  while (length(s) mod 4) <> 0 do
    s := '0' + s;
end;


function chartoInt(c : char) : integer;
begin
  case UpCase(c) of
    'A'..'Z': result := ord(c) - ord('A') + 10;
    '0'..'9': result := ord(c) - ord('0');
    else WriteLn('Error in sample string: char ''' + c + ''' is not allowed');
  end;
end;





function strtonatural(s : string) : TNaturalNumber;
var
  i, j : integer;
  w : word;
begin
  toNatural(s);
  setlength(result, length(s) div 4);
  for i := 0 to (length(s) div 4) - 1 do begin
    w := 0;
    for j := 1 to 4 do begin
      w := w * 16;
      w := w + charToInt(s[4 * i + j]);
    end;
    result[(length(s) div 4) - i - 1] := w;
  end;
end;


//----------------------------------------------------------




//----------------------------strToRational------------------------

function strToRational(s : string; k : boolean = true) : PRationalNumber;
begin
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
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType <> gDiv then begin
    ItisError('not found ''''/'''' ');
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType = gNumber then
    result^.Denominator := strToNatural(currentTokenData)
  else begin
    ItisError('not found Denominator');
    exit;
  end;

  currentTokenData := LexerNext(ResultType);
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

  if ResultType <> gPower then begin
    ItisError('Not Found ''''^'''' ');
    exit;
  end;

  currentTokenData := LexerNext(ResultType);

  if ResultType <> gNumber then begin
    ItisError('Not Found Power Number');
    exit;
  end else
    result := strToInt(currentTokenData);

  currentTokenData := LexerNext(ResultType);

  if (ResultType <> gPlusOp) and (ResultType <> gEnd)  then begin
    ItisError('Not Found Polynom PlusOp');
    exit;
  end;
end;




function strToPolynom(s : string) : TPolynom;
var
  k, i : integer;

begin


  tempPRational := strToRational(s);
  k := readPower;
  if k < 0 then
    exit;

  setLength(Result, k + 1);

  for i := 0 to k do
    result[i] := intToPRat(0);

  result[k] := tempPRational;



  while (ResultType <> gEnd) and (ResultType <> gError) do begin
    tempPRational := strToRational('', false);
    k := readPower;

    if (k < 0) then
      exit;

    result[k] := tempPRational;
  end;
end;





end.
