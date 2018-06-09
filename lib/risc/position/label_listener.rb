module Risc

  # LabelListener is the one point that connects the BinaryCode
  # and Instruction positions.
  #
  # LabelListener is instantiated with the first label of a Method
  # and attached to the first BinaryCode.
  #
  # When the code moves, the label position is updated.
  #
  # The first code may get pushed by a previous method, and there is otherwise
  # no way to react to this.
  class LabelListener

    attr_reader :label

    # initialize with the first label of the method
    def initialize(label)
      @label = label
    end


    # The incoming position is the first BinaryCode of the method
    # We simply position the Label (instance, see initialize) as the
    # first entry in the BinaryCode, at BinaryCode.byte_offset
    def position_changed(position)
      label_pos = Position.get(@label)
      label_pos.set(position + Parfait::BinaryCode.byte_offset)
    end

    # don't react to insertion, as the CodeListener will take care
    def position_inserted(position)
    end

    # dont react, as we do the work in position_changed
    def position_changing(position , to)
    end
  end
end
