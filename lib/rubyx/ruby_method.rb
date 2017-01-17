module Rubyx

  class RubyMethod

    attr_reader :name , :args_type , :locals_type , :source

    def initialize(name , args_type , locals_type , source )
      @name , @args_type , @locals_type , @source = name , args_type, locals_type , source
      raise "Name must be symbol" unless name.is_a?(Symbol)
      raise "args_type must be type" unless args_type.is_a?(Parfait::Type)
      raise "locals_type must be type" unless locals_type.is_a?(Parfait::Type)
    end

    def normalize_source
      @source = yield @source
    end

    def create_vm_method( type )
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      type.create_method( @name , @args_type )#FIXME, @locals_type)
    end


  end
end
