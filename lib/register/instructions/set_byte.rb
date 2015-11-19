module Register

  # SetByte moves a byte into memory from a register.

  # indexes are 1 based !

  class SetByte < Instruction

    # If you had a c array (off int8) and index offset (>0)
    # the instruction would do array[index] = register
    # So SetByte means the register (first argument) moves to the slot (array and index)
    def initialize source , register , array , index
      super(source)
      @register = register
      @array = array
      @index = index
      raise "index 0 " if index == 0
      raise "Not integer or reg #{index}" unless index.is_a?(Numeric) or RegisterValue.look_like_reg(index)
      raise "Not register #{register}" unless RegisterValue.look_like_reg(register)
      raise "Not register #{array}" unless RegisterValue.look_like_reg(array)
    end
    attr_accessor :register , :array , :index
    def to_s
      "SetByte: #{register} -> #{array} [#{index}]"
    end

  end

  # Produce a SetByte instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  def self.set_byte source , from , to , index
    from = resolve_to_register from
    index = resolve_index( to , index)
    to = resolve_to_register to
    SetByte.new( source, from , to , index)
  end

end
