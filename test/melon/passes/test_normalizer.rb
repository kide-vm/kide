require_relative "helper"

module Melon
  module Passes
    class TestNormalizer < MiniTest::Test

      def setup
        Register.machine.boot unless Register.machine.booted
      end

      def test_no_thing
        assert true
      end
    end
  end
end
