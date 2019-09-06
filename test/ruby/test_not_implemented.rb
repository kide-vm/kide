require_relative "helper"

module Ruby
  class NotImplemented < Minitest::Test
    include RubyTests

    # random module names don't work, only global Parfait
    def assert_handler_missing(input)
      assert_raises(Ruby::ProcessError){ compile(input) }
    end

    def test_module
      assert_handler_missing( "module Mod ; end" )
    end

    def test_module_module_scoped
      assert_handler_missing( "M::Module" )
    end
    def test_module_parfait_scoped
      assert_handler_missing( "Parfait::Module" )
    end

    def test_module_parfait_scoped
      assert_handler_missing( "module Mod ; end" )
    end

  end
end
