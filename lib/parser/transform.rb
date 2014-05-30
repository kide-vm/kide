require 'parslet'
require 'ast/expression'

module Parser
  class Transform < Parslet::Transform
    rule(:string => sequence(:chars)) { Ast::StringExpression.new chars.join }
    rule(:esc => simple(:esc)) { '\\' +  esc }
    rule(char: simple(:char)) { char }
    
    rule(:integer => simple(:value)) { Ast::IntegerExpression.new(value.to_i) }
    rule(:name   => simple(:name))  { Ast::NameExpression.new(name.to_s) }
    rule(:instance_variable   => simple(:instance_variable))  { Ast::VariableExpression.new(instance_variable.name) }
    rule(:module_name   => simple(:module_name))  { Ast::ModuleName.new(module_name.to_s) }

    rule(:array_constant => sequence(:array_constant) ) { Ast::ArrayExpression.new(array_constant) } 
    rule(:array_element  => simple(:array_element))    { array_element  }
    rule(:hash_constant => sequence(:hash_constant) ) { Ast::HashExpression.new(hash_constant) } 
    rule(:hash_key => simple(:hash_key) , :hash_value => simple(:hash_value)) {  Ast::AssociationExpression.new(hash_key,hash_value) }
    rule(:hash_pair => simple(:hash_pair) ) {  hash_pair }

    rule(:argument  => simple(:argument))    { argument  }
    rule(:argument_list => sequence(:argument_list)) { argument_list }

    rule( :call_site => simple(:call_site), 
          :argument_list    => sequence(:argument_list)) do
           Ast::CallSiteExpression.new(call_site.name, argument_list) 
    end

    rule(:if => simple(:if), :conditional     => simple(:conditional),
         :if_true  => {:expressions => sequence(:if_true) , :else => simple(:else) },
         :if_false => {:expressions => sequence(:if_false) , :end => simple(:e) }) do
           Ast::IfExpression.new(conditional, if_true, if_false) 
         end

    rule(:while     => simple(:while),
         :while_cond => simple(:while_cond) , :do => simple(:do) , 
         :body => {:expressions => sequence(:body) , :end => simple(:e) }) do
           Ast::WhileExpression.new(while_cond, body) 
         end

    rule(:return => simple(:return) , :return_expression => simple(:return_expression))do
       Ast::ReturnExpression.new(return_expression) 
     end

    rule(:parmeter  => simple(:parmeter))    { parmeter  }
    rule(:parmeter_list => sequence(:parmeter_list)) { parmeter_list }

    rule(:function_name   => simple(:function_name),
         :parmeter_list => sequence(:parmeter_list),
         :expressions   => sequence(:expressions) , :end => simple(:e)) do
            Ast::FunctionExpression.new(function_name.name, parmeter_list, expressions) 
          end
    
    rule(l: simple(:l), o: simple(:o) , r: simple(:r)) do 
      Ast::OperatorExpression.new( o.to_s.strip , l ,r)
    end
    
    #modules and classes are undertsndibly quite similar   Class < Module
    rule( :module_name => simple(:module_name) , :module_expressions => sequence(:module_expressions) , :end=>"end") do
      Ast::ModuleExpression.new(module_name , module_expressions)
    end
    rule( :module_name => simple(:module_name) , :class_expressions => sequence(:class_expressions) , :end=>"end") do
      Ast::ClassExpression.new(module_name , class_expressions)
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
