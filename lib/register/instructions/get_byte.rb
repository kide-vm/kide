module Register

  # GetByte moves a single byte into a register from memory.

  # indexes are 1 based (as for slots) , which means we sacrifice a byte of every word
  #        for our sanity

  class GetByte < Getter

    # If you had a c array (of int8) and index offset
    # the instruction would do register = array[index]
    # The arguments are in the order that makes sense for the Instruction name
    # So SlotToReg means the slot (array and index) moves to the register (last argument)
    # def initialize source , array , index , register
    #   super
    # end
    # attr_accessor :array , :index , :register

  end

  # Produce a GetByte instruction.
  # from and to are translated (from symbol to register if neccessary)
  # but index is left as is.
  # def self.get_byte source , array , index , to
  #   from = resolve_to_register from
  #   to = resolve_to_register to
  #   GetByte.new( source , array , index , to)
  # end
end
