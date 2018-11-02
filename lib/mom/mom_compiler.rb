module Mom
  # The Compiler for the Mom level is a collection of Risc level Method compilers,
  # plus functions to translate from the risc to cpu specific code.
  #
  # Builtin functions are created here, lazily, when translate is called.
  # Instantiating builtin functions results in a MethodCompiler for that function, and
  # to avoid confusion, these should be instantiated only once.
  #
  # As RubyCompiler pools source at the vool level, when several classes are compiled
  # from vool to mom, several MomCompilers get instantiated. They must be merged before
  # proceeding with translate. Thus we have a append method.
  #
  class MomCompiler
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
      @method_compilers + boot_compilers
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

    # Translate code to whatever cpu is specified.
    # Currently only :arm and :interpret
    #
    # Translating means translating the initial jump
    # and then translating all methods
    def translate( platform_sym )
      platform_sym = platform_sym.to_s.capitalize
      platform = Risc::Platform.for(platform_sym)
      assemblers = translate_methods( platform.translator )
      Risc::Linker.new(platform , assemblers , constants)
    end

    # go through all methods and translate them to cpu, given the translator
    def translate_methods(translator)
      compilers.collect do |compiler|
        #log.debug "Translate method #{compiler.method.name}"
        translate_method(compiler , translator)
      end.flatten
    end

    # translate one method, which means the method itself and all blocks inside it
    # returns an array of assemblers
    def translate_method( method_compiler , translator)
      all = []
      all << translate_cpu( method_compiler , translator )
      method_compiler.block_compilers.each do |block_compiler|
        all << translate_cpu(block_compiler , translator)
      end
      all
    end

    # compile the callable (method or block) to cpu
    # return an Assembler that will then translate to binary
    def translate_cpu(compiler , translator)
      risc = compiler.risc_instructions
      cpu_instructions = risc.to_cpu(translator)
      nekst = risc.next
      while(nekst)
        cpu = nekst.to_cpu(translator) # returning nil means no replace
        cpu_instructions << cpu if cpu
        nekst = nekst.next
      end
      Risc::Assembler.new(compiler.callable , cpu_instructions )
    end

  end
end
