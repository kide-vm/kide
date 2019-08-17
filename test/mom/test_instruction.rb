
require_relative "helper"

module Mom
  class TestInstruction < MiniTest::Test

    def test_instantiates
      assert Instruction.new("Hi")
    end
    def test_string_source
      assert_equal "Hi" ,Instruction.new("Hi").source
    end
    def test_nil_next
      assert_nil Instruction.new("Hi").next
    end
    def test_raise
      assert_raises {Instruction.new(5)}
    end
  end
end
