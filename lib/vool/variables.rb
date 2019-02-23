module Vool
  module Named
    attr_reader :name
    def initialize name
      @name = name
    end
    def each(&block)
    end
  end

  class LocalVariable < Expression
    include Named
    def slot_definition(compiler)
      slot_def = compiler.slot_type_for(@name)
      Mom::SlotDefinition.new(:message , slot_def)
    end
    def to_s
      name.to_s
    end
  end

  class InstanceVariable < Expression
    include Named
    def slot_definition(_)
      Mom::SlotDefinition.new(:message , [ :receiver , @name] )
    end
    # used to collect type information
    def add_ivar( array )
      array << @name
    end
    def to_s
      "@#{name}"
    end
  end

  class ClassVariable < Expression
    include Named
  end

  class ModuleName < Expression
    include Named
    def ct_type
      get_named_class.meta_class.instance_type
    end
    def slot_definition(_)
      return Mom::SlotDefinition.new( get_named_class, [])
    end
    def get_named_class
      Parfait.object_space.get_class_by_name(self.name)
    end
  end
end
