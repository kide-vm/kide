module Risc
  # just moved compilers register related stuff here
  #
  # Allocator keeps a list of registers and passes them out
  # upon request. they must be returned in order
  class Allocator

    def initialize( compiler , platform)
      @compiler = compiler
      @platform = platform
      @regs = []
      reset_regs
    end
    attr_reader :regs , :compiler , :platform

    def regs_empty?
      @regs.empty?
    end
    def add_reg(reg)
      raise "not reg #{reg.class}" unless reg.is_a?(RegisterValue)
      @regs << reg
    end
    def pop
      @regs.pop
    end
    def clear_regs
      @regs.clear
    end

    # require a (temporary) register. code must give this back with release_reg
    # Second extra parameter may give extra info about the value, see RegisterValue
    def use_reg( type , extra = {} )
      raise "Not type #{type.inspect}:#{type.class}" unless type.is_a?(Symbol) or type.is_a?(Parfait::Type)
      if @regs.empty?
        reg = Risc.tmp_reg(type , extra)
      else
        reg = @regs.last.next_reg_use(type , extra)
      end
      @regs << reg
      return reg
    end

    def copy( reg , source )
      copied = use_reg reg.type
      add_code Register.transfer( source , reg , copied )
      copied
    end

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg( reg )
      last = @regs.pop
      raise "released register in wrong order, expect #{last} but was #{reg}" if reg != last
    end

    # reset the registers to be used. Start at r4 for next usage.
    # Every statement starts with this, meaning each statement may use all registers, but none
    # get saved. Statements have affect on objects.
    def reset_regs
      @regs.clear
    end

  end
end
