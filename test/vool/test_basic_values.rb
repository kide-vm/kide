require_relative "helper"

module Vool
  class TestBasicValues < MiniTest::Test

    def test_self
      lst = Compiler.compile( "self")
      assert_equal SelfStatement , lst.class
    end
    def test_nil
      lst = Compiler.compile( "nil")
      assert_equal NilStatement , lst.class
    end
    def test_false
      lst = Compiler.compile( "false")
      assert_equal FalseStatement , lst.class
    end
    def test_true
      lst = Compiler.compile( "true")
      assert_equal TrueStatement , lst.class
    end
    def test_integer
      lst = Compiler.compile( "123")
      assert_equal IntegerStatement , lst.class
    end
    def test_string
      lst = Compiler.compile( "'string'")
      assert_equal StringStatement , lst.class , lst.inspect
    end
    def test_sym
      lst = Compiler.compile( ":symbol")
      assert_equal SymbolStatement , lst.class , lst.inspect
    end
    def test_dstr
      assert_raises RuntimeError do
        Compiler.compile( '"dstr#{self}"')
      end
    end

    def test_scope
      lst = Compiler.compile( "begin ; 1 ; end")
      assert_equal ScopeStatement , lst.class , lst.inspect
    end
    def test_scope_contents
      lst = Compiler.compile( "begin ; 1 ; end")
      assert_equal 1 , lst.statements.first.value
    end
  end
end
