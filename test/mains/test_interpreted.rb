require_relative 'helper'

module Mains
  class TestInterpreted < MiniTest::Test
      include Risc::Ticker
      def setup;end

    # runnable_methods is called by minitest to determine which tests to run
    def self.runnable_methods
      all = Dir["test/mains/source/*.rb"]
      tests =[]
      all.each do |file_name|
        fullname = file_name.split("/").last.split(".").first
        order , name , stdout , exit_code = fullname.split("_")
        method_name = "test_#{order}_#{name}"
        tests << method_name
        input = File.read(file_name)
        self.send(:define_method, method_name ) do
          ticks = run_input(input)
          #puts "Ticks for #{method_name}=#{ticks}"
          assert_equal stdout , @interpreter.stdout , "Wrong stdout #{name}"
          assert_equal exit_code , get_return.to_s , "Wrong exit code #{name}"
        end
      end
      tests
    end

  end
end
