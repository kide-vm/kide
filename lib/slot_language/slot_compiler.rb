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
      #puts  statement
      kids = statement.children.dup
      receiver = process(kids.shift) || MessageSlot.new
      name = kids.shift
      return label(name) if(name.to_s.end_with?("_label"))
      SlotMaker.new( name , receiver )
    end
    def on_lvasgn expression
      #puts expression
      name = expression.children[0]
      value = process(expression.children[1])
      Sol::LocalAssignment.new(name,value)
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
  end
end
require_relative "named_slot"
require_relative "message_slot"
require_relative "slot_maker"
