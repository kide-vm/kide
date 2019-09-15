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

    # lazily instantiate the compiler for __init__ function and __method_missing__
    def init_compiler
      @init_compilers ||= [
        MomCollection.create_init_compiler ,
        MomCollection.create_mm_compiler ,
                  ]
    end

    # Return all compilers, namely the MethodCompilers passed in, plus the
    # boot_function's compilers (boot_compilers)
    def compilers
      @method_compilers + init_compiler
    end

    # Append another MomCompilers method_compilers to this one.
    def append(mom_compiler)
      @method_compilers += mom_compiler.method_compilers
      self
    end

    def to_risc( )
      riscs = compilers.collect do | mom_c |
        mom_c.to_risc
      end
      # to_risc all compilers
      # for each suffling constnts and fist label, then all instructions (see below)
      # then create risc collection
      Risc::RiscCollection.new(riscs)
    end

    # See Init instruction. We must have an init (ie we need it in code), so it is created in code
    def self.create_init_compiler
      compiler = compiler_for(:Object,:__init__ ,{})
      compiler._reset_for_init # no return, just for init
      compiler.add_code Init.new("missing")
      return compiler
    end

    def self.create_mm_compiler
      compiler = compiler_for(:Object,:__method_missing__ ,{})
      compiler.add_code MethodMissing.new("missing")
      return compiler
    end

    def self.compiler_for( clazz_name , method_name , arguments , locals = {})
      frame = Parfait::NamedList.type_for( locals )
      args = Parfait::NamedList.type_for( arguments )
      MethodCompiler.compiler_for_class(clazz_name , method_name , args, frame )
    end

  end
end
