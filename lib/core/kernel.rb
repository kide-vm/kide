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

      # testing method, hand coded fibo, expects arg in 1 , so pass 2 in, first bogy
      # result comes in 0
      # a hand coded version of the fibonachi numbers
      #  not my hand off course, found in the net from a basic introduction
      def fibo context
        fibo_function = Vm::Function.new(:fibo , [Vm::Integer , Vm::Integer] , Vm::Integer )
        result = fibo_function.args[0]
        int =fibo_function.args[1]
        i = Vm::Integer.new(2)
        f1 = Vm::Integer.new(3)
        f2 = Vm::Integer.new(4)
        loop_block = Vm::Block.new("loop")
        fibo_function.body.instance_eval do
          cmp( int , 1)
          mov( result, int , condition_code: :le)
          mov( :pc , :lr , condition_code: :le)
          push [  i , f1 , f2 , :lr]
          mov( f1 , 1)
          mov(f2 , 0)
          sub( i , int , 2)
          add_code loop_block
        end
        loop_block.instance_eval do
          add( f1 , f1 , f2)
          sub( f2 , f1 , f2)
          sub( i , i , 1 , update_status: 1)
          bpl( loop_block )
          mov( result , f1 )
          pop [ i , f1 , f2 , :pc]
        end
        fibo_function
      end

    end
    
    extend ClassMethods
  end
end