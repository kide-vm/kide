module Asm
  class DataObject
    def initialize(data)
      @data = data
    end
    
    def position
      throw "Not set" unless @address
      @address 
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