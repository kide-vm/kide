module Risc
  # A platform is (or will be) something like the linux tripple
  #
  # Currently it just provides a Translator and binary start point
  #
  class Platform

    # return the translator instance that traslates risc intructions into
    # platform specific ones
    def translator
      raise "not implemented in #{self.class}"
    end

    # return an integer where the binary is loaded
    def loaded_at
      raise "not implemented in #{self.class}"
    end

    # return an array of register names that should be used by the allocator
    # does not include :message
    # could be in interpreter and arm, but here for now
    def register_names
      (1 ... 16).collect{|i| "r#{i}".to_sym }
    end

    # return the Allocator for the platform
    # stanrard implementation return StandardAllocator, which uses
    # num_registers and assumes rXX naming (ie arm + interpreter)
    #
    # Possibility to override and implemented different schemes
    def allocator(compiler)
      StandardAllocator.new(compiler , self )
    end

    def assign_reg?(name)
      case name
      when :message
        :r0
      when :syscall_1
        :r0
      when :syscall_2
        :r1
      when :saved_message
        :r15
      else
        nil
      end
    end

    # Factory method to create a Platform object according to the platform
    # string given.
    # Currently only "Arm" and "Interpreter"
    def self.for( name )
      return name if name.is_a?(Platform)
      name = name.to_s.capitalize
      case name
      when "Arm"
        return Arm::ArmPlatform.new
      when "Interpreter"
        return Risc::InterpreterPlatform.new
      else
        raise "not recognized platform #{name.class}:#{name}"
      end
    end
  end
end
require_relative "interpreter_platform"
