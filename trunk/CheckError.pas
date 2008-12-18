unit CheckError;

interface

var
  ErrorFlag : boolean;   // тру, если ошибка есть, фолс, если нет
  ErrorStr : string;

procedure InitCheckError;
procedure WriteErrorPolynoms(NameError : string);
procedure WriteErrorRationals(NameError : string);
procedure WriteErrorNaturals(NameError : string);

 (*

    В переменную Error надо писать название процедуры, в котором
    произошла ошибка.

  *)

implementation

procedure InitCheckError;
begin
   ErrorFlag := false;
   ErrorStr := '';
end;


procedure MakeFlag;
begin
  ErrorFlag := true;
end;

procedure AddtoErrorStr(s, error : string);
begin
  MakeFlag;
  ErrorStr := ErrorStr + 'Error in ' + s + Error + #13#10;
end;



procedure WriteErrorPolynoms(NameError : string);
begin
  AddtoErrorStr('Polynoms.', NameError);
end;

procedure WriteErrorRationals(NameError : string);
begin
  AddtoErrorStr('Rationals.', NameError);
end;

procedure WriteErrorNaturals(NameError : string);
begin
  AddtoErrorStr('Naturals.', NameError);
end;


end.
