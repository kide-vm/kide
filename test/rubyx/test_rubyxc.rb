require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCli < MiniTest::Test

    def test_invoke_without_not_work
      assert_output(nil , /not find/) {RubyXC.start(["list"])}
    end
    def test_invoke_compile_works
      assert_output( "") {RubyXC.start(["compile" ])}
    end
    def test_file_fail
      assert_output(nil , /No such file/) {RubyXC.start(["compile" , "hi"])}
    end
  end
end
