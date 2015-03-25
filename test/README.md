# Testing

Testing is off course great, and well practised in the ruby community.
Good tests exists in the parts where functionality is clear: Parsing and binary generation.

But it is difficult to write tests when you don't know what the functionality is.
Also TDD does not really help as it assumes you know what you're doing.

As this is all quite new, i tend to test only when i know that the functionality will stay that way.
Otherwise it's just too much effort to rewrite and rewrite the tests.

I used minitest / test-unit as the framewok, just because it is lighter and thus when the
time comes to move to salama, less work.

## Commands

bundle exec rake test

