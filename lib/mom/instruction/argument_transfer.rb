module Mom

  # Transering the arguments from the current frame into the next frame
  #
  # This could be _done_ at this level, and in fact used to be.
  # The instructions was introduced to
  # 1. make optimisations easier
  # 2. localise the inevitable change
  #
  # 1. The optimal implementation for this loads old and new frames into registers
  #    and does a whole bunch of transfers
  #    But if we do individual SlotMoves here, each one has to load the frames,
  #    thus making advanced analysis/optimisation neccessary to achieve the same effect.
  #
  # 2. Closures will have to have access to variables after the frame goes out of scope
  #   and in fact be able to change the parents variables. This design does not allow for
  #   this, and so will have to be change in the not so distant future.
  #
  class ArgumentTransfer < Instruction

    attr_reader :receiver , :arguments

    def initialize( receiver,arguments )
      @receiver , @arguments = receiver , arguments
    end

    def to_risc(context)
      Risc::Label.new(self,"ArgumentTransfer")
    end
  end


end
