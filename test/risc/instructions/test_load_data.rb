require_relative "../helper"

module Risc
  class TestLoadData < MiniTest::Test
    def setup
      Parfait.boot!({})
    end
    def risc(i)
      Risc.load_data("source" , 1)
    end
    def test_const
      assert_equal  LoadData , risc(1).class
    end
    def test_val
      assert_equal  1 , risc(1).constant
    end
    def test_reg
      assert_equal  :fix_1 , risc(1).register.symbol
    end
    def test_reg_type
      assert_equal  "Integer_Type" , risc(1).register.type.name
    end
  end
end
