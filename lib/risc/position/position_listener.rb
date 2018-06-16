
module Risc

  # Listeners localise the changes that need to happen.
  #
  # An object listener assmes it is set up to the previous object.
  # so when position changes, it places itself just behind the previous object
  #
  # This is handy, since the "normal" chaining of object is forward
  # But the dependencies are backwards. This way we don't clutter the
  # actual object (or even the position), but keep the logic seperate.
  class PositionListener

    # initialize with the object that needs to react to change
    def initialize(object)
      @object = object
    end

    def position_changing(position , to)
    end

    # when the argument changes position, we update the next objects
    # position to reflect that change
    #
    def position_changed(previous)
      add = previous.object ? previous.object.padded_length : 0
      next_at = previous.at + add
      next_pos = Position.get(@object)
      next_pos.set(next_at)
    end
  end
end
