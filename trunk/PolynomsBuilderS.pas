unit PolynomsBuilderS;

interface






uses
  SysUtils,
  ParserError;



Procedure InitBuilderS(t : integer);
function  resultBuilderS() : string;


procedure forwardErrorParser();

procedure BuildNumber(currentTokenData : string);
procedure BuildVar();
procedure BuildPower(currentTokenData : string);

procedure afterPower(currentTokenData : string);
procedure forwardPower();


procedure afterFactor();
procedure forwardFactor(plusOpFactor : string);

procedure afterMult();
procedure forwardMult();

procedure afterSum();
procedure forwardSum();

procedure afterPolynom();
procedure forwardPolynom();



//-------------------------------------Заглушки-----------------------------------------

procedure forwardMultFactor(melOpMult : string);
procedure forwardSumMult(plusOpSum : string);





implementation


var
  ResultString : string;
  numOfGap : integer;
  NameVar : string;
  plusOpFactor : string;


Procedure InitBuilderS(t : integer);
begin
  numOfGap := t - 1;
  ResultString := '';
end;

function  resultBuilderS() : string;
begin
  result := resultString;
end;

procedure PlusGap();
begin
  numOfGap := numOfGap + 1;
end;

procedure MinusGap();
begin
  numOfGap := numOfGap - 1;
end;


procedure writeGap();
var
  i : integer;
begin
  for i := 1 to 2 * numOfGap do
    ResultString := ResultString + ' ';
end;

procedure WriteStr(S : string);
begin

  if errorFlag then
    exit;

  writeGap;
  ResultString := ResultString + s + #13#10;
end;

procedure forwardErrorParser;
begin
  resultString := resultString + ErrorStr + #13#10;
end;







procedure BuildNumber(currentTokenData : string);
begin
  WriteStr('number ' + currentTokenData);
end;



procedure BuildVar();
begin
  WriteStr('var ' + NameVar);
end;

procedure BuildPower(currentTokenData : string);
begin
  BuildVar();
  BuildNumber(currentTokenData);
end;




procedure afterPower(currentTokenData : string);
begin
  NameVar := currentTokenData;
  plusGap;
    writeStr('< power >');
    plusGap;
end;

procedure forwardPower;
begin
    minusGap;
    writeStr('< /power >');
  minusGap;
end;


procedure afterPolynom();
begin
  plusGap;
    writeStr('< polynom >');
    plusGap;
end;

procedure forwardPolynom();
begin
    minusGap;
    writeStr('< /polynom >');
  minusGap;
end;

procedure afterFactor();
begin
  plusGap;
    writeStr('< factor >');
    plusGap;
end;

procedure forwardFactor(plusOpFactor : string);
begin
    minusGap;
    writeStr('< /factor >');
  minusGap;
end;

procedure afterMult();
begin
  plusGap;
    writeStr('< mult >');
    plusGap;

end;

procedure forwardMult();
begin
    minusGap;
    writeStr('< /mult >');
  minusGap;

end;

procedure afterSum();
begin
  plusGap;
    writeStr('< Sum >');
    plusGap;

end;

procedure forwardSum();
begin
    minusGap;
    writeStr('< /Sum >');
  minusGap;

end;



//-------------------------------------Заглушки-----------------------------------------




procedure forwardMultFactor(melOpMult : string);
begin

end;


procedure forwardSumMult(plusOpSum : string);
begin

end;





end.
