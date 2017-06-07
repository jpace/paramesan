# Overview

Paramesan adds parameterized tests to test/unit in Ruby. This is to eliminate the boilerplate of
repetitious methods.

# Example

## Before

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
