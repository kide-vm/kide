require_relative "../helper"

module Ruby
  module RubyTests
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def compile(input)
      RubyCompiler.compile(input)
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
      @vool = compile( "class Tryout < Base; #{attr_def};end" ).to_vool
    end
    def getter
      @vool.body.statements.first
    end
    def setter
      @vool.body.statements.last
    end
    def test_class
      assert_equal Vool::ClassExpression , @vool.class
    end
    def test_body
      assert_equal Vool::Statements , @vool.body.class
    end
    def test_getter
      assert_equal Vool::MethodExpression , getter.class
    end
    def test_getter_return
      assert_equal Vool::ReturnStatement , getter.body.class
    end
    def test_getter_name
      assert_equal :page , getter.name
    end
  end
end
