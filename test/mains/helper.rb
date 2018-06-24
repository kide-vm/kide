require_relative '../helper'

module Mains
  class MainsTest < MiniTest::Test
    include Risc::Ticker
    def setup;end

    def run_main_file(file)
      input = File.read("test/mains/#{file}.rb")
      run_main(input)
    end
  end
end
