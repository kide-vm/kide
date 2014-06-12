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
    # The constants are here for readablility, the code uses access functions below
    RETURN_REG = :r0
    TYPE_REG = :r1
    RECEIVER_REG = :r2
    
    def return_register
      RETURN_REG
    end
    def type_register
      TYPE_REG
    end
    def receiver_register
      RECEIVER_REG
    end

    def integer_equals block ,  left , right
      block.add_code  cmp( left ,  right )
      Vm::BranchCondition.new :eq
    end
    def integer_less_or_equal block ,  left , right
      block.add_code  cmp( left ,  right )
      Vm::BranchCondition.new :le
    end
    def integer_greater_or_equal block ,  left , right
      block.add_code  cmp( left ,  right )
      Vm::BranchCondition.new :ge
    end
    def integer_less_than block ,  left , right
      block.add_code  cmp( left ,  right )
      Vm::BranchCondition.new :lt
    end
    def integer_greater_than block ,  left , right
      block.add_code  cmp( left ,  right )
      Vm::BranchCondition.new :gt
    end

    # TODO wrong type, should be object_reference. But that needs the actual typing to work
    def integer_at_index block , result ,left , right
      block.add_code  ldr( result , left , right )
      result
    end

    def integer_plus block , result , left , right
      block.add_code  add( result , left ,  right )
      result
    end

    def integer_minus block , result , left , right
      block.add_code  sub( result ,  left ,  right )
      result
    end
    def integer_left_shift block , result , left , right
      block.add_code  mov( result ,  left , shift_lsr: right )
      result
    end

    def function_call into , call
      raise "Not CallSite #{call.inspect}" unless call.is_a? Vm::CallSite
      raise "Not linked #{call.inspect}" unless call.function
      into.add_code  call(  call.function  )
      raise "No return type for #{call.function.name}" unless call.function.return_type
      call.function.return_type
    end

    def main_start context
      entry = Vm::Block.new("main_entry",nil,nil)
      entry.do_add mov(  :fp ,  0 )
      entry.do_add call( context.function.entry )
      entry
    end
    def main_exit context
      exit = Vm::Block.new("main_exit",nil,nil)
      syscall(exit , 1)
      exit
    end
    def function_entry block, f_name
        block.do_add  push( [:lr] )
        block
    end
    def function_exit entry , f_name
      entry.do_add   pop(  [:pc] )
      entry
    end

    # assumes string in standard receiver reg (r2) and moves them down for the syscall
    def write_stdout function #, string
      # TODO save and restore r0
      function.mov( :r0 ,  1 ) # 1 == stdout
      function.mov( :r1 , RECEIVER_REG )
      function.mov( RECEIVER_REG , :r3 )
      syscall( function.insertion_point , 4 ) # 4 == write
    end

    
    # the number (a Vm::integer) is (itself) divided by 10, ie overwritten by the result
    #  and the remainder is overwritten (ie an out argument)
    # not really a function, more a macro, 
    def div10 function, number , remainder
      # Note about division: devision is MUCH more expensive than one would have thought
      # And coding it is a bit of a mind leap: it's all about finding a a result that gets the 
      #  remainder smaller than an int. i'll post some links sometime. This is from the arm manual
      function.instance_eval do 
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
      # This is very arm specific, syscall number is passed in r7, other arguments like a c call ie 0 and up
      sys = Vm::Integer.new( Vm::RegisterUse.new(:r7) )
      ret = Vm::Integer.new( Vm::RegisterUse.new(RETURN_REG) )
      block.do_add  mov(  sys , num )
      block.do_add  swi(  0 )
      #todo should write type into r1 according to syscall
      ret
    end

  end
end