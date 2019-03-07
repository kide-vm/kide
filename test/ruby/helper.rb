require_relative "../helper"

module Ruby
  module RubyTests
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def compile(input)
      RubyCompiler.compile(input)
    end

    def ruby_to_vool(input)
      FIXMERubyXCompiler.new(input).ruby_to_vool
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
  end
end
