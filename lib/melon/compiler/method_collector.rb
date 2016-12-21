module Melon

  class MethodCollector < TotalProcessor

    def initialize
      @methods = []
    end

    def collect(statement)
      process statement
      @methods
    end

    def on_def(statement)
      name , args , body = *statement
      args_type = make_type(args)
      locals_type = make_locals(body)
      @methods << RubyMethod.new(name , args_type , locals_type , body )
    end

    private

    def make_type( statement )
      type = Parfait::Space.object_space.get_class_by_name(:Message ).instance_type
      statement.children.each do |arg|
        type = type.add_instance_variable( arg.children[0] , :Object )
      end
      type
    end

    def make_locals(body)
      locals = LocalsCollector.new.collect(body)
      type = Parfait::Space.object_space.get_class_by_name(:NamedList ).instance_type
      locals.each do |name , local_type |
        type = type.add_instance_variable( name , local_type )
      end
      type
    end
  end
end
