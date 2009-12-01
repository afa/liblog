class Identity < ActiveRecord::Base
 validates_uniqueness_of :name
 has_many :users
 named_scope :order_by_name, {:order=>'name'}
end
