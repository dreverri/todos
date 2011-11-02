Todos
=====

Overview
========

Todos is a simple example application which uses Backbone.js, Ruby (Sinatra, Rack, Ripple), and Riak for a key value datastore.  This also provides a good example of using OAuth to authenticate against twitter.

Getting Started
===============

To run this app, the following steps need to happen:

0)  Get the todo source using git.
1)  Get Twitter API keys.  These are needed for OAuth.
2)  Install Riak.
3)  Configure this app (via Ripple) to use Riak.
4)  Run!

Getting the Source
==================
Clone the source tree using git:

    git clone https://github.com/dreverri/todos.git

This is a Ruby app. If you haven't used RVM, get set up before going farther.

    http://beginrescueend.com/

To prepare everything for running, switch to the source tree and run:

    bundle install

Obtaining Twitter Keys
======================

Log into the [twitter developer portal](http://dev.twitter.com) and generate some Twitter API keys.  Make sure the Callback URL is correct.  If you plan on runnings under localhost, use something like `http://127.0.0.1` for the URL.

Copy the settings file (config/settings.yml.example) to (config/settings.yml).  Edit it, and insert your twitter API keys from above.  Make sure you use the "Consumer Key" and "Consumer Secret" hashes, not something else.

Installing Riak
===============

Refer to the [official instructions](http://wiki.basho.com/Installation.html) to Riak running.

Configure Ripple
================
Edit config/ripple.yml and ensure one of the environments matches your Riak info.  If you are running Riak on localhost, you don't need to change anything; just use the development profile.

Run
===
Set the environment ripple will use from the config file:

    export RACK_ENV=<environment>

Use bundle to run the app & pick the TCP port you want Sinatra to use:

    bundle exec rackup -p 4567
