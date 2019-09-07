module Ruby
  # Send and yield are very very similar, so they have a base class CallStatement
  #
  # The SendStatement really only provides to_s, so see CallStatement
  #
  class SendStatement < CallStatement

    def to_vool
      if @receiver.is_a?(ModuleName) and @receiver.name == :X
        args = @arguments.collect { |arg| arg.to_vool }
        return Vool::MacroExpression.new(name , args)
      end
      return require_file if( @name == :require_relative )
      return super
    end
    def to_s(depth = 0)
      at_depth( depth , "#{receiver}.#{name}(#{arguments.join(', ')})")
    end
    def require_file
      target = @arguments.first.value
      if(target == 'helper')
        file = "/test/rubyx/rt_parfait/helper.rb"
      else
        file = "/lib/parfait/#{target}.rb"
      end
      path = File.expand_path(  "../../../#{file}" , __FILE__)
      source = File.read(path)
      RubyCompiler.compile( source ).to_vool
    end
  end
  class SuperStatement < SendStatement
    def initialize(args)
      super(:super , SelfExpression.new , args)
    end
  end

end
