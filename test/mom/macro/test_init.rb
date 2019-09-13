require_relative "helper"

module Mom
  module Builtin
    class TestObjectInitRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:init)
      end
      def test_mom_length
        assert_equal :__init__ , @method.callable.name
        assert_equal 7 , @method.mom_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 31 , @method.to_risc.risc_instructions.length
      end
    end
  end
end
