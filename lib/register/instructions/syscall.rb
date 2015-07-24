module Register

  # name says it all really
  # only arg is the method syscall name
  # how the layer below executes these is really up to it

  # Any function issuing a Syscall should also save the current message
  # and restore it after the syscall, saving the return value in Return_index

  class Syscall < Instruction

    def initialize name
      @name = name
    end
    attr_reader :name

    def to_s
      "Syscall(#{name})"
    end

  end
end
