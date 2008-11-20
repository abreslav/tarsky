program Add_Tests;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  TestAdd,
  Naturals,
  TestingUtils;

begin
  Test_Add('00EF00EF', '00790079', '01680168');
  Test_Add('E000', 'E000', '0001C000');
  Test_Add('000E0000', '000E0000', '0000001C0000');
  Test_Add('E000E000', 'E000E000', '0001C001C000');
  Test_Add('BCDEEDBC', '0000', 'BCDEEDBC');
  Test_Add('0000', 'BCDEEDBC', 'BCDEEDBC');
  readln;
end.