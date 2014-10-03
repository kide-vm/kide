module Register

  class Instruction

    # returns an array of registers (RegisterReferences) that this instruction uses.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r2,r3]
    # for pushes the list may be longer, whereas for a jump empty
    def uses
      raise "abstract called for #{self.class}"
    end
    # returns an array of registers (RegisterReferences) that this instruction assigns to.
    # ie for r1 = r2 + r3 
    # which in assembler is add r1 , r2 , r3
    # it would return [r1]
    # for most instruction this is one, but comparisons and jumps 0 , and pop's as long as 16
    def assigns
      raise "abstract called for #{self.class}"
    end
    def method_missing name , *args , &block 
      return super unless (args.length <= 1) or block_given?
      set , attribute = name.to_s.split("set_")
      if set == ""
        @attributes[attribute.to_sym] = args[0] || 1
        return self 
      else
        return super
      end
      return @attributes[name.to_sym]
    end
  end
  
end
