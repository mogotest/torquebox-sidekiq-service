# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "torquebox-sidekiq-service"
  gem.homepage = "http://github.com/mogotest/torquebox-sidekiq-service"
  gem.license = "ASLv2"
  gem.summary = 'A TorqueBox service for running Sidekiq in the TorqueBox application server.'
  gem.description = <<-DESC
    The TorqueBox Sidekiq service replaces the traditional Sidekiq CLI client for starting a Sidekiq processor.  This
    allows TorqueBox features only available in-container to be usable by all your Sidekiq workers.  It has the added
    benefit of reducing memory overhead by running in a single JVM and allows for better optimization through JIT and
    better debugging & profiling through TorqueBox's runtime inspection facilities.
  DESC
  gem.email = "nirvdrum@gmail.com"
  gem.authors = ["Kevin Menard"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test
