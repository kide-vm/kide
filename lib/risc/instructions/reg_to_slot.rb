module Risc

  # RegToSlot moves data into memory from a register.
  # SlotToReg moves data into a register from memory.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  # an element in an array, in the case of RegToSlot setting the register in the array.

  # btw: to move data between registers, use Transfer

  class RegToSlot < Setter

  end

  # Produce a RegToSlot instruction.
  # From and to are registers
  # index may be a Symbol in which case is resolves with resolve_index.
  #
  # The slot is ultimately a memory location, so no new register is created
  def self.reg_to_slot( source , from , to , index )
    raise "Not register #{to}" unless RegisterValue.look_like_reg(to)
    index = to.resolve_index(index) if index.is_a?(Symbol)
    RegToSlot.new( source, from , to , index)
  end

end
