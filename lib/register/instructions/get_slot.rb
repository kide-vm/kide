module Register

  # GetSlot moves data into a register from memory.
  # SetSlot moves data into memory from a register.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of GetSlot setting the value in the array.

  # btw: to move data between registers, use RegisterTransfer

  class GetSlot < Getter

    # If you had a c array and index offset
    # the instruction would do register = array[index]
    # The arguments are in the order that makes sense for the Instruction name
    # So GetSlot means the slot (array and index) moves to the register (last argument)
    # def initialize source , array , index , register
    #   super
    # end
    # attr_accessor :array , :index , :register

  end

  # Produce a GetSlot instruction.
  # Array and to are registers or symbols that can be transformed to a register by resolve_to_register
  # index resolves with resolve_index.
  def self.get_slot source , array , index , to
    index = resolve_index( array , index)
    array = resolve_to_register array
    to = resolve_to_register to
    GetSlot.new( source , array , index , to)
  end
end
