unit CheckError;

interface

var
  ErrorFlag : boolean;   // ���, ���� ������ ����, ����, ���� ���
  ErrorStr : string;

procedure InitCheckError;
procedure WriteErrorPolynoms(NameError : string);
procedure WriteErrorRationals(NameError : string);
procedure WriteErrorNaturals(NameError : string);

 (*

    � ���������� Error ���� ������ �������� ���������, � �������
    ��������� ������.

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
