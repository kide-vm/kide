require_relative "rt_helper"

module RubyX
  class ObjectTest < MiniTest::Test
    include ParfaitHelper
    def setup
      @input = load_parfait(:object) + load_parfait_test(:object)
    end

    def test_load
      assert @input.include? "ParfaitTest"
      assert @input.include? "class Object"
    end
    def test_compile
      compiled = Ruby::RubyCompiler.compile(@input)
      assert_equal Ruby::ScopeStatement , compiled.class
      assert_equal Ruby::ClassStatement , compiled.first.class
    end
    def test_require
      compiled = Ruby::RubyCompiler.compile(@input)
      assert_equal Ruby::SendStatement , compiled[1].class
      assert_equal :require_relative , compiled[1].name
    end
    def test_test_class
      compiled = Ruby::RubyCompiler.compile(@input)
      assert_equal Ruby::ClassStatement , compiled[2].class
      assert_equal :TestObject , compiled[2].name
    end
    def test_vool_object
      vool = Ruby::RubyCompiler.compile(@input).to_vool
      assert_equal Vool::ScopeStatement , vool.class
      assert_equal Vool::ClassExpression , vool.first.class
    end
    def test_vool_helper
      vool = Ruby::RubyCompiler.compile(@input).to_vool
      assert_equal Vool::ClassExpression , vool[1].class
      assert_equal :ParfaitTest , vool[1].name
    end
    def test_vool_test
      vool = Ruby::RubyCompiler.compile(@input).to_vool
      assert_equal Vool::ClassExpression , vool[2].class
      assert_equal :TestObject , vool[2].name
    end

    def test_basics
      risc = compiler.ruby_to_binary @input , :interpreter
      assert_equal Risc::Linker , risc.class
    end

    def test_run_all
      @input += "class Space;def main(arg);'Object'.putstring;end;end"
      run_input
      assert_equal "Object" , @interpreter.stdout
    end
  end
end
