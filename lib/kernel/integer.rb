#integer related kernel functions
module Crystal
  module Kernel
    # The conversion to base10 is quite a bit more complicated than i thought. The bulk of it is in div10
    # We set up variables, do the devision and write the result to the string
    # then check if were done and recurse if neccessary
    # As we write before we recurse (save a push) we write the number backwards
    # arguments: string address , integer
    def self.utoa context
      utoa_function = Virtual::Function.new(:utoa , Virtual::Integer , [ Virtual::Integer ] , Virtual::Integer )
      str_addr = utoa_function.receiver
      number = utoa_function.args.first
      remainder = utoa_function.new_local
      Virtual::RegisterMachine.instance.div10( utoa_function , number  , remainder )
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

    def self.putint context
      putint_function = Virtual::Function.new(:putint , Virtual::Integer , [] , Virtual::Integer )
      buffer = Virtual::StringConstant.new("           ") # create a buffer
      context.object_space.add_object buffer              # and save it (function local variable: a no no)
      int = putint_function.receiver
      moved_int = putint_function.new_local
      utoa = context.object_space.get_or_create_class(:Object).resolve_function(:utoa)
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
      Virtual::RegisterMachine.instance.write_stdout(putint_function)
      putint_function
    end

    # testing method, hand coded fibo, expects arg in receiver_register 
    # result comes in return_register
    # a hand coded version of the fibonachi numbers
    # not my hand off course, found in the net http://www.peter-cockerell.net/aalp/html/ch-5.html
    def self.fibo context
      fibo_function = Virtual::Function.new(:fibo , Virtual::Integer , [] , Virtual::Integer )
      result = fibo_function.return_type
      int = fibo_function.receiver
    
      last = fibo_function.new_block("return")
    
      f1 = fibo_function.new_local
      f2 = fibo_function.new_local
    
      fibo_function.instance_eval do
        cmp  int , 1
        mov( result, int , condition_code: :le)
        ble( last ) #branch to return, rather than return (as the original)
        mov f1 , 1        #set up initial values
        mov f2 , 0
      end

      loop = fibo_function.new_block("loop")
      fibo_function.insert_at loop
    
      fibo_function.instance_eval do #loop through 
        add f1 , f1 , f2             # f1 = f1 + f2
        sub f2 , f1 , f2             # f2 = f1 -f2
        sub int ,  int , 1  # todo: set.. should do below cmp, but doesn't , set_update_status: 1
        cmp int , 1
        bne( loop )
        mov( result , f1 )
      end
    
      fibo_function
    end

  end
end