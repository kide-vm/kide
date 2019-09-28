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
      assemblers = translate_methods( platform.translator )
      Risc::Linker.new(platform , assemblers , constants)
    end

    # go through all methods and translate them to cpu, given the translator
    def translate_methods(translator)
      collection = []
      method_compilers.each_compiler do |compiler|
        #puts "Translate method #{compiler.callable.name}"
        translate_method(compiler , translator , collection)
      end
      collection
    end

    # translate one method, which means the method itself and all blocks inside it
    # returns an array of assemblers
    def translate_method( method_compiler , translator , collection)
      collection << translate_cpu( method_compiler , translator )
      method_compiler.block_compilers.each do |block_compiler|
        collection << translate_cpu(block_compiler , translator)
      end
      collection
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
