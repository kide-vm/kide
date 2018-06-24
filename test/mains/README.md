# Mains testing

Test methods by their output and exit codes (return, since it is the main). 

There are only two tests here, one for interpreter, one for arm.
Both run the same tests. The actual ruby code that is run is in the source dir.
Test methods are generated, one for each source file.

File names follow [name,stdout,exitcode] joined by _ pattern. Stdout may be left blank,
but exit code must be supplied.

Obviously the arm tests need an arm platform. This may be defined by ARM_HOST,
eg for simulated ARM_HOST=localhost

Also port and user may be specified with ARM_PORT and ARM_USER , they default to
2222 and pi if left blank.
SSH keys must be set up so no passwords are required (and the users private key may
  not be password protected)
