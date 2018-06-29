require_relative 'helper'
require 'net/ssh'
require 'net/scp'

module Mains
  class TestArm < MiniTest::Test

    DEBUG = true
    def self.user
      ENV["ARM_USER"] || "pi"
    end
    def self.port
      ENV["ARM_PORT"] || 2222
    end

    # runnable_methods is called by minitest to determine which tests to run
    def self.runnable_methods
      all = Dir["test/mains/source/*_*.rb"]
      tests =[]
      host = ENV["ARM_HOST"]
      return tests unless host
      ssh = Net::SSH.start(host, user , port: port )
      all.each do |file_name|
        fullname = file_name.split("/").last.split(".").first
        name , stdout , exit_code = fullname.split("_")
        method_name = "test_#{name}"
        input = File.read(file_name)
        tests << method_name
        self.send(:define_method, method_name ) do
          compile( input , name , ssh.scp)
          out , code = run_ssh(name , ssh)
          assert_equal stdout , out , "Wrong stdout #{name}"
          assert_equal exit_code , code.to_s , "Wrong exit code #{name}"
        end
      end
      tests
    end

    def compile(input , file , scp)
      Risc.machine.boot
      puts "Compiling test/#{file}.o" if DEBUG
      RubyX::RubyXCompiler.ruby_to_binary( "class Space;def main(arg);#{input};end;end" )
      writer = Elf::ObjectWriter.new(Risc.machine)
      writer.save "test/#{file}.o"
      object_file = "/tmp/#{file}.o"
      puts "Copying test/#{file}.o to #{object_file}" if DEBUG
      scp.upload! "test/#{file}.o",  object_file
    end

    def run_ssh( file , ssh)
      binary_file = "/tmp/#{file}"
      object_file = binary_file + ".o"
      puts "Linking #{object_file}" if DEBUG
      stdout , exit_code = ssh_exec!(ssh , "ld -N -o #{binary_file} #{object_file}")
      assert_equal 0 , exit_code , "Linking #{binary_file} failed"
      puts "Running #{binary_file}" if DEBUG
      stdout , exit_code = ssh_exec!(ssh , binary_file)
      puts "Result #{stdout} #{exit_code}" if DEBUG
      return stdout , exit_code
    end

    def ssh_exec!(ssh, command)
      stdout_data = ""
      exit_code = nil
      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            raise "FAILED: couldn't execute command (ssh.channel.exec)"
          end
          channel.on_data do |c,data|
            stdout_data+=data
          end
          channel.on_extended_data do |c,type,data|
            raise "#{ssh} received stderr #{data}"
          end
          channel.on_request("exit-status") do |c,data|
            exit_code = data.read_long
          end
          channel.on_request("exit-signal") do |c, data|
            raise "#{ssh} received signal #{data.read_long}"
          end
        end
      end
      ssh.loop
      [stdout_data, exit_code]
    end
  end
end
