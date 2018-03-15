require_relative "helper"

module Vool
  class TestVariables < MiniTest::Test

    # "free standing" local can not be tested as it will result in send
    # in other words ther is no way of knowing if a name is variable or method
    # one needs an assignemnt first, to "tell" the parser it's a local
    def test_local_basic
      lst = RubyCompiler.compile( "foo = 1 ; foo")
      assert_equal ScopeStatement , lst.class
      assert_equal LocalVariable , lst.statements[1].class
    end

    def test_local_nane
      lst = RubyCompiler.compile( "foo = 1 ; foo")
      assert_equal LocalVariable , lst.statements[1].class
    end

    def test_instance_basic
      lst = RubyCompiler.compile( "@var" )
      assert_equal InstanceVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_instance_return
      lst = RubyCompiler.compile( "return @var" )
      assert_equal InstanceVariable , lst.return_value.class
    end

    def test_class_basic
      lst = RubyCompiler.compile( "@@var" )
      assert_equal ClassVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_class_return
      lst = RubyCompiler.compile( "return @@var" )
      assert_equal ClassVariable , lst.return_value.class
    end

    def test_module_basic
      lst = RubyCompiler.compile( "Module" )
      assert_equal ModuleName , lst.class
      assert_equal :Module , lst.name
    end

    def test_module_base_scoped
      lst = RubyCompiler.compile( "::Module" )
      assert_equal ModuleName , lst.class
      assert_equal :Module , lst.name
    end
    def test_module_module_scoped
      assert_raises {RubyCompiler.compile( "M::Module" ) }
    end
  end
end
