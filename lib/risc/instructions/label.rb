module Risc

  # A label is a placeholder for it's next Instruction
  # It's function is not to turn into code, but to be a valid branch target
  # Labels have the same position as their next instruction (See positioning code)
  #
  # So branches and Labels are pairs, fan out, fan in
  #
  # For a return, the address (position) of the label has to be loaded.
  # So a Label carries the ReturnAddress constant that holds the address (it's own
  # position, again see positioning code).
  # But currently the label is used in the Risc abstraction layer, and in the
  # arm/interpreter layer. The integer is only used in the lower layer, but needs
  # to be created (and positioned)

  class Label < Instruction
    # See class description. also factory method Risc.label below
    def initialize( source , name , addr , nekst = nil)
      super(source , nekst)
      @name = name
      @address = addr
      raise "Not address #{addr}" unless addr.is_a?(Parfait::ReturnAddress)
    end
    attr_reader :name , :address

    def to_cpu(translator)
      @cpu_label ||= super
    end

    def to_s
      class_source "#{@name} (next: #{self.next.class.name.split("::").last})"
    end

    def rxf_reference_name
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

    # shame we need this, just for logging
    def byte_length
      0
    end
    alias :padded_length  :byte_length
  end

  # Labels carry what is esentially an integer constant
  # The int holds the labels position for use at runtime (return address)
  # An integer is plucked from object_space abd added to the machine constant pool
  # if none was given
  def self.label( source , name , position = nil , nekst = nil)
    position = Risc.machine.get_address unless position
    Label.new( source , name , position, nekst )
  end
end
