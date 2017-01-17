require_relative '../helper'
require "register/interpreter"
require "parser/ruby22"

module Rubyx
  module RubyxTests
    include CompilerHelper
    include Register::InterpreterHelpers
    subs = ObjectSpace.each_object(Class).select { |klass| klass < Register::Instruction }
    subs.each do |clazz|
      name = clazz.to_s
      next if name.include?("Arm")
      scoped = name.split("::").last
      module_eval "#{scoped} = #{name}"
    end
  end
end
