module Asm
  class Relocation
    def initialize(pos, label, type, handler)
      @position = pos
      @label = label
      @type = type
      @handler = handler
    end
    attr_reader :position, :label, :type, :handler
  end
  
end