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
      @reg_names = (0 ... platform.num_registers).collect{|i| "r#{i-1}".to_sym }
    end
    attr_reader :used_regs , :compiler , :platform , :reg_names

    # main entry point and the whole reason for the class.
    # Allocate regs by changing the names of compiler instructions to
    # register names according to platform.
    # Ie on arm register names are r0 .. . r15 , so it keeps a list of unused
    # regs and frees regs according to live ranges
    def allocate_regs

    end

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

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg( reg )
      reg = reg.symbol if reg.is_a?(RegisterValue)
      raise "not symbol #{reg}:#{reg.class}" unless reg.is_a?(Symbol)
      @used_regs.delete(reg)
    end

  end
end
