require "parser/current"
require "ast"

module SlotLanguage
  class SlotCompiler < AST::Processor
    DEBUG = false

    def self.compile(input)
      ast = Parser::CurrentRuby.parse( input )
      self.new.process(ast)
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
      return check(name,receiver, kids) if(name == :==)
      return assign(receiver, name , kids) if(name.to_s.end_with?("="))
      puts "Send #{name} , #{receiver} kids=#{kids}" if DEBUG
      SlotMaker.new( name )
    end
    def on_lvar(lvar)
      puts "lvar #{lvar}" if DEBUG
      SlotMaker.new(lvar.children.first )
    end
    def on_lvasgn( expression)
      puts "lvasgn #{expression}" if DEBUG
      name = expression.children[0]
      value = process(expression.children[1])
      LoadMaker.new(SlotMaker.new(name),value)
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
      SlotMaker.new(expression.children.first)
    end

    private
    def label(name)
      SlotMachine::Label.new(name.to_s , name)
    end
    def goto(name , args)
      # error handling would not hurt
      puts "goto #{name} , #{args}" if DEBUG
      label = process(args.first)
      SlotMachine::Jump.new(  label )
    end
    def check(name , receiver , kids)
      raise "Only ==, not #{name}" unless name == :==
      raise "Familiy too large #{kids}" if kids.length > 1
      puts   "Kids " + kids.to_s if DEBUG
      right = process(kids.first)
      CheckMaker.new(name , receiver , right)
    end
    def assign(receiver , name , kids)
      name = name.to_s[0...-1].to_sym
      receiver.add_slot_name(name)
      right = process kids.shift
      puts "Assign #{name} , #{receiver}" if DEBUG
      LoadMaker.new(receiver,right)
    end
  end
end
require_relative "named_slot"
require_relative "message_slot"
require_relative "slot_maker"
require_relative "load_maker"
require_relative "check_maker"
require_relative "macro_maker"
