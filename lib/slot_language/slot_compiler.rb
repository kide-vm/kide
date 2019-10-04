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
      raise "Kids #{kids}" unless kids.empty?
      SlotMaker.new( name , receiver )
    end
  end
end
require_relative "named_slot"
require_relative "message_slot"
require_relative "slot_maker"
