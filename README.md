# paramesan
Parameterized tests in Ruby

This is inspired by
[Parameterized-tests](https://github.com/junit-team/junit4/wiki/Parameterized-tests), the basis for
executing parameterized tests in Java, with JUnit4.

That concept was taken further by [JUnitParams](https://github.com/Pragmatists/JUnitParams), which
expands the options that are supported, and has been an epiphany for the way that I view and write
unit tests, which initially focused on the behavior (the process or code), then looks at the input
and output as data that go through the process.

I looked for the equivalent in Ruby, and the closest that I found was
[param_test](https://www.ruby-toolbox.com/projects/param_test). That, however, uses activesupport,
which is included in Rails, but I wanted a version that ran in a pure Ruby environment, using only
Test::Unit.

Ergo, paramesan, which as of this writing, allows a very primitive set of options for parameterized
tests.

```ruby

   require 'paramesan'

   class SomeTest < Test::Unit
     # example code ...
   end
```

