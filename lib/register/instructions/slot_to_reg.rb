module Register

  # SlotToReg moves data into a register from memory.
  # RegToSlot moves data into memory from a register.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of SlotToReg setting the value in the array.

  # btw: to move data between registers, use RegisterTransfer

  class SlotToReg < Getter

    # If you had a c array and index offset
    # the instruction would do register = array[index]
    # The arguments are in the order that makes sense for the Instruction name
    # So SlotToReg means the slot (array and index) moves to the register (last argument)
    # def initialize source , array , index , register
    #   super
    # end
    # attr_accessor :array , :index , :register

  end

  # Produce a SlotToReg instruction.
  # Array and to are registers or symbols that can be transformed to a register by resolve_to_register
  # index resolves with resolve_index.
  def self.slot_to_reg source , array , index , to
    index = resolve_index( array , index)
    array = resolve_to_register array
    to = resolve_to_register to
    SlotToReg.new( source , array , index , to)
  end
end
