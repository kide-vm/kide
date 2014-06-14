module Crystal
  module Kernel
    def self.putstring context 
      function = Vm::Function.new(:putstring , Vm::Reference , [] )
      ret = Vm::RegisterMachine.instance.write_stdout(function)
      function.set_return ret
      function
    end
  end
end
