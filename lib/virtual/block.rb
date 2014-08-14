require_relative "object"

module Virtual
  
  # Think flowcharts: blocks are the boxes. The smallest unit of linear code
  
  # Blocks must end in control instructions (jump/call/return). 
  # And the only valid argument for a jump is a Block 
  
  # Blocks form a graph, which is managed by the method
  
  class Block < Virtual::Object

    def initialize(name , method )
      super()
      @method = method
      @name = name.to_sym
      @branch = nil
      @codes = []
    end

    def attributes
      [:name  , :codes , :branch]
    end

    attr_reader :name , :codes , :method
    attr_accessor :branch
    
    def reachable ret = []
      add_next ret
      add_branch ret
      ret
    end

    def add_code kode
      @codes << kode
      self
    end

    # returns if this is a block that ends in a call (and thus needs local variable handling)
    def call_block?
      return false unless codes.last.is_a?(CallInstruction)
      return false unless codes.last.opcode == :call
      codes.dup.reverse.find{ |c| c.is_a? StackInstruction }
    end

    private
    # helper for determining reachable blocks 
    def add_next ret
      return if @next.nil?
      return if ret.include? @next
      ret << @next
      @next.reachable ret
    end
    # helper for determining reachable blocks 
    def add_branch ret
      return if @branch.nil?
      return if ret.include? @branch
      ret << @branch
      @branch.reachable ret
    end
  end
end