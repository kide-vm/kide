module Core
  class Kernel
    
    #there are no Kernel instances, only class methods.
    # We use this module syntax to avoid the (ugly) self (also eases searching).
    module ClassMethods
      def main_start
        #TODO extract args into array of strings
        Vm::CMachine.instance.main_start
      end
      def main_exit
        # Machine.exit mov r7 , 0  + swi 0 
        Vm::CMachine.instance.main_exit
      end
      def function_entry f_name
        Vm::CMachine.instance.function_entry f_name
      end
      def function_exit f_name
        Vm::CMachine.instance.function_exit f_name
      end
      def putstring
        # should unwrap from string to char*
        Vm::CMachine.instance.putstring 
      end
    end
    
    extend ClassMethods
  end
end