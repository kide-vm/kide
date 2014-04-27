require_relative "basic_types"

module Parser
  class Composed < Parslet::Parser
    include BasicTypes

    rule(:args) {
      lparen >>
      ((expression.as(:arg) >> (comma >> expression.as(:arg)).repeat(0)).maybe).as(:args) >>
      rparen
    }

    rule(:funcall) { name.as(:funcall) >> args }

    rule(:expression) { cond | funcall | number | name }

    rule(:lparen) { str('(') >> space? }
    rule(:rparen) { str(')') >> space? }
    rule(:comma)  { str(',') >> space? }

    rule(:cond) {
      if_kw >> lparen >> expression.as(:cond) >> rparen >>
        body.as(:if_true) >>
        else_kw >>
        body.as(:if_false)
    }

    rule(:body)    { lbrace >> expression.as(:body) >> rbrace }
    rule(:lbrace)  { str('{')    >> space? }
    rule(:rbrace)  { str('}')    >> space? }
    rule(:comma)   { str(',')    >> space? }
    rule(:if_kw)   { str('if')   >> space? }
    rule(:else_kw) { str('else') >> space? }

    rule(:func) {
      func_kw >> name.as(:func) >> params >> body
    }

    rule(:func_kw) { str('function') >> space? }

    rule(:params) {
      lparen >>
        ((name.as(:param) >> (comma >> name.as(:param)).repeat(0)).maybe).as(:params) >>
      rparen
    }
    rule(:root){ func.repeat(0) >> expression | expression | args }
  end
end
