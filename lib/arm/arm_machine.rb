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

    def integer_less_or_equal block ,  first , right
      block.add_code cmp( first , right: right )
      Vm::Bool.new
    end

    def integer_plus block , result , first , right
      block.add_code add( result , left: first , :extra => right )
      result
    end

    def integer_minus block , result , first , right
      block.add_code sub( result , left: first , :extra => right )
      result
    end

    def integer_load block , first , right
      block.add_code mov(  first , right: right )
      first 
    end

    def integer_move block , first , right
      block.add_code mov(  first , right: right )
      first 
    end

    def string_load block ,  str_lit , reg
      block.add_code add(  "r#{reg}".to_sym   , :extra => str_lit )   #right is pc, implicit
        #second arg is a hack to get the stringlength without coding
      block.add_code mov(  "r#{reg+1}".to_sym , right: str_lit.length )
      str_lit
    end

    def function_call into , call
      raise "Not CallSite #{call.inspect}" unless call.is_a? Vm::CallSite
      raise "Not linked #{call.inspect}" unless call.function
      into.add_code call(  call.function  , {})
      call.function.return_type
    end

    def main_start entry
      entry.add_code  mov(  :fp , right: 0 )
    end
    def main_exit exit
      syscall(exit , 1)
      exit
    end
    def function_entry block, f_name
        block.add_code  push( [:lr] , {})
    end
    def function_exit entry , f_name
      entry.add_code  pop(  [:pc] , {})
    end

    # assumes string in r0 and r1 and moves them along for the syscall
    def write_stdout block
      block.instance_eval do 
        mov(  :r2 , right: :r1 )
        mov(  :r1 , right: :r0 )
        mov(  :r0 , right: 1 ) # 1 == stdout
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
        sub( remainder , left: number , right: 10 )
        sub( number , left: number , right: number ,  shift_lsr: 2)
        add( number , left: number , right: number ,  shift_lsr: 4)
        add( number , left: number , right: number ,  shift_lsr: 8)
        add( number , left: number , right: number ,  shift_lsr: 16)
        mov( number ,  right: number , shift_lsr: 3)
        tmp = Vm::Integer.new( remainder.register + 1)
        add( tmp , left: number , right: number ,  shift_lsl: 2)
        sub( remainder , left: remainder , right: tmp , shift_lsl: 1 , update_status: 1)
        add( number , left: number,  right: 1 , condition_code: :pl )
        add( remainder , left: remainder ,  right: 10 , condition_code: :mi )
      end
    end

    def syscall block , num
      block.add_code mov(  :r7 , right: num )
      block.add_code swi(  0 , {})
      Vm::Integer.new(0)  #small todo, is this actually correct for all (that they return int)
    end

  end
end