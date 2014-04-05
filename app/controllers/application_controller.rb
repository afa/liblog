# coding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Controller
  helper :all # include all helpers, all the time
  #include Afauth::Controller::App
  #remembered_cookie_name :afalone_token
  #user_model User
  #can_be_unlogged true
  #auth_expired_in_days 30
  #authen_field_name :username
  #redirect_failed_cb :fail_redirect
  #post_logout_cb :to_root
  #before_logout_cb :do_nothing
  #post_sign_cb :to_root
  
  #def fail_redirect
  # new_session_path
  #end

  #def to_root
  # redirect_to root_path
  #end

  #def do_nothing
  #end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => 'cde0b420e0543a4323b9979a26d5b8e7'
# before_filter :user_from_cookie
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
# def current_user
#  User.current
# end

# def current_user=(user)
#  User.current = user
# end

 # need change when subdomain_routes will handle non-80 port
 protected

=begin
  def user_from_cookie
   token = cookies[:remember_token]
   if token
    if token.blank?
     User.current = nil
     return nil
     cookies.delete(:remember_token)
     return nil
    end
    u = User.where(:remember_token => token).first
    #cookies.delete(:user_remember_token) unless u
   end
   u
  end
=end
 #def default_url_options(options=nil)
 # logger.info "#{options.inspect}"
 # { :port => (self.request.andand.port ? self.request.andand.port : 80), :host=>(self.request.andand.host ? self.request.andand.host : 'e3pc') }.merge(options || {})
 #end
end
