require_relative "helper"

module Vool
  class TestClassInstance < MiniTest::Test
    include Mom
    include VoolCompile

    def class_main
      <<-eos
        class Space
          def self.some_inst
            return @inst
          end
          def main(arg)
            return Space.one_plus
          end
        end
      eos
    end

    def setup
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(class_main)
      @ins = ret.compilers.find{|c|c.callable.name==:some_inst}.mom_instructions.next
    end
    def test_class_inst
        space_class = Parfait.object_space.get_class
        assert_equal :Space , space_class.name
        names = space_class.meta_class.instance_type.names
        assert names.index_of(:inst) , names
    end
    def test_array
      check_array   [SlotLoad, ReturnJump, Label, ReturnSequence, Label]  , @ins
    end
    def test_load_inst
      assert_equal SlotLoad,  @ins.class
    end
    def test_left
      assert_equal SlotDefinition , @ins.left.class
      assert_equal [:return_value] , @ins.left.slots
    end
    def test_right
      assert_equal SlotDefinition , @ins.right.class
      assert_equal [:receiver , :inst] , @ins.right.slots
    end
  end
end
