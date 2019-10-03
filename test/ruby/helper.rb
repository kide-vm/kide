require_relative "../helper"

module Ruby
  module RubyTests
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def compile(input)
      RubyCompiler.compile(input)
    end
    def compile_main(input)
      RubyCompiler.compile(as_main(input))
    end
    def compile_main_sol(input)
      xcompiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
      xcompiler.ruby_to_sol(as_main(input))
    end

    def assert_raises_muted &block
      orig_stdout = $stdout
      $stdout = StringIO.new
      assert_raises &block
      $stdout = orig_stdout
    end
  end
  module AttributeTests
    include RubyTests
    def setup
      super
      @sol = compile( "class Tryout < Base; #{attr_def};end" ).to_sol
    end
    def getter
      @sol.body.statements.first
    end
    def setter
      @sol.body.statements.last
    end
    def test_class
      assert_equal Sol::ClassExpression , @sol.class
    end
    def test_body
      assert_equal Sol::Statements , @sol.body.class
    end
    def test_getter
      assert_equal Sol::MethodExpression , getter.class
    end
    def test_getter_return
      assert_equal Sol::ReturnStatement , getter.body.class
    end
    def test_getter_name
      assert_equal :page , getter.name
    end
  end
end
