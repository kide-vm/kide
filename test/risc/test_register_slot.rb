require_relative "../helper"

module Risc
  class TestRegisterSlot1 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @r0 = RegisterValue.new(:message , :Message).set_compiler(@compiler)
    end
    def test_reg_to_slot_reg
      reg = @r0[:next_message] << @r0
      assert_equal RegisterValue , reg.class
      assert_equal :message , reg.symbol
      assert_equal "Message_Type" , reg.type.name
    end
    def test_reg_to_slot_inst
      @r0[:next_message] << @r0
      assert_equal RegToSlot , @compiler.current.class
      assert_equal @r0 , @compiler.current.register
      assert_equal 1 , @compiler.current.index
      assert_equal :message , @compiler.current.array.symbol
    end
  end
  class TestRegisterSlot2 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @r0 = RegisterValue.new(:message , :Message).set_compiler(@compiler)
    end
    def test_reg_to_slot_reg
      reg = @r0[:next_message] << @r0[:next_message]
      assert_equal RegisterValue , reg.class
      assert_equal :"message.message" , reg.symbol
      assert_equal "Message_Type" , reg.type.name
    end
    def test_reg_to_slot_inst1
      @r0[:next_message] << @r0[:next_message]
      inst = @compiler.risc_instructions.next
      assert_equal SlotToReg , inst.class
      assert_equal :"message.message" , inst.register.symbol
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
    end
    def test_reg_to_slot_inst2
      @r0[:next_message] << @r0[:next_message]
      inst = @compiler.current
      assert_equal RegToSlot , inst.class
      assert_equal :"message.message" , inst.register.symbol
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
    end
  end
end
