require_relative "../helper"

class SuperFakeCompiler
  attr_reader :code
  def add_code(ins)
    @code = ins
  end
end
module Risc
  class TestRegisterValue < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @r0 = RegisterValue.new(:message , :Message)
      @r1 = RegisterValue.new(:id_1234 , :Space)
      @r2 = RegisterValue.new(:id_1256 , :Factory)
    end
    def test_class_name_type
      assert_equal :Message , @r0.class_name
    end
    def test_class_name_fix
      assert_equal :Integer , RegisterValue.new(:id_234 , :Integer).class_name
    end
    def test_r0
      assert_equal :message , @r0.symbol
    end
    def test_dup
      copy = @r0.dup( :r0 )
      assert_equal :r0 , copy.symbol
      assert_equal :message , copy.ssa
    end
    def test_load_label
      label = Risc::Label.new("HI","ho" , FakeAddress.new(0))
      move = @r1 << label
      assert_equal LoadConstant , move.class
    end
    def test_transfer
      transfer = @r0 << @r1
      assert_equal Transfer , transfer.class
    end
    def test_set_compiler
      reg = @r0.set_compiler(SuperFakeCompiler.new)
      assert_equal RegisterValue , reg.class
      assert reg.compiler
    end
    def test_calls_compiler
      compiler = SuperFakeCompiler.new
      @r0.set_compiler( compiler )
      @r0 << @r1
      assert_equal Transfer , compiler.code.class
    end
    def test_index_op
      message = @r0[:next_message]
      assert_equal RegisterSlot , message.class
      assert_equal :next_message , message.index
      assert_equal @r0 , message.register
    end
    def test_operator
      @r0.set_compiler( fake = SuperFakeCompiler.new)
      result = @r0.op :<< , @r1
      ret = fake.code
      assert_operator ret , :<< , :message , "id_" , "op_<<_"
    end
    def test_operator_slot
      @r0.set_compiler( fake = SuperFakeCompiler.new)
      result = @r0.op :<< , @r1[:type]
      ret = fake.code
      assert_operator ret , :<< , :message , "id_.type" , "op_<<_"
    end
    def test_byte_to_reg
      instr = @r0 <= @r1[@r0]
      assert_equal ByteToReg , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal @r0 , instr.index
    end
    def test_slot_to_reg
      instr = @r0 << @r2[:next_object]
      assert_slot_to_reg instr , "id_" , 2 , :message
    end
    def test_reg_to_byte
      instr = @r1[@r0] <= @r0
      assert_equal RegToByte , instr.class
      assert_equal @r1 , instr.array
      assert_equal @r0 , instr.register
      assert_equal @r0 , instr.index
    end
  end
end
