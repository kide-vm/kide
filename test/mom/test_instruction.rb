require_relative "helper"

module Mom
  class TestInstruction < MiniTest::Test

    def test_class_exists
      assert Instruction.new
    end
  end
end
