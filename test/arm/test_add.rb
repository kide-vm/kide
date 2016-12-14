require_relative 'helper'

class TestAdd < MiniTest::Test
  include ArmHelper

  def test_adc
    code = @machine.adc	 :r1,  :r3, :r5
    assert_code code , :adc , [0x05,0x10,0xb3,0xe0] #e0 b3 10 05
  end
  def test_add
    code = @machine.add	 :r1 , :r1, :r3
    assert_code code , :add , [0x03,0x10,0x91,0xe0] #e0 91 10 03
  end
  def test_add_const
    code = @machine.add	 :r1 , :r1, 0x22
    assert_code code , :add , [0x22,0x10,0x91,0xe2] #e2 91 10 22
  end
  def test_add_const_pc
    code = @machine.add	 :r1 , :pc, 0x22
    assert_code code , :add , [0x22,0x10,0x9f,0xe2] #e2 9f 10 22
  end
  def test_add_const_shift
    code = @machine.add( :r1 , :r1 , 0x22 ,  shift_lsr: 8)
    assert_code code , :add , [0x22,0x14,0x91,0xe2] #e2 91 14 23
  end
  def test_add_lst
    code = @machine.add( :r1 , :r2 , :r3 ,  shift_lsr: 8)
    assert_code code , :add , [0x23,0x14,0x92,0xe0] #e0 92 14 23
  end
  def test_big_add
    code = @machine.add	 :r1 , :r1, 0x220
    assert_code code , :add , [0x22,0x1e,0x91,0xe2] #e2 91 1e 22
  end

  def label pos = 0x22
    l  = Register::Label.new("some" , "Label")
    l.position =  pos
    l
  end

  def pest_move_object
    code = @machine.add( :r1 , label)
    assert_code code , :add , [0x22,0x10,0x9f,0xe2] #e2 9f 10 22
  end
end
