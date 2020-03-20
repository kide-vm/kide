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
      @release_points = Hash.new {|hash , key | hash[key] = [] }
      @reg_names = platform.register_names
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
        names.each {|name| release_after(pointer, name)}
        pointer = pointer.next
      end
    end

    # if the instruction has a release point with the given name, release it
    # Release points store the last use of a register (in ssa)
    # This method is called after machine registers have been assigned,
    # and give us the chance to reclaim any unsued machine regs
    # (via the precalculated release_points)
    def release_after(instruction , ssa_name)
      #puts "release request for #{ssa_name}"
      release = @release_points[instruction]
      return unless release
      return unless release.include?(ssa_name)
      #puts "ReleasePoint #{ssa_name} for #{instruction} #{release}"
      pois = reverse_used(ssa_name)
      release_reg( pois ) if pois
    end

    def assign(instruction)
      names = instruction.register_names
      #puts "AT #{instruction}"
      names.each do |ssa_name|
        # BUG: clearly we do NOT do ssa, because some of the instances of
        # RegisterValue are the same. This causes the symbols/names to
        # have changed through the previous assign. Hence without next line check
        # we assign risc regs to risc reg names. Easily avoided, but not clean
        next if @reg_names.include?(ssa_name)
        new_reg = get_reg(ssa_name)
        instruction.set_registers( ssa_name , new_reg)
        #puts "Assign #{new_reg} for #{ssa_name}"
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
      #puts "Walking #{instruction}"
      instruction.register_names.each do |ssa_name|
        next if released.include?(ssa_name)
        @release_points[instruction] << ssa_name
        #puts "ADDING #{ssa_name}"
        released << ssa_name
      end
      released
    end

    # use the given reg (first) parameter and mark it as assigned to
    # it's ssa form, the second parameter.
    # forward check is trivial, and reverse_used provides reverse check
    def use_reg(reg , ssa_name)
      reg = reg.symbol if reg.is_a?(RegisterValue)
      raise "Stupid error #{reg}" unless reg.is_a?(Symbol)
      #puts "Using #{reg} for #{ssa_name}"
      @used_regs[reg] = ssa_name
      reg
    end

    # Check whether a register has been assigned to the given ssa form given.
    # Ie a reverse check on the used_regs hash
    def reverse_used( ssa_name )
      @used_regs.each {|reg,name| return reg if ssa_name == name }
      return nil
    end

    # if a register has been assigned to the given ssa name, return that
    #
    # otherwise find the first free register by going through the available names
    # and checking if it is used
    def get_reg(ssa_name)
      name = reverse_used( ssa_name )
      return name if name
      get_next_free(ssa_name)
    end

    def get_next_free(ssa_name)
      reg = platform.assign_reg?( ssa_name )
      return use_reg(reg , ssa_name) if reg
      @reg_names.each do |name|
        return use_reg(name , ssa_name) unless @used_regs.has_key?(name)
      end
      raise "No more registers #{self}"
    end

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg( reg )
      reg = reg.symbol if reg.is_a?(RegisterValue)
      raise "not symbol #{reg}:#{reg.class}" unless reg.is_a?(Symbol)
      #puts "Releasing #{reg} "
      @used_regs.delete(reg)
    end

  end
end
