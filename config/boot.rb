require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
 #fix for ruby 1.9 and russian
  if RUBY_VERSION >= '1.9'
   Encoding.default_internal = 'UTF-8'
   Encoding.default_external = 'UTF-8'
  end

  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

