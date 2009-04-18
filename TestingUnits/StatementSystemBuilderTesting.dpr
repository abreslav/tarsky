program StatementSystemBuilderTesting;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  FormulaToString,
  ParserError,
  StatementSystemParser,
  StatementSystemBuilder;

procedure test (const strIn, strOut : string; var n : Integer);
var
  strParsOut : string;
begin
  Write('Test number ', n : 2, ': ');
  parse(strIn);
  strParsOut := FormulaToStr(StatementSystemBuilder.ResultFormula);
  if strParsOut = strOut then begin
    Writeln('OK');
    Writeln;
  end else begin
    if ParserError.errorFlag = true then begin
      Writeln('Error');
      Writeln;
      Write(ParserError.ErrorStr);
      Writeln;
    end else begin
      Writeln('Error');
      Writeln;
      Writeln('Out string :');
      Writeln(strParsOut);
      Writeln;
      Writeln('Must :');
      Writeln(strOut);
      Writeln;
    end;
  end;
  inc(n);
end;

var
  strIn, strOut : string;
  n : Integer;
begin
  n := 1;
  //1
  strIn := 'E x {1=0}';
  strOut := 'E x {[[+ (0001)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //2
  strIn := 'A x { 1 = 0 }';
  strOut := 'A x {[[+ (0001)/(0001)] = 0]}';
  test(strIn, strOut, n);


  //3
  strIn := 'E x {!1 = 0}';
  strOut := 'E x {![[+ (0001)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //4
  strIn := 'A x {[ 1 = 0 ] and [1=0]}';
  strOut := 'A x {[[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]}';
  test(strIn, strOut, n);
  //5
  strIn := 'E x {[ 1 = 0 ] or [1=0]}';
  strOut := 'E x {[[[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]}';
  test(strIn, strOut, n);
  //6
  strIn := 'A x {[ 1 = 0 ] --> [1=0]}';
  strOut := 'A x {[![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]}';
  test(strIn, strOut, n);


  //7
  strIn := 'E x { 1 < 0 }';
  strOut := 'E x {[[+ (0001)/(0001)] < 0]}';
  test(strIn, strOut, n);
  //8
  strIn := 'A x { 1 > 0 }';
  strOut := 'A x {[[+ (0001)/(0001)] > 0]}';
  test(strIn, strOut, n);
  //9
  strIn := 'E x { 1 <= 0 }';
  strOut := 'E x {[[+ (0001)/(0001)] <= 0]}';
  test(strIn, strOut, n);
  //10
  strIn := 'A x { 1 >= 0 }' ;
  strOut := 'A x {[[+ (0001)/(0001)] >= 0]}';
  test(strIn, strOut, n);
  //11
  strIn := 'E x { 1 = 0 }' ;
  strOut := 'E x {[[+ (0001)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //12
  strIn := 'A x { 1 <> 0 }';
  strOut := 'A x {[[+ (0001)/(0001)] <> 0]}';
  test(strIn, strOut, n);


  //13
  strIn := 'E x { x + x = 0 }' ;
  strOut := 'E x {[[+ (0002)/(0001)] * x ^ 1 + [+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //14
  strIn := 'A x { 4 + 7 = 0}' ;
  strOut := 'A x {[[+ (000B)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //15
  strIn := 'E x { r - r = 0 }' ;
  strOut := 'E x {[[+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //16
  strIn := 'A x { 7 - 5 = 0}' ;
  strOut := 'A x {[[+ (0002)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //17
  strIn := 'E x { h * h = 0 }' ;
  strOut := 'E x {[[+ (0001)/(0001)] * x ^ 2 + [+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //18
  strIn := 'A x {7 * 8 = 0}' ;
  strOut := 'A x {[[+ (0038)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //19
  strIn := 'E x { j / 2 = 0 }' ;
  strOut := 'E x {[[+ (0001)/(0002)] * x ^ 1 + [+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //20
  strIn := 'A x {6 /8 = 0}' ;
  strOut := 'A x {[[+ (0003)/(0004)] = 0]}';
  test(strIn, strOut, n);
  //21
  strIn := 'A x {t ^ 3 = 0}' ;
  strOut := 'A x {[[+ (0001)/(0001)] * x ^ 3 + [+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);


  //22
  strIn := 'A x { [[  [  [[[1 = 0] and 1 = 0 ]]  or  [[[1 = 0]]]  ] or  [[  [[[[[1 = 0]]]]] and 1 = 0]]  ]] }' ;
  strOut := 'A x {[[[[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]] or [[+ (0001)/(0001)] = 0]] or [[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]]}';
  test(strIn, strOut, n);
  //23
  strIn := 'E x { ![1 = 0] or ![[1 = 0] and 1 = 0]}' ;
  strOut := 'E x {[![[+ (0001)/(0001)] = 0] or ![[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]]}';
  test(strIn, strOut, n);
  //24
  strIn := 'A x { 1 = 0 --> [[[1 = 0] --> 1 = 0]--> [[1 = 0]-->1 = 0]]}' ;
  strOut := 'A x {[![[+ (0001)/(0001)] = 0] or [![![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]] or [![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]]]}';
  test(strIn, strOut, n);
  //25
  strIn := 'E x {[[1 = 0] and ![1 = 0] --> [1 = 0]] --> !1 = 0 or [[1 = 0] and![1 = 0]] }' ;
  strOut := 'E x {[![[[+ (0001)/(0001)] = 0] and [!![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]] or [![[+ (0001)/(0001)] = 0] or [[[+ (0001)/(0001)] = 0] and ![[+ (0001)/(0001)] = 0]]]]}';
  test(strIn, strOut, n);


  //26
  strIn := 'A x {[[1 = 0]] or 1 <= 0 or [[[[1 >= 0]]]] or [[1 >= 0]] or [1 <> 0]}' ;
  strOut := 'A x {[[[+ (0001)/(0001)] = 0] or [[[+ (0001)/(0001)] <= 0] or [[[+ (0001)/(0001)] >= 0] or [[[+ (0001)/(0001)] >= 0] or [[+ (0001)/(0001)] <> 0]]]]]}';
  test(strIn, strOut, n);

  //27
  strIn := 'E x { ((4 + 7)) - (6 + (((54)))- 66 - ((((7 - 8))))) + (((8)) - (5) - (((66- ( 77 -66) + 7))))  - 99 = 0}' ;
  strOut := 'E x {[[- (008E)/(0001)] = 0]}';
  test(strIn, strOut, n);
  //28
  strIn := 'A x { 9 * (3 *((-3)*3)* 1 / (15/-5)) * ((9/(-27))/-3/3) / -81 * (  81 * 3/ (3*3) * ( 4* 12/ (1 *2) ) / 24 ) / ((7/21)*81/9) = 0}' ;
  strOut := 'A x {[[- (0001)/(0003)] = 0]}';
  test(strIn, strOut, n);
  //29
  strIn := 'E x {6/2 + (5 + 8 /-4) - 71 - (5-4/1) + 35*(-3)/5 = 0}';
  strOut := 'E x {[[- (0057)/(0001)] = 0]}';
  test(strIn, strOut, n);


  //30
  strIn := 'A x {-(x^ 3 * x^5 *x) - x^6*(x ^3 + x^2 *x) =  + x^9 -x ^ 4*( x*x*5) * x^3}' ;
  strOut := 'A x {[[+ (0001)/(0001)] * x ^ 9 + [+ (0000)/(0001)] = 0]}';
  test(strIn, strOut, n);


  //31
  strIn := 'E x {-(x^ 3 * x^5 *x)/-4 - x^6*(-x ^3 + x^2- 42) <  + x^9 -x ^ 4*( x+x^2/33*x*11)/6 * x^3 + 77}' ;
  strOut := 'E x {[[+ (0001)/(0012)] * x ^ 10 + [+ (0001)/(0004)] * x ^ 9 + [- (0005)/(0006)] * x ^ 8 + [+ (002A)/(0001)] * x ^ 6 + [- (004D)/(0001)] < 0]}';
  test(strIn, strOut, n);


  //32
  strIn := 'E x {(x - 2)^2 = 3}' ;
  strOut := 'E x {[[+ (0001)/(0012)] * x ^ 10 + [+ (0001)/(0004)] * x ^ 9 + [- (0005)/(0006)] * x ^ 8 + [+ (002A)/(0001)] * x ^ 6 + [- (004D)/(0001)] < 0]}';
  test(strIn, strOut, n);



  Readln;
end.

1  'E x {1=0}'                       E          'E x {[[+ (0001)/(0001)] = 0]}'
2  'A x { 1 = 0 }'                   A          'A x {[[+ (0001)/(0001)] = 0]}'


3  'E x {!1 = 0}'                    !        'E x {![[[+ (0001)/(0001)] = 0]]}'
4  'A x {[ 1 = 0 ] and [1=0]}'       and      'A x {[[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]}'
5  'E x {[ 1 = 0 ] or [1=0]}'        or       'E x {[[[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]}'
6  'A x {[ 1 = 0 ] --> [1=0]}'       -->      'A x {[![[[+ (0001)/(0001)] = 0]] or [[+ (0001)/(0001)] = 0]]}'


7  'E x { 1 < 0 }'                   <        'E x {[[+ (0001)/(0001)] < 0]}'
8  'A x { 1 > 0 }'                   >        'A x {[[+ (0001)/(0001)] > 0]}'
9  'E x { 1 <= 0 }'                   <=      'E x {[[+ (0001)/(0001)] <= 0]}'
10 'A x { 1 >= 0 }'                   >=      'A x {[[+ (0001)/(0001)] >= 0]}'
11 'E x { 1 = 0 }'                   =        'E x {[[+ (0001)/(0001)] = 0]}'
12 'A x { 1 <> 0 }'                   <>      'A x {[[+ (0001)/(0001)] <> 0]}'


13 'E x { x + x = 0 }'                  +     'E x {[[+ (0002)/(0001)] * x ^ 1 + [+ (0000)/(0001)] = 0]}'
14 'A x { 4 + 7 = 0}'                         'A x {[[+ (000B)/(0001)] = 0]}'
15 'E x { r - r = 0 }'                  -     'E x {[[+ (0000)/(0001)] = 0]}'
16 'A x { 7 - 6 = 0}'                         'A x {[[+ (0002)/(0001)] = 0]}'
17 'E x { h * h = 0 }'                  *     'E x {[[+ (0001)/(0001)] * x ^ 2 + [+ (0000)/(0001)] = 0]}'
18 'A x {7 * 8 = 0}'                          'A x {[[+ (0038)/(0001)] = 0]}'
19 'E x { j / 2 = 0 }'                  /     'E x {[[+ (0001)/(0002)] * x ^ 1 + [+ (0000)/(0001)] = 0]}'
20 'A x {6 /8 = 0}'                           'A x {[[+ (0003)/(0004)] = 0]}'
21 'A x {t ^ 3 = 0}'                    ^     'A x {[[+ (0001)/(0001)] * x ^ 3 + [+ (0000)/(0001)] = 0]}'


22 'A x { [[  [  [[[1 = 0] and 1 = 0 ]]  or  [[[1 = 0]]]  ] or  [[  [[[[[1 = 0]]]]] and 1 = 0]]  ]] }'
     'A x {[[[[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]] or [[+ (0001)/(0001)] = 0]] or [[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]]}';
23 'E x { ![1 = 0] or ![[1 = 0] and 1 = 0]}'
     'E x {[![[+ (0001)/(0001)] = 0] or ![[[+ (0001)/(0001)] = 0] and [[+ (0001)/(0001)] = 0]]]}';
24 'A x { 1 = 0 --> [[[1 = 0] --> 1 = 0]--> [[1 = 0]-->1 = 0]]}'
     'A x {[![[+ (0001)/(0001)] = 0] or [![![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]] or [![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]]]}';
25 'E x {[[1 = 0] and ![1 = 0] --> [1 = 0]] --> !1 = 0 or [[1 = 0] and![1 = 0]] }'
     'E x {[![[[+ (0001)/(0001)] = 0] and [!![[+ (0001)/(0001)] = 0] or [[+ (0001)/(0001)] = 0]]] or [![[+ (0001)/(0001)] = 0] or [[[+ (0001)/(0001)] = 0] and ![[+ (0001)/(0001)] = 0]]]]}';


26 'A x {[[1 = 0]] or 1 <= 0 or [[[[1 >= 0]]]] or [[1 >= 0]] or [1 <> 0]}'
     'A x {[[[+ (0001)/(0001)] = 0] or [[[+ (0001)/(0001)] <= 0] or [[[+ (0001)/(0001)] >= 0] or [[[+ (0001)/(0001)] >= 0] or [[+ (0001)/(0001)] <> 0]]]]]}'


27 'E x { ((4 + 7)) - (6 + (((54)))- 66 - ((((7 - 8))))) + (((8)) - (5) - (((66- ( 77 -66) + 7))))  - 99 = 0}'
     'E x {[[- (008E)/(0001)] = 0]}'
28 'A x { 9 * (3 *((-3)*3)* 1 / (15/-5)) * ((9/(-27))/-3/3) / -81 * (  81 * 3/ (3*3) * ( 4* 12/ (1 *2) ) / 24 ) / ((7/21)*81/9) = 0}'
     'A x {[[- (0001)/(0003)] = 0]}'
29 'E x {6/2 + (5 + 8 /-4) - 71 - (5-4/1) + 35*(-3)/5 = 0}'
     'E x {[[- (0057)/(0001)] = 0]}'

30 'A x {-(x^ 3 * x^5 *x) - x^6*(x ^3 + x^2 *x) =  + x^9 -x ^ 4*( x*x*5) * x^3}'
     'A x {[[+ (0001)/(0001)] * x ^ 9 + [+ (0000)/(0001)] = 0]}'
31 'E x {-(x^ 3 * x^5 *x)/-4 - x^6*(-x ^3 + x^2- 42) =  + x^9 -x ^ 4*( x+x^2/33*x*11)/6 * x^3 + 77}'
     'E x {[[+ (0001)/(0012)] * x ^ 10 + [+ (0001)/(0004)] * x ^ 9 + [- (0005)/(0006)] * x ^ 8 + [+ (002A)/(0001)] * x ^ 6 + [- (004D)/(0001)] < 0]}'



Formula --> Quantor VAR '{' StatementSystem '}';
Quantor --> 'E' | 'A';
StatementSystem --> Statement | Statement Oper StatementSystem;
Oper --> 'and' | 'or' | '-->';
Statement --> '[' StatementSystem ']' | '!' Statement | Inequation;
Inequation --> Polynom IneqSign Polynom;
IneqSign --> '<' | '>' | '=' | '>=' | '<=' | '<>';
Polynom --> Mult | Mult PlusOp Polynom;
PlusOp --> '+' | '-';
Mult --> Factor | Factor MelOp Mult;
MelOp --> '*' | '/';
Factor --> NUMBER | '(' Polynom ')' | Power | PlusOp Factor;
Power --> VAR | VAR '^' NUMBER;
VAR --> [ a - z A - Z _][a - z A - Z _ 0 - 9]*;
NUMBER --> [0 - 9] +;
