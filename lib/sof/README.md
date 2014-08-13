### Salama Object File

Ok, so we all heard about object files, it's the things compilers create so we don't have to have huge compiles and
can link them later.

Much few know what they include, and that is not because they are not very useful, but rather very complicated.

An object machine must off course have it's own object files, because:

- otherwise we'd have to express the object machine in c (nischt gut)
- we would be forced to read the source every time (slow)
- we would have no language independant format

And i was going to get there, juust not now. I mean i think it's a great idea to have many languages compile and run 
on the same object machine. Not neccessarily my idea, but i haven't seen it pulled off. Not that i will.

I just want to be able to read my compiled code!!

And so this is a little start, just some outputter.

#### Direction

The way this is meant to go (planned for 2020+) was a salama core with only a sof parser (as that is soo much simpler).

Then to_ruby for all the ast classes to be able to roundtrip ruby code.

Then go to storing sof in git, rather than ruby.

Then write a python/java parser and respective runtime conversion. Extracting common features. With the respective 
to_python on the ast's to roundtrip that too. Have to since by now we work on sof's. Etc . ..
