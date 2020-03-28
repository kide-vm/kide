# Mains testing

Test methods by their output and exit codes (return, since it is the main).

Every test here is tested first as an Interpreter test, and then as binary (arm).


## Setup and assert

The setup require the @input variable to hold the code. This is usually renerated with
as_main or similar helper.

The @preload may be set to load any of the Macros, so one can actually use methods.
Otherwise the only methods are the ones you code

The assert_result takes the exit code and std out. It runs both interpreter and arm,
in that order.

### Interpreter

The interpreter is for the most part like another platform. Everything up to the
creation of binaries is the same. The Linker object get's passed to the
Interpreter which runs the code to the end, and returns return code and stdout.

If this passes, arm is run.

### Arm

Arm is actually only run if:
- you set TEST_ALL  (as is done in test/test_all)
- you set TEST_ARM

AND it requires that you have qemu set up correctly. But given all that, it:
- creates a binary from the code (mains.o), which is linked to a.out
- runs the binary
- captures return code and stdout and returns

Obviously Interpreter AND Arm need to return same codes, the one the assert specifies.

## Status

I have moved most of the risc/interpreter code here, which means we now have over 50
binary tests.

Next i will recreate the file based tests in a better way to integrate with the
current style.
