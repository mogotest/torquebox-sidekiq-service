module TorqueBox
  class SidekiqService
    attr_accessor :config, :launcher

    CONFIG_OPTIONS_TO_STRIP = [:config_file, :daemon, :environment, :pidfile, :require, :tag]

    def initialize(opts = {})
      @config = opts.symbolize_keys.reject { |k, _| CONFIG_OPTIONS_TO_STRIP.include?(k) }
    end

    def start
      Thread.new { run }
    end

    def stop
      launcher.stop
    end

    def run
      Sidekiq.options.merge!(config)
      Sidekiq.options[:queues] << 'default' if Sidekiq.options[:queues].empty?

      if Sidekiq.options.has_key?(:logfile)
        Sidekiq::Logging.initialize_logger(Sidekiq.options[:logfile])
      else
        Sidekiq::Logging.logger = TorqueBox::Logger.new('sidekiq') if ENV.has_key?('TORQUEBOX_CONTEXT')
      end

      require 'celluloid'

      if Sidekiq.options.has_key?(:verbose)
        Sidekiq.logger.level = Logger::DEBUG
        Celluloid.logger = Sidekiq.logger
      end

      require 'sidekiq/manager'
      require 'sidekiq/scheduled'
      require 'sidekiq/launcher'
      @launcher = Sidekiq::Launcher.new(Sidekiq.options)

      launcher.run
    end
  end
end