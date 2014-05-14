require "vm/c_machine"
require_relative "stack_instruction"
require_relative "logic_instruction"
require_relative "move_instruction"
require_relative "compare_instruction"
require_relative "memory_instruction"
require_relative "call_instruction"
require_relative "constants"

module Arm
  class ArmMachine < Vm::CMachine

    def integer_less_or_equal block ,  left , right
      block.add_code cmp(:left => left , :right => right )
      Vm::Bool.new
    end

    def integer_plus block , left , right
      block.add_code add(:left => left , :right => right )
      left
    end

    def integer_minus block , left , right
      block.add_code sub(:left => left , :right => right )
      left
    end

    def integer_load block , left , right
      block.add_code mov( :left => left , :right => right )
      left 
    end

    def integer_move block , left , right
      block.add_code mov( :left => left , :right => right )
      left 
    end

    def string_load block ,  str_lit , reg
      block.add_code add( :left => "r#{reg}".to_sym   , :extra => str_lit )   #right is pc, implicit
        #second arg is a hack to get the stringlength without coding
      block.add_code mov( :left => "r#{reg+1}".to_sym , :right => str_lit.length )
      str_lit
    end

    def function_call into , call
      raise "Not CallSite #{call.inspect}" unless call.is_a? Vm::CallSite
      raise "Not linked #{call.inspect}" unless call.function
      into.add_code call( :left => call.function )
      call.function.return_type
    end

    def main_start entry
      entry.add_code  mov( :left => :fp , :right => 0 )
    end
    def main_exit exit
      syscall(exit , 1)
    end
    def function_entry block, f_name
        #      entry.add_code  push( :regs => [:lr] )
        block
    end
    def function_exit entry , f_name
      entry.add_code  mov( :left => :pc , :right => :lr )
    end

    # assumes string in r0 and r1 and moves them along for the syscall
    def write_stdout block
      block.add_code mov( :left => :r2 , :right => :r1 )
      block.add_code mov( :left => :r1 , :right => :r0 )
      block.add_code mov( :left => :r0 , :right => 1 ) # 1 == stdout
      syscall( block , 4 )
    end

    private     

    def syscall block , num
      block.add_code mov( :left => :r7 , :right => num )
      block.add_code swi( :left => 0 )
      Vm::Integer.new(0)  #small todo, is this actually correct for all (that they return int)
    end

  end
end