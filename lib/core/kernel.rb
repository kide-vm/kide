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
        reg1 = Vm::Integer.new(1)
        block.add_code Vm::CMachine.instance.mov( reg1 , right: str_addr ) #move arg up
        block.add_code Vm::CMachine.instance.add( str_addr , left: buffer )   # string to write to
        block.add_code Vm::CMachine.instance.add( str_addr , left: str_addr , right: (buffer.length-3))   # string to write to
        context.str_addr = str_addr
        itos_fun = context.program.get_or_create_function(:utoa)
        block.add_code Vm::CMachine.instance.call( itos_fun , {})
        # And now we "just" have to print it, using the write_stdout
        block.add_code Vm::CMachine.instance.add( str_addr , left: buffer )   # string to write to
        block.add_code Vm::CMachine.instance.mov( reg1 , right: buffer.length )
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
        block.add_code Vm::CMachine.instance.add( remainder , left: remainder , right: 48 )
        block.add_code Vm::CMachine.instance.strb( remainder, right: str_addr ) 
        block.add_code Vm::CMachine.instance.sub( str_addr, left: str_addr , right: 1 ) 
        block.add_code Vm::CMachine.instance.cmp( number , right: 0 )
        block.add_code Vm::CMachine.instance.callne( function , {} )
        return function
      end
    end
    
    extend ClassMethods
  end
end