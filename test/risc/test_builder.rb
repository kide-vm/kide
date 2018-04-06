require_relative "../helper"

module Risc
  class TestBuilderBoot < MiniTest::Test

    def setup
      Risc.machine.boot
      init = Parfait.object_space.get_init
      compiler = Risc::MethodCompiler.new( init )
      @builder = Builder.new(compiler)
    end
    def test_register_alloc_space
      reg = @builder.space
      assert_equal RiscValue , reg.class
      assert_equal :Space , reg.type
    end
    def test_register_alloc_message
      reg = @builder.message
      assert_equal :r1 , reg.symbol
      assert_equal :Message , reg.type
    end
    def test_returns_built
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 }
      assert_equal Transfer , built.class
    end
    def test_returns_two
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 ; space << r1}
      assert_equal Transfer , built.next.class
    end
    def test_returns_slot
      r2 = RiscValue.new(:r2 , :Message)
      built = @builder.build{ space[:first_message] >> r2 }
      assert_equal SlotToReg , built.class
      assert_equal :r1 , built.array.symbol
    end
    def test_returns_slot_reverse
      r2 = RiscValue.new(:r2 , :Message)
      built = @builder.build{ r2 << space[:first_message] }
      assert_equal SlotToReg , built.class
      assert_equal :r1 , built.array.symbol
    end
    def test_reuses_names
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 ; space << r1}
      assert_equal built.to.symbol , built.next.to.symbol
    end
  end

  class TestBuilderNoBoot < MiniTest::Test

    def setup
      @builder = Builder.new(nil)
    end
    def test_has_build
      assert_nil @builder.build{ }
    end
    def test_has_attribute
      assert_nil @builder.built
    end
  end
end
