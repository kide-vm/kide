require_relative 'helper'

module Mains
  class TestPuts < MainsTest

    def test_ruby_puts
      run_main_file "puts"
    end

  end
end
