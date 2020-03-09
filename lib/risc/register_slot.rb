module Risc

  # A RegisterSlot is a description of a slot into an object in a register.
  #
  # In many ways, it is like a variable in programming it can be a value, or it
  # can be assigned a value. An l-value or r-value, and since we don't know at
  # the time they are created (because of the dsl nature) we delay.
  #
  # RegisterSlots are created trough the array operator on a register.
  # ie message[:caller], and this can either be further indexed, assigned
  # something or assigned to something. So we overload those operators here.
  #
  # Ultimately SlotToReg or RegToSlot instructions are created for the l-value
  # or r-vlalue respectively.

  class RegisterSlot
    attr_reader :register , :index , :compiler

    def initialize(register, index , compiler)
      @register , @index , @compiler = register , index , compiler
    end

    # fullfil the objects purpose by creating a RegToSlot instruction from
    # itself (the slot) and the register given
    def <<( reg )
      case reg
      when RegisterValue
        to_mem("#{reg.class_name} -> #{register.class_name}[#{index}]" , reg)
      when RegisterSlot
        reg = to_reg()
        to_mem("#{reg.class_name} -> #{register.class_name}[#{index}]" , reg)
      else
        raise "not reg value or slot #{reg}"
      end
    end

    # for chaining the array operator is defined here too.
    # It basically reduces the slot to a register and applies the [] on that reg.
    # thus returning a new RegisterSlot.
    # Example: message[:caller][:next_message]
    #     message[:caller] returns a RegisterSlot, which would be self for this example
    #    to evaluate self[:next_message] we reduce self to a register with to_reg
    def []( index )
      reg = to_reg()
      reg[index]
    end

    # push the given register into the slot that self represents
    # ie create a slot_to_reg instruction and add to the compiler
    # the register represents and "array", and the content of the
    # given register from, is pushed to the memory at register[index]
    def to_mem( source , from )
      reg_to_slot = Risc.reg_to_slot(source , from , register, index)
      compiler.add_code(reg_to_slot) if compiler
      reg_to_slot.register
    end

    # load the conntent of the slot that self descibes into a a new register.
    # the register is created, and the slot_to_reg instruction added to the
    # compiler. the return is a bit like @register[@index]
    def to_reg()
      source = "reduce #{@register.symbol}[@index]"
      slot_to_reg = Risc.slot_to_reg(source , register, index)
      if compiler
        compiler.add_code(slot_to_reg)
        slot_to_reg.register.set_compiler(compiler)
      end
      slot_to_reg.register
    end

    # similar to above (<< which produces reg_to_slot), this produces reg_to_byte
    # from itself (the slot) and the register given
    def <=( reg )
      raise "not reg #{reg}" unless reg.is_a?(RegisterValue)
      raise "Index must be register #{index}" unless(index.is_a?(RegisterValue))
      reg_to_byte = Risc.reg_to_byte("#{reg.class_name} -> #{register.class_name}[#{index}]" , reg , register, index)
      compiler.add_code(reg_to_byte) if compiler
      reg_to_byte
    end

  end
end
