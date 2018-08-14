require_relative "../helper"

module Risc
  class TestCompilerBuilder < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @init = Parfait.object_space.get_init
      @compiler = Risc::MethodCompiler.new( @init )
      @builder  = @compiler.compiler_builder(@init)
    end
    def test_inserts_built
      r1 = RegisterValue.new(:r1 , :Space)
      @builder.build{ space! << r1 }
      assert_equal Transfer , @compiler.risc_instructions.next.class
      assert_equal RegisterValue ,  @builder.space.class
    end
    def test_loads
      @builder.build{ space! << Parfait.object_space }
      assert_equal LoadConstant , @compiler.risc_instructions.next.class
      assert_equal RegisterValue ,  @builder.space.class
    end
    def test_two
      @builder.build{ space! << Parfait.object_space ; integer! << 1}
      assert_equal LoadConstant , @compiler.risc_instructions.next.class
      assert_equal LoadData , @compiler.risc_instructions.next(2).class
    end
    def test_swap
      test_two
      @builder.swap_names( :space , :integer)
      assert_equal :Integer ,  @builder.space.type.class_name
      assert_equal :Space ,  @builder.integer.type.class_name
    end
  end
end
