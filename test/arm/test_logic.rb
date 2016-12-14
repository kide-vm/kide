require_relative 'helper'

class TestLogic < MiniTest::Test
  include ArmHelper

  def test_mul1
    code = @machine.mul(  :r0 , :r1 , :r2)
    assert_code code , :mul , [0x91,0x02,0x10,0xe0] #e0 10 02 91
  end
  def test_mul2
    code = @machine.mul(  :r1 , :r2 , :r3)
    assert_code code , :mul , [0x92,0x03,0x11,0xe0] #e0 11 03 92
  end
  def test_mul3
    code = @machine.mul(  :r2 , :r3 , :r4)
    assert_code code , :mul , [0x93,0x04,0x12,0xe0] #e0 12 04 93
  end
  def test_and
    code = @machine.and(  :r1 , :r2 , :r3)
    assert_code code , :and , [0x03,0x10,0x12,0xe0] #e0 12 10 03
  end
  def test_bic
    code = @machine.bic	 :r2 , :r2 , :r3
    assert_code code , :bic , [0x03,0x20,0xd2,0xe1] #e3 d2 20 44
  end
  def test_eor
    code = @machine.eor	 :r2 , :r2 , :r3
    assert_code code , :eor , [0x03,0x20,0x32,0xe0] #e0 32 20 03
  end
  def test_rsb
    code = @machine.rsb	 :r1 ,  :r2 ,  :r3
    assert_code code , :rsb , [0x03,0x10,0x72,0xe0]#e0 72 10 03
  end
  def test_rsc
    code = @machine.rsc	 :r2 ,  :r3 ,  :r4
    assert_code code , :rsc , [0x04,0x20,0xf3,0xe0]#e0 f3 20 04
  end
  def test_sbc
    code = @machine.sbc	 :r3,  :r4 ,  :r5
    assert_code code , :sbc , [0x05,0x30,0xd4,0xe0]#e0 d4 30 05
  end
  def test_sub
    code = @machine.sub  :r2, :r0, 1
    assert_code code, :sub ,  [0x01,0x20,0x50,0xe2] #e2 50 20 01
  end
  def test_subs
    code = @machine.sub  :r2, :r2, 1 , update_status: 1
    assert_code code, :sub ,  [0x01,0x20,0x52,0xe2] #e2 52 20 01
  end
  def test_orr
    code = @machine.orr	 :r2 , :r2 , :r3
    assert_code code , :orr , [0x03,0x20,0x92,0xe1] #e1 92 20 03
  end
end
