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
      @release_points = Hash.new( [] )
      @reg_names = (0 ... platform.num_registers).collect{|i| "r#{i}".to_sym }
    end
    attr_reader :used_regs , :compiler , :platform , :reg_names

    # main entry point and the whole reason for the class.
    # Allocate regs by changing the names of compiler instructions to
    # register names according to platform.
    # Ie on arm register names are r0 .. . r15 , so it keeps a list of unused
    # regs and frees regs according to live ranges
    def allocate_regs
      walk_and_mark(@compiler.risc_instructions)
      pointer = @compiler.risc_instructions
      while(pointer)
        names = assign(pointer)
        names.each {|name| release_reg(name)}
        pointer = pointer.next
      end
    end

    def assign(instruction)
      names = instruction.register_names
      names.each do |for_name|
        new_reg = get_reg(for_name)
        # swap name out
      end
      names
    end

    # determines when registers can be freed
    #
    # this is done by walking the instructions backwards and saving the first
    # occurence of a register name. (The last, as we walk backwards)
    #
    # First walk down, and on the way up mark register occurences, unless they
    # have been marked already
    def walk_and_mark(instruction)
      released = []
      released = walk_and_mark(instruction.next) if instruction.next
      #puts instruction.class.name
      instruction.register_names.each do |name|
        next if released.include?(name)
        @release_points[instruction] << name
        released << name
      end
      released
    end

    def used_regs_empty?
      @used_regs.empty?
    end

    def use_reg(reg , for_name)
      reg = reg.symbol if reg.is_a?(RegisterValue)
      raise "Stupid error #{reg}" unless reg.is_a?(Symbol)
      puts "Using #{reg} for #{for_name}"
      @used_regs[reg] = for_name
    end

    # if a register has been assigned to the given name, return that
    #
    # otherwise find the first free register by going through the available names
    # and checking if it is used
    def get_reg(for_name)
      @used_regs.each {|reg,name| return reg if for_name == name }
      @reg_names.each do |name|
        return use_reg(name , for_name) unless @used_regs.has_key?(name)
      end
      raise "No more registers #{self}"
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
