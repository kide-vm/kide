require_relative 'helper'
require 'net/ssh'
require 'net/scp'

module Mains
  class TestArm < MiniTest::Test

    DEBUG = false

    # runnable_methods is called by minitest to determine which tests to run
    def self.runnable_methods
      all = Dir["test/mains/source/*_*.rb"]
      tests =[]
      return tests unless has_qemu
      all.each do |file_name|
        fullname = file_name.split("/").last.split(".").first
        name , stdout , exit_code = fullname.split("_")
        method_name = "test_#{name}"
        input = File.read(file_name)
        tests << method_name
        self.send(:define_method, method_name ) do
          out , code = run_code(input , name)
          assert_equal stdout , out , "Wrong stdout #{name}"
          assert_equal exit_code , code.to_s , "Wrong exit code #{name}"
        end
      end
      tests
    end

    def self.has_qemu
      `qemu-arm -version`
      return false unless $?.exitstatus == 0
      `arm-linux-gnu-ld -v`
      return false unless $?.exitstatus == 0
      true
    end

    def run_code(input , name )
      puts "Compiling #{name}.o" if DEBUG

      linker = ::RubyX::RubyXCompiler.new({}).ruby_to_binary( input , :arm )
      writer = Elf::ObjectWriter.new(linker)

      writer.save "mains.o"

      puts "Linking #{name}" if DEBUG

      `arm-linux-gnu-ld -N mains.o`
      assert_equal 0 , $?.exitstatus , "Linking #{name} failed #{$?}"

      puts "Running #{name}" if DEBUG
      stdout = `qemu-arm ./a.out`
      exit_code = $?.exitstatus
      puts "Result #{stdout} #{exit_code}" if DEBUG
      return stdout , exit_code
    end

  end
end
