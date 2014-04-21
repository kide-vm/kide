Crystal
=======

Small steps on a long road, will nevertheless lead to the destination

Sorry about the Zen, but it feels like i'm about to walk to China.

Step 1
------

Produce binary that represent code. Traditionally called assembling, but there is no need for an external file
representation. 

Ie only in ruby code do i want to create machine code.

First instructions are in fact assembling correctly. Meaning i have tests, and i can use objbump to verify the correct assembler code is disasembled

Step 2
------

Package the code into an executable. Run that and verify it's output. But full elf support (including externs) is eluding me for now.

Still, this has proven to be a good review point for the arcitecture and means no libc for now.
Full rationale on the web (pages rep for now), but it means starting an extra step

Step 2.1
--------

Start implementing syscalls and the functionality we actually need from c (basic io only really)

Step 3
-------

Start parsing some simple code. Using Parslet.

Get the parse - compile - execute -verify cycle going.

Step 4
-------

Implement function calling to modularise.
Implement a way to call libc

Step 5
------

Implement classes,  implement Core library of arrays/hash

Step 6
------

Implement Blocks

Step 7
------

Implement Exceptions

Step 8
-------


Celebrate New year 2020



Contributing to crystal
-----------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2014 Torsten Ruger. See LICENSE.txt for
further details.

