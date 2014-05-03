require_relative "values"

module Vm
  
  # Think flowcharts: blocks are the boxes. The smallest unit of linear code
  
  # Blocks must end in control instructions (jump/call/return). 
  # And the only valid argument for a jump is a Block 
  
  # Blocks for a double linked list so one can traverse back and forth
  
  # There are four ways for a block to get data (to work on)
  # - hard coded constants (embedded in code)
  # - memory move
  # - values passed in (from previous blocks. ie local variables)

  # See Value description on how to create code/instructions
  
  class Block < Value

    def initialize(name)
      super()
      @name = name.to_sym
    end

    attr_reader :name

    def verify
      raise "Empty #{self.inspect}" if @values.empty?
    end
    private 
    
    # possibly misguided ??
    def add_arg value
      # TODO check
      @args << value
    end

  end

end