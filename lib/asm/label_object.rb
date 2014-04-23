module Asm
  
  class LabelObject
    def initialize
      @address = nil
    end
    attr_writer :address

    def address
      if (@address.nil?)
        raise 'Tried to use label object that has not been set'
      end
      @address
    end

    def assemble(io, as)
      self.address = io.tell
    end

  end

end