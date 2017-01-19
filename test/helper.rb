require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  SimpleCov.start { add_filter "/test/" }
end

require "minitest/color"
require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'test'))

require 'rubyx'

module Compiling
  def clean_compile(clazz_name , method_name , args , statements)
    compiler = Vm::MethodCompiler.create_method(clazz_name,method_name,args ).init_method
    compiler.process( Vm.ast_to_code( statements ) )
  end

end

module Risc
  # relies on @interpreter instance to be set up during setup
  module InterpreterHelpers

    def check_chain should
      should.each_with_index do |name , index|
        got = ticks(1)
        assert_equal got.class ,name , "Wrong class for #{index+1}, expect #{name} , got #{got}"
      end
    end

    def check_return val
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
      assert_equal val , @interpreter.get_register(:r0).return_value
    end

    def ticks num
      last = nil
      num.times do
        last = @interpreter.instruction
        @interpreter.tick
      end
      return last
    end

    def show_ticks
      classes = []
      tick = 1
      begin
        while true and (classes.length < 200)
          cl = ticks(1).class
          tick += 1
          classes << cl
          break if cl == NilClass
        end
      rescue => e
        puts "Error at tick #{tick}"
        puts e
        puts e.backtrace
      end
      str = classes.to_s.gsub("Risc::","")
      str.split(",").each_slice(5).each do |line|
        puts "            " + line.join(",") + ","
      end
      puts "length = #{classes.length}"
      exit(1)
    end
  end
end


class Ignored
  def == other
    return false unless other.class == self.class
    Sof::Util.attributes(self).each do |a|
      begin
        left = send(a)
      rescue NoMethodError
        next  # not using instance variables that are not defined as attr_readers for equality
      end
      begin
        right = other.send(a)
      rescue NoMethodError
        return false
      end
      return false unless left.class == right.class
      return false unless left == right
    end
    return true
  end
end
