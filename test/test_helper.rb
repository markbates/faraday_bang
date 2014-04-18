require 'bundler/setup'

require 'faraday_bang' # and any other gems you need

require 'ostruct'
require 'minitest/autorun'
require "mocha/setup"
require 'mocha/mini_test'

class MiniTest::Spec

  class << self
    alias :context :describe
  end

end
