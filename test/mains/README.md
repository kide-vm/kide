# Mains testing

Test methods by their output and exit codes (return, since it is the main).

There are only two tests here (plus one, see below), one for interpreter, one for arm.
Both run the same tests. The actual ruby code that is run is in the source dir.
Test methods are generated, one for each source file.

## Files

File names follow [order,name,stdout,exitcode] joined by _ pattern.
Stdout may be left blank, but exit code must be supplied.

The order number is some number giving the difficulty of the test, higher is more.
The first digit represents how many external methods the code relies on, the second
is some general indicator, ie recursive is more difficult than not, syscalls more than
normal calls, if or while more than nothing etc.

## Arm

Obviously the arm tests need an arm platform. This may be defined by ARM_HOST,
eg for simulated ARM_HOST=localhost

Also port and user may be specified with ARM_PORT and ARM_USER , they default to
2222 and pi if left blank.
SSH keys must be set up so no passwords are required (and the users private key may
  not be password protected)

## Developing

Since the Framework always runs all tests, it is a little cumbersome for developing
a single new test. Since all get run and it is slow.

To develop the next test, one can edit test_new.rb . Once it runs on the interpreter,
move the changes to a source file and revert test_new changes.
