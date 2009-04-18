unit New_Dispose;

interface
uses
  Polynoms,
  Rationals,
  SysUtils,
  FullSys;



var


  runNaturalsAdd, runNaturalsSubtract, runNaturalsMult, runNaturalsDivide, runNaturalsGCD : integer;
  timeNaturalsAdd, timeNaturalsSubtract, timeNaturalsMult, timeNaturalsDivide, timeNaturalsGCD : TDateTime;


  runRationalsAdd, runRationalsMult, runRationalsDivide, runRationalsSubtract : integer;
  timeRationalsAdd, timeRationalsMult, timeRationalsDivide, timeRationalsSubtract : TDateTime;

  runPolynomsDerivative, runPolynomsModule, runPolynomsMult, runPolynomsSubtract, runPolynomsAdd : integer;
  timePolynomsDerivative, timePolynomsModule, timePolynomsMult, timePolynomsSubtract, timePolynomsAdd  : TDateTime;



  numbersColumn, lengthPolynomSystem : integer;

  timeConstractingFullSys : TDateTime;







procedure WriteTime;


procedure firstPolynomsAdd;
procedure closePolynomsAdd;

procedure firstPolynomsMult;
procedure closePolynomsMult;

procedure firstPolynomsSubtract;
procedure closePolynomsSubtract;

procedure firstPolynomsDerivative;
procedure closePolynomsDerivative;

procedure firstPolynomsModule;
procedure closePolynomsModule;




procedure firstRationalsAdd;
procedure closeRationalsAdd;

procedure firstRationalsSubtract;
procedure closeRationalsSubtract;

procedure firstRationalsDivide;
procedure closeRationalsDivide;

procedure firstRationalsMult;
procedure closeRationalsMult;


procedure firstNaturalsAdd;
procedure closeNaturalsAdd;

procedure firstNaturalsSubtract;
procedure closeNaturalsSubtract;

procedure firstNaturalsMult;
procedure closeNaturalsMult;

procedure firstNaturalsDivide;
procedure closeNaturalsDivide;

procedure firstNaturalsGCD;
procedure closeNaturalsGCD;


procedure numColumn(k : integer);
procedure lengthPS(k : integer);

implementation





var



  tempNaturalsAdd, tempNaturalsSubtract, tempNaturalsMult, tempNaturalsDivide, tempNaturalsGCD : TDateTime;



  tempRationalsAdd, tempRationalsMult, tempRationalsDivide, tempRationalsSubtract : TDateTime;

  tempPolynomsderivative, tempPolynomsmodule, tempPolynomsmult, tempPolynomssubtract, tempPolynomsadd : TDateTime;









procedure numColumn(k : integer);
begin
  numbersColumn := k;
end;

procedure lengthPS(k : integer);
begin
  lengthPolynomSystem := k;
end;

procedure firstPolynomsAdd;
begin
  inc(runPolynomsAdd);
  tempPolynomsAdd := now;
end;
procedure closePolynomsAdd;
begin
  timePolynomsAdd := now - tempPolynomsAdd + timePolynomsAdd;
end;




procedure firstPolynomsMult;
begin
  inc(runPolynomsMult);
  tempPolynomsMult := now;
end;
procedure closePolynomsMult;
begin
  timePolynomsMult := now - tempPolynomsMult + timePolynomsMult;
end;




procedure firstPolynomsSubtract;
begin
  inc(runPolynomsSubtract);
  tempPolynomsSubtract := now;
end;
procedure closePolynomsSubtract;
begin
  timePolynomsSubtract := now - tempPolynomsSubtract + timePolynomsSubtract;
end;




procedure firstPolynomsderivative;
begin
  inc(runPolynomsderivative);
  tempPolynomsderivative := now;
end;
procedure closePolynomsderivative;
begin
  timePolynomsderivative := now - tempPolynomsderivative + timePolynomsderivative;
end;




procedure firstPolynomsmodule;
begin
  inc(runPolynomsmodule);
  tempPolynomsmodule := now;
end;
procedure closePolynomsmodule;
begin
  timePolynomsmodule := now - tempPolynomsmodule + timePolynomsmodule;
end;




procedure firstRationalsAdd;
begin
  inc(runRationalsAdd);
  tempRationalsAdd := now;
end;
procedure closeRationalsAdd;
begin
  timeRationalsAdd := now - tempRationalsAdd + timeRationalsAdd;
end;



procedure firstRationalsSubtract;
begin
  inc(runRationalsSubtract);
  tempRationalsSubtract := now;
end;
procedure closeRationalsSubtract;
begin
  timeRationalsSubtract := now - tempRationalsSubtract + timeRationalsSubtract;
end;



procedure firstRationalsDivide;
begin
  inc(runRationalsDivide);
  tempRationalsDivide := now;
end;
procedure closeRationalsDivide;
begin
  timeRationalsDivide := now - tempRationalsDivide + timeRationalsDivide;
end;


procedure firstRationalsMult;
begin
  inc(runRationalsMult);
  tempRationalsMult := now;
end;
procedure closeRationalsMult;
begin
  timeRationalsMult := now - tempRationalsMult + timeRationalsMult;
end;










procedure firstNaturalsAdd;
begin
  inc(runNaturalsAdd);
  tempNaturalsAdd := Now;
end;
procedure closeNaturalsAdd;
begin
  timeNaturalsAdd := timeNaturalsAdd + now - tempNaturalsAdd;
end;


procedure firstNaturalsSubtract;
begin
  inc(runNaturalsSubtract);
  tempNaturalsSubtract := Now;
end;
procedure closeNaturalsSubtract;
begin
  timeNaturalsSubtract := timeNaturalsSubtract + now - tempNaturalsSubtract;
end;


procedure firstNaturalsMult;
begin
  inc(runNaturalsMult);
  tempNaturalsMult := Now;
end;
procedure closeNaturalsMult;
begin
  timeNaturalsMult := timeNaturalsMult + now - tempNaturalsMult;
end;


procedure firstNaturalsDivide;
begin
  inc(runNaturalsDivide);
  tempNaturalsDivide := Now;
end;
procedure closeNaturalsDivide;
begin
  timeNaturalsDivide := timeNaturalsDivide + now - tempNaturalsDivide;
end;


procedure firstNaturalsGCD;
begin
  inc(runNaturalsGCD);
  tempNaturalsGCD := Now;
end;
procedure closeNaturalsGCD;
begin
  timeNaturalsGCD := timeNaturalsGCD + now - tempNaturalsGCD;
end;






procedure WriteTime;

begin
  writeln;
  writeln('Time Rationals ADD');
  writeln(timeToStr(timeRationalsAdd));
  writeln('Run Add');
  writeln(runRationalsAdd);
  writeln;
 {
  writeln('Time Run Temp');
  writeln(timeToStr(timeTemp));
  writeln('Run Temp');
  writeln(runTemp);
  writeln;

  writeln('Time Run Gg');
  writeln(timeToStr(timeGg));
  writeln('Run Gg');
  writeln(runGg);
  writeln;

  writeln('Time Run GCD');
  writeln(timeToStr(timeGCD));
  writeln('Run GCD');
  writeln(runGCD);
  writeln;
  writeln('Time Run Divide');
  writeln(timeToStr(timeDivide));
  writeln('Run Divide');
  writeln(runDivide);  }

 { t := searchstr('rationals.divide');
  writeln('naturals.divide');
  writeln(timeToStr(t^.time));
  writeln(t^.run);
  writeln;     }

end;






begin
  runNaturalsAdd := 0;
  timeNaturalsAdd := 0;

  runNaturalsSubtract := 0;
  timeNaturalsSubtract := 0;

  runNaturalsMult := 0;
  timeNaturalsMult := 0;

  runNaturalsDivide := 0;
  timeNaturalsDivide := 0;

  runNaturalsGCD := 0;
  timeNaturalsGCD := 0;



  runRationalsAdd := 0;
  timeRationalsAdd := 0;

  runRationalsSubtract := 0;
  timeRationalsSubtract := 0;

  runRationalsMult := 0;
  timeRationalsMult := 0;

  runRationalsDivide := 0;
  timeRationalsDivide := 0;



  runPolynomsAdd := 0;
  timePolynomsAdd := 0;

  runPolynomsSubtract := 0;
  timePolynomsSubtract := 0;

  runPolynomsMult := 0;
  timePolynomsMult := 0;

  runPolynomsModule := 0;
  timePolynomsModule := 0;

  runPolynomsDerivative := 0;
  timePolynomsDerivative := 0;





end.
