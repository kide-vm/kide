require_relative "../helper"

module Risc
  class TestClassCallSimple < MiniTest::Test
    include Statements

    def setup
      @class_input = "def self.simple_return; return 1 ; end;"
      @input = "return Space.simple_return"
      @expect = [LoadConstant, RegToSlot, Branch]
    end

    def test_send_instructions
      assert_nil msg = check_nil(:simple_return) , msg
    end
    def test_load_simple
      produced = produce_target(:simple_return).next(1)
      assert_load( produced , Parfait::Integer)
      assert_equal 1 , produced.constant.value
    end
  end
end
