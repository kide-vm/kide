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
  # following tests are really Instruction tests, but would require mocking there
  class TestInstructionProtocol < MiniTest::Test
    def setup
      Parfait.boot!({})
      @load = Risc.load_data("source" , 1)
    end
    def test_reg_names
      assert_equal 1 , @load.register_names.length
    end
    def test_reg_get
      reg = @load.register_names.first
      assert_equal :fix_1 , reg
    end
    def test_reg_set
      @load.set_registers(:fix_1 , :r10)
      assert_equal :r10 , @load.get_register(:register)
    end
    def test_reg_ssa
      value = @load.set_registers(:register , :r10)
      assert_equal :fix_1 , @load.get_register(:register)
    end
  end
end
