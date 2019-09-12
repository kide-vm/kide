require_relative "../helper"

module Risc
  class TestBlockSetupBlock < MiniTest::Test
    include Statements

    def setup
      super
      @input = as_block("return 5")
      @mom = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(as_main)
    end
    def main_risc
      @mom.to_risc.method_compilers.find{|c| c.callable.name == :main }
    end
    def test_mom
      assert_equal Mom::MomCollection , @mom.class
    end
    def test_mom_block_comp
      assert_equal 1 , @mom.method_compilers.first.block_compilers.length
    end
    def test_risc
      assert_equal Risc::RiscCollection , @mom.to_risc.class
    end
    def test_risc_comp
      assert_equal :main , main_risc.callable.name
    end
    def test_risc_block_comp
      assert_equal 1 , main_risc.block_compilers.length
    end

  end
end
