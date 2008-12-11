program AddTestsRat;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  TestAdd,
  Naturals,
  TestingUtils,
  TestAddRat in 'TestAddRat.pas';

{,
  Unit1 in '\\SCH239\WRK\PPL\10\1\TYSHUKYO\INFO\Unit1.pas'; }
var
  m, n: TNaturalNumber;
begin
  {Test_Add('00EF00EF', '00790079', '01680168');
  Test_Add('E000', 'E000', '0001C000');
  Test_Add('000E0000', '000E0000', '0000001C0000');
  Test_Add('E000E000', 'E000E000', '0001C001C000');
  Test_Add('BCDEEDBC', '0000', 'BCDEEDBC');
  Test_Add('0000', 'BCDEEDBC', 'BCDEEDBC');
  readln; }
  Test_add_rat('0000', '0000', '0001', '0001', '0000', '0001', nsPlus, nsPlus, nsPlus);
  Test_add_rat('0001', '0001', '0001', '0001', '0002', '0001', nsPlus, nsPlus, nsPlus);
  Test_add_rat('0001', '0001', '0001', '0002', '0003', '0002', nsPlus, nsPlus, nsPlus);
  Test_Add_Rat('0001', 'FFFF', '0001', '0001', '00010000', '0001', nsPlus, nsPlus, nsPlus);
  Test_add_rat('BCDEEDCB', 'BCDEEDCB', 'C5H6BA08', 'C5H6BA08', '0000', '0001', nsPlus, nsMinus, nsPlus);
  Test_Add_Rat('AD01BC6A2397', 'AD01BC6A2497', '0100', '0100', '0001', '0001', nsMinus, nsPlus, NsPlus);
  Test_Add_Rat('BC5E2397', 'BC5E2497', '0100', '0100', '0001', '0001', nsPlus, nsMinus, NsMinus);
  Test_Add_Rat('0239', '0194', '3765AB88', '3765AB88', '00A5', '3765AB88]', nsPlus, nsMinus, nsPlus);
  {setlength(m, 2);
  setlength(n, 2);
  m[0] := 60875;
  m[1] := 48350;
  n[0] := 47624;
  n[1] := 50770;
  format10to16write(m);
  writeLn;
  format10to16write(n);}
  readln;
end.