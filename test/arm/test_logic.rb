require_relative 'helper'

class TestArmAsm < MiniTest::Test
  include ArmHelper

  def test_adc
    code = @machine.adc	 :r1, left: :r3, right: :r5
    assert_code code , :adc , [0x05,0x10,0xa3,0xe0] #e0 a3 10 05
  end
  def test_add
    code = @machine.add	 :r1 , left: :r1, right: :r3
    assert_code code , :add , [0x03,0x10,0x81,0xe0] #e0 81 10 03
  end
  def test_and # inst eval doesn't really work with and
    code = @machine.and(  :r1 , left: :r2 , right: :r3)
    assert_code code , :and , [0x03,0x10,0x02,0xe0] #e0 01 10 03
  end
  def test_eor
    code = @machine.eor	 :r2 , left: :r2 , right: :r3
    assert_code code , :eor , [0x03,0x20,0x22,0xe0] #e0 22 20 03
  end
  def test_sub
    code = @machine.sub  :r2, left: :r0, right: 1
    assert_code code, :sub ,  [0x01,0x20,0x40,0xe2] #e2 40 20 01 
  end
  def test_orr
    code = @machine.orr	 :r2 , left: :r2 , right: :r3
    assert_code code , :orr , [0x03,0x20,0x82,0xe1] #e1 82 20 03
  end
end
