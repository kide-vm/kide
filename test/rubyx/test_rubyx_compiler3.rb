require_relative "helper"

module RubyX
  class TestRubyXCompilerBinary < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def space_source_for( name )
      "class Space ; def #{name}(arg);return arg;end; end"
    end
    def test_platform_option
      options = RubyX.interpreter_test_options
      options.delete(:platform)
      assert_raises{ RubyXCompiler.ruby_to_binary(space_source_for("main"), options)}
    end
    def test_return_linker
      @linker = RubyXCompiler.ruby_to_binary(space_source_for("main"), RubyX.interpreter_test_options)
      assert_equal Risc::Linker , @linker.class
    end
    def test_one_vool_call
      compiler = RubyXCompiler.new(RubyX.default_test_options)
      compiler.ruby_to_vool(space_source_for("main"))
      assert_equal Vool::ClassExpression , compiler.vool.class
    end
    def test_two_vool_calls
      compiler = RubyXCompiler.new(RubyX.default_test_options)
      compiler.ruby_to_vool(space_source_for("main"))
      compiler.ruby_to_vool(space_source_for("twain"))
      assert_equal Vool::ScopeStatement , compiler.vool.class
      assert_equal 2 , compiler.vool.length
    end
    def test_bin_two_sources
      compiler = RubyXCompiler.new(RubyX.default_test_options)
      compiler.ruby_to_vool(space_source_for("main"))
      compiler.ruby_to_vool(space_source_for("twain"))
      assert_equal 2 , compiler.vool.length
      linker = compiler.to_binary(:interpreter)
      assert_equal Risc::Linker , linker.class
      assert_equal 3 , linker.assemblers.length
    end
  end
end
