require "vm/machine"
require_relative "instruction"
require_relative "stack_instruction"
require_relative "logic_instruction"
require_relative "memory_instruction"
require_relative "call_instruction"

module Arm
  class ArmMachine < Vm::Machine
    
    # defines a method in the current class, with the name inst (first erg) 
    # the method instantiates an instruction of the given class which gets passed a single hash as arg
    
    # gets called for every "standard" instruction. 
    # may be used for machine specific ones too
    def define_instruction inst , clazz
      super
      return
      # need to use create_method and move to options hash
      define_method("#{inst}s") do |*args|
        instruction clazz , inst , :al , 1 , *args
      end
      ArmMachine::COND_CODES.keys.each do |suffix|
        define_method("#{inst}#{suffix}") do |options|
          instruction clazz , inst , suffix , 0 , *args
        end
        define_method("#{inst}s#{suffix}") do |options|
          instruction clazz , inst , suffix , 1 , *args
        end
      end
    end
    
    def word_load value , reg
      e = Vm::Block.new("load_#{value}")
      e.add_code( MoveInstruction.new( :left => reg , :right => value ) )
    end
    def function_call call
      raise "Not FunctionCall #{call.inspect}" unless call.is_a? Vm::FunctionCall
      bl( :left => call.function )
    end

    def main_entry
      mov( :left => :fp , :right => 0 )
    end
    def main_exit
      syscall(0)
    end
    def syscall num
      mov( :left => 7 , :right => num ) 
      swi( :left => 0 )
    end
  end
end