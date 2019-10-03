require_relative "helper"

module Ruby
  class TestVariables < MiniTest::Test
    include RubyTests

    # "free standing" local can not be tested as it will result in send
    # in other words there is no way of knowing if a name is variable or method
    # one needs an assignemnt first, to "tell" the parser it's a local
    def test_local_basic
      lst = compile( "foo = 1 ; foo")
      assert_equal ScopeStatement , lst.class
      assert_equal LocalVariable , lst.statements[1].class
    end

    def test_local_nane
      lst = compile( "foo = 1 ; foo")
      assert_equal LocalVariable , lst.statements[1].class
    end

    def test_instance_basic
      lst = compile( "@var" )
      assert_equal InstanceVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_instance_return
      lst = compile( "return @var" )
      assert_equal InstanceVariable , lst.return_value.class
    end

    def test_class_basic
      lst = compile( "@@var" )
      assert_equal ClassVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_class_return
      lst = compile( "return @@var" )
      assert_equal ClassVariable , lst.return_value.class
    end

    def test_module_basic
      lst = compile( "Module" )
      assert_equal ModuleName , lst.class
      assert_equal :Module , lst.name
    end

    def test_module_base_scoped
      lst = compile( "::Module" )
      assert_equal ModuleName , lst.class
      assert_equal :Module , lst.name
    end
  end
  class TestVariablesSol < MiniTest::Test
    include RubyTests
    def test_local_basic
      lst = compile( "foo = 1 ; return foo").to_sol
      assert_equal Sol::LocalVariable , lst.statements[1].return_value.class
    end

    def test_instance_basic
      lst = compile( "@var" ).to_sol
      assert_equal Sol::InstanceVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_instance_return
      lst = compile( "return @var" ).to_sol
      assert_equal Sol::InstanceVariable , lst.return_value.class
    end

    def test_class_basic
      lst = compile( "@@var" ).to_sol
      assert_equal Sol::ClassVariable , lst.class
      assert_equal :var , lst.name
    end

    def test_class_return
      lst = compile( "return @@var" ).to_sol
      assert_equal Sol::ClassVariable , lst.return_value.class
    end

    def test_module_basic
      lst = compile( "Module" ).to_sol
      assert_equal Sol::ModuleName , lst.class
      assert_equal :Module , lst.name
    end

  end
end
