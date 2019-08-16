# Test Parfait compilation

Parfait has tests in tests/parfait which test it using mri.

## Parsing and compiling Parfait

Since we need Parfait in the runtime, we need to parse it and compile it.
And since it is early days, we expect errors at every level during this process, which
means testing every layer for every file.

Rather than create parfait tests for every layer (ie in the vool/mom/risc directories)
we have one file per parfait file here. Each file tests all layers.

The usual workflow is to start with a new file and create tests for vool, mom, risc,binary
in that order. Possibly fixing the compiler on the way. Then adding the file to
the RubyXCompiler parfait load list.

## Testing compiled Parfait

The next step is to test the compiled parfait. Since we have tests, the best way would
be to parse and execute the tests. This would involve creating a mini MiniTest and some
fancy footwork in the compilation. But it should be possible to create one executable /
interpreted test for each of the exising Parfait test.

Alas, this is for another day.
