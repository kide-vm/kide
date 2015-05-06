module Virtual

  # Get a instance variable by _name_ . So we have to resolve the name to an index to trnsform into a Slot
  # The slot may the be used in a set on left or right hand. The transformation is done by GetImplementation
  class InstanceGet < Instruction
    def initialize name
      @name = name.to_sym
    end
    attr_reader :name
  end
end
