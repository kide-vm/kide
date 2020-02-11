require_relative "helper"

module Sol
  class TestClassSendInherited < MiniTest::Test
    include SlotMachine
    include SolCompile

    def class_main
      <<-eos
        class Object
          def self.one_plus()
            return 1
          end
        end
        class Space < Object
          def main(arg)
            return Space.one_plus
          end
        end
      eos
    end

    def setup
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(class_main)
      @ins = ret.compilers.find_compiler_name(:main).slot_instructions.next
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,
                    ReturnJump,Label, ReturnSequence , Label] , @ins
    end
    def test_receiver
      assert_equal SlotMachine::ArgumentTransfer,  @ins.next(1).class
      assert_equal 0,  @ins.next(1).arguments.length
      assert_equal ObjectSlot,  @ins.next(1).receiver.class
      assert_equal Parfait::Class,  @ins.next(1).receiver.known_object.class
      assert_equal :Space,  @ins.next(1).receiver.known_object.name
    end
    def test_call
      assert_equal SimpleCall,  @ins.next(2).class
      assert_equal :one_plus,  @ins.next(2).method.name
      assert_equal Parfait::Type,  @ins.next(2).method.self_type.class
      assert_equal :"Space.Single",  @ins.next(2).method.self_type.object_class.name
    end
  end
end
