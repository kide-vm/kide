module Asm
  class DataObject
    def initialize(data)
      @data = data
    end
    
    def at address
      @address = address
    end
    def length
      @data.length
    end
    def assemble(io, as)
      io << @data
    end
  end
end