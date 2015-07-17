module Register


  # a branch must branch to a block.
  class Branch < Instruction
    def initialize to
      raise "No block" unless to
      @block = to
    end
    attr_reader :block
  end
end
