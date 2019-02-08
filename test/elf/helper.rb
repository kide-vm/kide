require_relative "../helper"
require 'net/ssh'
require 'net/scp'

module Elf

  class FullTest < MiniTest::Test
    DEBUG = false

    def setup
    end

    def in_space(input)
      "class Space; #{input} ; end"
    end
    def as_main(input)
      in_space("def main(arg);#{input};end")
    end
    def check(input, file)
      linker = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_binary( input , :arm )
      writer = Elf::ObjectWriter.new(linker)
      writer.save "test/#{file}.o"
    end

    def check_remote(file)
      check(file)
      stdout , exit_code = run_ssh(file)
      @stdout = "" unless @stdout
      assert_equal @stdout , stdout
      assert_equal @exit_code , exit_code
    end

    def run_ssh( file )
      host = ENV["ARM_HOST"]
      return unless host
      port = (ENV["ARM_PORT"] || 2222)
      user = (ENV["ARM_USER"] || "pi")
      binary_file = "/tmp/#{file}"
      object_file = binary_file + ".o"
      Net::SCP.start(host, user , port: port ) do |scp|
        puts "Copying test/#{file}.o to #{object_file}" if DEBUG
        scp.upload! "test/#{file}.o",  object_file
      end
      Net::SSH.start(host, user , port: port ) do |ssh|
        puts "Linking #{object_file}" if DEBUG
        stdout , exit_code = ssh_exec!(ssh , "ld -N -o #{binary_file} #{object_file}")
        assert_equal 0 , exit_code , "Linking #{binary_file} failed"
        puts "Running #{binary_file}" if DEBUG
        stdout , exit_code = ssh_exec!(ssh , binary_file)
        puts "Result #{stdout} #{exit_code}" if DEBUG
        return stdout , exit_code
      end
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
