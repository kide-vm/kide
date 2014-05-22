require "vm/register_machine"
require_relative "stack_instruction"
require_relative "logic_instruction"
require_relative "move_instruction"
require_relative "compare_instruction"
require_relative "memory_instruction"
require_relative "call_instruction"
require_relative "constants"

module Arm
  class ArmMachine < Vm::RegisterMachine

    def integer_less_or_equal block ,  left , right
      block <<  cmp( left ,  right )
      Vm::BranchCondition.new :le
    end
    def integer_greater_than block ,  left , right
      block <<  cmp( left ,  right )
      Vm::BranchCondition.new :gt
    end

    def integer_plus block , result , left , right
      block <<  add( result , left ,  right )
      result
    end

    def integer_minus block , result , left , right
      block <<  sub( result ,  left ,  right )
      result
    end

    def function_call into , call
      raise "Not CallSite #{call.inspect}" unless call.is_a? Vm::CallSite
      raise "Not linked #{call.inspect}" unless call.function
      into <<  call(  call.function  )
      raise "No return type for #{call.function.name}" unless call.function.return_type
      call.function.return_type
    end

    def main_start entry
      entry <<   mov(  :fp ,  0 )
    end
    def main_exit exit
      syscall(exit , 1)
      exit
    end
    def function_entry block, f_name
        block <<  push( [:lr] )
    end
    def function_exit entry , f_name
      entry <<   pop(  [:pc] )
    end

    # assumes string in r0 and r1 and moves them along for the syscall
    def write_stdout block
      block.instance_eval do 
        mov(  :r2 ,  :r1 )
        mov(  :r1 ,  :r0 )
        mov(  :r0 ,  1 ) # 1 == stdout
      end
      syscall( block , 4 )
    end

    
    # the number (a Vm::integer) is (itself) divided by 10, ie overwritten by the result
    #  and the remainder is overwritten (ie an out argument)
    # not really a function, more a macro, 
    def div10 block, number , remainder
      # Note about division: devision is MUCH more expensive than one would have thought
      # And coding it is a bit of a mind leap: it's all about finding a a result that gets the 
      #  remainder smaller than an int. i'll post some links sometime. This is from the arm manual
      block.instance_eval do 
        sub( remainder ,  number ,  10 )
        sub( number ,  number ,  number ,  shift_lsr: 2)
        add( number ,  number ,  number ,  shift_lsr: 4)
        add( number ,  number ,  number ,  shift_lsr: 8)
        add( number ,  number ,  number ,  shift_lsr: 16)
        mov( number ,   number , shift_lsr: 3)
        tmp = function.new_local
        add( tmp ,  number ,  number ,  shift_lsl: 2)
        sub( remainder ,  remainder ,  tmp , shift_lsl: 1 , update_status: 1)
        add( number ,  number,   1 , condition_code: :pl )
        add( remainder ,  remainder ,   10 , condition_code: :mi )
      end
    end

    def syscall block , num
      block <<  mov(  :r7 , num )
      block <<  swi(  0 )
      Vm::Integer.new(0)  #small todo, is this actually correct for all (that they return int)
    end

  end
end