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
        # should be another level of indirection, ie write(io,str)
        ret = Vm::CMachine.instance.integer_to_s(block , buffer)
        function.return_type = ret
        function
      end
    end
    
    extend ClassMethods
  end
end