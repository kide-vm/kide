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
    def initialize source , array , index , register
      super(source)
      @array = array
      @index = index
      @register = register
      raise "not integer #{index}" unless index.is_a? Numeric
      raise "Not register #{register}" unless Register::RegisterValue.look_like_reg(register)
      raise "Not register #{array}" unless Register::RegisterValue.look_like_reg(array)
    end
    attr_accessor :array , :index , :register

    def to_s
      "GetSlot: #{array} [#{index}] -> #{register}"
    end

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

  def self.get_slot_to source , slot , to
    array = nil
    index = nil
    case slot
    when Virtual::Self
      array = :message
      index = :receiver
    when Virtual::Return
      array = :message
      index = :return_value
    when Virtual::FrameSlot
      array = :frame
      index = slot.index
    when Virtual::ArgSlot
      array = :message
      index = slot.index
    else
      raise "not done #{slot}"
    end
    get_slot( source , array , index , to)
  end
end
