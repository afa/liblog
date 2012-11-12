#coding: UTF-8
module Afauth
 class AuthError < Exception; end
 module Model
  def self.included(base)
   base.extend ClassMethods
   base.instance_eval do
    before_validation :make_salt, :if => lambda{self.salt.blank?}
    before_validation :calc_password, :on => :create
    before_validation :generate_remember_token, :if => lambda{ self.remember_token.blank? }
    before_save :encrypt_password, :unless => lambda{ self.password.blank? }
   end

  end

  module ClassMethods
   def current=(user)
    @current = user
   end

   def current
    raise AuthError if @current.nil?
    @current
   end

   def post_auth(*list)
    @post_methods ||= []
    @post_methods += list unless list.empty?
   end

   def authen_field_name(symb)
    @auth_field_name = symb
   end

   def failed_auth(*list)
    @failed_methods ||= []
    @failed_methods += list unless list.empty?
   end

   def logged?
    not @current.nil?
   end

   def authenticate(username, password)
    p "---aname", @auth_field_name
    p username, password
    unless user = where((@auth_field_name || :username) => username).first
     @failed_methods.each{|m| send(m, nil) } unless @failed_methods.blank?
     raise AuthError
    end
    unless user.authenticated?(password)
     @failed_methods.each{|m| send(m, user) } unless @failed_methods.blank?
     raise AuthError
    end
    @post_methods.each{|m| send(m, user) } unless @post_methods.blank?
    user
   end

   def make_recover_pass
    base62(Digest::MD5.hexdigest([base62(rand(62**8)), Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16), 20)
   end

   def locate_recoverable(email)
   end

   def base62(bin, max_length = 8)
    dig = []
    chrs = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    max_length.times do
     dig << chrs[bin % 62]
     bin /= 62
    end
    dig.map{|i| sprintf("%c", i) }.join
   end

  end

  def authenticated?(pwd)
   self.encrypted_password == self.encrypt(pwd)
  end

  def make_salt
   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, sprintf("%x", rand(2**24))].join) unless self.salt
  end

  def encrypt_password
   self.encrypted_password = self.encrypt(self.password)
  end

  def reset_remember_token!
   self.generate_remember_token
   save(:validate => false)
  end

  def calc_pass
   self.class.base62(Digest::MD5.hexdigest([salt, Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16))
  end

 #protected
  def generate_hash(string)
   if RUBY_VERSION >= '1.9'
    Digest::SHA1.hexdigest(string).encode('UTF-8')
   else
    Digest::SHA1.hexdigest(string)
   end
  end

  def generate_random_code(length = 20)
   if RUBY_VERSION >= '1.9'
    SecureRandom.hex(length).encode('UTF-8')
   else
    SecureRandom.hex(length)
   end
  end

  def encrypt(string)
   generate_hash("--#{self.class.name}--#{salt}--#{string}--")
  end

  def calc_password
   self.password = calc_pass
  end

  def generate_remember_token
   self.remember_token = generate_random_code
  end

 end

 module Controller
  module App
   def self.included(base)
    #base.extend ClassMethods
    base.extend ClassMethods
    base.instance_eval do
     before_filter :process_cookie
     before_filter :login_from_cookie
     before_filter :authenticate!
     # hide when hardly test
     rescue_from Afauth::AuthError do |e|
      Rails.logger.info "---rescue: need redirect, #{e}, #{e.backtrace.first(3)}"
      if self.class.class_variable_defined?(:@@auth_redirect_on_failed) && self.class.auth_redirect_on_failed
       redirect_to self.class.auth_redirect_on_failed
      elsif self.class.class_variable_defined?(:@@auth_redirect_on_failed_cb) && self.class.auth_redirect_on_failed_cb
       redirect_to self.send(self.class.auth_redirect_on_failed_cb)
      else
       raise
      end
     end
    end
   end

  def current_user
   p "---c-u", self.class.name, self.class.auth_model
   self.class.auth_model.current
  end

  def current_user=(user)
   p "---c-u=", self.class.name, self.class.auth_model, user
   self.class.auth_model.current = user
  end

  def authenticate!
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

   def sign_out
    if logged_in? #before_signout
     if self.class.class_variable_defined?(:@@auth_before_logout_cb)
      self.send(self.class.class_variable_get(:@@auth_before_logout_cb))
     end
    end
    cookies.delete(self.class.auth_cookie_name)
    self.class.auth_model.current = nil
   end

   def process_cookie
    if cookies[self.class.auth_cookie_name].blank? || self.class.auth_model.where(:remember_token => cookies[self.class.auth_cookie_name]).first.nil?
     raise Afauth::AuthError
    end
   end

   def user_from_cookie
    token = cookies[self.class.auth_cookie_name]
    if token
     return nil if token.blank?
     u = self.class.auth_model.where(:remember_token => token).first
     #cookies.delete(:user_remember_token) unless u
    end
    u
   end

   def login_from_cookie
    u = user_from_cookie
    if u 
     self.class.auth_model.current = u
    end
   end

   def logged_in?
    self.class.auth_model.logged?
   end

  def sign_in(user, opts = {})
   if user
    val = {
      :value   => user.remember_token
    }
    val.merge!(:expires => self.class.auth_expired_in.day.from_now.utc) if opts.is_a?(Hash) && opts[:rememberme] && self.class.auth_cookie_name && self.class.auth_expired_in.to_i > 0
    cookies[self.class.auth_cookie_name] = val
    self.class.auth_model.current = user
   end
  end

   module ClassMethods
    #setup
    %w(auth_model auth_cookie_name auth_redirect_on_failed auth_redirect_on_failed_cb auth_expired_in auth_before_logout_cb auth_field_name auth_post_sign_cb auth_post_logout_cb).each do |mtd|
     define_method(mtd) do
      begin
       class_variable_get("@@#{mtd}")
      rescue NameError
       superclass.class_variable_get("@@#{mtd}")
      end
     end

     define_method("#{mtd}=") do |val|
      class_variable_set("@@#{mtd}", val)
     end
    end
    define_method(:user_model) do |klass|
     self.auth_model = klass
     if (class_variable_defined?(:@@auth_field_name) || superclass.class_variable_defined?(:@@auth_field_name)) && !auth_field_name.nil?
      self.auth_model.authen_field_name nm
     end
    end
    define_method(:remembered_cookie_name) do |name|
     self.auth_cookie_name = name
    end
    define_method(:redirect_failed) do |rte|
     self.auth_redirect_on_failed = rte
    end
    define_method(:redirect_failed_cb) do |prc|
     self.auth_redirect_on_failed_cb = prc
    end
    define_method(:auth_expired_in_days) do |days|
     self.auth_expired_in = days
    end
    define_method(:before_logout_cb) do |prc|
     self.auth_before_logout_cb = prc
    end
    define_method(:authen_field_name) do |nm|
     self.auth_field_name = nm
     if (class_variable_defined?(:@@user_model) || superclass.class_variable_defined?(:@@user_model)) && !auth_model.nil?
      auth_model.authen_field_name nm
     end
    end
    define_method(:post_sign_cb) do |mtd|
     self.auth_post_sign_cb = mtd
    end
    define_method(:post_logout_cb) do |mtd|
     self.auth_post_logout_cb = mtd
    end
    #done

   end
  end

  module Session
   def self.included(base)
    base.instance_eval do
     skip_before_filter :login_from_cookie, :except => :destroy
     skip_before_filter :process_cookie, :except => :destroy
     skip_before_filter :authenticate!, :except => :destroy
    end
   end

   def new
   end

   def create
    p "---sesaucr", params[:session], self.class.name, self.class.auth_field_name
    sign_out if logged_in?
    l_user = self.class.auth_model.authenticate(params[:session].try(:[], self.class.auth_field_name), params[:session].try(:[], :password))
    unless l_user
     self.class.auth_model.current = nil
     redirect_to self.class.auth_redirect_on_failed_cb, :flash => {:error => "Неверный пароль или имя пользователя."} 
     return
    end
    sign_in(l_user, :rememberme => params[:rememberme]) #unless logged_in?
    if logged_in?
     if self.class.class_variable_defined?(:@@auth_post_sign_cb) && self.class.auth_post_sign_cb
      [self.class.auth_post_sign_cb].flatten.each do |mtd|
       self.send(mtd)
      end
     end
    else
     if self.class.class_variable_defined?(:@@auth_redirect_on_failed) && self.class.auth_redirect_on_failed
      redirect_to self.class.auth_redirect_on_failed, :flash => {:error => "Неверный пароль или имя пользователя."}
     elsif self.class.class_variable_defined?(:@@auth_redirect_on_failed_cb) && self.class.auth_redirect_on_failed_cb
      redirect_to self.send(self.class.auth_redirect_on_failed_cb), :flash => {:error => "Неверный пароль или имя пользователя."}
     else
      raise Afauth::AuthError
     end
    end
   end

   def destroy
    sign_out
    if self.class.class_variable_defined?(:@@auth_post_logout_cb) && self.class.auth_post_logout_cb
     [self.class.auth_post_logout_cb].flatten.each do |mtd|
      self.send(mtd)
     end
    end
   end
  end
  module Helper
   def self.included(base)
    #base.instance_eval do
    #end
   end

   #def auth_field_name
   # controller.class.auth_field_name || :username
   #end
  end
 end
end
