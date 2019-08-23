require_relative "helper"

module Mom
  module Builtin
    class TestObjectInitRisc < BootTest
      def setup
        super
        @method = get_object_compiler(:__init__)
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 19 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
