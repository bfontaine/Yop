#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require "test/unit"
require "simplecov"

test_dir = File.expand_path(File.dirname(__FILE__))

if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
SimpleCov.start { add_filter "/tests/" }

require "yop"

for t in Dir[File.join(test_dir,  "*_tests.rb")]
  require t
end

class YopTests < Test::Unit::TestCase

  # == #version == #

  def test_version
    assert(Yop.version =~ /^\d+\.\d+\.\d+/)
  end

end


exit Test::Unit::AutoRunner.run
