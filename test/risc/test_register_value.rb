require_relative "../helper"

class FakeBuilder
  attr_reader :built
  def add_code(ins)
    @built = ins
  end
end
module Risc
  class TestRegisterValue < MiniTest::Test

    def setup
      Parfait.boot!
      @r0 = RegisterValue.new(:r0 , :Message)
      @r1 = RegisterValue.new(:r1 , :Space)
    end
    def test_class_name_type
      assert_equal :Message , @r0.class_name
    end
    def test_class_name_fix
      assert_equal :fixnum , RegisterValue.new(:r0 , :fixnum).class_name
    end
    def test_r0
      assert_equal :r0 , @r0.symbol
    end
    def test_load_space
      move = @r0 << Parfait.object_space
      assert_equal LoadConstant , move.class
    end
    def test_load_symbol
      move = @r1 << :puts
      assert_equal LoadConstant , move.class
    end
    def test_transfer
      transfer = @r0 << @r1
      assert_equal Transfer , transfer.class
    end
    def test_calls_builder
      builder = FakeBuilder.new
      @r0.builder = builder
      @r0 << @r1
      assert_equal Transfer , builder.built.class
    end
    def test_index_op
      message = @r0[:next_message]
      assert_equal RValue , message.class
      assert_equal :next_message , message.index
      assert_equal @r0 , message.register
    end
    def test_return
      ret = @r0.function_return
      assert_equal FunctionReturn , ret.class
      assert_equal @r0 , ret.register
    end
    def test_operator
      ret = @r0.op :<< , @r1
      assert_equal OperatorInstruction , ret.class
      assert_equal @r0 , ret.left
      assert_equal @r1 , ret.right
      assert_equal :<< , ret.operator
    end
    def test_byte_to_reg
      instr = @r0 <= @r1[1]
      assert_equal ByteToReg , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal 1 , instr.index
    end
    def test_slot_to_reg
      instr = @r0 << @r1[:next_message]
      assert_equal SlotToReg , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal 3 , instr.index
    end
    def test_reg_to_byte
      instr = @r1[1] <= @r0
      assert_equal RegToByte , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal 1 , instr.index
    end
    def test_reg_to_slot
      instr = @r1[:next_message] << @r0
      assert_equal RegToSlot , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal 3 , instr.index
    end
  end
end
