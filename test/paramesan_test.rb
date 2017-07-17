require 'test_helper'
require 'paramesan'

class ParamesanTest < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Paramesan::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end

class IncludeParamesanTest < Test::Unit::TestCase
  include Paramesan
  
  param_test [
    [ 1, 1 ],
  ] do |exp, result|
    assert_equal exp, result
  end
end
