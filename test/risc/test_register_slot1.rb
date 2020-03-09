require_relative "../helper"

module Risc
  class TestRegisterSlot4 < MiniTest::Test
    include HasCompiler
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @r0 = RegisterValue.new(:message , :Message).set_compiler(@compiler)
      @r0[:next_message][:return_address] << @r0
    end
    def test_instructions
      assert_equal SlotToReg ,  @compiler.risc_instructions.next(1).class
      assert_equal RegToSlot ,  @compiler.risc_instructions.next(2).class
      assert_equal NilClass ,  @compiler.risc_instructions.next(3).class
    end
    def test_slot_to
      assert_slot_to_reg 1 , :message, 1, :"message.next_message"
      assert risc(1).register.compiler
    end
    def test_reg_to
      assert_reg_to_slot 2 , :message, :"message.next_message" , 4
      assert risc(2).register.compiler
    end
  end
end
