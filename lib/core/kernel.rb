module Core
  class Kernel
    
    #there are no Kernel instances, only class methods.
    # We use this module syntax to avoid the (ugly) self (also eases searching).
    module ClassMethods

      def putstring context 
        function = Vm::Function.new(:putstring , Vm::Integer , [] )
        ret = Vm::RegisterMachine.instance.write_stdout(function)
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
        putint_function.instance_eval do
          mov( moved_int ,  int )     # move arg up
          add( int ,  buffer ,nil )   # string to write to (add string address to pc)
          add( int , int ,  buffer.length - 3) # 3 for good measure , ahem.
          call( utoa )
          after = new_block("after_call")
          insert_at after
          # And now we "just" have to print it, using the write_stdout
          add( int ,  buffer , nil )   # string to write to
          mov( moved_int ,  buffer.length )
        end
        Vm::RegisterMachine.instance.write_stdout(putint_function)
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
        Vm::RegisterMachine.instance.div10( utoa_function , number  , remainder )
        # make char out of digit (by using ascii encoding) 48 == "0"
        utoa_function.instance_eval do
          add(  remainder , remainder , 48)
          strb( remainder, str_addr ) 
          sub(  str_addr,  str_addr ,  1 ) 
          cmp(  number ,  0 )
          callne( utoa_function  )
        end
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
        fibo_function.instance_eval do
        
          cmp  int , 1
          mov( result, int , condition_code: :le)
          mov( :pc , :lr , condition_code: :le)
          push [  count , f1 , f2 , :lr]
          mov f1 , 1
          mov f2 , 0
          sub count , int , 2 
        end

        l = fibo_function.new_block("loop")
        fibo_function.insert_at l
        
        fibo_function.instance_eval do 
          add f1 , f1 , f2
          sub f2 , f1 , f2
          sub count ,  count , 1 , set_update_status: 1
          bpl( l )
          mov( result , f1 )
          pop [ count , f1 , f2 , :pc]
        end
        fibo_function.set_return result
        fibo_function
      end

    end
    
    extend ClassMethods
  end
end