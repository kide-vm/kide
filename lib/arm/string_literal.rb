require "vm/code"

module Arm
  # The name really says it all.
  # The only interesting thing is storage.
  # Currently string are stored "inline" , ie in the code segment. 
  # Mainly because that works an i aint no elf expert.
  
  class StringLiteral < Vm::Code
    
    # currently aligned to 4 (ie padded with 0) and off course 0 at the end
    def initialize(str)
      length = str.length 
      # rounding up to the next 4 (always adding one for zero pad)
      pad =  ((length / 4 ) + 1 ) * 4 - length
      raise "#{pad} #{self}" unless pad >= 1
      @string = str + "\x00" * pad 
    end
    
    # the strings length plus padding
    def length
      @string.length
    end
    
    # just writing the string
    def assemble(io)
      io << @string
    end
  end
end