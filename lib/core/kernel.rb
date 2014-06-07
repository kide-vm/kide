module Core
  class Kernel
    
    #there are no Kernel instances, only class methods.
    # We use this module syntax to avoid the (ugly) self (also eases searching).
    module ClassMethods
      def main_start block
        #TODO extract args into array of strings
        Vm::RegisterMachine.instance.main_start block
        block
      end
      def main_exit block
        # Machine.exit mov r7 , 0  + swi 0 
        Vm::RegisterMachine.instance.main_exit block
        block
      end
      def function_entry block , f_name
        Vm::RegisterMachine.instance.function_entry block , f_name
      end
      def function_exit block , f_name
        Vm::RegisterMachine.instance.function_exit block , f_name
      end

      #TODO this is in the wrong place. It is a function that returns a function object
      #   while all other methods add their code into some block. --> kernel
      def putstring context 
        function = Vm::Function.new(:putstring , Vm::Integer , [] )
        block = function.body
        # should be another level of indirection, ie write(io,str)
        ret = Vm::RegisterMachine.instance.write_stdout(block)
        function.set_return ret
        function
      end

      def putint context
        putint_function = Vm::Function.new(:putint , Vm::Integer , [] , Vm::Integer )
        buffer = Vm::StringConstant.new("           ") # create a buffer
        context.object_space.add_object buffer              # and save it (function local variable: a no no)
        int = putint_function.receiver
        moved_int = putint_function.new_local
        utoa = context.object_space.get_or_create_class(:Object).get_or_create_function(:utoa)
        body = putint_function.body
        body.mov( moved_int ,  int ) #move arg up
        #body.a       buffer  => int          # string to write to
        
        body.add( int ,  buffer ,nil )   # string to write to
        body.add(int , int ,  buffer.length - 3) 
        body.call( utoa )
        after = body.new_block("#{body.name}_a")
        body.insert_at after
        # And now we "just" have to print it, using the write_stdout
        after.add( int ,  buffer , nil )   # string to write to
        after.mov( moved_int ,  buffer.length )
        Vm::RegisterMachine.instance.write_stdout(after)
        putint_function
      end

      # The conversion to base10 is quite a bit more complicated than i thought. The bulk of it is in div10
      # We set up variables, do the devision and write the result to the string
      # then check if were done and recurse if neccessary
      # As we write before we recurse (save a push) we write the number backwards
      # arguments: string address , integer
      def utoa context
        utoa_function = Vm::Function.new(:utoa , Vm::Integer , [ Vm::Integer ] , Vm::Integer )
        str_addr = utoa_function.receiver
        number = utoa_function.args.first
        remainder = utoa_function.new_local
        Vm::RegisterMachine.instance.div10( utoa_function.body , number  , remainder )
        # make char out of digit (by using ascii encoding) 48 == "0"
        body = utoa_function.body
        body.add(remainder , remainder , 48)
        body.strb( remainder, str_addr ) 
        body.sub( str_addr,  str_addr ,  1 ) 
        body.cmp( number ,  0 )
        body.callne( utoa_function  )
        return utoa_function
      end

      # testing method, hand coded fibo, expects arg in 1 
      # result comes in 7
      # a hand coded version of the fibonachi numbers
      #  not my hand off course, found in the net from a basic introduction
      def fibo context
        fibo_function = Vm::Function.new(:fibo , Vm::Integer , [] , Vm::Integer )
        result = fibo_function.return_type
        int = fibo_function.receiver
        count = fibo_function.new_local
        f1 = fibo_function.new_local
        f2 = fibo_function.new_local
        body = fibo_function.body
        
        body.cmp  int , 1
        body.mov( result, int , condition_code: :le)
        body.mov( :pc , :lr , condition_code: :le)
        body.push [  count , f1 , f2 , :lr]
        body.mov f1 , 1
        body.mov f2 , 0
        body.sub count , int , 2 

        l = fibo_function.body.new_block("loop")
        
        l.add f1 , f1 , f2
        l.sub f2 , f1 , f2
        l.sub count ,  count , 1 , set_update_status: 1
        l.bpl( l )
        l.mov( result , f1 )
        fibo_function.set_return result
        l.pop [ count , f1 , f2 , :pc]
        fibo_function
      end

    end
    
    extend ClassMethods
  end
end