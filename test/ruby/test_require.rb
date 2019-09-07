require_relative "helper"

module Ruby
  class TestSendRequireHelper < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "require_relative 'helper'").to_vool
    end
    def test_helper_class
      assert_equal Vool::ClassExpression , @lst.class
      assert_equal :ParfaitTest , @lst.name
    end
    def test_methods
      assert_equal Vool::Statements , @lst.body.class
      assert_equal Vool::MethodExpression , @lst.body.first.class
      assert_equal :setup , @lst.body.first.name
    end
  end
  class TestSendRequireparfait < MiniTest::Test
    include RubyTests
    def setup
      @lst = compile( "require_relative 'object'").to_vool
    end
    def test_helper_class
      assert_equal Vool::ClassExpression , @lst.class
      assert_equal :Object , @lst.name
    end
    def test_methods
      assert_equal Vool::Statements , @lst.body.class
      assert_equal Vool::MethodExpression , @lst.body.first.class
      assert_equal :type , @lst.body.first.name
    end
  end
end
