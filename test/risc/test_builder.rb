require_relative "../helper"

module Risc
  class TestBuilder < MiniTest::Test

    def setup
      Risc.machine.boot
      init = Parfait.object_space.get_init
      compiler = Risc::MethodCompiler.new( init )
      @builder = Builder.new(compiler)
    end
    def test_has_build
      assert_nil @builder.build{ }
    end
    def test_has_build_and_returns_built
      r1 = RiscValue.new(:r1 , :Space)
      built = @builder.build{ space << r1 }
      assert_equal Transfer , built.class
    end
    def test_has_attribute
      assert_nil @builder.built
    end
  end
end
