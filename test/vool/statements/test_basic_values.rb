require_relative "helper"

module Vool
  class TestBasicValues < MiniTest::Test

    def test_self
      lst = RubyCompiler.compile( "self")
      assert_equal SelfExpression , lst.class
    end
    def test_nil
      lst = RubyCompiler.compile( "nil")
      assert_equal NilConstant , lst.class
    end
    def test_false
      lst = RubyCompiler.compile( "false")
      assert_equal FalseConstant , lst.class
    end
    def test_true
      lst = RubyCompiler.compile( "true")
      assert_equal TrueConstant , lst.class
    end
    def test_integer
      lst = RubyCompiler.compile( "123")
      assert_equal IntegerConstant , lst.class
    end
    def test_string
      lst = RubyCompiler.compile( "'string'")
      assert_equal StringConstant , lst.class , lst.inspect
    end
    def test_sym
      lst = RubyCompiler.compile( ":symbol")
      assert_equal SymbolConstant , lst.class , lst.inspect
    end
    def test_dstr
      assert_raises RuntimeError do
        RubyCompiler.compile( '"dstr#{self}"')
      end
    end

    def test_scope
      lst = RubyCompiler.compile( "begin ; 1 ; end")
      assert_equal ScopeStatement , lst.class , lst.inspect
    end
    def test_scope_contents
      lst = RubyCompiler.compile( "begin ; 1 ; end")
      assert_equal 1 , lst.statements.first.value
    end
  end
  class TestBasicTypes < MiniTest::Test
    def setup
      Risc.machine.boot
    end
    def compile( input )
      lst = RubyCompiler.compile( input )
      lst.ct_type
    end
    def test_integer
      assert_equal "Integer_Type" , compile( "123").name
    end
    def test_string
      assert_equal "Word_Type" , compile( "'string'").name
    end
    def test_sym
      assert_equal "Word_Type" , compile( ":symbol").name
    end
    # classes fot these are not implemented in parfait yet
    # def pest_nil
    #   assert_equal "Nil_Type" , compile( "nil").name
    # end
    # def pest_false
    #   assert_equal "False_Type" , compile( "false").name
    # end
    # def pest_true
    #   assert_equal "True_Type" , compile( "true").name
    # end
  end
end
