require_relative "rt_helper"

module RubyX
  class ObjectSourceTest < MiniTest::Test
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
    def test_sol_object
      sol = Ruby::RubyCompiler.compile(@input).to_sol
      assert_equal Sol::ScopeStatement , sol.class
      assert_equal Sol::ClassExpression , sol.first.class
    end
    def test_sol_helper
      sol = Ruby::RubyCompiler.compile(@input).to_sol
      assert_equal Sol::ClassExpression , sol[1].class
      assert_equal :ParfaitTest , sol[1].name
    end
    def test_sol_test
      sol = Ruby::RubyCompiler.compile(@input).to_sol
      assert_equal Sol::ClassExpression , sol[2].class
      assert_equal :TestObject , sol[2].name
    end
    def test_sol_methods
      sol = Ruby::RubyCompiler.compile(@input).to_sol
      assert_equal Sol::Statements , sol[2].body.class
      sol[2].body.statements.each do |st|
        assert_equal Sol::MethodExpression , st.class
      end
    end
  end
  class TestObjectRtTest < Minitest::Test
    self.class.include ParfaitHelper
    include Risc::Ticker

    def self.runnable_methods
      input = load_parfait(:object) + load_parfait_test(:object)
      sol = Ruby::RubyCompiler.compile(input).to_sol
      tests = [  ]
      sol[2].body.statements.each do |method|
        tests << method.name
        self.send(:define_method, method.name ) do
          code = input + <<MAIN
            class Space
              def main(args)
                test = #{sol[2].name}.new
                test.setup
                test.#{method.name}
              end
            end
MAIN
#          ticks = run_input(code)
#          assert_equal "" , @interpreter.stdout
        end
        break
      end
      tests
    end

  end
end
