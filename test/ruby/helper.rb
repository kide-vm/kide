require_relative "../helper"

module Ruby
  module RubyTests
    def setup
      Parfait.boot!
    end
    def compile(input)
      RubyCompiler.compile(input)
    end

    def ruby_to_vool(input)
      RubyXCompiler.new(input).ruby_to_vool
    end

  end
end
