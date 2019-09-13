require_relative "helper"

module Elf
  class SomeOtherTest < FullTest

    def test_string_put
      hello = "Hello World!\n"
      input = "return '#{hello}'.putstring"
      preload = "class Word;def putstring;X.putstring;end;end;"
      @stdout = hello
      @exit_code = hello.length
      check preload + as_main(input), "hello"
    end
  end
end
