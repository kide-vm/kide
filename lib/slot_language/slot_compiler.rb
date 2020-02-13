require "parser/current"
require "ast"

module SlotLanguage
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
    def on_send(statement)
      kids = statement.children.dup
      receiver = process(kids.shift) || MessageSlot.new
      name = kids.shift
      return label(name) if(name.to_s.end_with?("_label"))
      return goto(name,kids) if(name == :goto)
      return check(name,receiver, kids) if SlotCompiler.checks.include?(name)
      return assign(receiver, name , kids) if(name.to_s.end_with?("="))
      puts "Send #{name} , #{receiver} kids=#{kids}" if DEBUG
      Variable.new( name )
    end
    def on_lvar(lvar)
      puts "lvar #{lvar}" if DEBUG
      Variable.new(lvar.children.first )
    end
    def on_lvasgn( expression)
      puts "lvasgn #{expression}" if DEBUG
      name = expression.children[0]
      value = process(expression.children[1])
      Assignment.new(Variable.new(name),value)
    end
    alias :on_ivasgn :on_lvasgn

    def on_if(expression)
      puts "if #{expression}" if DEBUG
      condition = process(expression.children[0])
      condition.set_goto( process(expression.children[1]) )
      condition
    end
    def on_begin(exp)
      if( exp.children.length == 1)
        process(exp.first)
      else
        process_all(exp)
      end
    end
    def on_ivar( expression)
      puts "ivar #{expression}" if DEBUG
      Variable.new(expression.children.first)
    end

    private
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
      Goto.new(  label )
    end
    def check(name , receiver , kids)
      raise "Familiy too large #{kids}" if kids.length > 1
      puts   "Kids " + kids.to_s if DEBUG
      right = process(kids.first)
      case name
      when :==
        return EqualGoto.new(receiver , right)
      else
        raise "Only ==, not #{name}" unless name == :==
      end
    end

    def assign(receiver , name , kids)
      name = name.to_s[0...-1].to_sym
      receiver.add_slot_name(name)
      right = process kids.shift
      puts "Assign #{name} , #{receiver}" if DEBUG
      Assignment.new(receiver,right)
    end
  end
end
require_relative "named_slot"
require_relative "message_slot"
require_relative "variable"
require_relative "assignment"
require_relative "macro_maker"
require_relative "goto"
require_relative "equal_goto"
