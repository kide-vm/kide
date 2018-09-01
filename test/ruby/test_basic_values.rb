require_relative "helper"

module Ruby
  class TestBasicValues < MiniTest::Test
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
  class TestBasicTypes < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!
    end
    def compile_const( input )
      lst = compile( input )
      lst.class
    end
    def test_integer
      assert_equal IntegerConstant , compile_const( "123")
    end
    def test_float
      assert_equal FloatConstant , compile_const( "123.1")
    end
    def test_string
      assert_equal StringConstant , compile_const( "'string'")
    end
    def test_sym
      assert_equal SymbolConstant , compile_const( ":symbol")
    end
    def test_nil
      assert_equal NilConstant , compile_const( "nil")
    end
    def test_false
      assert_equal FalseConstant , compile_const( "false")
    end
    def test_true
      assert_equal TrueConstant , compile_const( "true")
    end
  end
  class TestBasicTypesVool < MiniTest::Test
    include RubyTests

    def setup
      Parfait.boot!
    end
    def compile_const( input )
      lst = compile( input )
      lst.to_vool.to_s
    end
    def test_integer
      assert_equal "123" , compile_const( "123")
    end
    def test_float
      assert_equal "123.0" , compile_const( "123.0")
    end
    def test_string
      assert_equal "'string'" , compile_const( "'string'")
    end
    def test_sym
      assert_equal "'symbol'" , compile_const( ":symbol")
    end
    def test_nil
      assert_equal "nil" , compile_const( "nil")
    end
    def test_false
      assert_equal "false" , compile_const( "false")
    end
    def test_true
      assert_equal "true" , compile_const( "true")
    end
  end
end
