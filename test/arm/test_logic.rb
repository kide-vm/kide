require_relative 'helper'

class TestLogic < MiniTest::Test
  include ArmHelper

  def test_adc
    code = @machine.adc	 :r1,  :r3, :r5
    assert_code code , :adc , [0x05,0x10,0xa3,0xe0] #e0 a3 10 05
  end
  def test_add
    code = @machine.add	 :r1 , :r1, :r3
    assert_code code , :add , [0x03,0x10,0x81,0xe0] #e0 81 10 03
  end
  def test_add_lst
    code = @machine.add( :r1 , :r2 , :r3 ,  shift_lsr: 8)
    assert_code code , :add , [0x23,0x14,0x82,0xe0] #e0 82 14 23
  end
  def test_and # inst eval doesn't really work with and
    code = @machine.and(  :r1 , :r2 , :r3)
    assert_code code , :and , [0x03,0x10,0x02,0xe0] #e0 01 10 03
  end
  def test_bic
    code = @machine.bic	 :r2 , :r2 , :r3
    assert_code code , :bic , [0x03,0x20,0xc2,0xe1] #e3 c2 20 44
  end
  def test_eor
    code = @machine.eor	 :r2 , :r2 , :r3
    assert_code code , :eor , [0x03,0x20,0x22,0xe0] #e0 22 20 03
  end
  def test_rsb
    code = @machine.rsb	 :r1 ,  :r2 ,  :r3
    assert_code code , :rsb , [0x03,0x10,0x62,0xe0]#e0 62 10 03
  end
  def test_rsc
    code = @machine.rsc	 :r2 ,  :r3 ,  :r4
    assert_code code , :rsc , [0x04,0x20,0xe3,0xe0]#e0 e3 20 04
  end
  def test_sbc
    code = @machine.sbc	 :r3,  :r4 ,  :r5
    assert_code code , :sbc , [0x05,0x30,0xc4,0xe0]#e0 c4 30 05
  end
  def test_sub
    code = @machine.sub  :r2, :r0, 1
    assert_code code, :sub ,  [0x01,0x20,0x40,0xe2] #e2 40 20 01 
  end
  def test_subs
    code = @machine.sub  :r2, :r2, 1 , update_status: 1
    assert_code code, :sub ,  [0x01,0x20,0x52,0xe2] #e2 52 20 01
  end
  def test_orr
    code = @machine.orr	 :r2 , :r2 , :r3
    assert_code code , :orr , [0x03,0x20,0x82,0xe1] #e1 82 20 03
  end
end
