module Risc

  class BranchListener

    # initialize with the instruction listener
    def initialize(listener)
      @listener = listener
    end


    def position_changed(position)
    end

    # don't react to insertion, as the CodeListener will take care
    def position_inserted(position)
    end

    # dont react, as we do the work in position_changed
    def position_changing(position , to)
    end
  end
end
