module Risc
  #
  # StandardAllocator keeps a list of registers whole names it accuires from the
  # Plaform.
  #
  # It allocates registers by going throught the instructions and dishing
  # out sequential registers.
  # Before doing that it determines live ranges, so registers can be returned
  # when not used anymore, and thus reused.
  class StandardAllocator

    def initialize( compiler , platform)
      @compiler = compiler
      @platform = platform
      @used_regs = {}
      reset_used_regs
    end
    attr_reader :used_regs , :compiler , :platform

    def used_regs_empty?
      @used_regs.empty?
    end

    def use_reg(reg)
      raise "not reg #{reg.class}" unless reg.is_a?(RegisterValue)
      @used_regs[reg.symbol] = reg
    end

    #
    def release_reg(reg)
      @used_regs.pop
    end

    def clear_used_regs
      @used_regs.clear
    end

    #helper method to calculate with register symbols
    def next_reg_use( type , extra = {} )
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 11
      sym = "r#{int + 1}".to_sym
      RegisterValue.new( sym , type, extra)
    end

    def copy( reg , source )
      copied = use_reg reg.type
      add_code Register.transfer( source , reg , copied )
      copied
    end

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg( reg )
      reg = reg.symbol if reg.is_a?(RegisterValue)
      raise "not symbol #{reg}:#{reg.class}" unless reg.is_a?(Symbol)
      @used_regs.delete(reg)
    end

    # reset the registers to be used. Start at r4 for next usage.
    # Every statement starts with this, meaning each statement may use all registers, but none
    # get saved. Statements have affect on objects.
    def reset_used_regs
      @used_regs.clear
    end

  end
end
