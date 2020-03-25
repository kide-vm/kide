require_relative "../helper"

module Risc
  class TestCompilerBuilder < MiniTest::Test
    include Parfait::MethodHelper
    include HasCompiler

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
      assert int.symbol.to_s.split(".").first.start_with?("id_")
    end
    def test_allocate_len
      int = @builder.allocate_int
      assert_equal 22 , @builder.compiler.risc_instructions.length
    end
    def test_allocate
      int = @builder.allocate_int
      assert_allocate
    end
    def test_compiler
      int = @builder.allocate_int
      assert int.compiler
      assert int.symbol.to_s.start_with?("id_fac")
    end
  end
end
