module Crystal
  module Kernel
    def self.exit context
      function = Virtual::Function.new(:exit , Virtual::Integer , [] )
      ret = Virtual::RegisterMachine.instance.exit(function)
      function.set_return ret
      function
    end
  end
end
