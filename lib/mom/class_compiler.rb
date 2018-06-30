module Mom
  class ClassCompiler
    attr_reader :clazz , :methods

    def initialize(clazz , methods)
      @clazz = clazz
      @methods = methods
    end
  end
end
