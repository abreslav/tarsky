program Testing;
{$APPTYPE CONSOLE}


uses
  TestingLexer;

var
  s : string;



begin
  s :=lexerTest;
  write(s);
  readln;

end.
