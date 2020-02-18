require "parser/current"
require "ast"

module SlotMachine
  class SlotCompiler < AST::Processor
    DEBUG = false

    # conditionals supported, currently only equal
    def self.checks
      [:==]
    end

    def self.compile(input)
      ast = Parser::CurrentRuby.parse( input )
      self.new.process(ast)
    end
    attr_reader :labels
    def initialize
      @labels = {}
    end

    def not_implemented(node)
      raise "Not implemented #{node.type}"
    end
    # default to error, so non implemented stuff shows early
    def handler_missing(node)
      not_implemented(node)
    end
    def process_all(exp)
      arr = super(exp)
      head = arr.shift
      until( arr.empty?)
        head << arr.shift
      end
      head
    end
    def on_send(statement)
      kids = statement.children.dup
      receiver = kids.shift
      name = kids.shift
      return label(name) if(name.to_s.end_with?("_label"))
      return goto(name,kids) if(name == :goto)
      return check(name,receiver, kids) if SlotCompiler.checks.include?(name)
      return assign(receiver, name , kids) if(name.to_s.end_with?("="))
      puts "Send: #{statement} " if DEBUG
      var = SlottedMessage.new( [name] )
      if(receiver)
        puts "receiver at #{name} #{receiver}" if DEBUG
        prev = process(receiver)
        prev.set_next(var.slots)
        prev
      else
        var
      end
    end
    def on_lvar(lvar)
      puts "lvar #{lvar}" if DEBUG
      SlottedMessage.new( [lvar.children.first] )
    end
    def on_lvasgn( expression)
      puts "i/lvasgn #{expression}" if DEBUG
      var = var_for(expression.children[0])
      value = process(expression.children[1])
      SlotLoad.new(expression.to_s,var , value)
    end
    alias :on_ivasgn :on_lvasgn

    def on_if(expression)
      puts "if #{expression}" if DEBUG
      condition = process(expression.children[0])
      jump = process(expression.children[1])
      condition.set_label( jump.label )
      condition
    end
    def on_begin(exp)
      if( exp.children.length == 1)
        process(exp.first)
      else
        process_all(exp)
      end
    end
    def on_ivar(expression)
      puts "ivar #{expression}" if DEBUG
      var_for(expression.children.first)
    end

    private

    def var_for( name )
      name = name.to_s
      if(name[0] == "@")
        var = name.to_s[1 .. -1].to_sym
        SlottedMessage.new([:receiver , var])
      else
        SlottedMessage.new([:receiver , name])
      end
    end
    def label(name)
      raise "no label #{name}" unless(name.to_s.end_with?("_label"))
      if @labels.has_key?(name)
        return @labels[name]
      else
        @labels[name] = SlotMachine::Label.new(name.to_s , name)
      end
    end
    def goto(name , args)
      # error handling would not hurt
      puts "goto #{name} , #{args}" if DEBUG
      label = process(args.first)
      Jump.new( label )
    end
    def check(name , receiver , kids)
      raise "Familiy too large #{kids}" if kids.length > 1
      puts   "Kids " + kids.to_s if DEBUG
      right = process(kids.first)
      case name
      when :==
        return SameCheck.new(process(receiver) , right , Label.new("none", :dummy))
      else
        raise "Only ==, not #{name}" unless name == :==
      end
    end

    def assign(receiver , name , kids)
      receiver = process(receiver)
      puts "Assign #{name} , #{receiver}" if DEBUG
      raise "Only one arg #{kids}" unless kids.length == 1
      right = process kids.shift
      name = name.to_s[0...-1].to_sym
      receiver.set_next(Slot.new(name))
      SlotLoad.new("#{receiver} = #{name}",receiver,right)
    end
  end
end
