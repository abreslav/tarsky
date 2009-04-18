unit PaintType;

interface

type
  TPoint = record
    x, y : Real;
  end;
  TPoints = array of TPoint;
  TRounds = record
    center : Tpoint;
    size : Integer;
    rad : array of Real;
  end;
  TWater = array of TRounds;

implementation

end.
