0.2.2 (05/28/2013)
------------------

* Use a mutex rather than a timeout for dealing with race conditions.

0.2.1 (05/19/2013)
------------------

* Sidekiq sets up Celluloid to us TaskThreads on its own now, so no need for us to do it.

0.2.0 (05/05/2013)
------------------

* Configured Celluloid to use TaskThreads instead of the default TaskFibers, as TaskThreads work better on JRuby.

0.1.3 (04/30/2013)
------------------

* Require 'celluloid/autostart' so its at_exit handler is registered, otherwise it'll leak threads when the service is stopped.

0.1.2 (04/30/2013)
------------------

* Added a definition for Sidekiq::Shutdown like Sidekiq's CLI does so things don't blow up when the class isn't available.

0.1.1 (03/28/2013)
------------------

* Don't silently swallow errors during Sidekiq launcher startup.
* Properly handle `stop` calls on the service when Sidekiq failed to launch.
* Properly handle `stop` calls on the service if Sidekiq has finished launching (fixed a race condition).

0.1.0 (03/13/2013)
------------------

* Initial release.
