require_relative "../helper"

module Risc
  class TestLoadConstant < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def load(const = SlotMachine::StringConstant.new("hi") )
      Risc.load_constant("source" , const)
    end
    def test_const
      assert_equal LoadConstant , load.class
    end
    def test_const_reg
      assert load.register.is_object?
    end
  end
  class TestLoadConstant1 < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def  load(const = Parfait.new_word("hi") )
      Risc.load_constant("source" , const)
    end
    def test_parf
      assert_equal LoadConstant , load.class
    end
    def test_parf_reg
      assert load.register.is_object?
    end
  end
end
