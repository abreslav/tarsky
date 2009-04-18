unit OldCode;

interface

implementation



{function sravneniye(a, b : TNaturalNumber) : integer;
var
  i, tempResult : integer;
begin
  tempResult := - CompareNaturals(a, b);

  if length(a) < length(b) then
    setlength(a, length(b));
  if length(b) < length(a) then
    setlength(b, length(a));
  for i := (length(a) - 1) downto 0 do begin
    if a[i] > b[i] then begin
      result := 1;


  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

      exit;
    end;
    if a[i] < b[i] then begin
      result := -1;

  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

      exit;
    end;
  end;
  result := 0;

  //------------------
  if tempResult <> result then
    writeln('Errorrrr');
  //------------------

end;  }

//-------------------------------------------------------------------------



////////////////////////////////naturals




//----------------------------

{

procedure makeA_B(var a : TNaturalNumber; const b : TNaturalNumber);
var
  i : integer;
begin
  SetLength(a, length(b));
  for i := 0 to (length(b) - 1) do begin
    a[i] := b[i];
  end;
end;



procedure vardivide(var result, module, a : TNaturalNumber; const b : TNaturalNumber);
var
  n : TNaturalNumber;
  x : TNumberSign;
  p : TNaturalNumber;
begin
  if CompareNaturals(a, b) = 1 then begin
    makeA_B(module, a);
    SetLength(result, 1);
    result[0] := 0;
    exit;
  end;
  SetLength(n, 1);
  n[0] := 1;
  if a[0] and 1 = 1 then begin
    shrNN(a);
    vardivide(result, module, a, b);
    shlNN(module, 1);
    shlNN(result, 1);
    makeA_B(p, module);
    add(module, p, n);
  end
  else begin
    shrNN(a);
    vardivide(result, module, a, b);
    shlNN(module, 1);
    shlNN(result, 1);
  end;
  if CompareNaturals(module, b) <= 0 then begin
    makeA_B(p, result);
    add(result, p, n);
    x := NsMinus;
    makeA_B(p, module);
    subtract(module, x, p, b);
  end;
end;    }

{procedure oldDivide(var result, module : TNaturalNumber; const a, b : TNaturalNumber);
var
  x : TNaturalNumber;
begin
  makeA_B(x, a);
  vardivide(result, module, x, b);
  toNaturals(result);
  toNaturals(module);
  disposeNatural(x);
end;   }


{procedure oneNatural(var a : TNaturalNumber);
begin
  setLength(a, 1);
  a[0] := 1;
end;





procedure newr(var x, y : TNaturalNumber);
type
  PNatNumber = ^TNaturalNumber;
  CancOper = (plus1, inw);
  POper = ^TOper;
  TOper = record
    TData : CancOper;
    TNatural : PNatNumber;
    nextOper : POper;
  end;


var
  OperRad, tempOp : POper;
  tNaturalTemp, temp : TNaturalNumber;
  sign : TNumberSign;
  a, b, l : PNatNumber;
begin
  OperRad := nil;
  new(a);
  a^ := x;
  new(b);
  b^ := y;

  while true do begin

    if not itIsNotZero(a^) then begin
      oneNatural(b^);
      break;
    end;
    case compareNaturals(a^, b^) of
      0: begin
        oneNatural(a^);
        oneNatural(b^);
        break;
      end;
      1: begin
        l := a;
        a := b;
        b := l;
        new(tempOp);
        tempOp^.TData := inw;
        tempOp^.TNatural := nil;
        tempOp^.nextOper := OperRad;
        OperRad := tempOp;
      end;
      -1: begin

        firstTemp;

        tNaturalTemp := aboutDivideNatural(a^, b^);
        mult(temp, tNaturalTemp, b^);



        subtract(a^, sign, a^, temp);
        disposeNatural(temp);

        closeTemp;

        new(tempOp);
        tempOp^.TData := Plus1;
        new(tempOp^.TNatural);
        tempOp^.TNatural^ := tNaturalTemp;
        tempOp^.nextOper := OperRad;
        OperRad := tempOp;

      {
      Cancellation(a, b);


      mult(temp, tNaturalTemp, b);
      add(a, a, temp);


      disposeNatural(temp);
      disposeNatural(TNaturalTemp); }
      {end;
    end;
  end;


  while OperRad <> nil do begin
    if operRad^.TData = inw then begin
      l := a;
      a := b;
      b := l;
    end else begin
      firstTemp;
      mult(temp, OperRad^.TNatural^, b^);
      add(a^, a^, temp);
      disposeNatural(temp);
      disposeNatural(OperRad^.TNatural^);
      closeTemp;

      dispose(OperRad^.TNatural);
    end;
    tempOp := OperRad.nextOper;
    dispose(OperRad);
    OperRad := tempOp;
  end;
  x := a^;
  y := b^;
  dispose(a);
  dispose(b);





end;


procedure Cancellation(var a, b : TNaturalNumber);
var
  tNaturalTemp, temp : TNaturalNumber;
  sign : TNumberSign;
begin
  {newr(a,b);
  exit; }

  {if not itIsNotZero(a) then begin
    oneNatural(b);
    exit;
  end;
  case compareNaturals(a, b) of
    0: begin
      oneNatural(a);
      oneNatural(b);
    end;
    1: begin
      Cancellation(b, a);
    end;
    -1: begin
    //  firstTemp;
      tNaturalTemp := aboutDivideNatural(a, b);
      mult(temp, tNaturalTemp, b);


      subtract(a, sign, a, temp);
      disposeNatural(temp);
      //closeTemp;

      Cancellation(a, b);


      mult(temp, tNaturalTemp, b);
      add(a, a, temp);


      disposeNatural(temp);
      disposeNatural(TNaturalTemp);

    end;
  end;



end;}


////////////////////////////////////////////////////////constractingSignTable


{procedure toTPolynomSystem;
var
  i, j, l : integer;
  TempSystem : TPolynomSystem;
  k : boolean;
  p, pTemp, pL : TPolynom;
begin
  setLength(TempSystem, length(PolynomSystem));
  TempSystem[0] := PolynomSystem[0];
  l := 1;
  for i := 1 to length(PolynomSystem) - 1 do begin
    k := true;
    for j := 0 to l - 1 do
      if comparePolynoms(tempSystem[j]^, PolynomSystem[i]^) = 0 then
        k := false;
    if k then begin
      TempSystem[l] := PolynomSystem[i];
      inc(l);
    end;
  end;




  setLength(PolynomSystem, l);
  for i := 0 to l - 1 do begin
    PolynomSystem[i] := TempSystem[i];
  end;


 // disposePolynom(p);
// DisposePolynom(pL);
 // disposePolynom(pTemp);
  setLength(TempSystem, 0);


  {
  setLength(PolynomSystem, l + 1);
  PolynomSystem[0] := TempSystem[0];
  p := TempSystem[0]^;
  for i := 1 to l - 1 do begin
    PolynomSystem[i] := TempSystem[i];
    if (length(TempSystem[i]^) > 2) or false then begin
      copyPolynoms(pl, p);
      polynoms.mult(p, pl, TempSystem[i]^);
    end;
  end;
  new(PolynomSystem[l]);
  derivative(PolynomSystem[l]^, p);

 // disposePolynom(p);
// DisposePolynom(pL);
 // disposePolynom(pTemp);
  setLength(TempSystem, 0);



   }
  ///////////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
  {for i := 0 to length(PolynomSystem) - 1 do
    ToNewPolynom(PolynomSystem[i]^); }
//end;

{
procedure addNewColumns; // идём по к + 1 строчке и если встречаем + - то вставляем между ними столбец.
var
  nextColumn, t : PSignTableColumn;
begin
  nextColumn := table.FirstColumn;
  while nextColumn.next <> nil do begin
    t := nextColumn.next;
    if between(EasyGet(nextColumn, k + 1), EasyGet(nextColumn.next, k + 1)) = 0 then
      fillNextColumn(nextColumn);
    nextColumn := t;
  end;
end;


function searchZero(var Column : PSignTableColumn) : integer; // Поиск нуля в этом столбце от 0 до к
var
  i : integer;
begin
  result := -1;
  for i := 0 to k do
    if EasyGet(Column, i) = 0 then
      result := i;
  if result = -1 then begin
    writeln('code 45');
    readln;
  end;
end;


procedure fillTheSquare(var Column : PSignTableColumn); // заполнение K + 1 клетки.
var
  l : integer;
  p : TPolynom;
begin
  l := searchZero(Column);
  module(p, PolynomSystem[k + 1]^, PolynomSystem[l]^);
  if length(p) <> 1 then begin
    l := search(PolynomSystem, p, pos, -6);
    EasyWrite(Column, k + 1, EasyGet(Column, l));
  end else begin
    l := polynomNaPlus(p);
    EasyWrite(Column, k + 1, l);
  end;
  disposePolynom(p);
end;









procedure modellingOfNewRow;
var
  Column : PSignTableColumn;
  l : integer;
begin
  Column := table.FirstColumn;
  l := polinomNaMinus(PolynomSystem[k + 1]^);
  EasyWrite(Column, k + 1, l);

  column := column.next;

  while column.next <> nil do begin
    fillTheSquare(Column);
    column := column.Next;
  end;

  l := polynomNaPlus(PolynomSystem[k + 1]^);
  EasyWrite(Column, k + 1, l);
end;

}


{procedure llmm; // заполняем к+1 строку...
var
  i : integer;
  p : TPolynom;
  l : integer;
  tempC : PTableColumn;
  xTemp, pTemp : TRationalNumber;
  signPolynom : integer;
begin
  ggkk;
  if PListColumn = nil then
    exit;


  if length(PolynomSystem[k + 1]^) = 2 then begin
    CopyRationals(xTemp, PolynomSystem[k + 1]^[0]^);
    notSign(xTemp.sign);

    for i := k + 2 to length(PolynomSystem) - 1 do begin
      tempC := PListColumn;

      if length(PolynomSystem[i]^) = 2 then
        rationals.add(pTemp, PolynomSystem[i]^[0]^, xTemp)
      else
        CountInTRational(pTemp, PolynomSystem[i]^, xTemp);

      l := signTRat(pTemp);
      disposeRational(pTemp);
      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, l);
        tempC := tempC^.Next;
      end;
    end;
    disposeRational(xTemp);
  end;


  for i := k + 2 to length(PolynomSystem) - 1 do begin
    tempC := PListColumn;
    module(p, PolynomSystem[i]^, PolynomSystem[k + 1]^);




    if length(p) <> 1 then begin

    //111111111111111111111111111111111111111111111111
      signPolynom := ToNewPolynom(p);
    //111111111111111111111111111111111111111111111111111111

      l := search(PolynomSystem, p, pos, -6);
      if l = -1 then begin
        writeln(tpolynomToStr(PolynomSystem[i]^));
        writeln(tpolynomToStr(PolynomSystem[k + 1]^));
        writeln(tpolynomToStr(p));
      end;

      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, signPolynom*EasyGet(tempC^.Column, l));
        tempC := tempC^.Next;
      end;
    end else begin
      l := polynomNaPlus(p);
      while tempC <> nil do begin
        EasyWrite(tempC^.Column, i, l);
        tempC := tempC^.Next;
      end;
    end;  // if length(p) <> 1

    disposePolynom(p);
  end; //for

end;}


///////////////////////////////////////////////////////////formulae
 {

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
  formulaErrorFlag := true;
  if (RationalNumber^.Numerator <> nil) and (RationalNumber^.Denominator <> nil) then
    result := '( '
     + tNumbSignToStr(RationalNumber^.Sign)
     + ' '
     + tNaturlNumberToStr(RationalNumber^.Numerator)
     + '/'
     + tNaturlNumberToStr(RationalNumber^.Denominator)
     + ')'
  else
    formulaErrorFlag := false;
end;


function tInegSingToStr(TSing : TInequationSign) : string;
begin
  case TSing of
    isGreater: result := '>';
    isGreaterEqual: result := '>=';
    isLess: result := '<';
    isLessEqual: result := '<=';
    isEqual: result := '=';
    isNotEqual: result := '<>';
  end;
end;






function tPolynomToStr(Polynom : TPolynom; k : boolean = false) : string;
var
  i : integer;
begin
  if k then
    push(Polynom);

  result := '( ';
  for i := 0 to length(Polynom) - 2 do
    result := result + pRationalNumberToStr(Polynom[i]) + ', ';
  result := result + pRationalNumberToStr(Polynom[length(Polynom) - 1]) + ')';
end;

function pIneguationToStr(var Inequation : PInequation; k : boolean = false) : string;
begin
  formulaErrorFlag := true;
  if (inequation^.polynom <> nil) then
    result := tPolynomToStr(inequation^.polynom, k)
    + ' '
    + tInegSingToStr(inequation^.InequationSign)
    + ' 0'
  else
    formulaErrorFlag := false;
end;

function pStatSystToStr(PStatSys : PStatementSystem; k : boolean = false) : string;
begin
  formulaErrorFlag := true;
  case pStatSys^.Operation of
    oAnd: if (pStatSys^.LeftSS <> nil) and (pStatSys^.RightSS <> nil) then
      result := '(' + pStatSystToStr(pStatSys^.LeftSS, k) + ') And (' + pStatSystToStr(pStatSys^.RightSS, k) + ')'
    else
      formulaErrorFlag := false;

    oOr: if (pStatSys^.LeftSS <> nil) and (pStatSys^.RightSS <> nil) then
      result := '(' + pStatSystToStr(pStatSys^.LeftSS, k) + ') Or (' + pStatSystToStr(pStatSys^.RightSS, k) + ')'
    else
      formulaErrorFlag := false;

    oNot: if (pStatSys^.LeftSS <> nil) and (pStatSys^.RightSS = nil) then
      result := 'Not (' + pStatSystToStr(pStatSys^.LeftSS, k) + ')'
    else
      formulaErrorFlag := false;

    oInequation: if (pStatSys^.LeftSS = nil) and (pStatSys^.Inequation <> nil) then
      result := pIneguationToStr(pStatSys^.Inequation, k)
    else
      formulaErrorFlag := false;
  else
    formulaErrorFlag := false;
  end;
end;

function tQuantFormulaToStr(const TFormula : TQuanitifedFormula; k : boolean = false) : string;
begin

  if k then
    initStek;

  formulaErrorFlag := true;
  case TFormula.Quantor of    }


//------------------------------------------------------------------------



///////////////////////////////////////////////////polynoms
  {if (length(b) = 2) and (length(a) = 2) then begin
    firstTemp;
    setLength(result, 1);
    new(result[0]);
    rationals.mult(xTemp, a[1]^, b[0]^, 0);
    rationals.divide(yTemp, xTemp, b[1]^, 0);
    rationals.subtract(result[0]^, yTemp, a[0]^, 0);
    disposeRational(xTemp);
    disposeRational(yTemp);
    closeTemp;
    exit;
  end; }

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
end;}


end.
