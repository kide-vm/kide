require_relative "helper"

module Elf
  class SomeOtherTest < FullTest

    def test_string_put
      hello = "Hello World!\n"
      input = "return '#{hello}'.putstring"
      @stdout = hello
      @exit_code = hello.length
      check as_main(input), "hello"
    end
  end
end
