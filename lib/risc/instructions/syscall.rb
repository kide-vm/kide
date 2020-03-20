module Risc

  # name says it all really
  # only arg is the method syscall name
  # how the layer below executes these is really up to it

  # Any function issuing a Syscall should also save the current message
  # and restore it after the syscall, saving the return value in Return_index

  class Syscall < Instruction

    def initialize source ,name
      super(source)
      @name = name
      raise "must have name" unless name
    end
    attr_reader :name

    # return an array of names of registers that is used by the instruction
    def register_attributes
      []
    end

    def to_s
      class_source name
    end
  end

  # return the nth register that a sycall needs
  # these map to different physical registers in the Platform
  # first arg is (running 1..) integer, second (optional) type
  def self.syscall_reg( number , type = nil)
    type = :Integer unless type
    RegisterValue.new("syscall_#{number}".to_sym , type)
  end
end
