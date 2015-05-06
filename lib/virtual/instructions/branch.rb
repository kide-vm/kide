module Virtual


  # a branch must branch to a block. This is an abstract class, names indicate the actual test
  class Branch < Instruction
    def initialize to
      @to = to
    end
    attr_reader :to
  end
end

require_relative "is_true_branch"
require_relative "unconditional_branch"
