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

    def integer_plus block , result , left , right
      block.add_code add(:left => result , :right => left , :extra => right )
      result
    end

    def integer_minus block , result , left , right
      block.add_code sub(:left => result , :right => left , :extra => right )
      result
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
      exit
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

    # make a string out of the integer.
    # as we don't have memory manegement yet, you have to pass the string in (ouch)
    # in a weird twist the string is actually a string, while we actually use its address.
    def integer_to_s block , string
      number = Vm::Integer.new(0)
      tos = Vm::Block.new("integer_to_s") # need to create a block to jump to
      block.add_code(tos) # and then use the new block to add code
      #STMFD  sp!, {r9, r10, lr}               #function entry save working regs (for recursion)
      tos.add_code( push :regs => [:lr ])      #and the return address.
      #  MOV    r9, r1                         # preserve arguments over following
      #  MOV    r10, r2                         # function calls
      # pin data, ie no saving
      remainder = Vm::Integer.new( number.register + 2)
      # BL     udiv10                         # r1 = r1 / 10
      div10( tos , number  , remainder )
      # ADD    r10, r10, 48 #'0'                   # make char out of digit (by using ascii encoding)
      tos.add_code( add( left: remainder , right: remainder , extra: 48 ))
      #STRB   r10, [r1], 1                   # store digit at end of buffer
      tos.add_code( strb( left: string , right: remainder ))  #and increment TODO check
      # CMP    r1, #0                         # quotient non-zero?
      tos.add_code( cmp left: number , right: 0 )
      #BLNE   utoa                           # conditional recursive call to utoa
      tos.add_code( callne( left: tos ))
      #LDMFD  sp!, {r9, r10, pc}              # function exit - restore and return
      tos.add_code( pop regs: [:pc])
    end
        
    private     


    # the number (a Vm::integer) is (itself) divided by 10, ie overwritten by the result
    #  and the remainder is overwritten (ie an out argument)
    # not really a function, more a macro, hence private
    def div10 block, number , remainder
      
      # takes argument in r1
      # returns quotient in r1, remainder in r2
      #          SUB    r2, r1, #10                       # keep (x-10) for later
      block.add_code sub(:left => remainder , :right => number , :extra => 10 )
#          SUB    r1, r1, r1, lsr #2
#          ADD    r1, r1, r1, lsr #4
#          ADD    r1, r1, r1, lsr #8
#          ADD    r1, r1, r1, lsr #16
#          MOV    r1, r1, lsr #3
#          ADD    r3, r1, r1, asl #2
#          SUBS   r2, r2, r3, asl #1                # calc (x-10) - (x/10)*10
#          ADDPL  r1, r1, #1                        # fix-up quotient
#          ADDMI  r2, r2, #10                       # fix-up remainder
#          MOV    pc, lr     
    end

    def syscall block , num
      block.add_code mov( :left => :r7 , :right => num )
      block.add_code swi( :left => 0 )
      Vm::Integer.new(0)  #small todo, is this actually correct for all (that they return int)
    end

  end
end