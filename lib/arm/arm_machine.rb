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
      # need to use create_method and move to attributes hash
      define_method("#{inst}s") do |*args|
        instruction clazz , inst , :al , 1 , *args
      end
      ArmMachine::COND_CODES.keys.each do |suffix|
        define_method("#{inst}#{suffix}") do |attributes|
          instruction clazz , inst , suffix , 0 , *args
        end
        define_method("#{inst}s#{suffix}") do |attributes|
          instruction clazz , inst , suffix , 1 , *args
        end
      end
    end
    
    def word_load value , reg
      mov( :left => reg , :right => value )
    end
    def string_load str_lit , reg
      [  add( :left => "r#{reg}".to_sym   , :extra => str_lit ) ,  #right is pc, implicit
        #second arg is a hack to get the stringlength without coding
         mov( :left => "r#{reg+1}".to_sym , :right => str_lit.length ) ] 
    end

    def function_call call
      raise "Not FunctionCall #{call.inspect}" unless call.is_a? Vm::FunctionCall
      call.args.each do | arg |
      end
      bl( :left => call.function )
    end

    def main_start
      entry = Vm::Block.new("main_entry")
      entry.add_code  mov( :left => :fp , :right => 0 )
    end
    def main_exit
      entry = Vm::Block.new("main_exit")
      entry.add_code syscall(1)
    end
    def function_entry f_name
      entry = Vm::Block.new("#{f_name}_entry")
#      entry.add_code  push( :left => :lr )
    end
    def function_exit f_name
      entry = Vm::Block.new("#{f_name}_exit")
      entry.add_code  mov( :left => :pc , :right => :lr )
    end
    def putstring
      put = Vm::Block.new("putstring_code")
      # should be another level of indirection, ie write(io,str)
      put.add_code mov( :left => :r2 , :right => :r1 )
      put.add_code mov( :left => :r1 , :right => :r0 )
      put.add_code mov( :left => :r0 , :right => 1 ) #stdout
      put.add_code  syscall(4)
    end
    private     
    def syscall num
      [mov( :left => :r7 , :right => num ) ,  swi( :left => 0 )]
    end

  end
end