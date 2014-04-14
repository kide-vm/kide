module Asm
  class AssemblyError < StandardError
    def initialize(message, node)
      super(message)

      @node = node
    end
    attr_reader :node
  end
  
end
  