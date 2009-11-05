# Settings specified here will take precedence over those in config/environment.rb

config.action_controller.session ||= {}
config.action_controller.session[:session_domain] = '.e3pc'
SubdomainRoutes::Config.domain_length = 1

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

config.after_initialize do
  Bullet.enable = true 
  Bullet.alert = false
  Bullet.bullet_logger = true  
  Bullet.console = false
  Bullet.growl = false
  Bullet.rails_logger = false
  Bullet.disable_browser_cache = true
end

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
NGINXLOGS_PATH='.'
NGINXLOGS_MASK=['access*log']


DESC_PATH = File.join RAILS_ROOT, 'desc'
FB2_PATH = File.join RAILS_ROOT, 'fb2'

BUNDLE_PATH = File.join RAILS_ROOT, 'bundles'
