require_relative "helper"

module Elf
  class HelloTest < FullTest

    def test_string_put
      hello = "Hello World!\n"
      @input = "return '#{hello}'.putstring"
      @stdout = hello
      @exit_code = hello.length
      check "hello"
    end
  end
end
