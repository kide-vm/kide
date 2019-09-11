require_relative "../helper"

module RubyX
  module BuiltinHelper
    def setup
      @mom = RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(source)
      @mom.method_compilers.first
      assert_equal Mom::MomCollection , @mom.class
      assert_equal Mom::MethodCompiler , compiler.class
    end
    def compiler
      @mom.method_compilers.last
    end

  end
end
