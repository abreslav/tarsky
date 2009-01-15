unit PolynomParser;

interface

uses
  SysUtils,
  Lexer,
  PolynomsBuilderS,
//  PolynomsBuilderP,
  ParserError
  ;



procedure ReadPolynom();
procedure ReadPolynomParser(t :integer; currentTokenData : string; ResultType : TGrammarElementType);
function ReadCurrentTokenData(var ResultType : TGrammarElementType) : string;


implementation

type
  TString = (rMult, rPower, rFactor, rSum, rVar, rNumber, rPolynom, rIneq, rStaSyst, rStatement, rFormula);





var
  ResultType : TGrammarElementType;
  currentTokenData : string;







procedure ReadPower();
begin
  if ResultType = gVar then begin
    currentTokenData := LexerNext(ResultType);
    if ResultType = gPower then begin
      currentTokenData := LexerNext(ResultType);
      if ResultType = gNumber then begin

        //-----------
        BuildPower(currentTokenData);
        //-----------

        currentTokenData := LexerNext(ResultType);
      end else begin
        WriteErrorParser('number', ResultType, currentTokenData);

        //-----------
        forwardErrorParser();
        //-----------

        exit;
      end;
    end else
    
      //-----------
      BuildVar();
      //-----------

  end else begin
    WriteErrorParser('var', ResultType, currentTokenData);

    //-----------
    forwardErrorParser();
    //-----------

  end;
end;




Procedure ReadFactor();
var
  plusOpFactor : string;
begin
  case ResultType of
    gNumber : begin

      //--------------------
      BuildNumber(currentTokenData);
      //--------------------

      currentTokenData := LexerNext(ResultType);
    end;
    gBracketOpen : begin
      currentTokenData := LexerNext(ResultType);

      //---------------
      afterPolynom;
      //---------------

      ReadPolynom();

      if errorFlag then
        exit;

      //---------------
      forwardPolynom;
      //---------------

      if resultType <> gBracketClose then begin
        WriteErrorParser('close bracket', ResultType, currentTokenData);

        //---------------
        forwardErrorParser();
        //---------------

        exit;
      end;
      currentTokenData := LexerNext(ResultType);
    end;
    gVar : begin

      //---------------
      afterPower(currentTokenData);
      //---------------
      
      ReadPower;

      if errorFlag then
        exit;

      //----------------
      forwardPower;
      //----------------

    end;
    gPlusOp : begin

      //----------------
      afterFactor();
      plusOpFactor := currentTokenData;
      //----------------

      currentTokenData := LexerNext(ResultType);
      ReadFactor;

      if errorFlag then
        exit;

      //---------------
      forwardFactor(plusOpFactor);
      //---------------

    end;
  else begin
      WriteErrorParser('number, open bracket or var', ResultType, currentTokenData);
      forwardErrorParser();
    end;
  end;
end;




Procedure ReadMult();
var
  k : boolean;
  melOpMult : string;
begin

  //-----------------
  afterFactor();
  //-----------------

  ReadFactor;

  if errorFlag then
    exit;

  //-----------------
  forwardFactor('+');;
  //-----------------

  while ResultType = gMelOp do begin
    //----------------
    melOpMult := currentTokenData;
    //----------------

    currentTokenData := LexerNext(ResultType);

    //-----------------
    afterFactor();
    //-----------------

    ReadFactor();

    if errorFlag then
      exit;

    //-----------------
    forwardFactor('+');
    //-----------------

    //-----------------
    forwardMultFactor(melOpMult);
    //-----------------


  end;
end;




Procedure ReadSum();
var
  k : Boolean;
  plusOpSum : string;
begin

  //----------------
  afterMult();
  //----------------

  ReadMult();

  if errorFlag then
    exit;

  //----------------
  forwardMult();
  //----------------

  while ResultType = gPlusOp do begin

    //--------------
    plusOpSum := currentTokenData;
    //--------------



    currentTokenData := LexerNext(ResultType);

    //----------------
    afterMult();
    //----------------

    ReadMult();

    if errorFlag then
      exit;

    //----------------
    forwardMult();
    //----------------


    //------------------
    forwardSumMult(plusOpSum);
    //------------------



  end;
end;




procedure ReadPolynom();
begin
  afterSum;
  ReadSum();
  forwardSum;
end;

procedure ReadPolynomParser(t :integer; currentTokenData : string; ResultType : TGrammarElementType);
begin
  PolynomParser.currentTokenData := currentTokenData;
  PolynomParser.ResultType := ResultType;
  ReadPolynom();
  InitParserError;
end;

function ReadCurrentTokenData(var ResultType : TGrammarElementType) : string;
begin
  result := PolynomParser.currentTokenData;
  resultType := PolynomParser.ResultType;
end;




end.
