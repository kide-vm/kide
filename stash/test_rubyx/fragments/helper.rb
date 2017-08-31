require_relative '../helper'
require "risc/interpreter"
require "parser/ruby22"

module Rubyx
  module RubyxTests
    include CompilerHelper
    include Risc::InterpreterHelpers
    subs = ObjectSpace.each_object(Class).select { |klass| klass < Risc::Instruction }
    subs.each do |clazz|
      name = clazz.to_s
      next if name.include?("Arm")
      scoped = name.split("::").last
      module_eval "#{scoped} = #{name}"
    end
  end
end
