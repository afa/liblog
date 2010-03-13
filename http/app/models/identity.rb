class Identity < ActiveRecord::Base
 validates_uniqueness_of :name
 has_many :users
 has_many :posts, :class_name=>'BlogPost'
 named_scope :order_by_name, {:order=>'name'}
end
