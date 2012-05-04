# coding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => 'cde0b420e0543a4323b9979a26d5b8e7'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
 def current_user
  if @logged.nil? then
   unless session[:logon].nil? then
    @logged = User.find(session[:logon]) or GuestUser.new
   else 
    @logged = GuestUser.new
   end
  end
  @logged
 end

 def current_user=(user)
  User.current = user
  @logged = user
 end

 # need change when subdomain_routes will handle non-80 port
 protected
 #def default_url_options(options=nil)
 # logger.info "#{options.inspect}"
 # { :port => (self.request.andand.port ? self.request.andand.port : 80), :host=>(self.request.andand.host ? self.request.andand.host : 'e3pc') }.merge(options || {})
 #end
end