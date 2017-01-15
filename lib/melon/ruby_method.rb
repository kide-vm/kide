module Melon

  class RubyMethod

    attr_reader :name , :args_type , :locals_type , :source

    def initialize(name , args_type , locals_type , source )
      @name , @args_type , @locals_type , @source = name , args_type, locals_type , source
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
