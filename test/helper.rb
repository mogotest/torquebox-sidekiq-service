require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'torquebox-sidekiq-service'

require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/reporters'

MiniTest::Reporters.use!