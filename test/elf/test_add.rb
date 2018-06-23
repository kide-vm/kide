require_relative "helper"

module Elf
  class AddTest < FullTest

    def test_add
      @input = "return 2 + 2"
      @exit_code = 4
      check "add"
    end
  end
end
