require_relative "helper"

module Rubyx
  module Passes
    class TestNormalizer < MiniTest::Test

      def setup
        Risc.machine.boot unless Risc.machine.booted
      end

      def test_no_thing
        assert true
      end
    end
  end
end
