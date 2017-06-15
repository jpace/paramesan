# Overview

Paramesan adds parameterized tests to test/unit in Ruby. This is to eliminate the boilerplate of
repetitious methods.

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
Test::Unit, which I prefer over Minitest, mainly because the latter uses notifications that don't
work especially well with Emacs, such as changing the mode line to show the success/failure status,
but do not afterward change back to the default settings.

Ergo, paramesan, which as of this writing, allows a very primitive set of options for parameterized
tests.

# Example

## Before

31 lines.

```ruby
require 'pvn/log/options'
require 'test/unit'

class FormatOptionTest < Test::Unit::TestCase
  def assert_formatter expected, *types
    types.each do |type|
      fmtr = Pvn::Log::FormatOption.new type
      assert_kind_of expected, fmtr.formatter, "type: #{type}"
    end
  end
  
  def test_oneline
    assert_formatter Pvn::Log::FormatOneLine, "single", "single-line", "si", "oneline"
  end

  def test_summary
    assert_formatter Pvn::Log::FormatSummary, "summary", "su"
  end

  def test_revision_only
    assert_formatter Pvn::Log::FormatRevisionOnly, "revision", "rev", "revisiononly"
  end

  def test_revision_author
    assert_formatter Pvn::Log::FormatRevisionAuthor, "revauthor", "revauth", "revisionauthor"
  end

  def test_colorized
    assert_formatter Pvn::Log::FormatColorized, "color", "colorized"
  end
end
```

## After

20 lines, 35% fewer.

```ruby
require 'pvn/log/options'
require 'test/unit'
require 'paramesan'

class FormatOptionTest < Test::Unit::TestCase
  extend Paramesan
  
  param_test [
    [ Pvn::Log::FormatOneLine,        "single", "single-line", "si", "oneline" ],
    [ Pvn::Log::FormatSummary,        "summary", "su" ],
    [ Pvn::Log::FormatRevisionOnly,   "revision", "rev", "revisiononly" ],
    [ Pvn::Log::FormatRevisionAuthor, "revauthor", "revauth", "revisionauthor" ],
    [ Pvn::Log::FormatColorized,      "color", "colorized" ],
  ] do |exp, *types|
    fmts = Pvn::Log::Formats.new
    types.each do |type|
      assert_equal exp, fmts.class_for(type), "type: #{type}"
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jpace/paramesan.

## License

This gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
