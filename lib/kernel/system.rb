module Crystal
  module Kernel
    def self.exit context
      function = Vm::Function.new(:exit , Vm::Integer , [] )
      ret = Vm::RegisterMachine.instance.exit(function)
      function.set_return ret
      function
    end
  end
end
