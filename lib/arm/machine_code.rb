module Arm
  class MachineCode

    def function_call into , call
      raise "Not CallSite #{call.inspect}" unless call.is_a? Virtual::CallSite
      raise "Not linked #{call.inspect}" unless call.function
      into.add_code  call(  call.function  )
      raise "No return type for #{call.function.name}" unless call.function.return_type
      call.function.return_type
    end

    def main_start context
      entry = Virtual::Block.new("main_entry",nil,nil)
      entry.add_code mov(  :fp ,  0 )
      entry.add_code call( context.function )
      entry
    end
    def main_exit context
      exit = Virtual::Block.new("main_exit",nil,nil)
      syscall(exit , 1)
      exit
    end
    def function_entry block, f_name
        block.add_code  push( [:lr] )
        block
    end
    def function_exit entry , f_name
      entry.add_code   pop(  [:pc] )
      entry
    end

    # assumes string in standard receiver reg (r2) and moves them down for the syscall
    def write_stdout function #, string
      # TODO save and restore r0
      function.mov( :r0 ,  1 ) # 1 == stdout
      function.mov( :r1 , receiver_register )
      function.mov( receiver_register , :r3 )
      syscall( function.insertion_point , 4 ) # 4 == write
    end

    # stop, do not return
    def exit function #, string
      syscall( function.insertion_point , 1 ) # 1 == exit
    end

    
    # the number (a Virtual::integer) is (itself) divided by 10, ie overwritten by the result
    #  and the remainder is overwritten (ie an out argument)
    # not really a function, more a macro, 
    def div10 function, number , remainder
      # Note about division: devision is MUCH more expensive than one would have thought
      # And coding it is a bit of a mind leap: it's all about finding a a result that gets the 
      #  remainder smaller than an int. i'll post some links sometime. This is from the arm manual
      tmp = function.new_local
      function.instance_eval do 
        sub( remainder ,  number ,  10 )
        sub( number ,  number ,  number ,  shift_lsr: 2)
        add( number ,  number ,  number ,  shift_lsr: 4)
        add( number ,  number ,  number ,  shift_lsr: 8)
        add( number ,  number ,  number ,  shift_lsr: 16)
        mov( number ,   number , shift_lsr: 3)
        add( tmp ,  number ,  number ,  shift_lsl: 2)
        sub( remainder ,  remainder ,  tmp , shift_lsl: 1 , update_status: 1)
        add( number ,  number,   1 , condition_code: :pl )
        add( remainder ,  remainder ,   10 , condition_code: :mi )
      end
    end

    def syscall block , num
      # This is very arm specific, syscall number is passed in r7, other arguments like a c call ie 0 and up
      sys = Virtual::Integer.new( Virtual::RegisterReference.new(SYSCALL_REG) )
      ret = Virtual::Integer.new( Virtual::RegisterReference.new(RETURN_REG) )
      block.add_code  mov(  sys , num )
      block.add_code  swi(  0 )
      #todo should write type into r1 according to syscall
      ret
    end

  end
end

