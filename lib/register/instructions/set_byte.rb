module Register

  # SetByte moves a byte into memory from a register.

  # indexes are 1 based !

  class SetByte < Setter

    def to_s
      "SetByte: #{register} -> #{array} [#{index}]"
    end

  end

  # Produce a SetByte instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  # def self.set_byte source , from , to , index
  #   from = resolve_to_register from
  #   index = resolve_index( to , index)
  #   to = resolve_to_register to
  #   SetByte.new( source, from , to , index)
  # end

end
