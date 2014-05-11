module Parser
  # Tokens are single or double character combinations with "meaning"
  # braces, comman, point, questionmark , quotes, that kind of thing
  # operator symbols are seperate in Opreators
  module Tokens
    include Parslet
    rule(:left_parenthesis) { str('(') >> space? }
    rule(:right_parenthesis) { str(')') >> space? }
    rule(:left_brace)  { str('{')    >> space? }
    rule(:right_brace)  { str('}')    >> space? }

    rule(:comma)  { str(',') >> space? }
    rule(:colon)  { str(':') >> space? }
    rule(:semicolon)  { str(';') >> space? }
    rule(:question_mark)  { str('?') >> space? }
    rule(:excamation_mark)  { str('!') >> space? }  

  end
end