require 'parslet'
require 'ast/expression'

module Parser
  class Transform < Parslet::Transform
    rule(:string => sequence(:chars)) { Ast::StringExpression.new chars.join }
    rule(:esc => simple(:esc)) { '\\' +  esc }
    rule(char: simple(:char)) { char }
    
    rule(:integer => simple(:value)) { Ast::IntegerExpression.new(value.to_i) }
    rule(:name   => simple(:name))  { Ast::NameExpression.new(name.to_s) }

    rule(:argument  => simple(:argument))    { argument  }
    rule(:argument_list => sequence(:argument_list)) { argument_list }

    rule( :function_call => simple(:function_call), 
          :argument_list    => sequence(:argument_list)) do
           Ast::FuncallExpression.new(function_call.name, argument_list) 
    end

    rule(:if => simple(:if), :conditional     => simple(:conditional),
         :if_true  => {:expressions => sequence(:if_true) , :else => simple(:else) },
         :if_false => {:expressions => sequence(:if_false) , :end => simple(:e) }) do
           Ast::ConditionalExpression.new(conditional, if_true, if_false) 
         end

    rule(:while     => simple(:while),
         :while_cond => { :expressions => sequence(:while_cond) , :do => simple(:do)} , 
         :body => {:expressions => sequence(:body) , :end => simple(:e) }) do
           Ast::WhileExpression.new(while_cond, body) 
         end

    rule(:parmeter  => simple(:parmeter))    { parmeter  }
    rule(:parmeter_list => sequence(:parmeter_list)) { parmeter_list }

    rule(:function_definition   => simple(:function_definition),
         :parmeter_list => sequence(:parmeter_list),
         :expressions   => sequence(:expressions) , :end => simple(:e)) do
            Ast::FunctionExpression.new(function_definition.name, parmeter_list, expressions) 
          end
    
    rule(l: simple(:l), o: simple(:o) , r: simple(:r)) do 
      Ast::OperatorExpression.new( o.to_s.strip , l ,r)
    end
    
    #shortcut to get the ast tree for a given string
    # optional second arguement specifies a rule that will be parsed (mainly for testing)     
    def self.ast string , rule = :root
      syntax    = Parser.new.send(rule).parse(string)
      tree      = Transform.new.apply(syntax)
      tree
    end
  end
end
