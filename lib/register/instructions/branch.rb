module Register


  # a branch must branch to a block.
  class Branch < Instruction
    def initialize source , to
      super(source)
      raise "No block" unless to
      @block = to
    end
    attr_reader :block 

    def to_s
      "Branch(to: #{block.name})"
    end

  end

end
