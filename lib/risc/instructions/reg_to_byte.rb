module Risc

  # RegToByte moves a byte into memory from a register.

  # indexes are 1 based !

  class RegToByte < Setter

  end

  # Produce a RegToByte instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  def self.reg_to_byte( source , from , to , index)
    raise "Not register #{to}" unless RegisterValue.look_like_reg(to)
    index = to.resolve_index(index) if index.is_a?(Symbol)
    RegToByte.new( source, from , to , index)
  end

end
