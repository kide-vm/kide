module Parser
  # Basic types are numbers and strings
  # later maybe arrays and hashes
  # floats ?  
  module BasicTypes
    include Parslet
    # space really is just space. ruby is newline sensitive, so there is more whitespace footwork
    # rule of thumb is that anything eats space behind it, but only space, no newlines
    rule(:space)  { (str('\t') | str(' ')).repeat(1) }
    rule(:space?) { space.maybe }
    rule(:newline){ str("\n") >> space? >> newline.repeat }
    
    rule(:quote)      { str('"') }
    rule(:nonquote)   { str('"').absent? >> any }

    rule(:comment){ match('#') >> (newline.absent? >> any).repeat.as(:comment) >> newline }

    rule(:eol) { newline  | any.absent? }
    
    rule(:double_quote){ str('"') }
    rule(:minus) { str('-') }
    rule(:plus) { str('+') }

    rule(:sign) { plus | minus }
    rule(:dot) {  str('.') }
    rule(:digit) { match('[0-9]') }
    rule(:exponent) { (str('e')| str('E')) }
     
    # identifier must start with lower case
    rule(:name)   { keyword.absent? >> (match['a-z'] >> match['a-zA-Z0-9'].repeat).as(:name)  >> space? }
    
    rule(:escape)     { str('\\') >> any.as(:esc) }
    rule(:string)     { quote >> (
        escape | 
        nonquote.as(:char)
      ).repeat(1).as(:string) >> quote }
    
    
#    rule(:string_special) { match['\0\t\n\r"\\\\'] }
#    rule(:escaped_special) { str("\\") >> match['0tnr"\\\\'] }
    
    #anything in double quotes
#    rule(:string){
#      double_quote >> 
#      ( escaped_special | string_special.absent? >> any ).repeat.as(:string) >> 
#      double_quote >> space?
#    }
    rule(:integer)    { sign.maybe >> digit.repeat(1).as(:integer) >> space? }
    
    rule(:float) { integer >>  dot >> integer >> 
                            (exponent >> sign.maybe >> digit.repeat(1,3)).maybe >> space?}
  end
end