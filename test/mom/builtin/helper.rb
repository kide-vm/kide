require_relative "../helper"

module Mom
  module Builtin
    class BootTest < MiniTest::Test
      def setup
        Parfait.boot!(Parfait.default_test_options)
        Builtin.compiler_for( Parfait.object_space.get_class.instance_type   , Space , :main)
      end
      def get_int_compiler(name)
        obj_type = Parfait.object_space.get_type_by_class_name(:Integer)
        Builtin.compiler_for( obj_type , Integer , name)
      end
      def get_operator_compiler(name)
        obj_type = Parfait.object_space.get_type_by_class_name(:Integer)
        Builtin.operator_compiler( obj_type , name)
      end

      def get_object_compiler(name)
        obj_type = Parfait.object_space.get_type_by_class_name(:Object)
        Builtin.compiler_for( obj_type , Object , name)
      end
      def get_word_compiler(name)
        obj_type = Parfait.object_space.get_type_by_class_name(:Word)
        Builtin.compiler_for( obj_type , Word , name)
      end
    end
  end
end
