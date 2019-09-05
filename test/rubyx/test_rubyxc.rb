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
    def test_file_open
      assert_output(/compiling/) {RubyXC.start(["compile" , "test/mains/source/add__4.rb"])}
      #File.delete "add__4.o"
    end
    def test_interpret
      assert_output(/interpreting/) {RubyXC.start(["interpret" , "test/mains/source/add__4.rb"])}
    end
    def test_execute
      assert_output(/Running/) {RubyXC.start(["execute" , "test/mains/source/add__4.rb"])}
    end
    def test_stats
      out, err = capture_io {RubyXC.start(["stats" , "test/mains/source/add__4.rb"])}
      assert out.include?("Space") , out
      assert out.include?("Total") , out
      assert out.include?("Objects=") , out
    end
  end
end
