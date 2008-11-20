program SubTests;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  TestSub, Naturals;

var
  a, b, c : string;
  s : TNumberSign;
begin
  Test_Sub('000100000000', '0001', 'FFFFFFFF', nsPlus);
  Test_Sub('0001', '000100000000', 'FFFFFFFF', nsMinus);
  Test_Sub('000200000000', '0001', '0001FFFFFFFF', nsPlus);
  Test_Sub('0001', '000200000000', '0001FFFFFFFF', nsMinus);
  Test_Sub('00010239', '00010000', '0239', nsPlus);
  Test_Sub('00010000', '00010239', '0239', nsMinus);
  Test_Sub('000100239000', '000100239000', '0000', nsPlus);
  ReadLn;
end.