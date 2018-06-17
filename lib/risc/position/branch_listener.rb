module Risc

  class BranchListener

    # initialize with the instruction listener
    def initialize(branch)
      @branch = branch
    end

    # incoming position is the labels
    def position_changed(position)
      @branch.precheck
    end

    # don't react to insertion, as the CodeListener will take care
    def position_inserted(position)
    end

    # dont react, as we do the work in position_changed
    def position_changing(position , to)
    end
  end
end
