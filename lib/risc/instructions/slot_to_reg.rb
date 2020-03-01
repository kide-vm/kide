module Risc

  # SlotToReg moves data into a register from memory.
  # RegToSlot moves data into memory from a register.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of SlotToReg setting the value in the array.

  # btw: to move data between registers, use Transfer

  class SlotToReg < Getter

  end

  # Produce a SlotToReg instruction.
  # Array is a register
  # index may be a Symbol in which case is resolves with resolve_index.
  # a new regsister will be created as the result, ie the reg part for slot_to_reg
  def self.slot_to_reg( source , array , index )
    raise "Register #{array}" if RegisterValue.look_like_reg(array.symbol)
    new_name = "#{array.symbol}.#{index.to_s.downcase}".to_sym
    index = array.resolve_index(index) if index.is_a?(Symbol)
    type = array.type_at(index)
    #puts "Slot for #{array.symbol}@ index #{index} is #{type}"
    to = RegisterValue.new( new_name , type )
    SlotToReg.new( source , array , index , to)
  end
end
