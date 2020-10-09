#!/usr/bin/ruby -w
# -*- ruby -*-

require "paramesan/version"

module Paramesan
  module ClassMethods
    def param_test paramlist, &blk
      count = paramlist.count
      paramlist.each_with_index do |params, idx|
        name = param_test_name params, idx, count

        mname = name.to_sym
        i = 0
        while instance_methods.include? mname.to_sym
          i += 1
          mname = name + "_#{i}"
        end

        define_method mname do
          instance_exec(params, &blk)
        end
      end
    end

    def param_test_name params, idx, count
      name = "test_" + idx.to_s + "_of_" + count.to_s + "__"
      if params.kind_of?(Enumerable)
        nonword = Regexp.new '[^\w]+'
        elements = params.collect { |param| param.to_s.gsub nonword, '_' }
        name << elements.join('_')
      else
        name << params.to_s
      end
    end
  end

  extend ClassMethods

  def self.included other
    other.extend ClassMethods
  end
end
