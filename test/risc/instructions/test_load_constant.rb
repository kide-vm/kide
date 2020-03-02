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
      assert_load load , SlotMachine::StringConstant , "id_"
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
      assert_load load , Parfait::Word , "id_"
    end
  end
end
