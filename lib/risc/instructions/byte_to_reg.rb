module Risc

  # ByteToReg moves a single byte into a register from memory.

  # indexes are 1 based (as for slots) , which means we sacrifice a byte of every word
  #        for our sanity

  class ByteToReg < Getter

  end

  # Produce a ByteToReg instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  def self.byte_to_reg( source , array , index , to)
     ByteToReg.new( source , array , index , to)
  end
end
