require_relative "../helper"

module Vool
  module Norm

    class NormTest < MiniTest::Test

      def normalize(input)
        RubyX::RubyCompiler.compile(input).normalize
      end
    end
  end
end
