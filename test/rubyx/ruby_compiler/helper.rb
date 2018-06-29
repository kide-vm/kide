require_relative "../../helper"

module Vool
  module RubyTests
    def compile(input)
      RubyX::RubyCompiler.compile(input)
    end
  end
end
