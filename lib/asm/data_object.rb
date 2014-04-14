module Asm
  class DataObject
    def initialize(data)
      @data = data
    end

    def assemble(io, as)
      io << @data
    end
  end
end