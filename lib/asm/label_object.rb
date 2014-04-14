module Asm
  
  class LabelObject
    def initialize
      @address = nil
      @extern = false
    end
    attr_writer :address

    def address
      return 0 if extern?

      if (@address.nil?)
        raise 'Tried to use label object that has not been set'
      end
      @address
    end

    def assemble(io, as)
      self.address = io.tell
    end

    def extern?
      @extern
    end

    def extern!
      @extern = true
    end
  end

end