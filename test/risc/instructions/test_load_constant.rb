require_relative "../helper"

module Risc
  class TestLoadConstant < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def risc(i)
      const = SlotMachine::StringConstant.new("hi")
      Risc.load_constant("source" , const)
    end
    def test_const
      assert_load 1 , SlotMachine::StringConstant , "id_string_"
    end
  end
  class TestLoadConstant1 < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def risc(i)
      const = Parfait.new_word("hi")
      Risc.load_constant("source" , const)
    end
    def test_parf
      assert_load 1 , Parfait::Word , "id_word_"
    end
  end
end
