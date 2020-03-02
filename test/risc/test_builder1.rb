require_relative "../helper"

module Risc
  class TestCompilerBuilder < MiniTest::Test
    include Parfait::MethodHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @method = SlotMachine::SlotCollection.compiler_for( :Space , :main,{},{}).callable
      @compiler = Risc::MethodCompiler.new( @method , SlotMachine::Label.new( "source_name", "return_label"))
      @builder  = @compiler.builder(@method)
    end
    def test_prepare_int
      assert @builder.prepare_int_return
    end
    def test_allocate_returns
      int = @builder.allocate_int
      assert_equal :integer_tmp , int.symbol
    end
    def test_allocate_len
      int = @builder.allocate_int
      assert_equal 23 , @builder.compiler.risc_instructions.length
    end
  end
end
