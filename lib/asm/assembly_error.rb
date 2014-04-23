module Asm
  class AssemblyError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
  