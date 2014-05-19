module Core
  class Kernel
    
    #there are no Kernel instances, only class methods.
    # We use this module syntax to avoid the (ugly) self (also eases searching).
    module ClassMethods
      def main_start block
        #TODO extract args into array of strings
        Vm::CMachine.instance.main_start block
        block
      end
      def main_exit block
        # Machine.exit mov r7 , 0  + swi 0 
        Vm::CMachine.instance.main_exit block
        block
      end
      def function_entry block , f_name
        Vm::CMachine.instance.function_entry block , f_name
      end
      def function_exit block , f_name
        Vm::CMachine.instance.function_exit block , f_name
      end
        
      #TODO this is in the wrong place. It is a function that returns a function object
      #   while all other methods add their code into some block. --> kernel
      def putstring context , string = Vm::Integer , length = Vm::Integer
        function = Vm::Function.new(:putstring , [string , length ] , string)
        block = function.body
        # should be another level of indirection, ie write(io,str)
        ret = Vm::CMachine.instance.write_stdout(block)
        function.return_type = ret
        function
      end

      def putint context , arg = Vm::Integer
        putint_function = Vm::Function.new(:putint , [arg] , arg )
        buffer = Vm::StringConstant.new("           ") # create a buffer
        context.program.add_object buffer              # and save it (function local variable: a no no)
        int = putint_function.args.first
        moved_int = Vm::Integer.new(1)
        utoa = context.program.get_or_create_function(:utoa)
        b = putint_function.body
        b.mov( moved_int ,  int ) #move arg up
        #b.a       buffer  => int          # string to write to
        
        b.add( int ,  buffer ,nil )   # string to write to
        b.a       int +  (buffer.length-3) => int
        b.call( utoa )
        # And now we "just" have to print it, using the write_stdout
        b.add( int ,  buffer , nil )   # string to write to
        b.mov( moved_int ,  buffer.length )
        Vm::CMachine.instance.write_stdout(putint_function.body)
        putint_function
      end

      # The conversion to base10 is quite a bit more complicated than i thought. The bulk of it is in div10
      # We set up variables, do the devision and write the result to the string
      # then check if were done and recurse if neccessary
      # As we write before we recurse (save a push) we write the number backwards
      # arguments: string address , integer
      def utoa context
        utoa_function = Vm::Function.new(:utoa , [Vm::Integer , Vm::Integer ] , Vm::Integer )
        str_addr = utoa_function.args[0]
        number = utoa_function.args[1]
        remainder = Vm::Integer.new( number.register + 1)
        Vm::CMachine.instance.div10( utoa_function.body , number  , remainder )
        # make char out of digit (by using ascii encoding) 48 == "0"
        b = utoa_function.body
        b.a      remainder + 48 => remainder
        b.strb( remainder, right: str_addr ) 
        b.sub( str_addr,  str_addr ,  1 ) 
        b.cmp( number ,  0 )
        b.callne( utoa_function  )
        return utoa_function
      end
    end
    
    extend ClassMethods
  end
end