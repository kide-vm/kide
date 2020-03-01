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
      inst = @compiler.current
      assert_equal RegToSlot , @compiler.current.class
      assert_equal @r0 , inst.register
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
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
      assert_equal :"message.next_message" , reg.symbol
      assert_equal "Message_Type" , reg.type.name
    end
    def test_reg_to_slot_inst1
      @r0[:next_message] << @r0[:next_message]
      inst = @compiler.risc_instructions.next
      assert_equal SlotToReg , inst.class
      assert_equal :"message.next_message" , inst.register.symbol
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
    end
    def test_reg_to_slot_inst2
      @r0[:next_message] << @r0[:next_message]
      inst = @compiler.current
      assert_equal RegToSlot , inst.class
      assert_equal :"message.next_message" , inst.register.symbol
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
    end
  end
  class TestRegisterSlot3 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = Risc.test_compiler
      @r0 = RegisterValue.new(:message , :Message).set_compiler(@compiler)
    end
    def test_arr_reg
      slot = @r0[:next_message][:type]
      assert_equal RegisterSlot , slot.class
      assert_equal :"message.next_message" , slot.register.symbol
      assert_equal "Message_Type" , slot.register.type.name
    end
    def test_arr_inst
      slot = @r0[:next_message][:type]
      inst = @compiler.current
      assert_equal SlotToReg , inst.class
      assert_equal :"message.next_message" , inst.register.symbol
      assert_equal 1 , inst.index
      assert_equal :message , inst.array.symbol
    end
  end
  class TestRegisterSlot4 < MiniTest::Test
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
      slot = @compiler.risc_instructions.next(1)
      assert_slot_to_reg slot , :message, 1, :"message.next_message"
      assert slot.register.compiler
    end
    def test_reg_to
      reg = @compiler.risc_instructions.next(2)
      assert_reg_to_slot reg , :message, :"message.next_message" , 4
      assert reg.register.compiler
    end
  end
end
