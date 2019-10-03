require_relative "../helper"

module RubyX
  module MacroHelper
    def setup
      whole ="class Space;def main(arg);return;end;end;" + source
      @mom = RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(whole)
      @mom.method_compilers
      assert_equal SlotMachine::SlotCollection , @mom.class
      assert_equal SlotMachine::MethodCompiler , compiler.class
    end
    def compiler
      @mom.method_compilers.last_compiler
    end

  end
end
