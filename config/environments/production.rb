Afalone::Application.configure do
  config.eager_load = true
# Settings specified here will take precedence over those in config/environment.rb

#config.action_controller.session ||= {}
#config.action_controller.session[:session_domain] = '.afalone.ru'
#SubdomainRoutes::Config.domain_length = 2

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
#config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
#config.action_controller.consider_all_requests_local = false
#config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
end
GEM_PATH='/home/virtwww/w_afalone-ru_3e7b26fa/.gems:/usr/lib/ruby/gems/1.8'
NGINXLOGS_PATH='../../logs'
NGINXLOGS_MASK=['access*log']

DESC_PATH = File.join Rails.root, 'desc'
FB2_PATH = File.join Rails.root, 'fb2'

BUNDLE_PATH = File.join Rails.root, 'bundles'
