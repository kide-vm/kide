module Risc
  # A platform is (or will be) something like the linux tripple
  #
  # Currently it just provides a Translator and binary start point
  #
  class Platform

    # return the translator instance that traslates risc intructions into
    # platform specific ones
    def translator
      raise "not implemented"
    end

    # return an integer where the binary is loaded
    def loaded_at
      raise "not implemented"
    end

    # return the number of registers the platform supports
    def num_registers
      raise "not implemented"
    end

    # return the Allocator for the platform
    # stanrard implementation return StandardAllocator, which uses
    # num_registers and assumes rXX naming (ie arm + interpreter)
    #
    # Possibility to override and implemented different schemes
    def allocator(compiler)
      StandardAllocator.new(compiler , self )
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
