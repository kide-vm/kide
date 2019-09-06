require_relative "rt_helper"

module RubyX
  class ObjectTest < MiniTest::Test
    include ParfaitHelper
    def setup
      @input = load_parfait(:object) #+ load_parfait_test(:object)
    end

    def test_basics
      risc = compiler.ruby_to_binary @input , :interpreter
      assert_equal Risc::Linker , risc.class
    end

    def test_run_all
      @input += "class Space;def main(arg);::Parfait::Object.new;end;end"
      run_input
    end
  end
end
