require_relative "../helper"

module RubyX
  module MacroHelper
    def setup
      whole ="class Space;def main(arg);return;end;end;" + source
      @slot = RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(whole)
      @slot.method_compilers
      assert_equal SlotMachine::SlotCollection , @slot.class
      assert_equal SlotMachine::MethodCompiler , compiler.class
    end
    def compiler
      @slot.method_compilers.last_compiler
    end

  end
end
