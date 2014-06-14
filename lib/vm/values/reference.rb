module Vm
  class Reference < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initialize reg
      super
    end

  end
end
