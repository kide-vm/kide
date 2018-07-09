module Mom
  class MomCompiler
    attr_reader :method_compilers

    def initialize(compilers = [])
      @method_compilers = compilers + Risc::Builtin.boot_functions
    end

    # collects constants from all compilers into one array
    def constants
      @method_compilers.inject([]){|sum ,comp| sum + comp.constants }
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
      method_compilers.collect do |compiler|
        #log.debug "Translate method #{compiler.method.name}"
        translate_cpu(compiler , translator)
      end
    end

    def translate_cpu(compiler , translator)
      risc = compiler.risc_instructions
      cpu_instructions = risc.to_cpu(translator)
      nekst = risc.next
      while(nekst)
        cpu = nekst.to_cpu(translator) # returning nil means no replace
        cpu_instructions << cpu if cpu
        nekst = nekst.next
      end
      Risc::Assembler.new(compiler.get_method , cpu_instructions )
    end

  end
end
