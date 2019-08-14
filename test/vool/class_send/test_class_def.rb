require_relative "helper"

module Vool
  class TestClassDef < MiniTest::Test
    include Mom
    def class_main
      <<-eos
        class Space
          def self.one_plus()
            return 1 + 1
          end
          def main(arg)
            return Space.one_plus
          end
        end
      eos
    end

    def setup
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(class_main)
      @ins = ret.compilers.first.mom_instructions.next
    end

    def test_any
      assert_equal Mom::MessageSetup , @ins.class
    end

    def test_no_arg
      assert_equal Mom::ArgumentTransfer,  @ins.next(1).class
      assert_equal 1,  @ins.next(1).arguments.length
    end
    def test_call_two
      assert_equal SimpleCall,  @ins.next(2).class
    end
  end
end
