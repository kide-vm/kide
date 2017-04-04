require_relative "helper"

module Vool
  class TestVariables < MiniTest::Test

    # "free standing" local can not be tested as it will result in send
    # in other words ther is no way of knowing if a name is variable or method
    # def test_send_to_local
    #   lst = Compiler.compile( "foo.bar")
    #   assert_equal SendStatement , lst.class
    # end

    def test_instance_basic
      lst = Compiler.compile( "@var" )
      assert_equal InstanceVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_instance_return
      lst = Compiler.compile( "return @var" )
      assert_equal InstanceVariable , lst.return_value.class
    end

    def test_class_basic
      lst = Compiler.compile( "@@var" )
      assert_equal ClassVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_class_return
      lst = Compiler.compile( "return @@var" )
      assert_equal ClassVariable , lst.return_value.class
    end
  end
end
