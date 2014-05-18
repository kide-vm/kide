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
      def putstring context
        function = Vm::Function.new(:putstring , [Vm::Integer , Vm::Integer ] )
        block = function.body
        # should be another level of indirection, ie write(io,str)
        ret = Vm::CMachine.instance.write_stdout(block)
        function.return_type = ret
        function
      end

      def putint context
        function = Vm::Function.new(:putint , [Vm::Integer , Vm::Integer ] )
        block = function.body
        buffer = Vm::StringConstant.new("           ")
        context.program.add_object buffer
        str_addr = Vm::Integer.new(0)                  # address of the 
        context.str_addr = str_addr
        reg1 = Vm::Integer.new(1)
        itos_fun = context.program.get_or_create_function(:utoa)
        block.instance_eval do 
          mov( reg1 ,  str_addr ) #move arg up
          add( str_addr ,  buffer ,nil )   # string to write to
          add( str_addr ,  str_addr ,  (buffer.length-3))  
          call( itos_fun )
        # And now we "just" have to print it, using the write_stdout
          add( str_addr ,  buffer , nil )   # string to write to
          mov( reg1 ,  buffer.length )
        end
        ret = Vm::CMachine.instance.write_stdout(block)
        function
      end

      # The conversion to base10 is quite a bit more complicated than i thought. The bulk of it is in div10
      # We set up variables, do the devision and write the result to the string
      # then check if were done and recurse if neccessary
      # As we write before we recurse (save a push) we write the number backwards
      def utoa context
        function = Vm::Function.new(:utoa , [Vm::Integer , Vm::Integer ] )
        block = function.body
        str_addr = context.str_addr
        number = Vm::Integer.new(str_addr.register + 1)
        remainder = Vm::Integer.new( number.register + 1)
        Vm::CMachine.instance.div10( block , number  , remainder )
        # make char out of digit (by using ascii encoding) 48 == "0"
        block.instance_eval do 
          add( remainder ,  remainder ,  48 )
          strb( remainder, right: str_addr ) 
          sub( str_addr,  str_addr ,  1 ) 
          cmp( number ,  0 )
          callne( function  )
        end
        return function
      end
    end
    
    extend ClassMethods
  end
end