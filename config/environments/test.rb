Afalone::Application.configure do
  config.eager_load = false
# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true
#config.action_controller.session ||= {}
#config.action_controller.session[:session_domain] = '.e3pc'
#SubdomainRoutes::Config.domain_length = 1

# Log error messages when you accidentally call methods on nil.

#config.gem "test-unit", :lib => 'test/unit'
#config.gem "machinist"
#config.gem "faker"
#config.gem "factory_girl"

# Show full error reports and disable caching
#config.action_controller.consider_all_requests_local = false
#config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
config.active_support.deprecation = :log
end
BASE_DATA_DIR = 'test/testdata'
BATCH_INPUT_DIR = File.join(BASE_DATA_DIR, 'batch')
INPUT_DIR = File.join(BASE_DATA_DIR, 'input')
WORKING_DIR = File.join(BASE_DATA_DIR, 'work')
BUNDLE_DIR = File.join(BASE_DATA_DIR, 'bundle')

#config.gem "rspec", :lib=>false, :version=>'~>1.3.0'
#  config.gem 'rspec-rails', :version => '~> 1.3.2', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
