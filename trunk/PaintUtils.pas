unit PaintUtils;

interface

uses
  SysUtils, DelphiGraph, PaintType;

const
  FullDegree = 180;

procedure ConnectPoints(const a, b : PaintType.TPoint; c : TColor = -1);
procedure PaintPoint(const a : PaintType.TPoint; const r : Real; const c : TColor);
function GetCartesianCoordinates(const l, a : Real) : PaintType.TPoint;
procedure Circle(const r : Real);
procedure Ray(const a : Real);
procedure PaintPlane(const dR : Real; const k : Integer; const c : TColor);
function ctr : PaintType.TPoint;
procedure PaintPoints(const a : PaintType.TPoints; const r : Real; const c : TColor);
procedure ClearScreen;
procedure DrawRound(const p : PaintType.TPoint; const r : Real);
function GetScreenMaxSize : Real;


implementation

function ctr : PaintType.TPoint;
begin
  Result.x := GetMaxX / 2;
  Result.y := GetMaxY / 2;
end;

procedure ClearScreen;
begin
  SetBrushColor(clWhite);
  SetBrushStyle(bsSolid);
  clrscr;
end;

procedure ConnectPoints(const a, b : PaintType.TPoint; c : TColor = -1);
begin
  if c <> -1 then
    SetPenColor(c);
  MoveTo(round(a.x), round(a.y));
  LineTo(round(b.x), round(b.y));
end;

procedure PaintPoint(const a : PaintType.TPoint; const r : Real; const c : TColor);
begin
  SetPenColor(c);
  SetPenStyle(psSolid);
  SetBrushColor(c);
  SetBrushStyle(bsSolid);
  Ellipse(round(a.x) - round(r), round(a.y) - round(r), round(a.x) + round(r), round(a.y) + round(r));
end;

procedure PaintPoints(const a : PaintType.TPoints; const r : Real; const c : TColor);
var
  i : Integer;
begin
  for i := 0 to Length(a) - 1 do
    PaintPoint(a[i], r, c);
end;

function GetCartesianCoordinates(const l, a : Real) : PaintType.TPoint;
begin
  Result.x := ctr.x + cos(a / FullDegree * pi) * l;
  Result.y := ctr.y - sin(a / FullDegree * pi) * l;
end;

procedure Circle(const r : Real);
begin
  Ellipse(round(ctr.x) - round(r), round(ctr.y) - round(r), round(ctr.x) + round(r), round(ctr.y) + round(r));
end;

procedure DrawRound(const p : PaintType.TPoint; const r : Real);
begin
  Ellipse(round(p.x) - round(r), round(p.y) - round(r), round(p.x) + round(r), round(p.y) + round(r));
end;


function GetScreenMaxSize : Real;
begin
  Result := ord(GetMaxX >= GetMaxY) * GetMaxX + ord(GetMaxX < GetMaxY) * GetMaxY;
end;



procedure Ray(const a : Real);
var
  r : TPoint;
begin
  r := GetCartesianCoordinates(GetScreenMaxSize, a);
  ConnectPoints(ctr, r);
end;

procedure PaintPlane(const dR : Real; const k : Integer; const c : TColor);
var
  i : Integer;
begin
  SetPenColor(c);
  SetPenStyle(psSolid);
  SetBrushStyle(bsClear);
  for i := 1 to round(GetScreenMaxSize / dR + 1) do
    Circle(i * dR);
  for i := 0 to k - 1 do
    Ray(i * 2 * FullDegree / k);
end;

end.
