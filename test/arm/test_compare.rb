require_relative 'helper'

class TestArmAsm < MiniTest::Test
  include ArmHelper

  def test_cmn
    code = @machine.cmn	 :r1 , :r2
    assert_code code , :cmn , [0x02,0x00,0x71,0xe1] #e1 71 00 02
  end
  def test_cmp
    code = @machine.cmp	 :r1 , :r2
    assert_code code , :cmp , [0x02,0x00,0x51,0xe1] #e1 51 00 02
  end
  def test_teq
    code = @machine.teq  :r1 , :r2
    assert_code code , :teq , [0x02,0x00,0x31,0xe1] #e1 31 00 02
  end
  def test_tst
    code = @machine.tst  :r1 , :r2
    assert_code code , :tst , [0x02,0x00,0x11,0xe1] #e1 11 00 02
  end
  def test_tst2
    code = @machine.tst  :r1 , :r1
    assert_code code , :tst , [0x01,0x00,0x11,0xe1] #e1 11 00 01
  end
  def test_tst3
    code = @machine.tst  :r2 , :r2
    assert_code code , :tst , [0x02,0x00,0x12,0xe1] #e1 12 00 02
  end
end
