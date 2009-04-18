unit PolynomsBuilderP;

interface



uses
  Polynoms,
  Rationals,
  Naturals,
  SysUtils,
  ParserError,
  PolynomsStek;



procedure BuildNumber(currentTokenData : string);
procedure BuildVar();
procedure BuildPower(currentTokenData : string);


procedure forwardFactor(plusOpFactor : string);
procedure forwardMultFactor(melOpMult : string);
procedure forwardSumMult(plusOpSum : string);




//-------------------------------------Заглушки-----------------------------------------
procedure forwardErrorParser;

procedure afterPower(currentTokenData : string);
procedure forwardPower;

procedure afterPolynom();
procedure forwardPolynom();

procedure afterMult();
procedure forwardMult();

procedure afterSum();
procedure forwardSum();

procedure afterFactor();





implementation


var
  TPolynomTemp1, TPolynomTemp2, TPolynomTemp3 : TPolynom;


//---------------------------------------------------это всё пока не удалять.-------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------

 // TempPolynom : TRationalNumber;
 // plusOpFactor : string;
 // melOpMult : string;
 // plusOpSum : string;




{//------------------------------------------------------
function tNaturlNumberToStr(NatNumber : TNaturalNumber) : string;
var
  i : integer;
begin
  result := '(';
  for i := 0 to length(NatNumber) - 2 do
    result := result + intToStr(NatNumber[i]) + ', ';
  result := result + intToStr(NatNumber[length(NatNumber) - 1]) + ')';
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
  push(Polynom);
  result := '';
  for i := length(Polynom) - 1 downto  1 do
    result := result + pRationalNumberToStr(Polynom[i]) + ', ';
  result := result + pRationalNumberToStr(Polynom[0]) + '';
end; }

//writeln(tPolynomToStr(

//--------------------------------------------------------




{function itIsNotZero(PNumber : TNaturalNumber) : boolean;
var
  i : integer;
begin
  result := false;
  if PNumber = nil then
    exit;
  if (length(PNumber) = 1) and  (PNumber[0] = 0) then
      exit;
  result := true;
end;  }

{function itIsNotRZero(PRNumber : PRationalNumber) : boolean;
begin
  if (PRNumber <> nil) and itIsNotZero(PRNumber^.Numerator) then
    result := true
  else
    result := false;
end; }



{function itIsNotZeroConst(TPolynom : TPolynom) : boolean;
begin
  if (length(TPolynom) = 1) and itIsNotRZero(TPolynom[0]^) then
    result := true
  else
    result := false;
end; }




{function intToPRat(K : Integer) : PRationalNumber;
const
  cWord = 1 shl 16;
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
end;   }


{function zero() : PrationalNumber;
begin
  result := intToPRat(0);
end; }

//------------------------------------------------------------------------------------------------------------------------------

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
    end;
  end;
end;





function str16ToNatural(s : string) : TNaturalNumber;
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

function intToNatural(i : integer) : TNaturalNumber;
begin
  setLength(result, 1);
  result[0] := i;
end;


function str10ToNatural(s : string) : TNaturalNumber;
var
  nT, rT : TNaturalNumber;
  n10 : TNaturalNumber;
  i : integer;
begin
  n10 := intToNatural(10);
  result := intToNatural(strToInt(s[1]));
  for i := 2 to length(s) do begin
    naturals.mult(rT, result, n10);
    nT := intToNatural(strToInt(s[i]));
    naturals.add(result, rT, nT);
  end;
end;



function toPolynoms16(step : integer; s : string) : TPolynom;
var
  i : integer;
  sT : string;
  nNum : TNaturalNumber;
begin
  setlength(result, step + 1);
  for i := 0 to step - 1  do
    result[i] := initzero;
  new(result[step]);

  if s[1] = '#' then begin
    st := copy(s, 2, length(s) - 1);
    nNum := str16ToNatural(st);
  end else
    nNum := str10ToNatural(s);

  result[step].Sign := nsPlus;
  result[step].Numerator := nNum;
  result[step].Denominator := intToNatural(1);
end;





function toPolynoms(step, koef : integer) : TPolynom;
var
  i : integer;
begin
  setlength(result, step + 1);
  for i := 0 to step - 1  do
    result[i] := initzero;
  new(result[step]);
  result[step] := intToPRat(koef);
end;








//------------------------

procedure BuildNumber(currentTokenData : string);
begin
  try

    push(toPolynoms16(0, currentTokenData));
  except
    WriteError('Error Number:' + currentTokenData);
  end;
end;


procedure BuildPower(currentTokenData : string);
begin
  try
    Push(toPolynoms(strToInt(currentTokenData), 1));
  except
    WriteError('Error Number:' + currentTokenData);
  end;
end;

procedure BuildVar();
begin
  push(toPolynoms(1, 1));
end;




procedure forwardFactor(plusOpFactor : string);
begin
  if plusOpFactor = '-' then begin
    TPolynomTemp1 := pop();



    TPolynomTemp2 := toPolynoms(0, 0);
    polynoms.subtract(TPolynomTemp3, TPolynomTemp2, TPolynomTemp1);
    push(TPolynomTemp3);
  end;
end;



procedure forwardMultFactor(melOpMult : string);
begin
  TPolynomTemp2 := pop();



  TPolynomTemp1 := pop();



  if melOpMult = '*' then
      Polynoms.mult(TPolynomTemp3, TPolynomTemp1, TPolynomTemp2)
    else begin
      TPolynomTemp3 := TPolynomTemp1;
      if itIsNotZeroConst(TPolynomTemp2) then
        PolynomDivRat(TPolynomTemp3, TPolynomTemp2[0])
      else begin
        WriteError('Error: div by zero or polynom!');
        exit;
      end;
    end;
  push(TPolynomTemp3);
end;




procedure forwardSumMult(plusOpSum : string);
begin
  TPolynomTemp2 := pop();



  TPolynomTemp1 := pop();



  if plusOpSum = '-' then
    polynoms.subtract(TPolynomTemp3, TPolynomTemp1, TPolynomTemp2)
  else
    polynoms.add(TPolynomTemp3, TPolynomTemp1, TPolynomTemp2);
  push(TPolynomTemp3);
end;






//-------------------------------------Заглушки-----------------------------------------




procedure forwardErrorParser;
begin

end;

procedure afterPower(currentTokenData : string);
begin

end;

procedure forwardPower();
begin

end;

procedure afterPolynom();
begin

end;

procedure forwardPolynom();
begin

end;


procedure afterMult();
begin

end;

procedure forwardMult();
begin

end;

procedure afterSum();
begin

end;

procedure forwardSum();
begin

end;

procedure afterFactor();
begin

end;




end.
