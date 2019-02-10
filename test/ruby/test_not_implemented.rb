require_relative "helper"

module Ruby
  class NotImplemented < Minitest::Test
    include RubyTests

    def assert_handler_missing(input)
      assert_raises(Ruby::ProcessError){ compile(input) }
    end

    def test_module
      assert_handler_missing "module Name ; end"
    end

    def test_module_module_scoped
      assert_handler_missing( "M::Module" )
    end

  end
end
