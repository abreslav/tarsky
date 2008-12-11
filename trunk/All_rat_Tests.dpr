program All_rat_Tests;
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
  ok: Integer;
begin
  ok := 0;
  {Test_Add('00EF00EF', '00790079', '01680168');
  Test_Add('E000', 'E000', '0001C000');
  Test_Add('000E0000', '000E0000', '0000001C0000');
  Test_Add('E000E000', 'E000E000', '0001C001C000');
  Test_Add('BCDEEDBC', '0000', 'BCDEEDBC');
  Test_Add('0000', 'BCDEEDBC', 'BCDEEDBC');
  readln; }
  WriteLn('+');
  Test_add_rat(ok, '0000', '0000', '0001', '0001', '0000', '0001', nsPlus, nsPlus, nsPlus);
  Test_add_rat(ok, '0001', '0001', '0001', '0001', '0002', '0001', nsPlus, nsPlus, nsPlus);
  Test_add_rat(ok, '0001', '0001', '0001', '0002', '0003', '0002', nsPlus, nsPlus, nsPlus);
  Test_Add_Rat(ok, '0001', 'FFFF', '0001', '0001', '00010000', '0001', nsPlus, nsPlus, nsPlus);
  Test_Add_Rat(ok, 'BCDEEDCB', 'CFA77AFC', '0239', '0239', '00018C8668C7','0239',  nsPlus, nsPlus, nsPlus);
  Test_Add_Rat(ok, 'BCDEEDCB', 'CFA77AFC', '0239', '0239', '00018C8668C7','0239',  nsMinus, nsMinus, nsMinus);
  Test_Add_Rat(ok, '0002', '00010001', '0239', '0239', 'FFFF', '0239', nsMinus, nsPlus, nsPlus);
  Test_Add_Rat(ok, '0002', '00010001', '0239', '0239', 'FFFF', '0239', nsPlus, nsMinus, nsMinus);
  if ok = 0 then WriteLn('All Tests OK');
  WriteLn('Falses: ', ok);
  WriteLn('-');
  ok := 0;
  Test_Subtract_rat(ok, '0000', '0000', '0001', '0001', '0000', '0001', nsPlus, nsMinus, nsPlus);
  Test_subtract_rat(ok, '0001', '0001', '0001', '0001', '0002', '0001', nsPlus, nsMinus, nsPlus);
  Test_subtract_rat(ok, '0001', '0001', '0001', '0002', '0003', '0002', nsPlus, nsMinus, nsPlus);
  Test_subtract_Rat(ok, '0001', 'FFFF', '0001', '0001', '00010000', '0001', nsPlus, nsMinus, nsPlus);
  Test_subtract_Rat(ok, 'BCDEEDCB', 'CFA77AFC', '0239', '0239', '00018C8668C7','0239',  nsPlus, nsMinus, nsPlus);
  Test_subtract_Rat(ok, 'BCDEEDCB', 'CFA77AFC', '0239', '0239', '00018C8668C7','0239',  nsMinus, nsPlus, nsMinus);
  Test_Subtract_Rat(ok, '0002', '00010001', '0239', '0239', 'FFFF', '0239', nsMinus, nsMinus, nsPlus);
  Test_Subtract_Rat(ok, '0002', '00010001', '0239', '0239', 'FFFF', '0239', nsPlus, nsPlus, nsMinus);
  if ok = 0 then WriteLn('All Tests OK');
  WriteLn('Falses: ', ok);
  WriteLn('*');
  ok := 0;
  Test_Mult_rat(ok, '234FABD7', 'F456A430',  'F456A430',  '234FABD7', '0001', '0001', nsMinus, nsMinus, nsPlus);
  Test_Mult_rat(ok, '0000', '2345ACDA', '0001', 'FAE24352', '0000', '0001', nsPlus, nsMinus, nsMinus);
  if ok = 0 then WriteLn('All Tests OK');
  WriteLn('Falses: ', ok);
  readln;
end.