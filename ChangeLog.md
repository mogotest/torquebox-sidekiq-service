0.1.1 (03/28/2013)
------------------

* Don't silently swallow errors during Sidekiq launcher startup.
* Properly handle `stop` calls on the service when Sidekiq failed to launch.
* Properly handle `stop` calls on the service if Sidekiq has finished launching (fixed a race condition).

0.1.0 (03/13/2013)
------------------

* Initial release.
