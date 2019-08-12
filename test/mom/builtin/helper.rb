require_relative "../helper"

module Mom
  module Builtin
    class BootTest < MiniTest::Test
      def setup
        Parfait.boot!(Parfait.default_test_options)
        @functions = Builtin.boot_functions
      end
      def get_compiler( name )
        @functions.each.find{|meth|
          meth.callable.name == name}
      end
    end
  end
end
