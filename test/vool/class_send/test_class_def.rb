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
      statements = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(class_main)
      assert_equal Vool::ClassStatement, statements.class
      ret = statements.to_mom(nil)
      assert_equal Parfait::Class , statements.clazz.class , statements
      @method = statements.clazz.get_method(:main)
      assert_equal Parfait::VoolMethod , @method.class
      assert_equal Mom::MomCompiler , ret.class
      compiler = ret.method_compilers.find{|c| c.get_method.name == :main }
      assert_equal Risc::MethodCompiler , compiler.class
      @ins = @method.source.to_mom( compiler )
    end

    def test_any
      assert_equal Mom::MessageSetup , @ins.class
    end

    def test_no_arg
      assert_equal Mom::ArgumentTransfer,  @ins.next(1).class
      assert_equal 0,  @ins.next(1).arguments.length
    end
    def test_call_two
      assert_equal SimpleCall,  @ins.next(2).class
    end
  end
end
