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

    def assemble_all( io )
      self.each {|ins| ins.assemble(io)}
    end

    def assemble io
    end

    def total_byte_length
      ret = 0
      self.each{|ins| ret += ins.byte_length}
      ret
    end

    # labels have the same position as their next
    def set_position( position , count = 0)
      Positioned.set_position(self,position)
      self.next.set_position(position,count) if self.next
    end

    # shame we need this, just for logging
    def byte_length
      0
    end
    alias :padded_length  :byte_length
  end

  def self.label( source , name , nekst = nil)
    Label.new( source , name , nekst = nil)
  end
end
