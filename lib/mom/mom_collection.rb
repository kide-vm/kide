module Mom
  # The Compiler/Collection for the Mom level is a collection of Mom level Method
  # compilers These will transform to Risc MethodCompilers on the way down.
  #
  # As RubyCompiler pools source at the vool level, when several classes are compiled
  # from vool to mom, several MomCompilers get instantiated. They must be merged before
  # proceeding with translate. Thus we have a append method.
  #
  class MomCollection
    attr_reader :method_compilers

    # Initialize with an array of risc MethodCompilers
    def initialize(compilers = [])
      @method_compilers = compilers
    end

    # lazily instantiate the compilers for boot functions
    # (in the hope of only booting the functions once)
    def boot_compilers
      @boot_compilers ||= Risc::Builtin.boot_functions
    end

    # Return all compilers, namely the MethodCompilers passed in, plus the
    # boot_function's compilers (boot_compilers)
    def compilers
      @method_compilers #+ boot_compilers
    end

    # collects constants from all compilers into one array
    def constants
      compilers.inject([]){|sum ,comp| sum + comp.constants }
    end

    # Append another MomCompilers method_compilers to this one.
    def append(mom_compiler)
      @method_compilers += mom_compiler.method_compilers
      self
    end

    def to_risc(  )
      riscs = method_compilers.collect do | mom_c |
        mom_c.to_risc
      end
      # to_risc all compilers
      # for each suffling constnts and fist label, then all instructions (see below)
      # then create risc collection
      Risc::RiscCollection.new(riscs)
    end


  end
end
