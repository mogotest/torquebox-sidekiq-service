module TorqueBox
  class SidekiqService
    attr_accessor :config, :launcher, :start_failed

    CONFIG_OPTIONS_TO_STRIP = [:config_file, :daemon, :environment, :pidfile, :require, :tag]

    def initialize(opts = {})
      @config = opts.symbolize_keys.reject { |k, _| CONFIG_OPTIONS_TO_STRIP.include?(k) }
    end

    def start
      Thread.new { run }
    end

    def stop
      # Since the stop call may come before the launcher has finished starting up, try to see
      # if the launcher ever gets initialized.  We really don't want to orphan a Sidekiq launcher
      # if we can avoid it.
      Timeout::timeout(5.minutes) do
        while launcher.nil? && !start_failed
          sleep 1
        end
      end

      launcher.stop if launcher
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
      Celluloid.task_class = Celluloid::TaskThread

      require 'celluloid/autostart'

      if Sidekiq.options.has_key?(:verbose)
        Sidekiq.logger.level = Logger::DEBUG
        Celluloid.logger = Sidekiq.logger
      end

      require 'sidekiq/launcher'

      @launcher = Sidekiq::Launcher.new(Sidekiq.options)

      launcher.run
    rescue => e
      puts e.message
      puts e.backtrace

      @start_failed = true
    end
  end
end
