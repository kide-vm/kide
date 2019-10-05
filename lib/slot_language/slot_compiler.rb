require "parser/current"
require "ast"

module SlotLanguage
  class SlotCompiler < AST::Processor

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
      SlotMaker.new( name , receiver )
    end
    def on_lvasgn expression
      name = expression.children[0]
      value = process(expression.children[1])
      Sol::LocalAssignment.new(name,value)
    end
    def on_if(expression)
      condition = process(expression.children[0])
      condition.set_goto( process(expression.children[1]) )
      condition
    end
    def on_begin(exp)
      process(exp.first)
    end
    def on_ivar expression
      Sol::InstanceVariable.new(instance_name(expression.children.first))
    end

    private
    def instance_name(sym)
      sym.to_s[1 .. -1].to_sym
    end
    def label(name)
      SlotMachine::Label.new(name.to_s , name)
    end
    def goto(name , args)
      # error handling would not hurt
      label = process(args.first)
      SlotMachine::Jump.new(  label )
    end
    def check(name , receiver , kids)
      raise "Only ==, not #{name}" unless name == :==
      raise "Familiy too large #{kids}" if kids.length > 1
      puts  "Kids " + kids.to_s
      right = process(kids.first)
      CheckMaker.new(name , receiver , right)
    end
  end
end
require_relative "named_slot"
require_relative "message_slot"
require_relative "slot_maker"
require_relative "check_maker"
