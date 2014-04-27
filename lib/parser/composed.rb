require_relative "basic_types"
require_relative "tokens"

module Parser
  
  #obviously a work in progress !!
  # We "compose" the parser from bits, divide and hopefully conquer
   
  class Composed < Parslet::Parser
    include BasicTypes
    include Tokens
    
    rule(:args) {
      left_parenthesis >>
      ((expression.as(:arg) >> (comma >> expression.as(:arg)).repeat(0)).maybe).as(:args) >>
      right_parenthesis
    }

    rule(:funcall) { name.as(:funcall) >> args }

    rule(:expression) { cond | funcall | integer | name }

    rule(:cond) {
      if_kw >> left_parenthesis >> expression.as(:cond) >> right_parenthesis >>
        body.as(:if_true) >>
        else_kw >>
        body.as(:if_false)
    }

    rule(:body)    { left_brace >> expression.as(:body) >> right_brace }
    rule(:if_kw)   { str('if')   >> space? }
    rule(:else_kw) { str('else') >> space? }

    rule(:func) {
      func_kw >> name.as(:func) >> params >> body
    }

    rule(:func_kw) { str('function') >> space? }

    rule(:params) {
      left_parenthesis >>
        ((name.as(:param) >> (comma >> name.as(:param)).repeat(0)).maybe).as(:params) >>
      right_parenthesis
    }
    rule(:root){ func.repeat(0) >> expression | expression | args }
  end
end
