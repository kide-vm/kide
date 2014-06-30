module Vm
  class Reference < Value

    def initialize clazz = nil
      @clazz = clazz
    end
    attr_accessor :clazz

    def at_index block , left , right
      block.ldr( self , left , right )
      self
    end

  end
end
