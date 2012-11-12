module Afauth
# validates_uniqueness_of :username
# attr_accessor :password
# before_validation :make_salt, :if => lambda{ self.salt.blank? }
# before_validation :calc_password, :on => :create
# after_create :create_axapta_account
# before_validation :generate_remember_token, :if => lambda{ self.remember_token.blank? }
# before_save :encrypt_password, :unless => lambda{ self.password.blank? }

  def self.current=(user)
   @current = user
  end

  def self.current
   @current
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

 def self.authenticate(username, password)
  return nil  unless user = find_by_username(username)
  if user.current_account
   axapta_params = Axapta.user_info(user.current_account.axapta_hash)
   user.current_account.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless user.current_account.invent_location_id == axapta_params["invent_location_id"]
  end
  return nil  if     user.accounts.all.all? {|a| a.blocked? }
  return user if     user.authenticated?(password)
 end

  def self.make_recover_pass
   self.base62(Digest::MD5.hexdigest([self.base62(rand(62**8)), Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16), 20)
  end

  def self.locate_recoverable(email)
   
  end

 #  def authenticated?(password)
 #  Digest::MD5.hexdigest([salt, password].join) == encrypted_password
 # end

  def calc_pass
   User.base62(Digest::MD5.hexdigest([salt, Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16))
  end

 protected
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

  def generate_remember_token
   self.remember_token = generate_random_code
  end

#  def make_salt
#   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, ext_hash].join) unless self.salt
#  end

  def calc_password
   self.password = calc_pass
  end

  def self.base62(bin, max_length = 8)
   dig = []
   chrs = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
   max_length.times do
    dig << chrs[bin % 62]
    bin /= 62
   end
   dig.map{|i| sprintf("%c", i) }.join
  end

end
