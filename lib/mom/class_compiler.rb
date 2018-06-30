module Mom
  class ClassCompiler
    attr_reader :clazz , :methods

    def initialize(clazz , methods)
      @clazz = clazz
      @methods = methods
    end
    
    # Translate code to whatever cpu is specified.
    # Currently only :arm and :interpret
    #
    # Translating means translating the initial jump
    # and then translating all methods
    def translate( platform )
      platform = platform.to_s.capitalize
      @platform = Risc::Platform.for(platform)
      translate_methods( @platform.translator )
      #@cpu_init = risc_init.to_cpu(@platform.translator)
    end

    # go through all methods and translate them to cpu, given the translator
    def translate_methods(translator)
      Parfait.object_space.get_all_methods.each do |method|
        #log.debug "Translate method #{method.name}"
        method.translate_cpu(translator)
      end
    end
  end
end
