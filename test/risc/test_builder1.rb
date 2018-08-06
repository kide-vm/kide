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
      @builder.build{ space << r1 }
      assert_equal Transfer , @compiler.risc_instructions.next.class
    end

  end
end
