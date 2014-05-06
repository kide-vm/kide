module Core
  class Kernel
    
    #there are no Kernel instances, only class methods.
    # We use this module syntax to avoid the (ugly) self (also eases searching).
    module ClassMethods
      def main_start
        #TODO extract args into array of strings
        Vm::Machine.instance.main_start
      end
      def main_exit
        # Machine.exit mov r7 , 0  + swi 0 
        Vm::Machine.instance.main_exit
      end
      def function_entry f_name
        Vm::Machine.instance.function_entry f_name
      end
      def function_exit f_name
        Vm::Machine.instance.function_exit f_name
      end
      def putstring
        # should unwrap from string to char*
        Vm::Machine.instance.putstring 
      end
    end
    
    extend ClassMethods
  end
end