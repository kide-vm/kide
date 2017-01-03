require_relative 'helper'

module Arm
  class TestMemory < MiniTest::Test
    include ArmHelper

    def test_ldr
      code = @machine.ldr  :r0, :r0
      assert_code code, :ldr ,  [0x00,0x00,0x90,0xe5] #e5 90 00 00
    end
    def test_ldr_const_offset
      code = @machine.ldr  :r0, :r0 ,  4
      assert_code code, :ldr ,  [0x04,0x00,0x90,0xe5] #e5 90 00 04
    end
    def test_ldr_reg_offset
      code = @machine.ldr  :r3, :r4 , :r5
      assert_code code, :ldr ,  [0x05,0x30,0x94,0xe7] #e7 94 30 05
    end
    def test_ldr_reg_shift2
      code = @machine.ldr  :r3, :r4 , :r5 , :shift_lsl => 2
      assert_code code, :ldr ,  [0x05,0x31,0x94,0xe7] #e7 94 31 05
    end
    def test_ldr_reg_shift3
      code = @machine.ldr  :r3, :r4 , :r5 , :shift_lsl => 3
      assert_code code, :ldr ,  [0x85,0x31,0x94,0xe7] #e7 94 31 85
    end
    def test_ldrb
      code = @machine.ldrb  :r0, :r0
      assert_code code, :ldrb ,  [0x00,0x00,0xd0,0xe5] #e5 d0 00 00
    end
    def test_ldrb_const
      code = @machine.ldrb  :r0, :r0 , 12
      assert_code code, :ldrb ,  [0x0c,0x00,0xd0,0xe5] #e5 d0 00 0c
    end
    def test_ldrb_reg_offset
      code = @machine.ldrb  :r0, :r1 , :r2
      assert_code code, :ldrb ,  [0x02,0x00,0xd1,0xe7] #e7 d1 00 02
    end

    def test_str
      code = @machine.str  :r0, :r1
      assert_code code, :str ,  [0x00,0x00,0x81,0xe5] #e5 81 00 00
    end
    def test_str_const_offset
      code = @machine.str  :r1, :r2 ,  4
      assert_code code, :str ,  [0x04,0x10,0x82,0xe5] #e5 82 10 04
    end
    def test_str_reg_offset
      code = @machine.str  :r3, :r4 , :r5
      assert_code code, :str ,  [0x05,0x30,0x84,0xe7] #e7 84 30 05
    end
    def test_str_reg_shift
      code = @machine.str  :r3, :r4 , :r5 , :shift_lsl => 2
      assert_code code, :str ,  [0x05,0x31,0x84,0xe7] #e7 84 31 05
    end

    def test_strb_inc   #THIS IS BROKEN, but so is gnu as, as it produces same output for ! or not
      code = @machine.strb  :r0, :r2 , 1 , pre_post_index: 1  # pre_post_index is autoinc (r2 here)
      assert_code code, :strb ,  [0x01,0x00,0xc2,0xe5] #e5 e2 00 01
    end

    def test_strb
      code = @machine.strb  :r0, :r0
      assert_code code, :strb ,  [0x00,0x00,0xc0,0xe5] #e5 c0 00 00
    end

    def test_strb_const
      code = @machine.strb  :r1, :r2 , 4
      assert_code code, :strb ,  [0x04,0x10,0xc2,0xe5] #e5 c2 10 04
    end
    def test_strb_reg_offset
      code = @machine.strb  :r1, :r2 , :r3
      assert_code code, :strb ,  [0x03,0x10,0xc2,0xe7] #e7 c2 10 03
    end
  end
end
