require_relative "helper"

module Vool
  class TestVoolMethod < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ins = compile_first_method( "@a = 5")
    end

    def test_setup

    end
  end
end
