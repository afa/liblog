class User < ActiveRecord::Base
 belongs_to :identity
 validates_uniqueness_of :username, :message=>'Аккаунт с таким именем уже существует', :on=>:create
end
