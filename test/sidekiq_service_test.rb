require 'helper'

class SidekiqServiceTest < MiniTest::Unit::TestCase
  describe 'configuration' do
    it 'should remove the daemon config option' do
      service = TorqueBox::SidekiqService.new(daemon: true)
      assert !service.config.has_key?(:daemon)
    end

    it 'should remove the environment config option' do
      service = TorqueBox::SidekiqService.new(environment: 'production')
      assert !service.config.has_key?(:environment)
    end

    it 'should remove the tag config option' do
      service = TorqueBox::SidekiqService.new(tag: 'my-tag')
      assert !service.config.has_key?(:tag)
    end

    it 'should remove the require config option' do
      service = TorqueBox::SidekiqService.new(require: './lib')
      assert !service.config.has_key?(:require)
    end

    it 'should remove the config_file config option' do
      service = TorqueBox::SidekiqService.new(config_file: './config/sidekiq.yml')
      assert !service.config.has_key?(:config_file)
    end

    it 'should remove the pidfile config option' do
      service = TorqueBox::SidekiqService.new(pidfile: './tmp/sidekiq.pid')
      assert !service.config.has_key?(:pidfile)
    end
  end
end
