require_relative "rt_helper"

module RubyX
  class ObjectSourceTest #< MiniTest::Test
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
    def test_vool_methods
      vool = Ruby::RubyCompiler.compile(@input).to_vool
      assert_equal Vool::Statements , vool[2].body.class
      vool[2].body.statements.each do |st|
        assert_equal Vool::MethodExpression , st.class
      end
    end
  end
  class TestObjectRtTest < Minitest::Test
    self.class.include ParfaitHelper
    include Risc::Ticker

    def self.runnable_methods
      input = load_parfait(:object) + load_parfait_test(:object)
      vool = Ruby::RubyCompiler.compile(input).to_vool
      #puts vool.to_s
      tests = [  ]
      vool[2].body.statements.each do |method|
        tests << method.name
        self.send(:define_method, method.name ) do
          code = input + <<MAIN
            class Space
              def main(args)
                test = #{vool[2].name}.new
                test.setup
                test.#{method.name}
              end
            end
MAIN
          @preload = "all"
          ticks = run_input(code)
#          assert_equal "" , @interpreter.stdout
        end
        break
      end
      tests
    end

  end
end
