unit Draw;


interface

uses DelphiGraph,
  FullSys,
  polynoms;

procedure DrawPolynom(const p : TPolynom; c : TColor);
procedure DrawCoordinateSystem(k : Integer);
procedure DrawPS(const a : TPolynomSystem);
procedure DrawAll;
procedure ReadPS(var a : TPolynomSystem);
procedure AddPS(const a : TPolynomSystem);
procedure MOUSEandZOOM;
procedure initdraw;


implementation

uses
  PaintUtils,
  PaintType,
  naturals,
  rationals,
  Counting,
  printing
  ;

const
  w = 800;
  h = 800;
  cmain = clGray;
  cplane = clSilver;
  dm = 10;
  dc = 20;

var
  center : PaintType.TPoint;
  m : Integer;
  t : Boolean = false;
  f : File;


procedure SetCenter(p : PaintType.TPoint);
begin
  center := p;
end;

procedure DrawCoordinateSystem(k : Integer);
var
  p1, p2 : PaintType.TPoint;
begin
  t := true;
  m := k;
  p1.x := 0;
  p1.y := 0;
  p2.x := 0;
  p2.y := GetMaxY;
  while p1.x <= GetMaxX do begin
    p1.x := p1.x + 1;
    p2.x := p2.x + 1;
    if round(p1.x - center.x) mod m = 0 then
      ConnectPoints(p1, p2, cplane);
  end;
  p1.x := 0;
  p1.y := 0;
  p2.x := GetMaxX;
  p2.y := 0;
  while p1.y <= GetMaxY do begin
    p1.y := p1.y + 1;
    p2.y := p2.y + 1;
    if round(p1.y - center.y) mod m = 0 then
      ConnectPoints(p1, p2, cplane);
  end;
  p1.x := center.x;
  p1.y := 0;
  p2.x := center.x;
  p2.y := h;
  SetPenWidth(2);
  ConnectPoints(p1, p2, cmain);
  p1.x := 0;
  p1.y := center.y;
  p2.x := w;
  p2.y := center.y;
  ConnectPoints(p1, p2, cmain);
  SetPenWidth(1);
  SetFontName('Arial');
  SetFontSize(10);
  SetFontColor(clBlack);
  TextOut(round(center.x) + 2, round(center.y) + 1, '0');
end;



function IntToTNat(x : Integer) : TNaturalNumber;
begin
  SetLength(Result, 1);
  Result[0] := x;
end;

function CR(const p : TPolynom; x0 : Integer) : Integer;
var
  d, x : TRationalNumber;
begin
  d.sign := nsPlus;
  d.numerator := IntToTNat(1);
  d.denominator := IntToTNat(m);
  if x0 >= 0 then
    x.sign := nsPlus
  else
    x.sign := nsMinus;
  x.numerator := IntToTNat(abs(x0));
  x.denominator := IntToTNat(m);
  Result := CountResult(p, d, x);
  //if abs(Result) > 2 * h then Result := 1000
end;


procedure DrawPolynom(const p : TPolynom; c : TColor);
var
 x, y : Integer;
 xx, yy : Integer;
begin
  SetPenColor(c);
  SetPenWidth(2);
  x := round(-center.x);
  y := round(center.y);
    xx := x + round(center.x);
    if xx < 0 then
      xx := -1
    else if xx > GetMaxX then
      xx := GetMaxX + 1;
    yy := round(center.y) - CR(p, x);
    if yy < 0 then
      yy := -1
    else if yy > GetMaxY then
      yy := GetMaxY + 1;
  MoveTo(xx, yy);
  for x := round(-center.x) + 1 to round(center.x) do begin
    xx := x + round(center.x);
    if xx < 0 then
      xx := -1
    else if xx > GetMaxX then
      xx := GetMaxX + 1;
    yy := round(center.y) - CR(p, x);
    if yy < 0 then
      yy := -1
    else if yy > GetMaxY then
      yy := GetMaxY + 1;
    LineTo(xx, yy);
  end;
  SetPenWidth(1);
end;




function GetColor(const p : TPolynom) : TColor;
var
  l, i, R, G, B : Integer;
begin
  l := length(p);
  R := l;
  G := 2 * l + 1;
  B := l;
  for i := 0 to l - 1 do begin
    R := R + (p[i]^.numerator[0] + p[i]^.denominator[0]) * (2 * i + 1);
    G := G * (2 * p[i]^.numerator[0] * p[i]^.denominator[0] xor i + 1);
    B := B xor (p[i]^.numerator[0] xor p[i]^.denominator[0] + i);
  end;
  R := (R * 2335 - 178) mod 256;
  G := (G * 3256 - 163) mod 256;
  B := (B * 2954 - 239) mod 256;
  if R + G + B > 600 then begin
    R := R - 70;
    G := G - 70;
    B := B - 70;
  end;
  Result := RGB(R, G, B);
end;



procedure DrawPS(const a : TPolynomSystem);
var
  i : Integer;
begin
  if t = false then DrawCoordinateSystem(m);
  for i := 0 to length(a) - 1 do
    DrawPolynom(a[i]^, GetColor(a[i]^));
end;




procedure DeclarePS(var a : TPolynomSystem);
var
  l, htext, i, j : Integer;
  pos : TPolynomPosition;
begin
  l := length(a);
  Htext := 2 * TextHeight('01234/56789 * x^239');
  j := GetMaxY - l * htext;
  SetPolynomPositionWhenStarted(pos, l);
  QSort(a, 0, l-1, 0, pos);
  for i := 0 to l - 1 do begin
    setfontcolor(getcolor(a[pos[i]]^));
    textout(17, j, polytostring(a[pos[i]]^));
    j := j + htext;
  end;
end;






procedure DrawAll;
var
  a : TPolynomSystem;
begin
  FreezeScreen;
  CLrScr;
  ReadPS(a);
  DrawCoordinateSystem(m);
  DrawPS(a);
  DeclarePS(a);
  UnFreezeScreen;
end;




procedure ReadRational(var a : TRationalNumber);
var
  i, l : Integer;
begin
  BlockRead(f, a.sign, 1);
  BlockRead(f, l, 4);
  SetLength(a.numerator, l);
  for i := 0 to length(a.numerator) - 1 do begin
    BlockRead(f, a.numerator[i], 2);
  end;
  BlockRead(f, l, 4);
  SetLength(a.denominator, l);
  for i := 0 to length(a.denominator) - 1 do begin
    BlockRead(f, a.denominator[i], 2);
  end;
end;



procedure ReadPolynom(var p : TPolynom);
var
  i, l : Integer;
begin
  BlockRead(f, l, 4);
  SetLength(p, l);
  for i := 0 to length(p) - 1 do begin
    New(p[i]);
    ReadRational(p[i]^);
  end;
end;


procedure ReadPS(var a : TPolynomSystem);
var
  i, l : Integer;
begin
  Reset(f, 1);
  BlockRead(f, l, 4);
  SetLength(a, l);
  for i := 0 to length(a) - 1 do begin
    New(a[i]);
    ReadPolynom(a[i]^);
  end;
end;


procedure AddRational(const a : TRationalNumber);
var
  i, l : Integer;
begin
  BlockWrite(f, a.sign, 1);
  l := length(a.numerator);
  BlockWrite(f, l, 4);
  for i := 0 to length(a.numerator) - 1 do begin
    BlockWrite(f, a.numerator[i], 2);
  end;
  l := length(a.denominator);
  BlockWrite(f, l, 4);
  for i := 0 to length(a.denominator) - 1 do begin
    BlockWrite(f, a.denominator[i], 2);
  end;
end;


procedure AddPolynom(const p : TPolynom);
var
  i, l : Integer;
begin
  l := length(p);
  BlockWrite(f, l, 4);
  for i := 0 to length(p) - 1 do begin
    AddRational(p[i]^);
  end;
end;

procedure AddPS(const a : TPolynomSystem);
var
  i, l : Integer;
begin
  Reset(f, 1);
  if not EOF(f) then
    BlockRead(f, l, 4)
  else
    l := 0;
  l := l + length(a);
  Reset(f, 1);
  BlockWrite(f, l, 4);
  Seek(f, filesize(f));
  for i := 0 to length(a) - 1 do begin
    AddPolynom(a[i]^);
  end;
  DrawAll;
end;



procedure ZOOM;
var
  v : Word;
begin
  v := ReadKey;
  if v = VK_ADD then m := m + dm
  else if (v = VK_SUBTRACT) and (m > dm) then m := m - dm
  else if v = VK_UP then center.y := center.y + dc
  else if v = VK_DOWN then center.y := center.y - dc
  else if v = VK_LEFT then center.x := center.x + dc
  else if v = VK_RIGHT then center.x := center.x - dc
  else Exit;
  DrawAll;
end;

procedure MOUSE;
begin
end;

procedure MOUSEandZOOM;
begin
  WaitForGraph;
  Exit;
  while true do begin
    while (not MousePressed) and (not KeyPressed) do;
    if MousePressed then MOUSE;
    if KeyPressed then ZOOM;
  end;
end;




procedure initdraw;
begin
  InitGraph(w, h);
  m := 17;
  SetCenter(ctr);
  //HaltOnWindowClose := false;
  AssignFile(f, 'DrawPS.txt');
  ReWrite(f, 1);
end;


begin

end.
