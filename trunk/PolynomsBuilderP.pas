unit PolynomsBuilderP;

interface



uses
  Polynoms,
  Rationals,
  Naturals,
  SysUtils,
  ParserError,
  PolynomsStek
  ;



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
  TempPolynom : TRationalNumber;
  plusOpFactor : string;
  melOpMult : string;
  plusOpSum : string;

function intToPRat(K : Integer) : PRationalNumber;
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
end;


function toPolynoms(step, koef : integer) : TPolynom;
var
  i : integer;
begin
  setlength(result, step + 1);
  for i := 0 to step - 1 do
    result[i] := initzero;
  result[step] := intToPRat(koef);
end;

//------------------------------------------------------
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
    result := '( '
     + tNumbSignToStr(RationalNumber^.Sign)
     + ' '
     + tNaturlNumberToStr(RationalNumber^.Numerator)
     + '/'
     + tNaturlNumberToStr(RationalNumber^.Denominator)
     + ')';

end;









function tPolynomToStr(const Polynom : TPolynom) : string;
var
  i : integer;
begin
  push(Polynom);
  result := '( ';
  for i := length(Polynom) - 1 downto  1 do
    result := result + pRationalNumberToStr(Polynom[i]) + ', ';
  result := result + pRationalNumberToStr(Polynom[0]) + ')';
end;

//writeln(tPolynomToStr(

//--------------------------------------------------------




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



function itIsNotZeroConst(TPolynom : TPolynom) : boolean;
begin
  if (length(TPolynom) = 1) and itIsNotRZero(TPolynom[0]) then
    result := true
  else
    result := false;
end;

procedure PolynomDivRat(var P : TPolynom; k : PRationalNumber);
var
  i : integer;
begin
  for i := 0 to length(P) - 1 do begin
    TempPolynom := P[i]^;
    rationals.divide(P[i]^, TempPolynom, k^);
  end;
end;





//------------------------

procedure BuildNumber(currentTokenData : string);
begin
  try

    push(toPolynoms(0, strToInt(currentTokenData)));
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

    writeln('-');

    TPolynomTemp2 := toPolynoms(0, 0);
    polynoms.subtract(TPolynomTemp3, TPolynomTemp2, TPolynomTemp1);
    push(TPolynomTemp3);
  end;
end;



procedure forwardMultFactor(melOpMult : string);
begin
  TPolynomTemp2 := pop();

  writeln('-');

  TPolynomTemp1 := pop();

  writeln('-');

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

  writeln('-');

  TPolynomTemp1 := pop();

  writeln('-');

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
