require_relative 'helper'

class TestMemory < MiniTest::Test
  include ArmHelper

  def test_ldr
    code = @machine.ldr  :r0, right: :r0
    assert_code code, :ldr ,  [0x00,0x00,0x90,0xe5] #e5 90 00 00
  end
  def test_ldr2
    code = @machine.ldr  :r0, right: :r0 , :offset =>  4
    assert_code code, :ldr ,  [0x04,0x00,0x90,0xe5] #e5 90 00 04
  end
  def test_ldrb
    code = @machine.ldrb  :r0, right: :r0
    assert_code code, :ldrb ,  [0x00,0x00,0xd0,0xe5] #e5 d0 00 00
  end

  def test_str
    code = @machine.str  :r0, right: :r1
    assert_code code, :str ,  [0x00,0x00,0x81,0xe5] #e5 81 00 00
  end

  def test_strb_add
    code = @machine.strb  :r0, right: :r1 , :offset =>  1 , flaggie: 1
    assert_code code, :strb ,  [0x01,0x00,0xc1,0xe4] #e4 c1 00 01
  end

  def test_strb
    code = @machine.strb  :r0, right: :r0
    assert_code code, :strb ,  [0x00,0x00,0xc0,0xe5] #e5 c0 00 00
  end
end
