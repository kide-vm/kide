require_relative "../helper"

module Ruby
  module RubyTests
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def compile(input)
      RubyCompiler.compile(input)
    end

    def ruby_to_vool(input)
      FIXMERubyXCompiler.new(input).ruby_to_vool
    end

  end
end
