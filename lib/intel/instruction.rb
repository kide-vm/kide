module Intel
  ##
  # Instruction is an instruction shape that we're going to match to
  # Commands to find out what we should write in to memory.

  class Instruction
    attr_accessor :opcode, :machine, :parameters

    def initialize message, machine
      self.machine = machine
      self.opcode, *self.parameters = message
      self.opcode = opcode.to_s.upcase

      self.machine = parameters[1].machine unless machine

      self.parameters.map! { |each| Proc === each ? each.call.m : each }

      self.parameters.each do |each|
        each.machine = self.machine if each.is_a? Operand
      end
    end

    def first
      parameters.first
    end

    def second
      parameters.second
    end

    def get_address
      parameters.detect { |e| e.is_a?(Address) }
    end

    def assemble
      instructions = machine.instructions.select { |command|
        command.instruction_applies? self
      }

      return false if instructions.empty?

      bytes = instructions.map { |instruction| instruction.assemble self }

      sorted_bytes = bytes.sort_by {|byte| [byte.size, (byte[0]||0), (byte[1]||0)]}

      machine.stream.push(*sorted_bytes.first)

      true
    end

    def get_second_immediate
      parameters.detect { |e| e.is_a? Integer }
    end

    def get_immediate
      parameters.reverse.detect { |e| e.is_a? Integer }
    end
  end
end