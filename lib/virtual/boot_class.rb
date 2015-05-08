require_relative "meta_class"

module Virtual

  # class is mainly a list of methods with a name (for now)
  # layout of object is seperated into Layout
  class BootClass < Virtual::ObjectConstant
    def initialize name , super_class_name = :Object
      super()
      # class methods
      @instance_methods = []
      @name = name.to_sym
      @super_class_name = super_class_name.to_sym
      @meta_class = Virtual::MetaClass.new(self)
    end
    attr_reader :name , :instance_methods , :meta_class , :context , :super_class_name
    def add_instance_method method
      raise "not a method #{method.class} #{method.inspect}" unless method.is_a? Virtual::CompiledMethod
      raise "syserr " unless method.name.is_a? Symbol
      @instance_methods << method
    end

    def get_instance_method fname
      fname = fname.to_sym
      @instance_methods.detect{ |fun| fun.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method m_name
      method = get_instance_method(m_name)
      unless method
        unless( @name == :Object)
          supr = BootSpace.space.get_or_create_class(@super_class_name)
          method = supr.resolve_method(m_name)
        end
      end
      raise "Method not found #{m_name}, for #{@name}" unless method
      method
    end

    @@CLAZZ = { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
    def layout
      @@CLAZZ
    end
    def mem_length
      padded_words(3)
    end
    def to_s
      inspect[0...300]
    end

  end

end
