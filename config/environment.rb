# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Afalone::Application.initialize!

Haml::Template.options[:format] = :html5

# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '3.0.0' unless defined? RAILS_GEM_VERSION
#RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
#require File.join(File.dirname(__FILE__), 'boot')

#Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
#?   config.plugins = [ :in_place_editing, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
#  config.time_zone = 'Moscow'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
#  config.action_controller.session = {
#    :key => '_http_session',
#    #:session_key => '_http_session',
#    :secret      => '460020f2b609ada6898d4be1fa259184ff76b3a88b52b7215cfdfcfd94dfde541d3b0bec8deccc3cd0aa9961555e6e16dcca1e40cbf0037add6ceea193563971'
#  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store
#   config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector


#  config.gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source => 'http://gems.github.com'
#  config.gem 'russian'
#  config.gem 'andand'
#  config.gem 'nokogiri'
#  config.gem "mholling-paged_scopes", :lib=>"paged_scopes", :source=>"http://gems.github.com"
#  config.gem "paperclip"
#  #config.gem "rubyist-aasm", :lib=>'aasm'
#  #config.gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"
#  config.gem "state_machine"
#  config.gem "mechanize"
#  config.gem "acts-as-taggable-on", :source => "http://gemcutter.org"
#  #config.gem "blueprints"
#  #config.gem "machinist"
#  #config.gem "faker"
#  config.gem "delayed_job"
#  #config.gem "daemon-spawn"
#  config.gem "daemons"
#  config.gem "newrelic_rpm"
#  #config.gem "mholling-subdomain_routes", :lib=>"subdomain_routes"
#  config.gem "rmagick", :lib=>'RMagick'
#  config.gem "bluecloth"

#end


SKIP_EXISTS = true
