require_relative "meta_class"

module Boot
  # class is mainly a list of methods with a name (for now)
  # layout of object is seperated into Layout
  class BootClass < Virtual::ObjectConstant
    def initialize name , super_class = :Object
      super()
      # class methods
      @methods = []
      @name = name.to_sym
      @super_class = super_class
      @meta_class = MetaClass.new(self)
    end
    attr_reader :name , :methods , :meta_class , :context , :super_class
    def attributes
      [:name , :super_class]
    end
    def add_method method
      raise "not a method #{method}" unless method.is_a? Virtual::Method
      raise "syserr " unless method.name.is_a? Symbol
      @methods << method
    end

    def get_method fname
      fname = fname.to_sym
      f = @methods.detect{ |f| f.name == fname }
      names = @methods.collect{|f| f.name } 
      f
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method name
      fun = get_method name
      unless fun or name == :Object
        supr = @context.object_space.get_or_create_class(@super_class)
        fun = supr.get_method name
        puts "#{supr.methods.collect(&:name)} for #{name} GOT #{fun.class}" if name == :index_of
      end
      raise "Method not found :#{name}, for #{inspect}" unless fun
      fun
    end

    def to_s
      inspect
    end

  end
end