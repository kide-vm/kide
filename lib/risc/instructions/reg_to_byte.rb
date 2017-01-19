module Risc

  # RegToByte moves a byte into memory from a register.

  # indexes are 1 based !

  class RegToByte < Setter

  end

  # Produce a RegToByte instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  def self.reg_to_byte( source , from , to , index)
    from = resolve_to_register from
    index = resolve_to_index( to , index)
    to = resolve_to_register to
    RegToByte.new( source, from , to , index)
  end

end
