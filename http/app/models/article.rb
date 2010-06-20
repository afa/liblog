class Article < ActiveRecord::Base
 belongs_to :author
 validates_uniqueness_of :name, :blank => true
end
