module Asm
  class StringLiteral
    def initialize(str)
      #align
      length = str.length 
      # rounding up to the next 4 (always adding one for zero pad)
      pad =  ((length / 4 ) + 1 ) * 4 - length
      raise "#{pad} #{self}" unless pad >= 1
      @string = str + "\x00" * pad 
    end
    
    def position
      throw "Not set" unless @address
      @address 
    end
    def at address
      @address = address
    end
    def length
      @string.length
    end
    def assemble(io, as)
      io << @string
    end
  end
end