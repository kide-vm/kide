require_relative "helper"

module Mom
  class TestAssignemnt < MiniTest::Test
    include CompilerHelper

    def test_class_exists
      assert Instruction.new
    end
  end
end
