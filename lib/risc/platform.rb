module Risc
  # A platform is (or will be) something like the linux tripple
  #
  # Currently it just provides a Translator and binary start point
  #
  class Platform

    # return the translator instance that traslates risc intructions into
    # platform specific ones
    def translator
    end

    # return an integer where the binary is loaded
    def loaded_at
    end
    # Factory method to create a Platform object according to the platform
    # string given.
    # Currently only "Arm"
    def self.for( name )
      case name
      when "Arm"
        return Arm::ArmPlatform.new
      else
        raise "not recignized platform #{name}"
      end
    end
  end
end
