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
[param_test](https://www.ruby-toolbox.com/projects/param_test). That uses activesupport, which is
included in Rails, but I wanted a version that ran in a pure Ruby environment, using only the
test-unit gem. I prefer that over Minitest, mainly because the latter uses notifications that don't
work especially well with Emacs.

Ergo, Paramesan, which as of this writing, supports a set of options for parameterized tests.

# Example

## Before

58 lines.

```ruby
require 'pvn/log/options'
require 'test/unit'

class FormatOptionTest < Test::Unit::TestCase
  def assert_formatter expected, type
    fmtr = Pvn2::Log::FormatOption.new type
    assert_kind_of expected, fmtr.formatter, "type: #{type}"
  end
  
  def test_oneline_single
    assert_formatter Pvn2::Log::FormatOneLine, "single"
  end

  def test_oneline_si
    assert_formatter Pvn2::Log::FormatOneLine, "si"
  end

  def test_oneline_oneline
    assert_formatter Pvn2::Log::FormatOneLine, "oneline"
  end

  def test_summary_summary
    assert_formatter Pvn2::Log::FormatSummary, "summary"
  end

  def test_summary_su
    assert_formatter Pvn2::Log::FormatSummary, "su"
  end

  def test_revision_revision
    assert_formatter Pvn2::Log::FormatRevision, "revision"
  end

  def test_revision_author_revauthor
    assert_formatter Pvn2::Log::FormatRevisionAuthor, "revauthor"
  end

  def test_revision_author_revauth
    assert_formatter Pvn2::Log::FormatRevisionAuthor, "revauth"
  end

  def test_revision_author_revisionauthor
    assert_formatter Pvn2::Log::FormatRevisionAuthor, "revisionauthor"
  end

  def test_colorized_color
    assert_formatter Pvn2::Log::FormatColorized, "color"
  end

  def test_colorized_colorized
    assert_formatter Pvn2::Log::FormatColorized, "colorized"
  end

  def test_tree_tree
    assert_formatter Pvn2::Log::FormatTree, "tree"
  end
    
  def test_tree_zzz
    assert_formatter Pvn2::Log::FormatTree, "zzz"
  end
end
```

## After

17 lines.

```ruby
require 'pvn/log/options'
require 'test/unit'
require 'paramesan'

class FormatOptionTest < Test::Unit::TestCase
  extend Paramesan

  param_test [
    [ Pvn2::Log::FormatOneLine,        "oneline", "single", "si" ],
    [ Pvn2::Log::FormatSummary,        "summary", "sum" ],
    [ Pvn2::Log::FormatRevision,       "revision" ],
    [ Pvn2::Log::FormatRevisionAuthor, "revisionauthor", "revauthor", "revauth" ],
    [ Pvn2::Log::FormatColorized,      "colorized", "color", "full" ],
    [ Pvn2::Log::FormatMessage,        "message" ],
    [ Pvn2::Log::FormatTree,           "tree", "zzz" ],
  ] do |exp, *types|
    types.each do |type|
      assert_kind_of exp, Pvn2::Log::FormatOption.new(type).formatter, "type: #{type}"
    end
  end
end
```

The Paramesan code generates a test method for each parameter set, as for example, with the last
test case, which fails:

```text
Error: test__Pvn2_Log_FormatTree_tree_zzz_(FormatsTest): RuntimeError: invalid format zzz not one of: author colorized full message oneline revauthor revision revisionauthor single summary tree
/opt/proj/pvn2/lib/pvn2/log/formats.rb:46:in `class_for'
/opt/proj/pvn2/lib/pvn2/log/options.rb:19:in `initialize'
/opt/proj/pvn2/test/pvn2/log/formats_test.rb:134:in `new'
/opt/proj/pvn2/test/pvn2/log/formats_test.rb:134:in `block (2 levels) in <class:FormatsTest>'
/opt/proj/pvn2/test/pvn2/log/formats_test.rb:133:in `each'
/opt/proj/pvn2/test/pvn2/log/formats_test.rb:133:in `block in <class:FormatsTest>'
/home/jpace/.rvm/gems/ruby-2.3.0/gems/paramesan-0.1.1/lib/paramesan.rb:19:in `instance_exec'
/home/jpace/.rvm/gems/ruby-2.3.0/gems/paramesan-0.1.1/lib/paramesan.rb:19:in `block (2 levels) in param_test'
```

# Common Parameters

Sometimes the same set of parameters is used in multiple tests. To do that with Paramesan, simply
define a class method returning those parameters, and adjust the param_test blocks:

```ruby
class FormatsTest < Test::Unit::TestCase
  include Paramesan

  def self.build_class_types_params
    [
      [ Pvn2::Log::FormatOneLine,        "oneline", "single", "si" ],
      [ Pvn2::Log::FormatSummary,        "summary", "sum" ],
      [ Pvn2::Log::FormatRevision,       "revision" ],
      [ Pvn2::Log::FormatRevisionAuthor, "revisionauthor", "revauthor", "revauth" ],
      [ Pvn2::Log::FormatColorized,      "colorized", "color", "full" ],
      [ Pvn2::Log::FormatMessage,        "message" ],
      [ Pvn2::Log::FormatTree,           "tree", "zzz" ],
    ]
  end
  
  param_test build_class_types_params do |exp, *types|
    fmts = Pvn2::Log::Formats.new
    types.each do |type|
      assert_equal exp, fmts.class_for(type), "type: #{type}"
    end
  end

  param_test build_class_types_params do |exp, *types|
    types.each do |type|
      assert_kind_of exp, Pvn2::Log::FormatOption.new(type).formatter, "type: #{type}"
    end
  end
end
```

# Non Arrays

The set of parameters does not have to consist of arrays. For example, using strings:

```ruby
class FormatsTest < Test::Unit::TestCase
  include Paramesan

  param_test %w{ abc def } do |str|
    fmts = Pvn2::Log::Formats.new
    expfmts = "author colorized full message oneline revauthor revision revisionauthor single summary tree"
    assert_raise(RuntimeError.new "invalid format #{str} not one of: #{expfmts}") do
      fmts.class_for str
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jpace/paramesan.

## License

This gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
