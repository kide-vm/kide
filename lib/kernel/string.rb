module Crystal
  module Kernel
    def self.putstring context 
      function = Virtual::MethodDefinition.new(:putstring , [] )
      return function
      ret = Virtual::RegisterMachine.instance.write_stdout(function)
      function.set_return ret
      function
    end
  end
end
