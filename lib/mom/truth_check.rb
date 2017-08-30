module Mom

  # The funny thing about the ruby truth is that is is anything but false or nil
  #
  # To implement the normal ruby logic, we check for false or nil and jump
  # to the false branch. true_block follows implicitly
  #
  # The class only carries the blocks for analysis, and does
  #  - NOT imply any order
  # - will not "handle" the blocks in subsequent processing.
  #
  class TruthCheck < Instruction
    attr_reader :condition , :true_block , :false_block , :merge_block

    def initialize(condition , true_block , false_block , merge_block)
      @condition , @true_block , @false_block , @merge_block = condition , true_block , false_block , merge_block
    end
  end


end
