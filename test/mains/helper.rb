require_relative '../helper'

module Mains
  class MainsTest < MiniTest::Test
    include Risc::Ticker
    def setup;end

    def run_main_file(file)
      file_name = Dir["test/mains/source/#{file}*.rb"].first
      assert file_name , "no file #{file_name}"
      input = File.read(file_name)
      basename = file_name.split("/").last.split(".").first
      _ , stdout , exit_code = basename.split("_")
      stdout = "" unless stdout
      run_main(input)
      assert_equal stdout , @interpreter.stdout , "Wrong stdout for #{file}"
      assert_equal exit_code , get_return.to_s , "Wrong exit code for #{file}"
    end
  end
end
