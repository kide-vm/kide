require_relative "../helper"

module Risc
  class TestClassCallSimple < MiniTest::Test
    include Statements

    def setup
      super
      @class_input = "def self.simple_return; return 1 ; end;"
      @input = "return Test.simple_return"
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
    # The normal send
    def test_load_5
      produced = produce_body.next(8)
      assert_load( produced , Parfait::Class)
      assert_equal :Test , produced.constant.name
    end
    def test_load_label
      produced = produce_body.next(11)
      assert_load( produced , Label)
    end
    def test_function_call
      produced = produce_body.next(15)
      assert_equal FunctionCall , produced.class
      assert_equal :simple_return , produced.method.name
    end
    def test_check_continue
      produced = produce_body.next(16)
      assert_equal Label , produced.class
      assert produced.name.start_with?("continue_")
    end
  end
end
