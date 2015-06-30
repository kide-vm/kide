module Register

  # GetSlot moves data into a register from memory.
  # SetSlot moves data into memory from a register.
  # Both use a base memory (a register)

  # While the virtual machine has only one instruction (Set) to move data between slots,
  # the register has two, namely GetSlot and SetSlot
  #
  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of GetSlot setting the value in the array.

  # btw: to move data between registers, use RegisterTransfer

  class GetSlot < Instruction

    # If you had a c array and index offset
    # the instruction would do register = array[index]
    # The arguments are in the order that makes sense for the Instruciton name
    # So GetSlot means the slot (array and index) moves to the register (last argument)
    def initialize array , index , register
      @register = register
      @array = array
      @index = index
      raise "not integer #{index}" unless index.is_a? Numeric
      raise "Not register #{register}" unless Register::RegisterReference.look_like_reg(register)
      raise "Not register #{array}" unless Register::RegisterReference.look_like_reg(array)
    end
    attr_accessor :register , :array , :index
  end

  # Produce a GetSlot instruction.
  # From and to are registers or symbols that can be transformed to a register by resolve_to_register
  # index resolves with resolve_index.
  def self.get_slot from , index , to
    index = resolve_index( from , index)
    from = resolve_to_register from
    to = resolve_to_register to
    GetSlot.new( from , index , to)
  end

end
