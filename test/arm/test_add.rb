require_relative 'arm-helper'

class TestAdd < MiniTest::Test
  include ArmHelper

  def test_adc
    code = @machine.adc	 :r1,  :r3, :r5
    assert_code code , :adc , [0x05,0x10,0xa3,0xe0] #e0 a3 10 05
  end
  def test_add
    code = @machine.add	 :r1 , :r1, :r3
    assert_code code , :add , [0x03,0x10,0x81,0xe0] #e0 81 10 03
  end
  def test_add_const
    code = @machine.add	 :r1 , :r1, 0x22
    assert_code code , :add , [0x22,0x10,0x81,0xe2] #e2 81 10 22
  end
  def test_add_const_shift_lst
    code = @machine.add( :r1 , :r1 , 0x22 ,  shift_lsr: 8)
    assert_code code , :add , [0x22,0x14,0x81,0xe2] #e2 81 14 23
  end
  def test_add_lst
    code = @machine.add( :r1 , :r2 , :r3 ,  shift_lsr: 8)
    assert_code code , :add , [0x23,0x14,0x82,0xe0] #e0 82 14 23
  end
  def test_big_add
    code = @machine.add	 :r1 , :r1, 0x220
    assert_code code , :add , [0x20,0x12,0x81,0xe2] #e2 81 12 20
  end
end