require_relative "helper"

module RubyX
  class TestRubyXCompilerBinary < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def space_source_for( name )
      "class Space ; def #{name}(arg);return arg;end; end"
    end
    def test_return_linker
      @linker = RubyXCompiler.ruby_to_binary(space_source_for("main"), :interpreter)
      assert_equal Risc::Linker , @linker.class
    end
    def test_one_vool_call
      compiler = RubyXCompiler.new
      compiler.ruby_to_vool(space_source_for("main"))
      assert_equal Vool::ClassStatement , compiler.vool.class
    end
    def test_two_vool_calls
      compiler = RubyXCompiler.new
      compiler.ruby_to_vool(space_source_for("main"))
      compiler.ruby_to_vool(space_source_for("twain"))
      assert_equal Vool::ScopeStatement , compiler.vool.class
      assert_equal 2 , compiler.vool.length
    end
    def test_bin_two_sources
      compiler = RubyXCompiler.new
      compiler.ruby_to_vool(space_source_for("main"))
      compiler.ruby_to_vool(space_source_for("twain"))
#      linker = compiler.to_binary(:interpreter)
#      assert_equal Vool::ScopeStatement , linker.class
    end
  end
end
