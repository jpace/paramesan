#!/usr/bin/ruby -w
# -*- ruby -*-

require "paramesan/version"

module Paramesan
  module ClassMethods
    def param_test paramlist, &blk
      paramlist.each do |params|
        basename = "test_" + params.to_s.gsub(Regexp.new('[^\w]+'), '_')
        mname = basename

        count = 1
        while instance_methods.include? mname.to_sym
          mname += "_#{count}"
        end

        define_method mname do
          instance_exec(params, &blk)
          puts
        end
      end
    end
  end

  extend ClassMethods

  def self.included other
    other.extend ClassMethods
  end
end
