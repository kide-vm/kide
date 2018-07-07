require_relative "helper"

module Vool
  class TestBasicValuesX < MiniTest::Test
    include RubyTests

    def test_self
      lst = compile( "self")
      assert_equal SelfExpression , lst.class
    end
    def test_nil
      lst = compile( "nil")
      assert_equal NilConstant , lst.class
    end
    def test_false
      lst = compile( "false")
      assert_equal FalseConstant , lst.class
    end
    def test_true
      lst = compile( "true")
      assert_equal TrueConstant , lst.class
    end
    def test_integer
      lst = compile( "123")
      assert_equal IntegerConstant , lst.class
    end
    def test_string
      lst = compile( "'string'")
      assert_equal StringConstant , lst.class , lst.inspect
    end
    def test_sym
      lst = compile( ":symbol")
      assert_equal SymbolConstant , lst.class , lst.inspect
    end
    def test_dstr
      assert_raises RuntimeError do
        compile( '"dstr#{self}"')
      end
    end

    def test_scope
      lst = compile( "begin ; 1 ; end")
      assert_equal ScopeStatement , lst.class , lst.inspect
    end
    def test_scope_contents
      lst = compile( "begin ; 1 ; end")
      assert_equal 1 , lst.statements.first.value
    end
  end
  class TestBasicTypesX < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!
    end
    def compile_ct( input )
      lst = compile( input )
      lst.ct_type
    end
    def test_integer
      assert_equal "Integer_Type" , compile_ct( "123").name
    end
    def test_string
      assert_equal "Word_Type" , compile_ct( "'string'").name
    end
    def test_sym
      assert_equal "Word_Type" , compile_ct( ":symbol").name
    end
    # classes fot these are not implemented in parfait yet
    def pest_nil
      assert_equal "Nil_Type" , compile_ct( "nil").name
    end
    def pest_false
      assert_equal "False_Type" , compile_ct( "false").name
    end
    def pest_true
      assert_equal "True_Type" , compile_ct( "true").name
    end
  end
end
