# This is needed to make Sidekiq think it's working in a server capacity.
module Sidekiq
  class Shutdown < RuntimeError; end

  class CLI; end
end

# Sidekiq requires the Celluloid module to be in scope before it can start.
require 'celluloid/autostart'

# Sidekiq requires its processor to be available if configuring server middleware.
require 'sidekiq/processor'


require 'torque_box/sidekiq_service'
