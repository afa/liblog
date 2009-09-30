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
 def take_login
  if @logged.nil? then
   unless session[:logon].nil? then
    @logged = User.find( :first, session[:logon]) or GuestUser.new
   else 
    @logged = GuestUser.new
   end
  end
  @logged
 end

 # need change when subdomain_routes will handle non-80 port
 def default_url_options(options=nil)
  { :port => self.request.andand.port }
 end
end
