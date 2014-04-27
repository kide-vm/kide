Parser
================

This includes the parser and generated ast.

Parslet is really great in that it:
- does not generate code but instean gives a clean dsl to define a grammar
- uses ruby modules so one can split the grammars up
- has a seperate tranform stage to generate an ast layer

Especially the last point is great. Since it is seperate it does not clutter up the actual grammar.
And it can generate a layer that has no links to the actual parser anymore, thus saving/automating
a complete tranformation process. 

