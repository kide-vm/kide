module Risc

  # A label is a placeholder for it's next Instruction
  # It's function is not to turn into code, but to be a valid brnch target
  #
  # So branches and Labels are pairs, fan out, fan in
  #
  #

  class Label < Instruction
    def initialize( source , name , nekst = nil)
      super(source , nekst)
      @name = name
    end
    attr_reader :name

    def to_cpu(translator)
      @cpu_label ||= super
    end

    def to_s
      class_source "#{@name} (next: #{self.next.class.name.split("::").last})"
    end

    def sof_reference_name
      @name
    end

    # a method start has a label of the form Class.method , test for that
    def is_method
      @name.split(".").length == 2
    end

    def to_arr labels = []
      return [] if labels.include?(self)
      labels << self
      super
    end

    def length labels = []
      return 0 if labels.include?(self)
      labels << self
      ret = 1
      ret += self.next.length(labels) if self.next
      ret
    end

    def assemble io
    end

    def assemble_all io , labels = []
      return if labels.include?(self) or self.next.nil?
      labels << self
      self.next.assemble_all(io,labels)
    end

    def total_byte_length labels = []
      return 0 if labels.include?(self) or self.next.nil?
      labels << self
      ret = self.next.total_byte_length(labels)
      #puts "#{self.class.name} return #{ret}"
      ret
    end

    # labels have the same position as their next
    def set_position position , labels = []
      return position if labels.include?(self)
      labels << self
      super(position , labels)
      self.next.set_position(position,labels) if self.next
    end

    # shame we need this, just for logging
    def byte_length
      0
    end

    def each_label labels =[] , &block
      return if labels.include?(self)
      labels << self
      block.yield(self)
      super
    end
  end

  def self.label( source , name , nekst = nil)
    Label.new( source , name , nekst = nil)
  end
end
