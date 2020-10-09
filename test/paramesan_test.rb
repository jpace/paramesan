require 'test_helper'
require 'paramesan'

class ParamesanTest < Test::Unit::TestCase
  include Paramesan
  
  param_test [
    [ "a", "b" ],
    [ "c", "d" ],
  ] do |exp, result|
  end
  
  param_test [
    [ "e", "f" ],
  ] do |exp, result|
  end
  
  param_test [
    [ "e", "f" ],
  ] do |exp, result|
  end

  param_test [
    [ "e", "f" ],
  ] do |exp, result|
  end

  param_test [
    :one
  ] do |exp, result|
  end

  def test_methods
    expected = [
      "test_0_of_2__a_b",
      "test_1_of_2__c_d",
      "test_0_of_1__e_f",
      "test_0_of_1__e_f_1",
      "test_0_of_1__e_f_2",
    ]
    meths = self.methods - Class.methods - Object.new.methods
    ignore = %w{ test_methods test_names }.collect { |x| x.to_sym }
    testmethods = meths.select do |meth|
      meth.to_s.start_with?('test') && !ignore.include?(meth)
    end

    expected.each do |exp|
      result = testmethods.include? exp.to_sym
      assert result
    end
  end

  def test_names
    paramslist = [
      [ "test_0_of_1__a_d", [ "a", "d" ], 0, 1 ],
      [ "test_0_of_1__efg", [ "efg" ], 0, 1 ],
      [ "test_2_of_3__a_d", [ "a", "d" ], 2, 3 ],
    ]
    paramslist.each do |expected, params, idx, count|
      result = self.class.param_test_name params, idx, count
      assert_equal expected, result
    end
  end
end
