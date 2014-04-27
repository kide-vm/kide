module Parser
  module BasicTypes
    include Parslet
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    rule(:name)   { match('[a-z]').repeat(1).as(:name) >> space? }
    rule(:number) { match('[0-9]').repeat(1).as(:number) >> space? }
  end
end