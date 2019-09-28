require_relative "helper"

module Vool
  class TestClassSendInherited < MiniTest::Test
    include Mom
    include VoolCompile

    def class_main
      <<-eos
        class Space
          def self.one_plus()
            return 1 + 1
          end
        end
        class Space
          def main(arg)
            return Space.one_plus
          end
        end
      eos
    end

    def setup
      source = "class Integer < Data4;def +(other);X.int_operator(:+);end;end;" + class_main
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(source)
      @ins = ret.compilers.find_compiler{|c|c.callable.name==:main}.mom_instructions.next
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,
                    ReturnJump,Label, ReturnSequence , Label] , @ins
    end
    def test_receiver
      assert_equal Mom::ArgumentTransfer,  @ins.next(1).class
      assert_equal 0,  @ins.next(1).arguments.length
      assert_equal SlotDefinition,  @ins.next(1).receiver.class
      assert_equal Parfait::Class,  @ins.next(1).receiver.known_object.class
      assert_equal :Space,  @ins.next(1).receiver.known_object.name
    end
    def test_call
      assert_equal SimpleCall,  @ins.next(2).class
      assert_equal :one_plus,  @ins.next(2).method.name
      assert_equal Parfait::Type,  @ins.next(2).method.self_type.class
      assert_equal :Class,  @ins.next(2).method.self_type.object_class.name
    end
  end
end
