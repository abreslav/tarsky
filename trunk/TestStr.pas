unit TestStr;

interface

procedure NameUnit(s : string);
procedure NameProcedure(S : string);
procedure ErrorTest(S : string);
function ResultTestString : string;
procedure writeErrorToStr;

implementation



var
  StrTest : string;
  ErrorTestFlag : boolean;  //true есть ошибка в тестах false - нет ошибок
  ErrorTestName : string;
  First : boolean = true;




function ResultTestString : string;
begin
  writeErrorToStr;
  result := strTest;
end;

procedure writeErrorToStr;
begin
  if first then begin
    first := false;
    exit;
  end;
  if ErrorTestFlag then begin
    strTest := strTest + #13#10 + '    ErrorTest:' + ErrorTestName + '.';
    ErrorTestFlag := false;
  end else
    strTest := strTest + ': ok';
  strTest := strTest + #13#10;
end;



procedure NameUnit(s : string);
begin
  writeErrorToStr;
  StrTest :=  StrTest + #13#10 + 'NameUnit: ' + s + #13#10;
  first := true;
end;

procedure NameProcedure(S : string);
begin
  writeErrorToStr;
  ErrorTestFlag := False;
  strTest := strTest + '  test ' + s;
end;



procedure ErrorTest(S : string);
begin
  if ErrorTestFlag then
    ErrorTestName := ErrorTestName + ', ' + s
  else begin
    ErrorTestName := s;
    ErrorTestFlag := true;
  end;
end;




begin
  strTest := 'AllTest:' + #13#10;


end.
