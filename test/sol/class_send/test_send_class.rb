require_relative "helper"

module Sol
  class TestSendClassSlotMachine < MiniTest::Test
    include SolCompile

    def class_main
      <<-eos
        class Space
          def self.one_plus(one)
            return 1 + 1
          end
        end
        class Space
          def main(arg)
            return Space.one_plus(1)
          end
        end
      eos
    end

    def setup
      source = "class Integer < Data4;def +(other);X.int_operator(:+);end;end;" + class_main
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(source)
      @ins = ret.compilers.find_compiler_name(:main).slot_instructions.next
    end

    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,
                    ReturnJump,Label, ReturnSequence , Label] , @ins
    end

    def test_class_compiles
      assert_equal MessageSetup , @ins.class , @ins
    end
    def test_receiver
      assert_equal Slot,  @ins.next.receiver.class
      assert_equal Parfait::Class,  @ins.next.receiver.known_object.class
      assert_equal :Object ,  @ins.next.receiver.known_object.name
    end
    def test_receiver_move
      assert_equal ObjectSlot,  @ins.next.receiver.class
    end
    def test_receiver
      assert_equal Parfait::Class,  @ins.next.receiver.known_object.class
    end
    def test_arg_one
      assert_equal SlotLoad,  @ins.next(1).arguments[0].class
    end
    def test_receiver_move_class
      assert_equal ArgumentTransfer,  @ins.next(1).class
    end
    def test_call_is
      assert_equal SimpleCall,  @ins.next(2).class
      assert_equal Parfait::CallableMethod,  @ins.next(2).method.class
      assert_equal :one_plus,  @ins.next(2).method.name
    end
    def test_call_has_right_receiver
      assert_equal "Space.Single_Type",  @ins.next(2).method.self_type.name
    end
  end
end
