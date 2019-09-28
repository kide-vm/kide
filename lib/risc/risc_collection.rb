module Risc
  # The Collection for the Risc level is a collection of Risc level Method compilers,
  # plus functions to translate from the risc to cpu specific code.
  #
  class RiscCollection
    attr_reader :method_compilers

    # Initialize with an array of risc MethodCompilers
    def initialize(compilers = [])
      @method_compilers = nil
      compilers.each{|c| add_compiler(c)}
    end

    # collects constants from all compilers into one array
    def constants
      all = []
      method_compilers.each_compiler{|comp| all +=  comp.constants }
      all
    end

    def append(collection)
      @method_compilers.add_method_compiler( collection.method_compilers)
      self
    end

    def add_compiler(compiler)
      if(@method_compilers)
        @method_compilers.add_method_compiler(compiler)
      else
        @method_compilers = compiler
      end
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
      assemblers = []
      @method_compilers.each_compiler do |compiler|
        compiler.translate_method( platform.translator , assemblers)
      end
      Risc::Linker.new(platform , assemblers , constants)
    end

  end
end
