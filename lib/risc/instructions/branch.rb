module Risc

  # A branch must branch to a label.
  # Different Branches (derived classes) use different registers, the base
  # just stores the Label
  class Branch < Instruction
    def initialize( source , label )
      super(source)
      @label = label
    end
    attr_reader :label

    def to_s
      "#{self.class.name.split("::").last}: #{label ? label.name : ''}"
    end
    alias :inspect :to_s

    def length( labels = [])
      ret = super(labels)
      ret += self.label.length(labels) if self.label
      ret
    end

    def to_arr( labels = [] )
      ret = super(labels)
      ret += self.label.to_arr(labels) if self.label
      ret
    end

    def total_byte_length labels = []
      ret = super(labels)
      ret += self.label.total_byte_length(labels) if self.label
      #puts "#{self.class.name} return #{ret}"
      ret
    end

    # labels have the same position as their next
    def set_position( position , labels = [])
      set_position self.label.set_position( position , labels ) if self.label
      super(position,labels)
    end

    def assemble_all( io , labels = [])
      self.assemble(io)
      self.label.assemble_all(io,labels) if self.label
      self.next.assemble_all(io, labels) if self.next
    end

    def each_label( labels =[] , &block)
      super
      self.label.each_label(labels , &block) if self.label
    end

  end

  # branch if two registers contain same value
  class IsSame < Branch
    attr_reader :left , :right
    def initialize(source , left , right , label)
      super(source , label)
    end
  end

  class Unconditional < Branch

  end

  class IsZero < Branch
  end

  class IsNotzero < Branch
  end

  class IsMinus < Branch
  end

  class IsPlus < Branch
  end

end
