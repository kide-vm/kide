module Vm
  class Reference < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initialize reg , clazz = nil
      super(reg)
      @clazz = clazz
    end
    attr_accessor :clazz

  end
end
