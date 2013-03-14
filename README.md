TorqueBox Sidekiq Service
=========================

This library provides a TorqueBox service for running Sidekiq inside the TorqueBox application server.  It replaces the
Sidekiq CLI client typically used to start up TorqueBox.

[![Build Status](https://secure.travis-ci.org/mogotest/torquebox-sidekiq-service.png)](http://travis-ci.org/mogotest/torquebox-sidekiq-service)

Rationale
---------

The TorqueBox application server has a lot of features that are only accessible by running within the container.  E.g.,
if your application uses the TorqueBox cache provider you cannot access that cache from an external process, like a
traditional Sidekiq setup.  This can be confusing as something as benign as `Rails.cache` can have different values in
the same environment depending on how the code was invoked.

There are several other reasons why a TorqueBox service may make sense for you:

* Reduced memory consumption, as you'll only be using one JVM
* High availability, as TorqueBox can move a singleton service to any other node in a cluster
* Simpler process management, as Sidekiq will start as part of your normal application deploy
** No need for monit or similar tools in production
** No need for foreman or similar tools in development
* Easier to debug & profile by way of TorqueBox's debugging and profiling capabilities
* Better opportunity for JVM JIT optimization

Of course, for every item that I think is a pro, someone else may think is a con.  Depending on perspective, some flaws
with this approach are:

* Not maintained by Sidekiq
* If the TorqueBox process dies Sidekiq goes with it
* Harder to measure just Sidekiq's memory footprint
* May no longer be able to deploy front-end independently of back-end (not strictly true since you can deploy multiple apps)


Usage
-----

If you want to run multiple Sidekiq processors in the same app, you'll need to use a bounded pool for the services runtime.

E.g., if you want to run two processors, with no other services, your torquebox.yml will need to have something like:

<pre>
pooling:
  services:
    type: bounded
    min: 2
    max: 2
</pre>

Then your service configuration would look like:

<pre>
services:
  background-default:
    service: TorqueBox::SidekiqService
    config:
      queues: ['default']
      index: 0
      concurrency: 50

  background-deletes:
    service: TorqueBox::SidekiqService
    config:
      queues: ['deletes']
      index: 1
      concurrency: 50
</pre>

By default, services are [singletons](http://torquebox.org/documentation/2.3.0/services.html#ha-singleton-services) in
TorqueBox, meaning they will run on only one node in the cluster.  If that node ever goes down, the service will be
started on another available node.  Alternatively, you can run a Sidekiq processor on all nodes by disabling the
singleton setting, like so:

<pre>
services:
  background-default:
    service: TorqueBox::SidekiqService
    singleton: false
    config:
      queues: ['default']
      index: 0
      concurrency: 50
</pre>


Notes
-----

The torquebox-sidekiq-service must be loaded before you configure any Sidekiq server middleware.  If it isn't loaded,
Sidekiq assumes your runtime environment is only as a client and will then ignore any server middleware configuration.
It'll then go on to use its default server middleware, which can lead to some confusing results.  If you're on Rails,
everything in your Gemfile will be loaded by default so you won't have anything else to do.  Otherwise, make sure you
require the library.
